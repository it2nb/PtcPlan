<template>
  <div>
    <v-row dense>
      <v-col cols="12" class="pt-5 px-5 green lighten-5">
        <div class="col-12 col-md-2 ml-auto pa-0">
          <v-select
            v-model="disburseYear"
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
    <div v-if="userID && disburseYear" class="mt-2">
        <DisbursecheckTableVue :userID="userID" :disburseYear="disburseYear" :departmentSys="departmentSys"/>
    </div>
  </div>
</template>

<script>
import DisbursecheckTableVue from '~/components/DisbursecheckTable.vue';
export default {
  layout: 'department_layout',

  components: {
    DisbursecheckTableVue
  },

  data() {
    return {
      departmentID: null,
      departmentSys: null,
      userID: null,
      disburses: [],
      personalIDcard: null,
      disburseYear: null,
      insertBt: 1,
      updateBt: 1,
      deleteBt: 1,
      periodYears: []
    }
  },

  async mounted() {
    let loginuser = JSON.parse(sessionStorage.getItem("loginuser"))
    this.departmentID = loginuser.user.departmentID
    this.departmentSys = loginuser.user.departmentSys
    this.userID = loginuser.user.userID
    if(this.$route.query.periodYear) {
      this.disburseYear = this.$route.query.periodYear
    } else {
      await this.getPeriod()
      if(this.periodYears.length > 0) {
        let thisPeriod = this.periodYears.filter(period => Date.now() >= new Date(period.periodBegin.replace('/', '-')).getTime() && Date.now() <= new Date(period.periodEnd.replace('/', '-')+' 23:59:00').getTime())
        if(thisPeriod.length > 0) {
          this.disburseYear = thisPeriod[0].periodYear
        } else {
          this.disburseYear = this.periodYears[0].periodYear
        }
      }
    }
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
  },

watch: {
  async disburseYear() {
    await this.periodYears.find(period => period.periodYear==this.disburseYear)
    // await this.getDisburses()
  }
}

}
</script>
