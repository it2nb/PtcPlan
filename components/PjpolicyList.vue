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
            <v-responsive>
              <v-list>
                <template v-for="policy in policies">
                  <v-list-item :key="policy.key">
                    <v-list-item-content>
                      <v-list-item-title class="pa-3 blue-grey lighten-5">
                        <div v-if="policy.strategic.length <= 0">
                          <v-checkbox
                            v-model="policy.policyChk"
                            true-value="1"
                            false-value="0"
                            :label="policy.policyName"
                            :readonly="readOnly"
                            @change="policyChange(policy.policyID, 0, 0, policy.policyChk)"
                          ></v-checkbox>
                        </div>
                        <div v-else>
                          {{ policy.policyName }}
                        </div>
                      </v-list-item-title>
                      <v-list-item-title class="ml-5 px-3" v-for="strategic in policy.strategic" :key="strategic.key">
                        <v-row no-gutters>
                          <v-col cols="12" v-if="strategic.strategy.length <= 0">
                            <v-checkbox
                              v-model="strategic.strategicChk"
                              true-value="1"
                              false-value="0"
                              :label="strategic.strategicName" dense class="py-0 my-0"
                              :readonly="readOnly"
                              @change="policyChange(strategic.policyID, strategic.strategicID, 0, strategic.strategicChk)"
                            ></v-checkbox>
                          </v-col>
                          <v-col cols="12" class="py-2" v-else>
                            {{ strategic.strategicName }}
                          </v-col>
                          <v-col  cols="12" class="ml-5" v-for="strategy in strategic.strategy" :key="strategy.key">
                            <v-checkbox
                              v-model="strategy.strategyChk"
                              true-value="1"
                              false-value="0"
                              :label="strategy.strategyName" dense class="py-0 my-0"
                              :readonly="readOnly"
                              @change="policyChange(strategy.policyID, strategy.strategicID, strategy.strategyID, strategy.strategyChk)"
                            ></v-checkbox>
                          </v-col>
                        </v-row>
                      </v-list-item-title>
                    </v-list-item-content>
                  </v-list-item>
                  <v-divider :key="policy.key"></v-divider>
                </template>
              </v-list>
            </v-responsive>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- <v-row justify="center">
      <v-dialog
        v-model="insertDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="light-green lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="insertDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <PolicyInsertVue :policy="policyData" @getInsertStatus="insertPolicy"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="updateDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <PolicyUpdateVue :policy="policyData" @getUpdateStatus="updatePolicy"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="deleteDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="red lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="deleteDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <PolicyDeleteVue :policy="policyData" @getDeleteStatus="deletePolicy"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row> -->

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
    projectID: {
      type: String,
      default: null
    },
    periodYear: {
      type: String,
      default: null
    },
    readOnly: {
      type: Boolean,
      default: false,
    }
  },

  data() {
    return {
      policies: [],

      policyData: {},

      insertDialog: false,
      insertProgress: false,
      insertValidate: null,

      updateDialog: false,
      updateProgress: false,
      updateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      deleteValidate: null,
    }
  },

  async mounted() {
    if(this.projectID) {
      await this.getPolicy()
    }
  },

  methods: {
    async getPolicy() {
      let params = {
        token: this.$store.state.jwtToken,
        projectID: this.projectID,
        pjpolicyYear: this.periodYear,
        fn: 'All'
      }
      let result = await this.$axios.$get('pjpolicy.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.policies = JSON.parse(JSON.stringify(result.policy))
      }
    },

    async policyChange(policyID, strategicID, strategyID, value) {
      let params = {
        token: this.$store.state.jwtToken,
        projectID: this.projectID,
        strategyID: strategyID,
        strategicID: strategicID,
        policyID: policyID
      }
      if(value == '1') {
        await this.$axios.$post('pjpolicy.insert.php', params)
      } else {
        await this.$axios.$post('pjpolicy.delete.php', params)
      }
    },

    showInsertDialog() {
      this.policyData = {
        token: this.$store.state.jwtToken,
        projectID: this.projectID
      }
      this.insertDialog = true
    },

    async insertPolicy(res) {
      if(res.status) {
        await this.getPolicy()
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(policy) {
      this.policyData = policy
      this.policyData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updatePolicy(res) {
      if(res.status) {
        await this.getPolicy()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(policy) {
      this.policyData = policy
      this.policyData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deletePolicy(res) {
      if(res.status) {
        await this.getPolicy()
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
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
    async projectID() {
      await this.getPolicy()
    }
  }
}
</script>
