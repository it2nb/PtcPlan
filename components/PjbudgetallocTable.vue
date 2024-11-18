<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>จัดสรรงบประมาณโครงการ</b><br>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <div class="mb-3 font-weight-bold">
                {{ pjsubactivity.projectName }}<br>
                กิจกรรมย่อยที่ {{ pjsubactivity.pjactivityNum }}.{{ pjsubactivity.pjsubactivityNum }} {{ pjsubactivity.pjsubactivityName }}
            </div>
            <v-data-table
              :headers="headers"
              :items="pjbudgetallocs"
              :search="search"
              :items-per-page="-1"
              :loading="pjbudgetsLoading"
              hide-default-footer
            >
              <template v-slot:top v-if="!readOnly">
                <v-row>
                  <v-col cols="12" md="6" v-if="insertBt">
                    <v-btn color="success" text @click="showInsertDialog">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มผู้ใช้งบโครงการ
                    </v-btn>
                  </v-col>
                </v-row>
              </template>

              <!-- <template v-slot:item.pjbudgetMoney="{ item }">
                <div class="text-no-wrap text-right">
                  {{ moneyFormat(parseFloat(item.pjbudgetMoney)) }}
                </div>
              </template> -->

              <template v-slot:item.pjbudgetallocMoney="{ item }">
                {{ moneyFormat(item.pjbudgetallocMoney) }}
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
                <PjbudgetallocInsert :pjbudgetalloc="pjbudgetallocData" @getInsertStatus="insertPjbudgetalloc"/>
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
                <PjbudgetallocUpdate :pjbudgetalloc="pjbudgetallocData" @getUpdateStatus="updatePjbudgetalloc"/>
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
                <PjbudgetallocDelete :pjbudgetalloc="pjbudgetallocData" @getDeleteStatus="deletePjbudgetalloc"/>
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
export default {

  props: {
    userType: {
      type: String,
      default: null,
    },
    pjbudget: {
        type: Object,
        default: ()=>{}
    },
    departmentID: {
      type: Number,
      default: null
    },
    budgetplanID: {
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
        { text: 'แผนก/งาน', value: 'departmentName', align: 'left', class:'text-center' },
        { text: 'งบประมาณ', value: 'pjbudgetallocMoney', align: 'right', class:'text-center'  },
        { text: 'หมายเหตุ', value: 'pjbudgetallocDes', align: 'left', class:'text-center'  },
        { text: '', value: 'actions', align: 'center', class:'text-center'  },
      ],
      pjsubactivity: {},

      pjbudgetallocs: [],
      pjbudgetallocTotalMoney: 0,
      pjbudgetsLoading: true,
      search: '',

      pjbudgetallocData: {},

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
    if(this.pjbudget) {
      await this.getPjsubactivity()
      await this.getPjbudgetalloc()
    }
  },

  methods: {
    async getPjsubactivity() {
      let params = {
        token: this.$store.state.jwtToken,
        pjsubactivityID: this.pjbudget.pjsubactivityID
      }
      let result = await this.$axios.$get('pjsubactivity.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.pjsubactivity = JSON.parse(JSON.stringify(result.pjsubactivity))
      }
    },

    async getPjbudgetalloc() {
      this.pjbudgetsLoading = true
      let params = {
        token: this.$store.state.jwtToken,
        pjbudgetID: this.pjbudget.pjbudgetID
      }
      let result = await this.$axios.$get('pjbudgetalloc.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.pjbudgetallocs = JSON.parse(JSON.stringify(result.pjbudgetalloc))
        this.pjbudgetallocTotalMoney = this.pjbudgetallocs.reduce((prev, curr)=> parseFloat(prev) + parseFloat(curr.pjbudgetallocMoney), 0);
      }
      this.pjbudgetsLoading = false
    },

    showInsertDialog() {
      this.pjbudgetallocData = {
        token: this.$store.state.jwtToken,
        pjbudgetID: this.pjbudget.pjbudgetID,
        pjbudgetMoney: this.pjbudget.pjbudgetMoney,
        budgetplanID: this.pjbudget.budgetplanID,
        pjbudgetallocTotalMoney: this.pjbudgetallocTotalMoney
      }
      this.insertDialog = true
    },

    async insertPjbudgetalloc(res) {
      if(res.status) {
        await this.getPjbudgetalloc()
        this.$emit('getTableStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(pjbudgetalloc) {
      this.pjbudgetallocData = pjbudgetalloc
      this.pjbudgetallocData.token = this.$store.state.jwtToken
      this.pjbudgetallocData.pjbudgetMoney = this.pjbudget.pjbudgetMoney
      this.pjbudgetallocData.pjbudgetallocTotalMoney = this.pjbudgetallocTotalMoney-this.pjbudgetallocData.pjbudgetallocMoney
      this.updateDialog = true
    },

    async updatePjbudgetalloc(res) {
      if(res.status) {
        await this.getPjbudgetalloc()
        this.$emit('getTableStatus', {'status': true})
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(pjbudgetalloc) {
      this.pjbudgetallocData = pjbudgetalloc
      this.pjbudgetallocData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deletePjbudgetalloc(res) {
      if(res.status) {
        await this.getPjbudgetalloc()
        this.$emit('getTableStatus', {'status': true})
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
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
    async pjbudgetID() {
      await this.getPjsubactivity()
      await this.getPjbudgetalloc()
    }
  }
}
</script>
