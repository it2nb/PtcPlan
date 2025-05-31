<template>
  <v-row justify="center" align="center" dense>
    <v-col cols="12" class="pt-4" v-if="periodYear">
      <v-container class="py-0 my-0">
        <h2 class="col-12 col-md-5 px-0 fontBold white--text  ptcBg text-center rounded-br-xl rounded-tl-xl elevation-3">ปีงบประมาณ พ.ศ. {{ parseInt(periodYear)+543 }}</h2>
      </v-container>
    </v-col>
    <v-col cols="12" class="pb-5 white lighten-5" v-if="periodYear">
      <v-row class="col-12 col-md-10 col-xl-9 mx-auto container">
        <v-col cols="12" md="12" class="d-flex align-center text-center">
          <h2 class="col-12 px-0 fontBold">ยุทธศาสตร์สถานศึกษา</h2>
        </v-col>
        <v-col cols="12" md="12" >
          <OrgstrategicRadarVue :periodYear="parseInt(periodYear)" />
        </v-col>
        <!-- <v-col cols="12" md="6" >
          <OrgstrategicBudgetRadarVue :periodYear="parseInt(periodYear)" />
        </v-col> -->
      </v-row>
    </v-col>
    <v-col cols="12" class="py-5 blue-grey lighten-5" v-if="periodYear">
      <v-row class="col-12 col-md-10 col-xl-9 mx-auto container">
        <v-col cols="12" md="12" class="d-flex align-center text-center">
          <h2 class="col-12 px-0 fontBold">งบประมาณ</h2>
        </v-col>
        <v-col cols="12" md="12" >
          <BudgettypeBarVue :periodYear="parseInt(periodYear)" />
        </v-col>
        <v-col cols="12" md="12" v-for="budgettype in budgettypes" :key="budgettype.budgettypeID">
          <BudgetBarVue :periodYear="parseInt(periodYear)" :budgettypeID="budgettype.budgettypeID" :budgettypeName="budgettype.budgettypeName" />
        </v-col>
      </v-row>
    </v-col>
    <v-col cols="12" class="py-5" v-if="periodYear">
      <v-row class="col-12 col-md-10 col-xl-9 mx-auto container">
        <v-col cols="12" md="12" class="d-flex align-center text-center">
          <h2 class="col-12 px-0 fontBold">วัสดุการศึกษา</h2>
        </v-col>
        <v-col cols="12" md="12" >
          <DisburseDepartmentBarVue :periodYear="parseInt(periodYear)" expenseplanDes="วัสดุการศึกษา" />
        </v-col>
      </v-row>
    </v-col>
    <v-col cols="12" class="py-5 blue-grey lighten-5" v-if="periodYear">
      <v-row class="col-12 col-md-10 col-xl-9 mx-auto container">
        <v-col cols="12" md="12" class="d-flex align-center text-center">
          <h2 class="col-12 px-0 fontBold">ความก้าวหน้าในการดำเนินโครงการแยกตามยุทธศาสตร์</h2>
        </v-col>
        <v-col cols="12" md="12" >
          <OrgstrategicDonutVue :periodYear="parseInt(periodYear)" />
        </v-col>
      </v-row>
    </v-col>
  </v-row>
</template>

<script>
import OrgstrategicRadarVue from '~/components/charts/OrgstrategicRadar.vue'
import OrgstrategicBudgetRadarVue from '~/components/charts/OrgstrategicBudgetRadar.vue'
import OrgstrategicDonutVue from '~/components/charts/OrgstrategicDonut.vue'
import BudgettypeBarVue from '~/components/charts/BudgettypeBar.vue'
import BudgetBarVue from '~/components/charts/BudgetBar.vue'
import DisburseDepartmentBarVue from '~/components/charts/DisburseDepartmentBar.vue'
export default {
  components: {
    OrgstrategicRadarVue,
    OrgstrategicBudgetRadarVue,
    OrgstrategicDonutVue,
    BudgettypeBarVue,
    BudgetBarVue,
    DisburseDepartmentBarVue,
  },

  props: {
    periodYear: {
      type: Number,
      default: null,
    },
    userType: {
      type: String,
      default: null,
    }
  },

  data() {
    return {
      thdate: '',
      periods: [],
      budgettypes: [],
    }
  },
  async mounted() {
    this.thdate = new Date()
    //await this.getPeriods()
    await this.getBudgettype()
  },
  methods: {
    // async getPeriods() {
    //   let params = {
    //     token: this.$store.state.jwtToken,
    //     fn: 'getYears'
    //   }
    //   let result = await this.$axios.$get('period.php', {params})
    //   if(result.message == 'Success') {
    //     this.periods = JSON.parse(JSON.stringify(result.period))
    //     this.periods.reverse()
    //     if(this.periods.length > 0) {
    //       this.periodYear = this.periods[0].periodYear
    //     }
    //   }
    // },

    async getBudgettype() {
      let params = {
        token: this.$store.state.jwtToken,
        budgetslipYear: this.periodYear,
        fn: 'getSlipDisburse'
      }
      let result = await this.$axios.$get('budgettype.php', {params})
      if(result.message == 'Success') {
        this.budgettypes = JSON.parse(JSON.stringify(result.budgettype))
      }
    }
  }
}
</script>
