<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>งบประมาณโครงการ</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="pjbudgets"
              :search="search"
              :items-per-page="-1"
              :loading="pjbudgetsLoading"
              hide-default-footer
            >
              <template v-slot:top v-if="!readOnly">
                <v-row>
                  <v-col cols="12" md="6" v-if="insertBt">
                    <v-btn color="success" text @click="showInsertDialog">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มงบประมาณโครงการ
                    </v-btn>
                  </v-col>
                </v-row>
              </template>

              <!-- <template v-slot:item.pjbudgetMoney="{ item }">
                <div class="text-no-wrap text-right">
                  {{ moneyFormat(parseInt(item.pjbudgetMoney)) }}
                </div>
              </template> -->

              <template v-slot:item.pjbudgetMoney="{ item }">
                <div class="text-no-wrap text-right">
                  {{ moneyFormat(parseInt(item.pjbudgetQty)*parseFloat(item.pjbudgetMoney)) }}
                  <div class="caption" v-if="parseFloat(item.disburseMoney)>0">
                    <span class="px-1 success lighten-4" v-if="parseFloat(item.disburseMoney)<=parseFloat(item.pjbudgetMoney)">{{ moneyFormat(parseFloat(item.disburseMoney)) }}</span>
                    <span class="px-1 red lighten-4" v-else>{{ moneyFormat(parseFloat(item.disburseMoney)) }}</span>
                  </div>
                </div>
              </template>

              <template v-slot:item.actions="{ item }" v-if="!readOnly">
                <div  class="text-no-wrap">
                  <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="(item.projectStatus!='อนุมัติ' && updateBt) || userType=='Admin'">
                    <v-icon small class="mr-1">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="(item.projectStatus!='อนุมัติ' && parseFloat(item.disburseMoney)<=0 && deleteBt) || userType=='Admin'">
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
                <PjbudgetInsertVue :pjbudget="pjbudgetData" @getInsertStatus="insertPjbudget"/>
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
                <PjbudgetUpdateVue :pjbudget="pjbudgetData" @getUpdateStatus="updatePjbudget"/>
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
                <PjbudgetDeleteVue :pjbudget="pjbudgetData" @getDeleteStatus="deletePjbudget"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
var numeral = require('numeral')
import PjbudgetInsertVue from './PjbudgetInsert.vue'
import PjbudgetUpdateVue from './PjbudgetUpdate.vue'
import PjbudgetDeleteVue from './PjbudgetDelete.vue'
export default {
  components: {
    PjbudgetInsertVue,
    PjbudgetUpdateVue,
    PjbudgetDeleteVue,
  },

  props: {
    userType: {
      type: String,
      default: null,
    },
    expenseID: {
      type: Number,
      default: null
    },
    budgetID: {
      type: Number,
      default: null
    },
    pjsubactivityID: {
      type: Number,
      default: null
    },
    pjbudgetID: {
      type: Number,
      default: null
    },
    projectID: {
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
    readOnly: {
      type: Boolean,
      default: false,
    }
  },

  data() {
    return {
      headers: [
        // { text: 'กิจกรรมหลักที่', value: 'projectName', align: 'left', class: 'text-center' },
        // { text: 'ผู้รับผิดชอบ', value: '' },
        { text: 'กิจกรรม', value: 'pjsubactivityName', align: 'left', class:'text-center' },
        { text: 'หมวดค่าใช้จ่าย', value: 'expenseName', align: 'left', class:'text-center'  },
        { text: 'รายการ', value: 'pjbudgetName', align: 'left', class:'text-center'  },
        { text: 'หมวดงบประมาณ', value: 'budgetplanFullname', align: 'left', class:'text-center'  },
        // { text: 'จำนวน', value: 'pjbudgetQty', align: 'right', class:'text-center'  },
        // { text: 'หน่วย', value: 'pjbudgetUnit', align: 'left', class:'text-center'  },
        { text: 'จำนวนเงิน', value: 'pjbudgetMoney', align: 'right', class:'text-center'  },
        // { text: 'รวม', value: 'pjbudgetSumMoney', align: 'right', class:'text-center'  },
        { text: '', value: 'actions', align: 'center', class:'text-center'  },
      ],
      project: {},

      pjbudgets: [],
      pjbudgetsLoading: true,
      search: '',
      pjactivities: [],

      pjbudgetData: {},

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
      await this.getProject()
      await this.getPjbudget()
    }
  },

  methods: {
    async getProject() {
      let params = {
        token: this.$store.state.jwtToken,
        projectID: this.projectID
      }
      let result = await this.$axios.$get('project.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.project = JSON.parse(JSON.stringify(result.project))
      }
    },

    async getPjbudget() {
      this.pjbudgetsLoading = true
      let params = {
        token: this.$store.state.jwtToken,
        projectID: this.projectID
      }
      let result = await this.$axios.$get('pjbudget.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.pjbudgets = JSON.parse(JSON.stringify(result.pjbudget))
      }
      this.pjbudgetsLoading = false
    },

    showInsertDialog() {
      this.pjbudgetData = {
        token: this.$store.state.jwtToken,
        projectID: this.projectID,
        projectYear: this.project.projectYear
      }
      this.insertDialog = true
    },

    async insertPjbudget(res) {
      if(res.status) {
        await this.getPjbudget()
        this.$emit('getbudgetStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(pjbudget) {
      this.pjbudgetData = pjbudget
      this.pjbudgetData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updatePjbudget(res) {
      if(res.status) {
        await this.getPjbudget()
        this.$emit('getbudgetStatus', {'status': true})
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(pjbudget) {
      this.pjbudgetData = pjbudget
      this.pjbudgetData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deletePjbudget(res) {
      if(res.status) {
        await this.getPjbudget()
        this.$emit('getbudgetStatus', {'status': true})
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },

    showInsertSubDialog(pjbudget) {
      this.pjsubactivityData = {
        token: this.$store.state.jwtToken,
        pjbudgetNum: pjbudget.pjbudgetNum,
        pjbudgetName: pjbudget.pjbudgetName,
        pjbudgetID: pjbudget.pjbudgetID,
        projectID: this.projectID
      }
      this.insertSubDialog = true
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
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
      await this.getPjbudget()
    }
  }
}
</script>
