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
      <v-col cols="12" class="pt-4" v-if="projectYear">
        <v-container class="py-0 my-0">
          <h2 class="col-12 col-md-5 px-0 fontBold white--text  ptcBg text-center rounded-br-xl rounded-tl-xl elevation-3">ปีงบประมาณ พ.ศ. {{ parseInt(projectYear)+543 }}</h2>
        </v-container>
      </v-col>
    </v-row>
    <div v-if="projectYear" class="mt-2 container">
      <h2 class="col-12 px-0 text-center fontBold">ความก้าวหน้าในการดำเนินโครงการแยกตามยุทธศาสตร์</h2>
      <OrgstrategicDonutVue :periodYear="parseInt(projectYear)" />
      <ProjectInfoTableVue :projectYear="parseInt(projectYear)" :projectPeriod="projectPeriod" userType="Public" class="mt-5"/>
    </div>
  </div>
</template>

<script>
import ProjectInfoTableVue from '~/components/ProjectInfoTable.vue';
import OrgstrategicDonutVue from '~/components/charts/OrgstrategicDonut.vue';
export default {

  components: {
    ProjectInfoTableVue,
    OrgstrategicDonutVue
  },

  data() {
    return {
      userID: null,
      projectYear: null,
      projectPeriod: null,
      insertBt: 0,
      updateBt: 0,
      deleteBt: 0,
      periodYears: []
    }
  },

  async mounted() {
      await this.getPeriod()
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
      if(this.$route.query.period) {
        this.projectPeriod = this.$route.query.period
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
