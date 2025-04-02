<template>
  <div>
    <v-row dense>
      <v-col cols="12" class="pt-5 px-5 green lighten-5">
        <div class="col-12 col-md-2 ml-auto pa-0">
          <v-select
            v-model="policyYear"
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
    <!-- <div v-if="personalIDcard && policyYear" class="mt-2">
        <PolicyTable :personalIDcard="personalIDcard" :policyYear="policyYear" :insertBt="insertBt" :updateBt="updateBt" :deleteBt="deleteBt" userType="Admin" />
    </div> -->
    <div v-if="personalIDcard && policyYear" class="mt-2">
        <PolicyList :personalIDcard="personalIDcard" :policyYear="policyYear" :insertBt="insertBt" :updateBt="updateBt" :deleteBt="deleteBt" userType="Director" />
    </div>
  </div>
</template>

<script>
// import PolicyTable from '~/components/PolicyTable';
export default {
  layout: 'director_layout',

  // components: {
  //   PolicyTable
  // },

  data() {
    return {
      policys: [],
      personalIDcard: null,
      policyYear: null,
      insertBt: 0,
      updateBt: 0,
      deleteBt: 0,
      periodYears: []
    }
  },

  async mounted() {
    let loginuser = JSON.parse(sessionStorage.getItem("loginuser"))
    this.personalIDcard = loginuser.user.personalIDcard
    if(this.$route.query.periodYear) {
      this.policyYear = this.$route.query.periodYear
    } else {
      await this.getPeriod()
      // if(this.periodYears.length > 0) {
      //   this.periodYears.reverse()
      //   this.policyYear = this.periodYears[0].periodYear
      // }
      if(this.periodYears.length > 0) {
        let thisPeriod = this.periodYears.filter(period => Date.now() >= new Date(period.periodBegin.replace('/', '-')).getTime() && Date.now() <= new Date(period.periodEnd.replace('/', '-')+' 23:59:00').getTime())
        if(thisPeriod.length > 0) {
          this.policyYear = thisPeriod[0].periodYear
        } else {
          this.policyYear = this.periodYears[0].periodYear
        }
      }
    }
    await this.getPolicys()
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

    async getPolicys() {
      let result = await this.$axios.$get('policy.php', {
        params: {
          token: this.$store.state.jwtToken,
          policyYear: this.policyYear
        }
      })

      if(result.message === 'Success') {
        this.policys = JSON.parse(JSON.stringify(result.policy))
      }
    }
  },

watch: {
  async policyYear() {
    await this.periodYears.find(period => period.periodYear==this.policyYear)
    await this.getPolicys()
  }
}

}
</script>
