<template>
  <div>
    <v-row>
      <v-col cols="12" md="4" class="ml-md-auto">
        <v-select
          v-model="projectYear"
          label="ปีงบประมาณ พ.ศ."
          :items="periodYears"
          item-text="periodYearBd"
          item-value="periodYear"
          outlined
          dense
        ></v-select>
      </v-col>
    </v-row>
    <div v-if="personalIDcard && projectYear">
      <ProjectTableVue :personalIDcard="personalIDcard" :projectYear="projectYear" />
    </div>
  </div>
</template>
<script>
import ProjectTableVue from '~/components/ProjectTable.vue';
export default {
  layout: 'personal_layout',
  components: {
    ProjectTableVue
  },

  data() {
    return {
      personalIDcard: null,
      projectYear: null,
      periodYears: []
    }
  },

  async mounted() {
    let loginpersonal = JSON.parse(sessionStorage.getItem("loginuser"))
    this.personalIDcard = loginpersonal.personal.personalIDcard
    if(this.$route.query.periodYear) {
      this.projectYear = this.$route.query.periodYear
    } else {
      await this.getPeriod()
      if(this.periodYears.length > 0) {
        this.periodYears.reverse()
        this.projectYear = this.periodYears[0].periodYear
      }
    }
  },

  methods: {
    async getPeriod() {
      let params = {
        token: this.$store.state.jwtToken,
        fn: "getYears"
      }
      let result = await this.$axios.$get('period.php', {
        params:params
      })

      if(result.message == 'Success') {
        this.periodYears = JSON.parse(JSON.stringify(result.period))
      }
    }
  },
}
</script>
