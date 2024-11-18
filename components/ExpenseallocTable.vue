<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ผู้ใช้งบรายจ่าย</b><br>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <div class="mb-3 font-weight-bold">
                {{ expenseplan.expenseplanFullname }}
            </div>
            <v-data-table
              :headers="headers"
              :items="expenseallocs"
              :search="search"
              :items-per-page="-1"
              :loading="expensesLoading"
              hide-default-footer
            >
              <template v-slot:top v-if="!readOnly">
                <v-row>
                  <v-col cols="12" md="6" v-if="insertBt">
                    <v-btn color="success" text @click="showInsertDialog">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มผู้ใช้งบรายจ่าย
                    </v-btn>
                  </v-col>
                </v-row>
              </template>

              <!-- <template v-slot:item.expenseMoney="{ item }">
                <div class="text-no-wrap text-right">
                  {{ moneyFormat(parseFloat(item.expenseMoney)) }}
                </div>
              </template> -->

              <template v-slot:item.expenseallocMoney="{ item }">
                {{ moneyFormat(item.expenseallocMoney) }}
              </template>

              <template v-slot:item.actions="{ item }" v-if="!readOnly">
                <div  class="text-no-wrap">
                  <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="updateBt || userType=='Admin'">
                    <v-icon small class="mr-1">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="(parseFloat(item.disburseMoney)<=0 && deleteBt) || userType=='Admin'">
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
                <ExpenseallocInsert :expensealloc="expenseallocData" @getInsertStatus="insertExpensealloc"/>
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
                <ExpenseallocUpdate :expensealloc="expenseallocData" @getUpdateStatus="updateExpensealloc"/>
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
                <ExpenseallocDelete :expensealloc="expenseallocData" @getDeleteStatus="deleteExpensealloc"/>
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
    expenseplan: {
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
        { text: 'หมวดงบประมาณ', value: 'budgetplanFullname', align: 'right', class:'text-center'  },
        { text: 'งบประมาณ', value: 'expenseallocMoney', align: 'right', class:'text-center'  },
        { text: 'หมายเหตุ', value: 'expenseallocDes', align: 'left', class:'text-center'  },
        { text: '', value: 'actions', align: 'center', class:'text-center'  },
      ],
      pjsubactivity: {},

      expenseallocs: [],
      expenseallocTotalMoney: 0,
      expensesLoading: true,
      search: '',

      expenseallocData: {},

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
    if(this.expenseplan) {
      await this.getExpensealloc()
    }
  },

  methods: {
    async getExpensealloc() {
      this.expensesLoading = true
      let params = {
        token: this.$store.state.jwtToken,
        expenseplanID: this.expenseplan.expenseplanID
      }
      let result = await this.$axios.$get('expensealloc.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.expenseallocs = JSON.parse(JSON.stringify(result.expensealloc))
        this.expenseallocTotalMoney = this.expenseallocs.reduce((prev, curr)=> parseFloat(prev) + parseFloat(curr.expenseallocMoney), 0);
      }
      this.expensesLoading = false
    },

    showInsertDialog() {
      this.expenseallocData = {
        token: this.$store.state.jwtToken,
        expenseplanID: this.expenseplan.expenseplanID,
        expenseplanMoney: this.expenseplan.expenseplanMoney,
        expenseallocTotalMoney: this.expenseallocTotalMoney
      }
      this.insertDialog = true
    },

    async insertExpensealloc(res) {
      if(res.status) {
        await this.getExpensealloc()
        this.$emit('getTableStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(expensealloc) {
      this.expenseallocData = expensealloc
      this.expenseallocData.token = this.$store.state.jwtToken
      this.expenseallocData.expenseMoney = this.expenseplan.expenseMoney
      this.expenseallocData.expenseallocTotalMoney = this.expenseallocTotalMoney-this.expenseallocData.expenseallocMoney
      this.updateDialog = true
    },

    async updateExpensealloc(res) {
      if(res.status) {
        await this.getExpensealloc()
        this.$emit('getTableStatus', {'status': true})
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(expensealloc) {
      this.expenseallocData = expensealloc
      this.expenseallocData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteExpensealloc(res) {
      if(res.status) {
        await this.getExpensealloc()
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

  computed: {
    expenseplanID() {
      return this.expenseplan.expenseplanID
    }
  },

  watch: {
    async expenseplanID() {
      await this.getExpensealloc()
    }
  }
}
</script>
