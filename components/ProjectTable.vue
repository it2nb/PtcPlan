<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>โครงการ ประจำปีงบประมาณ พ.ศ.{{ parseInt(projectYear)+543 }}</b>
            <v-spacer></v-spacer>
              <span class="mr-md-3 text-center caption" v-if="userType=='Admin'|| userType=='Director'|| userType=='Plan'">
              <v-btn fab small color="white" :href="'/print/projecttableReport/?year='+projectYear" target="_blank">
                <v-icon color="primary">fas fa-print</v-icon>
              </v-btn><br>
              รายชื่อ
            </span>
            <span class="mr-md-3 text-center caption" v-if="userType=='Admin'||userType=='Director'||userType=='Plan'">
              <v-btn fab small color="white" :href="'/print/projecttableResultReport/?year='+projectYear" target="_blank">
                <v-icon color="primary">fas fa-print</v-icon>
              </v-btn><br>
              สรุป
            </span>
          </v-card-title>
          <!-- <v-card-subtitle  class="ptcBg white--text">
            จำนวน {{ projects.length }} โครงการ งบประมาณ {{ moneyFormat(projectSum.pjbudgetMoney) }} บาท
          </v-card-subtitle> -->
          <v-divider></v-divider>
          <v-card-text>
            <v-tabs
              v-model="tab"
              grow
              slider-color="orange darken-3"
              background-color="green lighten-5"
            >
              <v-tab>
                <b class="grey--text text--darken-2">ทั้งหมด</b>
              </v-tab>
              <v-tab>
                <b class="primary--text">เสนอโครงการ</b>
              </v-tab>
              <!-- <v-tab>
                <b class="deep-purple--text">แผนก/งานเห็นชอบแล้ว</b>
              </v-tab> -->
              <v-tab class="lime--text text--darken-3">
                <b>ฝ่ายเห็นชอบแล้ว</b>
              </v-tab>
              <v-tab class="success--text text--darken-3">
                <b>อนุมัติแล้ว</b>
              </v-tab>
            </v-tabs>
            <v-tabs-items
              v-model="tab"
            >
              <v-tab-item class="pt-5">
                <div v-if="projectYear && userType && projects" class="mt-2">
                  <ProjectTableFormVue
                    :projects="projects"
                    :projectsLoading="projectsLoading"
                    :userID="userID"
                    :userType="userType"
                    :personalIDcard="personalIDcard"
                    :partyID="partyID"
                    :departmentID="departmentID"
                    :orgstrategicID="orgstrategicID"
                    :orgstrategyID="orgstrategyID"
                    :projectYear="projectYear"
                    :insertBt="insertBt"
                    :updateBt="updateBt"
                    :deleteBt="deleteBt"
                    class="pb-5 mb-5"
                    @getProjects="getProjects"
                  />
                </div>
              </v-tab-item>
              <!-- เสนอโครงการ -->
              <v-tab-item class="pt-5">
                <div v-if="projectYear && userType && projects" class="mt-2">
                  <ProjectTableFormVue
                    :projects="projectsProp"
                    :projectsLoading="projectsLoading"
                    :userID="userID"
                    :userType="userType"
                    :personalIDcard="personalIDcard"
                    :partyID="partyID"
                    :departmentID="departmentID"
                    :orgstrategicID="orgstrategicID"
                    :orgstrategyID="orgstrategyID"
                    :projectYear="projectYear"
                    :insertBt="insertBt"
                    :updateBt="updateBt"
                    :deleteBt="deleteBt"
                    class="pb-5 mb-5"
                    @getProjects="getProjects"
                  />
                </div>
              </v-tab-item>
              <!-- แผนก/งานเห็นชอบ -->
              <!-- <v-tab-item class="pt-5">
                <div v-if="projectYear && userType && projects" class="mt-2">
                  <ProjectTableFormVue
                    :projects="projectsDept"
                    :projectsLoading="projectsLoading"
                    :userID="userID"
                    :userType="userType"
                    :personalIDcard="personalIDcard"
                    :partyID="partyID"
                    :departmentID="departmentID"
                    :orgstrategicID="orgstrategicID"
                    :orgstrategyID="orgstrategyID"
                    :projectYear="projectYear"
                    :insertBt="0"
                    :updateBt="updateBt"
                    :deleteBt="deleteBt"
                    class="pb-5 mb-5"
                    @getProjects="getProjects"
                  />
                </div>
              </v-tab-item> -->
              <!-- ฝ่ายเห็นชอบ -->
              <v-tab-item class="pt-5">
                <div v-if="projectYear && userType && projects" class="mt-2">
                  <ProjectTableFormVue
                    :projects="projectsPart"
                    :projectsLoading="projectsLoading"
                    :userID="userID"
                    :userType="userType"
                    :personalIDcard="personalIDcard"
                    :partyID="partyID"
                    :departmentID="departmentID"
                    :orgstrategicID="orgstrategicID"
                    :orgstrategyID="orgstrategyID"
                    :projectYear="projectYear"
                    :insertBt="0"
                    :updateBt="updateBt"
                    :deleteBt="deleteBt"
                    class="pb-5 mb-5"
                    @getProjects="getProjects"
                  />
                </div>
              </v-tab-item>
              <!-- อนุมัติ -->
              <v-tab-item class="pt-5">
                <div v-if="projectYear && userType && projects" class="mt-2">
                  <ProjectTableFormVue
                    :projects="projectsAppr"
                    :projectsLoading="projectsLoading"
                    :userID="userID"
                    :userType="userType"
                    :personalIDcard="personalIDcard"
                    :partyID="partyID"
                    :departmentID="departmentID"
                    :orgstrategicID="orgstrategicID"
                    :orgstrategyID="orgstrategyID"
                    :projectYear="projectYear"
                    :insertBt="0"
                    :updateBt="0"
                    :deleteBt="0"
                    class="pb-5 mb-5"
                    @getProjects="getProjects"
                  />
                </div>
              </v-tab-item>
            </v-tabs-items>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
