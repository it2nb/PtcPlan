<template>
  <div>
    <v-row dense>
      <v-col cols="12" class="pt-5 px-5 green lighten-5">
        <div class="col-12 col-md-2 ml-auto pa-0">
          <v-select
            v-model="budgetplanYear"
            label="ปีงบประมาณ พ.ศ."
            :items="periodYears"
            item-text="periodYearBd"
            item-value="periodYear"
            outlined
            dense
          ></v-select>
        </div>
      </v-col>
    </v-row>
    <v-tabs
      v-model="tabIndex"
      background-color="green lighten-5"
      class="mt-2"
    >
      <v-tab>
        แผนงบประมาณรายรับ
      </v-tab>
      <v-tab>
        แผนงบประมาณรายจ่าย
      </v-tab>
      <v-tab>
        งบประมาณที่ได้รับจัดสรร
      </v-tab>
    </v-tabs>
    <v-tabs-items
      v-model="tabIndex"
    >
      <v-tab-item>
        <div v-if="personalIDcard && budgetplanYear">
          <BudgetplanTable :personalIDcard="personalIDcard" :budgetplanYear="budgetplanYear" :insertBt="insertBt" :updateBt="updateBt" :deleteBt="deleteBt" userType="Admin" />
        </div>
      </v-tab-item>
      <v-tab-item>
        <div v-if="personalIDcard && budgetplanYear">
          <ExpenseplanTable :personalIDcard="personalIDcard" :expenseplanYear="budgetplanYear" :insertBt="insertBt" :updateBt="updateBt" :deleteBt="deleteBt" userType="Admin" />
        </div>
      </v-tab-item>
      <v-tab-item>
        <div v-if="personalIDcard && budgetplanYear">
          <BudgetslipTableVue :budgetslipYear="budgetplanYear" :updateBt="1" :deleteBt="1" />
        </div>
      </v-tab-item>
    </v-tabs-items>
  </div>
</template>

<script>
import BudgetplanTable from '~/components/BudgetplanTable'
import ExpenseplanTable from '~/components/ExpenseplanTable'
import BudgetslipTableVue from '~/components/BudgetslipTable.vue'
export default {
  layout: 'admin_layout',

  components: {
    BudgetplanTable,
    ExpenseplanTable,
    BudgetslipTableVue
  },

  data() {
    return {
      budgetplans: [],
      personalIDcard: null,
      budgetplanYear: null,
      insertBt: 1,
      updateBt: 1,
      deleteBt: 1,
      periodYears: [],
      tabIndex: 0,
    }
  },

  async mounted() {
    let loginuser = JSON.parse(sessionStorage.getItem("loginuser"))
    this.personalIDcard = loginuser.user.personalIDcard
    if(this.$route.query.periodYear) {
      this.budgetplanYear = this.$route.query.periodYear
    } else {
      await this.getPeriod()
      // if(this.periodYears.length > 0) {
      //   this.periodYears.reverse()
      //   this.budgetplanYear = this.periodYears[0].periodYear
      // }
      if(this.periodYears.length > 0) {
        let thisPeriod = this.periodYears.filter(period => Date.now() >= new Date(period.periodBegin.replace('-', '/')).getTime() && Date.now() <= new Date(period.periodEnd.replace('-', '/')+' 23:59:00').getTime())
        if(thisPeriod.length > 0) {
          this.budgetplanYear = thisPeriod[0].periodYear
        } else {
          this.budgetplanYear = this.periodYears[0].periodYear
        }
      }
    }
    await this.getBudgetplans()
  },

  methods: {
    async getPeriod() {
      let params = {
        token: this.$store.state.jwtToken,
        fn: "All"
      }
      let result = await this.$axios.$get('period.php', {
        params:params
      })

      if(result.message == 'Success') {
        this.periodYears = JSON.parse(JSON.stringify(result.period))
      }
    },

    async getBudgetplans() {
      let result = await this.$axios.$get('budgetplan.php', {
        params: {
          token: this.$store.state.jwtToken,
          budgetplanYear: this.budgetplanYear
        }
      })

      if(result.message === 'Success') {
        this.budgetplans = JSON.parse(JSON.stringify(result.budgetplan))
      }
    }
  },

watch: {
  async budgetplanYear() {
    await this.periodYears.find(period => period.periodYear==this.budgetplanYear)
    await this.getBudgetplans()
  }
}

}
</script>
