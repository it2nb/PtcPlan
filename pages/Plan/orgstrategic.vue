<template>
  <div>
    <v-row dense>
      <v-col cols="12" class="pt-5 px-5 green lighten-5">
        <div class="col-12 col-md-2 ml-auto pa-0">
          <v-select
            v-model="orgstrategicYear"
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
    <div v-if="personalIDcard && orgstrategicYear" class="mt-2">
        <OrgstrategicTable :personalIDcard="personalIDcard" :orgstrategicYear="orgstrategicYear" :insertBt="insertBt" :updateBt="updateBt" :deleteBt="deleteBt" userType="Plan" />
    </div>
  </div>
</template>

<script>
import OrgstrategicTable from '~/components/OrgstrategicTable';
export default {
  layout: 'plan_layout',

  components: {
    OrgstrategicTable
  },

  data() {
    return {
      orgstrategics: [],
      personalIDcard: null,
      orgstrategicYear: null,
      insertBt: 1,
      updateBt: 1,
      deleteBt: 1,
      periodYears: []
    }
  },

  async mounted() {
    let loginuser = JSON.parse(sessionStorage.getItem("loginuser"))
    this.personalIDcard = loginuser.user.personalIDcard
    if(this.$route.query.periodYear) {
      this.orgstrategicYear = this.$route.query.periodYear
    } else {
      await this.getPeriod()
      // if(this.periodYears.length > 0) {
      //   this.periodYears.reverse()
      //   this.orgstrategicYear = this.periodYears[0].periodYear
      // }
      if(this.periodYears.length > 0) {
        let thisPeriod = this.periodYears.filter(period => Date.now() >= new Date(period.periodBegin.replace('/', '-')).getTime() && Date.now() <= new Date(period.periodEnd.replace('/', '-')+' 23:59:00').getTime())
        if(thisPeriod.length > 0) {
          this.orgstrategicYear = thisPeriod[0].periodYear
        } else {
          this.orgstrategicYear = this.periodYears[0].periodYear
        }
      }
    }
    await this.getOrgstrategics()
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

    async getOrgstrategics() {
      let result = await this.$axios.$get('orgstrategic.php', {
        params: {
          token: this.$store.state.jwtToken,
          orgstrategicYear: this.orgstrategicYear
        }
      })

      if(result.message === 'Success') {
        this.orgstrategics = JSON.parse(JSON.stringify(result.orgstrategic))
      }
    }
  },

watch: {
  async orgstrategicYear() {
    await this.periodYears.find(period => period.periodYear==this.orgstrategicYear)
    await this.getOrgstrategics()
  }
}

}
</script>
