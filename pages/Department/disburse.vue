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
        <DisburseTableVue :departmentID="departmentID" :userID="userID" :disburseYear="disburseYear" userType="Department" />
    </div>
  </div>
</template>

<script>
import DisburseTableVue from '~/components/DisburseTable.vue';
export default {
  layout: 'department_layout',

  components: {
    DisburseTableVue
  },

  data() {
    return {
      departmentID: null,
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
    this.userID = loginuser.user.userID
    if(this.$route.query.periodYear) {
      this.disburseYear = this.$route.query.periodYear
    } else {
      await this.getPeriod()
      // if(this.periodYears.length > 0) {
      //   this.periodYears.reverse()
      //   this.disburseYear = this.periodYears[0].periodYear
      // }
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

    // async getDisburses() {
    //   let result = await this.$axios.$get('disburse.php', {
    //     params: {
    //       token: this.$store.state.jwtToken,
    //       disburseYear: this.disburseYear
    //     }
    //   })

    //   if(result.message === 'Success') {
    //     this.disburses = JSON.parse(JSON.stringify(result.disburse))
    //   }
    // }
  },

watch: {
  async disburseYear() {
    await this.periodYears.find(period => period.periodYear==this.disburseYear)
    // await this.getDisburses()
  }
}

}
</script>
