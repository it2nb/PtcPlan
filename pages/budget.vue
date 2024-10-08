<template>
  <div>
    <v-row dense>
      <v-col cols="12" class="pt-5 px-5 green lighten-5">
        <div class="col-12 col-md-2 ml-auto pa-0">
          <v-select
            v-model="projectYear"
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
    <v-sheet v-if="projectYear">
      <BudgetDisburseStatus :budgetYear="projectYear"/>
    </v-sheet>
    <v-tabs
      v-model="tab"
      centered
      fixed-tabs
      color="orange darken-4"
      background-color="green lighten-5"
      class="container mt-3"
      v-if="projectYear"
    >
      <v-tab>
        งบประมาณที่ได้รับจัดสรร
      </v-tab>
      <v-tab>
        ค่าใช้จ่าย
      </v-tab>
      <v-tab>
        ใบโอนจัดสรรงบประมาณ
      </v-tab>
    </v-tabs>
    <v-tabs-items
      v-model="tab"
      v-if="projectYear"
    >
      <v-tab-item>
        <BudgetDisburseInfoTableVue :budgetYear="projectYear" />
      </v-tab-item>
      <v-tab-item>
        <ExpenseplanDisburseInfoTableVue :expenseplanYear="projectYear" />
      </v-tab-item>
      <v-tab-item>
        <BudgetslipInfoTableVue :budgetslipYear="projectYear" />
      </v-tab-item>
    </v-tabs-items>
  </div>
</template>
<script>
import BudgetslipInfoTableVue from '~/components/BudgetslipInfoTable.vue'
import BudgetDisburseInfoTableVue from '~/components/BudgetDisburseInfoTable.vue'
import ExpenseplanDisburseInfoTableVue from '~/components/ExpenseplanDisburseInfoTable.vue'
export default {
  components: {
    BudgetslipInfoTableVue,
    ExpenseplanDisburseInfoTableVue,
    BudgetDisburseInfoTableVue
  },

  data() {
    return {
      tab: 0,
      userID: null,
      projectYear: null,
      insertBt: 0,
      updateBt: 0,
      deleteBt: 0,
      periodYears: []
    }
  },

  async mounted() {
    // let loginuser = JSON.parse(sessionStorage.getItem("loginuser"))
    // this.userID = loginuser.user.userID
    // if(this.$route.query.periodYear) {
    //   this.projectYear = this.$route.query.periodYear
    // } else {
      await this.getPeriod()
      // if(this.periodYears.length > 0) {
      //   this.periodYears.reverse()
      //   this.projectYear = this.periodYears[0].periodYear
      // }
      if(this.periodYears.length > 0) {
        if(this.$route.query.year) {
          this.projectYear = this.$route.query.year
        } else {
          let thisPeriod = this.periodYears.filter(period => Date.now() >= new Date(period.periodBegin.replace('/', '-')).getTime() && Date.now() <= new Date(period.periodEnd.replace('/', '-')+' 23:59:00').getTime())
          if(thisPeriod.length > 0) {
            this.projectYear = thisPeriod[0].periodYear
          } else {
            this.projectYear = this.periodYears[0].periodYear
          }
        }
      }
    // }
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
    }
  },

  watch: {
    async projectYear() {
      let result = await this.periodYears.find(period => period.periodYear==this.projectYear)
    }
  }
}
</script>
