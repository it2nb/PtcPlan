<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>การดำเนินการตามนโยบายที่เกี่ยวข้อง</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <div v-if="userType=='Admin' || userType=='Plan'">
              <v-btn text color="success" @click="showInsertPolicyDialog">
                <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มนโยบาย
              </v-btn>
            </div>
            <div>
              <v-list>
                <template v-for="policy, pindex in policies">
                  <v-list-item :key="policy.key">
                    <v-list-item-content>
                      <v-list-item-title class="pa-3 blue-grey lighten-5">
                        <v-row no-gutters>
                          <v-col cols="12" class="text-wrap">
                            <span class="font-weight-bold">{{ pindex + 1 }}. {{ policy.policyName }} </span>
                            <v-btn
                              outlined
                              x-small
                              color="primary"
                              class="mb-2"
                              @click="showProjectTableDialog(policy.policyID, null, null)"
                            >
                              <span class="font-weight-bold">{{ policy.projectQty }} โครงการ</span>
                            </v-btn>
                          </v-col>
                          <v-col cols="12" class="text-right text-wrap" v-if="userType=='Admin' || userType=='Plan'">
                            
                            <v-btn icon small color="warning" class="mr-1" @click="showUpdatePolicyDialog(policy)">
                              <v-icon small>fas fa-edit</v-icon>
                            </v-btn>
                            <v-btn icon small color="error" @click="showDeletePolicyDialog(policy)">
                              <v-icon small>fas fa-trash</v-icon>
                            </v-btn>
                            <v-btn text small color="success" @click="showInsertStrategicDialog(policy)">
                              <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มหัวข้อหลัก
                            </v-btn>
                          </v-col>
                        </v-row>
                      </v-list-item-title>
                      <v-list-item-subtitle class="ml-2 ml-md-5 px-md-1" v-for="strategic, sindex in policy.strategic" :key="strategic.key">
                        <v-row no-gutters class="mx-md-5 grey lighten-5">
                          <v-col cols="12" class="pt-3 pl-3 text-wrap">
                            <span class="font-weight-medium">{{ pindex + 1 }}.{{ sindex + 1 }} {{ strategic.strategicName }}</span>
                            <v-btn
                              outlined
                              x-small
                              color="primary"
                              class="mb-2"
                              @click="showProjectTableDialog(policy.policyID, strategic.strategicID, null)"
                            >
                            <span class="font-weight-bold">{{ strategic.projectQty }} โครงการ</span>
                            </v-btn>
                          </v-col>
                          <v-col cols="12" class="pb-3 text-right text-wrap" v-if="userType=='Admin' || userType=='Plan'">
                            <v-btn icon x-small color="warning" class="mr-1" @click="showUpdateStrategicDialog(policy, strategic)">
                              <v-icon x-small>fas fa-edit</v-icon>
                            </v-btn>
                            <v-btn icon x-small color="error" @click="showDeleteStrategicDialog(policy, strategic)">
                              <v-icon x-small>fas fa-trash</v-icon>
                            </v-btn>
                            <v-btn text x-small color="success" @click="showInsertStrategyDialog(policy, strategic)">
                              <v-icon x-small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มหัวข้อย่อย
                            </v-btn>
                          </v-col>
                          <v-col cols="12">
                            <v-divider></v-divider>
                          </v-col>
                        </v-row>
                        <v-row no-gutters class="mx-3 mx-md-10" v-for="strategy, index in strategic.strategy" :key="strategy.key">
                          <v-col cols="12" class="pt-3 pl-3 text-wrap">
                            {{ index + 1 }}) {{ strategy.strategyName }}
                            <v-btn
                              outlined
                              x-small
                              color="primary"
                              class="mb-2"
                              @click="showProjectTableDialog(policy.policyID, strategic.strategicID, strategy.strategyID)"
                            >
                            <span class="font-weight-bold">{{ strategy.projectQty }} โครงการ</span>
                            </v-btn>
                          </v-col>
                          <v-col cols="12" class="pb-3 text-right text-wrap" v-if="userType=='Admin' || userType=='Plan'">
                            <v-btn icon x-small color="warning" class="mr-1" @click="showUpdateStrategyDialog(policy, strategic, strategy)">
                              <v-icon x-small>fas fa-edit</v-icon>
                            </v-btn>
                            <v-btn icon x-small color="error" @click="showDeleteStrategyDialog(policy, strategic, strategy)">
                              <v-icon x-small>fas fa-trash</v-icon>
                            </v-btn>
                          </v-col>
                          <v-col cols="12">
                            <v-divider></v-divider>
                          </v-col>
                        </v-row>
                      </v-list-item-subtitle>
                    </v-list-item-content>
                  </v-list-item>
                  <!-- <v-divider :key="policy.key"></v-divider> -->
                </template>
              </v-list>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="insertPolicyDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="light-green lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="insertPolicyDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <PolicyInsert :policy="policyData" @getInsertStatus="insertPolicy"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="updatePolicyDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updatePolicyDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <PolicyUpdate :policy="policyData" @getUpdateStatus="updatePolicy"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="deletePolicyDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="red lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="deletePolicyDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <PolicyDelete :policy="policyData" @getDeleteStatus="deletePolicy"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="insertStrategicDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="light-green lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="insertStrategicDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <StrategicInsert :strategic="strategicData" @getInsertStatus="insertStrategic"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="updateStrategicDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateStrategicDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <StrategicUpdate :strategic="strategicData" @getUpdateStatus="updateStrategic"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="deleteStrategicDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="red lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="deleteStrategicDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <StrategicDelete :strategic="strategicData" @getDeleteStatus="deleteStrategic"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="insertStrategyDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="light-green lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="insertStrategyDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <StrategyInsert :strategy="strategyData" @getInsertStatus="insertStrategy"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="updateStrategyDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateStrategyDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <StrategyUpdate :strategy="strategyData" @getUpdateStatus="updateStrategy"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="deleteStrategyDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="red lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="deleteStrategyDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <StrategyDelete :strategy="strategyData" @getDeleteStatus="deleteStrategy"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="projectTableDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="primary lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="projectTableDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <h2 class="mt-2 font-weight-bold text-center" v-if="projectPolicyNames.policyName">{{ projectPolicyNames.policyName }}</h2>
                <h3 class="font-weight-bold text-center" v-if="projectPolicyNames.strategicName">{{ projectPolicyNames.strategicName }}</h3>
                <h3 class="font-weight-bold text-center" v-if="projectPolicyNames.strategyName">{{ projectPolicyNames.strategyName }}</h3>
                <h4 class="mt-1 font-weight-bold text-center">ปีงบประมาณ พ.ศ. {{ parseInt(policyYear)+543 }}</h4>
                <ProjectTableForm 
                  :projects="projects" 
                  :strategics="orgstrategics"
                  :projectsLoading="projectsLoading"
                  :projectSum="projectSum"
                  :projectYear="policyYear"
                  :userType="userType"
                  class="mt-2 mx-3 mx-md-5"
                />
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
// import PolicyInsertVue from './PolicyInsert.vue'
// import PolicyUpdateVue from './PolicyUpdate.vue'
// import PolicyDeleteVue from './PolicyDelete.vue'
export default {
  components: {
    // PolicyInsertVue,
    // PolicyUpdateVue,
    // PolicyDeleteVue,
  },

  props: {
    // projectID: {
    //   type: String,
    //   default: null
    // },
    policyYear: {
      type: String,
      default: null,
    },
    userType: {
      type: String,
      default: null,
    }
  },

  data() {
    return {
      policies: [],
      policyData: {},

      orgstrategics: [],

      insertPolicyDialog: false,
      insertPolicyProgress: false,
      insertPolicyValidate: null,

      updatePolicyDialog: false,
      updatePolicyProgress: false,
      updatePolicyValidate: null,

      deletePolicyDialog: false,
      deletePolicyProgress: false,
      deletePolicyValidate: null,

      strategicData: {},

      insertStrategicDialog: false,
      insertStrategicProgress: false,
      insertStrategicValidate: null,

      updateStrategicDialog: false,
      updateStrategicProgress: false,
      updateStrategicValidate: null,

      deleteStrategicDialog: false,
      deleteStrategicProgress: false,
      deleteStrategicValidate: null,

      strategicData: {},
      strategyData: {},

      insertStrategyDialog: false,
      insertStrategyProgress: false,
      insertStrategyValidate: null,

      updateStrategyDialog: false,
      updateStrategyProgress: false,
      updateStrategyValidate: null,

      deleteStrategyDialog: false,
      deleteStrategyProgress: false,
      deleteStrategyValidate: null,

      projectTableDialog: false,
      projectPolicyNames: {},
      projects: [],
      projectSum: {},
      projectsLoading: true,
    }
  },

  async mounted() {
    // if(this.projectID) {
      await this.getPolicy()
    // }
  },

  methods: {
    async getPolicy() {
      let params = {
        token: this.$store.state.jwtToken,
        policyYear: this.policyYear,
        fn: 'All'
      }

      if(this.userType == 'Public') {
        params.fn = 'AllApprovedProject'
      }

      let result = await this.$axios.$get('policy.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.policies = JSON.parse(JSON.stringify(result.policy))
      }
    },

    showInsertPolicyDialog() {
      this.policyData = {
        token: this.$store.state.jwtToken,
        policyYear: this.policyYear
      }
      this.insertPolicyDialog = true
    },

    async insertPolicy(res) {
      if(res.status) {
        await this.getPolicy()
        this.insertPolicyDialog = false
      } else {
        this.insertPolicyDialog = false
      }
    },

    showUpdatePolicyDialog(policy) {
      this.policyData = policy
      this.policyData.token = this.$store.state.jwtToken
      this.updatePolicyDialog = true
    },

    async updatePolicy(res) {
      if(res.status) {
        await this.getPolicy()
        this.updatePolicyDialog = false
      } else {
        this.updatePolicyDialog = false
      }
    },

    showDeletePolicyDialog(policy) {
      this.policyData = policy
      this.policyData.token = this.$store.state.jwtToken
      this.deletePolicyDialog = true
    },

    async deletePolicy(res) {
      if(res.status) {
        await this.getPolicy()
        this.deletePolicyDialog = false
      } else {
        this.deletePolicyDialog = false
      }
    },

    showInsertStrategicDialog(policy) {
      this.strategicData = {
        token: this.$store.state.jwtToken,
        strategicYear: this.policyYear,
        policyID: policy.policyID,
        policyName: policy.policyName,
      }
      this.insertStrategicDialog = true
    },

    async insertStrategic(res) {
      if(res.status) {
        await this.getPolicy()
        this.insertStrategicDialog = false
      } else {
        this.insertStrategicDialog = false
      }
    },

    showUpdateStrategicDialog(policy, strategic) {
      this.strategicData = strategic
      this.strategicData.token = this.$store.state.jwtToken
      this.strategicData.policyName = policy.policyName
      this.updateStrategicDialog = true
    },

    async updateStrategic(res) {
      if(res.status) {
        await this.getPolicy()
        this.updateStrategicDialog = false
      } else {
        this.updateStrategicDialog = false
      }
    },

    showDeleteStrategicDialog(policy, strategic) {
      this.strategicData = strategic
      this.strategicData.token = this.$store.state.jwtToken
      this.strategicData.policyName = policy.policyName
      this.deleteStrategicDialog = true
    },

    async deleteStrategic(res) {
      if(res.status) {
        await this.getPolicy()
        this.deleteStrategicDialog = false
      } else {
        this.deleteStrategicDialog = false
      }
    },

    showInsertStrategyDialog(policy, strategic) {
      this.strategyData = {
        token: this.$store.state.jwtToken,
        strategyYear: this.policyYear,
        policyID: policy.policyID,
        policyName: policy.policyName,
        strategicID: strategic.strategicID,
        strategicName: strategic.strategicName,
      }
      this.insertStrategyDialog = true
    },

    async insertStrategy(res) {
      if(res.status) {
        await this.getPolicy()
        this.insertStrategyDialog = false
      } else {
        this.insertStrategyDialog = false
      }
    },

    showUpdateStrategyDialog(policy, strategic, strategy) {
      this.strategyData = strategy
      this.strategyData.token = this.$store.state.jwtToken
      this.strategyData.policyName = policy.policyName
      this.strategyData.strategicName = strategic.strategicName
      this.updateStrategyDialog = true
    },

    async updateStrategy(res) {
      if(res.status) {
        await this.getPolicy()
        this.updateStrategyDialog = false
      } else {
        this.updateStrategyDialog = false
      }
    },

    showDeleteStrategyDialog(policy, strategic, strategy) {
      this.strategyData = strategy
      this.strategyData.token = this.$store.state.jwtToken
      this.strategyData.policyName = policy.policyName
      this.strategyData.strategicName = strategic.strategicName
      this.deleteStrategyDialog = true
    },

    async deleteStrategy(res) {
      if(res.status) {
        await this.getPolicy()
        this.deleteStrategyDialog = false
      } else {
        this.deleteStrategyDialog = false
      }
    },

    async getOrgstrategics(projectYear) {
      let params = {
        token: this.$store.state.jwtToken,
          orgstrategicYear: projectYear
      }

      let result = await this.$axios.$get('orgstrategic.php', {params: params})

      if(result.message == 'Success') {
        this.orgstrategics = JSON.parse(JSON.stringify(result.orgstrategic))
        this.orgstrategics.unshift({
          orgstrategicID: "all",
          orgstrategicName: "ทุกยุทธ์ศาสตร์"
        })
      }
    },

    async showProjectTableDialog(policyID, strategicID, strategyID) {
      this.projectsLoading = true
      this.projectPolicyNames = {
        policyName: null,
        strategicName: null,
        strategyName: null
      }
      await this.$axios.$get('project.php', {
        params: {
          token: this.$store.state.jwtToken,
          projectYear: this.policyYear,
          policyID: policyID,
          strategicID: strategicID,
          strategyID: strategyID
        }
      }).then((res) => {
        if(res.message == 'Success') {
          this.projects = JSON.parse(JSON.stringify(res.project))
          if(this.userType == 'Public') {
            this.projects = this.projects.filter(p => p.projectStatus == 'อนุมัติ')
          }
          this.getOrgstrategics(this.policyYear)
          if(policyID) {
            this.projectPolicyNames.policyName = this.policies.find(p => p.policyID == policyID).policyName
          }
          if(strategicID) {
            this.projectPolicyNames.strategicName = this.policies.find(p => p.policyID == policyID).strategic.find(s => s.strategicID == strategicID).strategicName
          }
          if(strategyID) {
            this.projectPolicyNames.strategyName = this.policies.find(p => p.policyID == policyID).strategic.find(s => s.strategicID == strategicID).strategy.find(st => st.strategyID == strategyID).strategyName
          }
        } else {
          this.projects = []
        }
        this.projectsLoading = false
        this.projectTableDialog = true
      }).catch((err) => {
        console.log(err)
      })
    },

    thaiDate(inDate) {
      let result = ''
      if(inDate) {
        let thdate = new Date(inDate)
        result = thdate.toLocaleDateString('th-TH', {
          year: 'numeric',
          month: 'long',
          day: 'numeric',
        })
      }
      return result
    },

  },

  watch: {
    async policyYear() {
      await this.getPolicy()
    }
  }
}
</script>
