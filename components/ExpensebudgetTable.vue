<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>งบประมาณรายจ่าย {{ expenseplan.expenseplanDes }}</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="expensebudgets"
              :search="search"
              :items-per-page="-1"
              :loading="expensebudgetsLoading"
              hide-default-footer
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || userType=='Plan'">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มงบประมาณรายจ่าย
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

              <template v-slot:item.budgetplanFullname="{ item }">
                {{ item.budgetName }} : {{ item.budgetplanDes }}
              </template>
              <template v-slot:item.expenseplanMoney="{ item }">
                {{ moneyFormat(item.expenseplanMoney) }}
              </template>
              <template v-slot:item.disburseMoney="{ item }">
                {{ moneyFormat(item.disburseMoney) }}
              </template>

              <template v-slot:item.expensediffMoney="{ item }">
                <span class="success--text fontBold" v-if="(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) > 0">
                  {{ moneyFormat(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) }}
                </span>
                <span class="red--text fontBold" v-else-if="(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) < 0">
                  {{ moneyFormat(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) }}
                </span>
                <span class="fontBold" v-else>
                  {{ moneyFormat(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) }}
                </span>
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
              <template slot="body.append">
                <tr>
                  <td colspan="3" class="fontBold text-center">รวม</td>
                  <td class="fontBold text-right">{{ moneyFormat(budgetSum.expenseplanMoney) }}</td>
                  <td class="fontBold text-right">{{ moneyFormat(budgetSum.disburseMoney) }}</td>
                  <td class="fontBold text-right">
                    <span class="success--text fontBold" v-if="(parseFloat(budgetSum.expenseplanMoney)-parseFloat(budgetSum.disburseMoney)) > 0">
                      {{ moneyFormat(parseFloat(budgetSum.expenseplanMoney)-parseFloat(budgetSum.disburseMoney)) }}
                    </span>
                    <span class="red--text fontBold" v-else-if="(parseFloat(budgetSum.expenseplanMoney)-parseFloat(budgetSum.disburseMoney)) < 0">
                      {{ moneyFormat(parseFloat(budgetSum.expenseplanMoney)-parseFloat(budgetSum.disburseMoney)) }}
                    </span>
                    <span class="fontBold" v-else>
                      {{ moneyFormat(parseFloat(budgetSum.expenseplanMoney)-parseFloat(budgetSum.disburseMoney)) }}
                    </span>
                  </td>
                  <td></td>
                </tr>
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
                <ExpensebudgetInsertVue :expensebudget="expensebudgetData" @getInsertStatus="insertExpensebudget"/>
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
                <ExpensebudgetUpdateVue :expensebudget="expensebudgetData" @getUpdateStatus="updateExpensebudget"/>
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
                <ExpensebudgetDeleteVue :expensebudget="expensebudgetData" @getDeleteStatus="deleteExpensebudget"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
import ExpensebudgetInsertVue from './ExpensebudgetInsert.vue'
import ExpensebudgetUpdateVue from './ExpensebudgetUpdate.vue'
import ExpensebudgetDeleteVue from './ExpensebudgetDelete.vue'
import numeral from 'numeral'
export default {
  components: {
    ExpensebudgetInsertVue,
    ExpensebudgetUpdateVue,
    ExpensebudgetDeleteVue,
  },

  props: {
    // expensebudgets: {
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
    expenseplanID: {
      type: String,
      default: null
    },
    budgetplanID: {
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
          value: 'expensebudgetID',
        },
        { text: 'หมวดค่าใช้จ่าย', value: 'expenseName', align: 'left', class: 'text-center' },
        { text: 'หมวดงบประมาณ', value: 'budgetplanFullname', align: 'left', class: 'text-center' },
        { text: 'ประมาณการรายจ่าย', value: 'expenseplanMoney', align: 'right', class: 'text-center' },
        { text: 'รอ/เบิกจ่ายแล้ว', value: 'disburseMoney', align: 'right', class: 'text-center' },
        { text: 'คงเหลือ', value: 'expensediffMoney', align: 'right', class: 'text-center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      expensebudgetsLoading: true,
      expenseplan: {},
      expensebudgets: [],
      budgetSum: {},
      expensebudgetData: {},
      insertDialog: false,
      insertProgress: false,
      expensebudgetInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      expensebudgetUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      expensebudgetDeleteValidate: null,
    }
  },

  async mounted() {
    await this.getExpenseplan()
    await this.getExpensebudgets()
  },

  methods: {
    async getExpenseplan() {
      let params = {
        token: this.$store.state.jwtToken,
        expenseplanID: this.expenseplanID
      }
      let result = await this.$axios.$get('expenseplan.php', {params})

      if(result.message === 'Success') {
        this.expenseplan = JSON.parse(JSON.stringify(result.expenseplan))
      }
    },

    async getExpensebudgets() {
      this.expensebudgetsLoading = true
      let params = {
        token: this.$store.state.jwtToken,
        expenseplanID: this.expenseplanID,
        budgetplanID: this.budgetplanID
      }
      let result = await this.$axios.$get('expensebudget.php', {params})
      if(result.message === 'Success') {
        this.expensebudgets = JSON.parse(JSON.stringify(result.expensebudget))
      }

      params = {
        token: this.$store.state.jwtToken,
        expenseplanID: this.expenseplanID,
        fn: 'getSummaryByExpenseplan'
      }
      let result2 = await this.$axios.$get('expensebudget.php', {params})
      if(result2.message === 'Success') {
        this.budgetSum = JSON.parse(JSON.stringify(result2.expensebudget))
      }
      this.expensebudgetsLoading = false
    },

    showInsertDialog() {
      this.expensebudgetData = {
        token: this.$store.state.jwtToken,
        expenseplanID: this.expenseplanID,
        expenseplanYear: this.expenseplan.expenseplanYear,
        expenseName: this.expenseplan.expenseName,
        expenseplanDes: this.expenseplan.expenseplanDes
      }
      this.insertDialog = true
    },

    async insertExpensebudget(res) {
      if(res.status) {
        await this.getExpensebudgets()
        this.$emit('getTableStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(expensebudget) {
      this.expensebudgetData = expensebudget
      this.expensebudgetData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updateExpensebudget(res) {
      if(res.status) {
        await this.getExpensebudgets()
        this.$emit('getTableStatus', {'status': true})
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(expensebudget) {
      this.expensebudgetData = expensebudget
      this.expensebudgetData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteExpensebudget(res) {
      if(res.status) {
        await this.getExpensebudgets()
        this.$emit('getTableStatus', {'status': true})
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    }
  },

watch: {
  async expenseplanID() {
    await this.getExpensebudgets()
    await this.getExpenseplan()
  },

  async budgetplanID() {
    await this.getExpensebudgets()
    await this.getExpenseplan()
  },

  async personalIDcard() {
    await this.getExpensebudgets()
    await this.getExpenseplan()
  }
}
}
</script>
