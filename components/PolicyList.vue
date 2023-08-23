<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>นโยบายที่เกี่ยวข้อง</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <div>
              <v-btn text color="success" @click="showInsertPolicyDialog">
                <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มนโยบาย
              </v-btn>
            </div>
            <div>
              <v-list>
                <template v-for="policy in policies">
                  <v-list-item :key="policy.key">
                    <v-list-item-content>
                      <v-list-item-title class="pa-3 blue-grey lighten-5">
                        <v-row no-gutters>
                          <v-col>
                            {{ policy.policyName }}
                          </v-col>
                          <v-col class="text-right" v-if="userType=='Admin' || userType=='Plan'">
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
                      <v-list-item-subtitle class="ml-5 px-3" v-for="strategic in policy.strategic" :key="strategic.key">
                        <v-row no-gutters class="mx-5 grey lighten-5">
                          <v-col class="pa-3">
                            {{ strategic.strategicName }}
                          </v-col>
                          <v-col class="py-3 text-right" v-if="userType=='Admin' || userType=='Plan'">
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
                        <v-row no-gutters class="mx-10" v-for="strategy in strategic.strategy" :key="strategy.key">
                          <v-col class="pa-3">
                            {{ strategy.strategyName }}
                          </v-col>
                          <v-col class="py-3 text-right" v-if="userType=='Admin' || userType=='Plan'">
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

      insertStrategyDialog: false,
      insertStrategyProgress: false,
      insertStrategyValidate: null,

      updateStrategyDialog: false,
      updateStrategyProgress: false,
      updateStrategyValidate: null,

      deleteStrategyDialog: false,
      deleteStrategyProgress: false,
      deleteStrategyValidate: null,
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