var numeral = require('numeral')
import Swal from 'sweetalert2'
// import ProjectInsertVue from './ProjectInsert.vue'
// import PjpolicyListVue from './PjpolicyList.vue'
// import PjactivityListVue from './PjactivityList.vue'
// import PjbudgetTableVue from './PjbudgetTable.vue'
// import PjsummaryInfoVue from './PjsummaryInfo.vue'
import ProjectTableFormVue from './ProjectTableForm.vue'
export default {
  components: {
    // ProjectInsertVue,
    ProjectTableFormVue,
    // PjpolicyListVue,
    // PjactivityListVue,
    // PjbudgetTableVue,
    // PjsummaryInfoVue
  },

  props: {
    userType: {
      type: String,
      default: null,
    },
    userID: {
      type: String,
      default: null,
    },
    personalIDcard: {
      type: String,
      default: null
    },
    partyID: {
      type: String,
      default: null
    },
    departmentID: {
      type: String,
      default: null
    },
    orgstrategicID: {
      type: String,
      default: null
    },
    orgstrategyID: {
      type: String,
      default: null
    },
    projectYear: {
      type: String,
      default: null
    },
    insertBt: {
      type: Number,
      default: 0
    },
    updateBt: {
      type: Number,
      default: 0
    },
    deleteBt: {
      type: Number,
      default: 0
    },
  },

  data() {
    return {
      projects: [],
      projectsProp: [],
      projectsDept: [],
      projectsPart: [],
      projectsAppr: [],
      projectSum: {},
      projectsLoading: true,
      tab: null,
    }
  },

  async mounted() {
    await this.getProjects()
  },

  methods: {
    async getProjects() {
      this.projectsLoading = true
      let params = {
        token: this.$store.state.jwtToken,
          personalIDcard: this.personalIDcard,
          partyID: this.partyID,
          departmentID: this.departmentID,
          orgstrategicID: this.orgstrategicID,
          orgstrategyID: this.orgstrategyID,
          projectYear: this.projectYear
      }
      if(this.userType == 'Admin') {
        delete params.personalIDcard
      } else if(this.userType == 'Director') {
        delete params.personalIDcard
        delete params.partyID
      }

      let result = await this.$axios.$get('project.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.projects = JSON.parse(JSON.stringify(result.project))
        if(this.projects){
          this.projectsProp = this.projects.filter(project => project.projectStatus=='เสนอโครงการ')
          this.projectsDept = this.projects.filter(project => project.projectStatus=='แผนก/งานเห็นชอบ')
          this.projectsPart = this.projects.filter(project => project.projectStatus=='ฝ่ายเห็นชอบ')
          this.projectsAppr = this.projects.filter(project => project.projectStatus=='อนุมัติ')
        }
      }

      if(this.userType == 'Admin' || this.userType == 'Director' || this.userType == 'Plan' || this.userType == 'Finance') {
        params.fn = 'getSummaryByYear'
      } else if(this.userType == 'Party') {
        params.fn = 'getSummaryByPartyYear'
      } else if(this.userType == 'Department') {
        params.fn = 'getSummaryByDepartmentYear'
      } else if(this.userType == 'Personal') {
        params.fn = 'getSummaryByPersonalYear'
      } else if(this.userType == 'Public') {
        params.fn = 'getSummaryApproveByYear'
      }

      let sum = await this.$axios.$get('project.php', {
        params: params
      })

      if(sum.message == 'Success') {
        this.projectSum = JSON.parse(JSON.stringify(sum.project))
      }

      this.projectsLoading = false
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    },

  },

  watch: {
    async projectYear() {
      await this.getProjects()
    },

    async personalIDcard() {
      await this.getProjects()
    }
  }
}
</script>
