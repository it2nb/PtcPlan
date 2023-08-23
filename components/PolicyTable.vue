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
            <v-data-table
              :headers="headers"
              :items="policys"
              :search="search"
              :items-per-page="-1"
              :loading="policysLoading"
              hide-default-footer
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <!-- <v-select
                      v-model="policyID"
                      label="ยุทธศาสตร์"
                      :items="policys"
                      item-text="policyFullname"
                      item-value="policyID"
                      outlined
                      @change="filterProjects"
                    ></v-select> -->
                    <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || userType=='Plan'">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มนโยบายที่เกี่ยวข้อง
                    </v-btn>
                  </v-col>
                  <v-col cols="12" md="6">
                    <v-text-field
                      v-model="search"
                      append-icon="mdi-magnify"
                      label="ค้นหา"
                      hide-details
                      outlined
                      dense
                    ></v-text-field>
                  </v-col>
                </v-row>
              </template>

              <template v-slot:item.policyID="{ item }">
                <div  class="text-no-wrap">PLC-{{ parseInt(item.policyID) }}</div>
              </template>
              <template v-slot:item.policyYear="{ item }">
                {{ parseInt(item.policyYear)+543 }}
              </template>
              <template v-slot:item.policyEnable="{ item }">
                <v-chip color="success" v-if="item.policyEnable==1">
                  <v-icon class="mr-1">fas fa-check-circle</v-icon> ใช้งาน
                </v-chip>
                <v-chip color="red" small dark v-else>
                  <v-icon small class="mr-1">fas fa-exclamation</v-icon> ไม่ใช้งาน
                </v-chip>
              </template>
              <template v-slot:item.actions="{ item }">
                <div  class="text-no-wrap">
                  <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="updateBt || userType=='Admin' || userType=='Plan'">
                    <v-icon small class="mr-1">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="deleteBt || userType=='Admin' || userType=='Plan'">
                    <v-icon small class="mr-1">fas fa-trash</v-icon>
                  </v-btn>
                </div>
              </template>
            </v-data-table>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row justify="center">
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
                <!-- <PolicyInsert :policy="policyData" @getInsertStatus="insertPolicy"/> -->
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
                <!-- <PolicyUpdate :policy="policyData" @getUpdateStatus="updatePolicy"/> -->
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
                <!-- <PolicyDelete :policy="policyData" @getDeleteStatus="deletePolicy"/> -->
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
export default {
  props: {
    // policys: {
    //   type: Array,
    //   default: () => []
    // }
    userType: {
      type: String,
      default: null,
    },
    personalIDcard: {
      type: String,
      default: null
    },
    policyYear: {
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
      headers: [
        {
          text: '#',
          align: 'center',
          sortable: false,
          value: 'policyID',
        },
        { text: 'นโยบาย', value: 'policyName', align: 'left', class: 'text-center' },
        { text: 'ปีงบประมาณ พ.ศ.', value: 'policyYear', align: 'center', class: 'text-center' },
        { text: 'สถานะ', value: 'policyEnable', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      policysLoading: true,
      policys: [],
      policyData: {},
      insertDialog: false,
      insertProgress: false,
      policyInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      policyUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      policyDeleteValidate: null,
    }
  },

  async mounted() {
    await this.getPolicys()
  },

  methods: {
    async getPolicys() {
      this.policysLoading = true
      let result = await this.$axios.$get('policy.php', {
        params: {
          token: this.$store.state.jwtToken,
          policyYear: this.policyYear,
          fn: 'All'
        }
      })

      if(result.message === 'Success') {
        this.policys = JSON.parse(JSON.stringify(result.policy))
      }
      this.policysLoading = false
    },

    showInsertDialog() {
      this.policyData = {
        token: this.$store.state.jwtToken,
        policyYear: this.policyYear,
        policyEnable: 1
      }
      this.insertDialog = true
    },

    async insertPolicy(res) {
      if(res.status) {
        await this.getPolicys()
        this.$emit('getpolicyStatus', {'status': true})
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
        await this.getPolicys()
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
        await this.getPolicys()
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },
  },

watch: {
  async policyYear() {
    await this.getPolicys()
  },

  async personalIDcard() {
    await this.getPolicys()
  }
}
}
</script>
