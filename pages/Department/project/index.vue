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
      <v-col cols="12" v-if="periodYears.length > 0">
        <v-data-table
          :items="periodYears"
          :headers="[
            {
              value: 'periodYear'
            }
          ]"
        >
            <template v-slot:item.periodYear="{item}">
              <div class="py-5 text-center">
                <h2 class="my-3 font-weight-bold">ปีงบประมาณ พ.ศ.{{ item.periodYearBd }}</h2>
                <v-btn x-large color="success" :to="'/Department/project/project/?projectYear='+item.periodYear+'&insertBt=1'" v-if="item.insertEnable==1">
                  <v-icon class="mr-2">fas fa-plus-circle</v-icon> เพิ่มโครงการ
                </v-btn>
                <v-btn x-large color="primary" :to="'/Department/project/project/?projectYear='+item.periodYear+'&insertBt=0'">
                  <v-icon class="mr-2">fas fa-spinner</v-icon> ดำเนินงานและรายงานผลโครงการ
                </v-btn>
              </div>
            </template>
        </v-data-table>
      </v-col>
    </v-row>
    <!-- <div v-if="userID && departmentID && projectYear" class="mt-2">
      <ProjectTableVue :userID="userID" :departmentID="departmentID" :projectYear="projectYear" :insertBt="insertBt" :updateBt="updateBt" :deleteBt="deleteBt" userType="Department" />
    </div> -->
  </div>
</template>

<script>
import ProjectTableVue from '~/components/ProjectTable.vue';
export default {
  layout: 'department_layout',

  components: {
    ProjectTableVue,
  },

  data() {
    return {
      departmentID: null,
      userID: null,
      projectYear: null,
      insertBt: 0,
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
      this.projectYear = this.$route.query.periodYear
    } else {
      await this.getPeriod()
      // if(this.periodYears.length > 0) {
      //   this.periodYears.reverse()
      //   this.projectYear = this.periodYears[0].periodYear
      // }
      console.log(this.periodYears)
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
        if(this.periodYears.length > 0) {
          let thisPeriod = this.periodYears.filter(period => Date.now() >= new Date(period.periodBegin.replace('/', '-')).getTime() && Date.now() <= new Date(period.periodEnd.replace('/', '-')+' 23:59:00').getTime())
          if(thisPeriod.length > 0) {
            this.projectYear = thisPeriod[0].periodYear
          } else {
            this.projectYear = this.periodYears[0].periodYear
          }

          this.periodYears = this.periodYears.filter(period=>period.periodEnable)
          this.periodYears.map(period=>{
            if(period.periodProjectStart != null && period.periodProjectEnd != null) {
              if(Date.now() >= new Date(period.periodProjectStart.replace('/', '-')+' 00:00:00').getTime() && Date.now() <= new Date(period.periodProjectEnd.replace('/', '/-')+' 23:59:59').getTime()) {
                period.insertEnable = 1;
              } else {
                period.insertEnable = 0;
              }
            } else {
              period.insertEnable = 0;
            }
          })
        }
      }
    }
  },

  watch: {
    // async projectYear() {
    //   let result = await this.periodYears.find(period => period.periodYear==this.projectYear)
    //   let intime = (Date.now() >= new Date(result.periodProjectStart.replace('/', '-')+' 00:00:00').getTime() && Date.now() <= new Date(result.periodProjectEnd.replace('/', '-')+' 23:59:59').getTime())
    //   if(intime && result.periodEnable == 1) {
    //     this.insertBt = 1;
    //   } else {
    //     this.insertBt = 0
    //   }
    // }
  }

}
</script>
