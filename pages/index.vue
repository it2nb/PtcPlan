<template>
  <v-row justify="center" align="center" dense>
    <v-col cols="12" class="pt-5 px-5 green lighten-5">
      <div class="col-12 col-md-2 ml-auto pa-0" v-if="periods.length > 0">
        <v-select
          v-model="periodYear"
          label="ปีงบประมาณ พ.ศ."
          :items="periods"
          item-text="periodYearBd"
          item-value="periodYear"
          outlined
          dense
        ></v-select>
      </div>
    </v-col>
    <v-col cols="12" class="mt-2" v-if="periodYear">
      <InfoVue :periodYear="parseInt(periodYear)" userType="Public" />
    </v-col>
  </v-row>
</template>

<script>
import InfoVue from '~/components/Info.vue'
export default {
  name: 'IndexPage',
  components: {
    InfoVue,
  },

  data() {
    return {
      thdate: '',
      periods: [],
      periodYear: null,
    }
  },
  async mounted() {
    this.thdate = new Date()
    await this.getPeriods()
  },
  methods: {
    async getPeriods() {
      let params = {
        token: this.$store.state.jwtToken,
        fn: 'All'
      }
      let result = await this.$axios.$get('period.php', {params})
      //console.log(result)
      if(result.message == 'Success') {
        this.periods = JSON.parse(JSON.stringify(result.period))
        if(this.periods.length > 0) {
          let thisPeriod = this.periods.filter(period => Date.now() >= new Date(period.periodBegin.replace('/', '-')).getTime() && Date.now() <= new Date(period.periodEnd.replace('/', '-')+' 23:59:00').getTime())
          
          if(thisPeriod.length > 0) {
            this.periodYear = thisPeriod[0].periodYear
          } else {
            this.periodYear = this.periods[0].periodYear
          }
        }
      }
    },
  }
}
</script>
