<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>แผนงบประมาณรายจ่าย ประจำปีงบประมาณ พ.ศ.{{ parseInt(expenseplanYear)+543 }}</b>
            <v-spacer></v-spacer>
            <v-btn fab small color="white" :to="'/print/expenseplantableReport/?year='+expenseplanYear" target="_blank" v-if="userType=='Admin'||userType=='Director'||userType=='Plan'||userType=='Finance'">
              <v-icon color="primary">fas fa-print</v-icon>
            </v-btn>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="expenseplans"
              :search="search"
              :items-per-page="-1"
              :loading="expenseplansLoading"
              hide-default-footer
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || userType=='Plan'">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มรายการค่าใช้จ่าย
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

              <template v-slot:item.expenseplanID="{ item }">
                <div  class="text-no-wrap">EP-{{ parseInt(item.expenseplanID) }}</div>
              </template>
              <template v-slot:item.expenseplanYear="{ item }">
                {{ parseInt(item.expenseplanYear)+543 }}
              </template>
              <template v-slot:item.expenseplanMoney="{ item }">
                <div class="text-no-wrap">
                  {{ moneyFormat(item.expenseplanMoney) }}
                  <v-btn icon @click="showExpenseBudgetDialog(item)" v-if="userType=='Admin' || userType=='Plan'">
                    <v-icon color="success">fas fa-money-check</v-icon>
                  </v-btn>
                </div>
              </template>

              <template v-slot:item.disburseMoney="{ item }">
                <div class="py-2">
                  <span class="grey--text"><i>{{ moneyFormat(item.disbursePlanMoney) }}</i></span>
                  <v-divider></v-divider>
                  <span class="black--text">{{ moneyFormat(item.disburseRealMoney) }}</span>
                </div>
              </template>

              <template v-slot:item.budgetdifMoney="{ item }">
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
                <div class="text-no-wrap">
                  <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="updateBt || userType=='Admin'">
                    <v-icon small class="mr-1">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="deleteBt || userType=='Admin'">
                    <v-icon small class="mr-1">fas fa-trash</v-icon>
                  </v-btn>
                </div>
              </template>
              <template slot="body.append">
                <tr class="d-none d-md-table-row">
                  <td colspan="4" class="fontBold text-center">รวม</td>
                  <td class="fontBold text-right">{{ moneyFormat(budgetSum.expenseplanMoney) }}</td>
                  <td class="py-2 fontBold text-right">
                    <span class="grey--text"><i class="fontBold">{{ moneyFormat(budgetSum.disbursePlanMoney) }}</i></span>
                    <v-divider></v-divider>
                    {{ moneyFormat(budgetSum.disburseRealMoney) }}
                  </td>
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
                <ExpenseplanInsertVue :expenseplan="expenseplanData" @getInsertStatus="insertExpenseplan"/>
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
                <ExpenseplanUpdateVue :expenseplan="expenseplanData" @getUpdateStatus="updateExpenseplan"/>
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
                <ExpenseplanDeleteVue :expenseplan="expenseplanData" @getDeleteStatus="deleteExpenseplan"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="expensebudgetDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="blue-grey lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="expensebudgetDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <ExpensebudgetTableVue :expenseplanID="expenseplan.expenseplanID" :userType="userType" @getTableStatus="getExpenseplans"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
import ExpenseplanInsertVue from './ExpenseplanInsert.vue'
import ExpenseplanUpdateVue from './ExpenseplanUpdate.vue'
import ExpenseplanDeleteVue from './ExpenseplanDelete.vue'
import ExpensebudgetTableVue from './ExpensebudgetTable.vue'
import numeral from 'numeral'
export default {
  components: {
    ExpenseplanInsertVue,
    ExpenseplanUpdateVue,
    ExpenseplanDeleteVue,
    ExpensebudgetTableVue,
  },

  props: {
    // expenseplans: {
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
    expenseplanYear: {
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
          value: 'expenseplanID',
        },
        { text: 'ปีงบประมาณ พ.ศ.', value: 'expenseplanYear', align: 'center', class: 'text-center' },
        { text: 'หมวดค่าใช้จ่าย', value: 'expenseName', align: 'left', class: 'text-center' },
        { text: 'รายการ', value: 'expenseplanDes', align: 'left', class: 'text-center' },
        { text: 'ประมาณการรายจ่าย', value: 'expenseplanMoney', align: 'right', class: 'text-center' },
        { text: 'รอเบิกจ่าย/เบิกจ่ายแล้ว', value: 'disburseMoney', align: 'right', class: 'text-center' },
        { text: 'คงเหลือ', value: 'budgetdifMoney', align: 'right', class: 'text-center' },
        // { text: 'หมวดงบประมาณ', value: 'budgetplanDes', align: 'left', class: 'text-center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      expenseplansLoading: true,
      expenseplans: [],
      expenseplan: {},
      budgetSum: {},
      expenseplanData: {},
      insertDialog: false,
      insertProgress: false,
      expenseplanInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      expenseplanUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      expenseplanDeleteValidate: null,

      expensebudgetDialog: false,
    }
  },

  async mounted() {
    await this.getExpenseplans()
  },

  methods: {
    async getExpenseplans() {
      this.expenseplansLoading = true
      let params = {
        token: this.$store.state.jwtToken,
        expenseplanYear: this.expenseplanYear
      }
      let result = await this.$axios.$get('expenseplan.php', {params})
      if(result.message === 'Success') {
        this.expenseplans = JSON.parse(JSON.stringify(result.expenseplan))
      }
      params = {
        token: this.$store.state.jwtToken,
        expenseplanYear: this.expenseplanYear,
        fn: 'getSummaryByYear'
      }
      let result2 = await this.$axios.$get('expenseplan.php', {params})
      if(result2.message === 'Success') {
        this.budgetSum = JSON.parse(JSON.stringify(result2.expenseplan))
      }
      this.expenseplansLoading = false
    },

    showInsertDialog() {
      this.expenseplanData = {
        token: this.$store.state.jwtToken,
        expenseplanYear: this.expenseplanYear,
        expenseplanEnable: 1
      }
      this.insertDialog = true
    },

    async insertExpenseplan(res) {
      if(res.status) {
        await this.getExpenseplans()
        this.$emit('getexpenseplanStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(expenseplan) {
      this.expenseplanData = expenseplan
      this.expenseplanData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updateExpenseplan(res) {
      if(res.status) {
        await this.getExpenseplans()
        this.$emit('getexpenseplanStatus', {'status': true})
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(expenseplan) {
      this.expenseplanData = expenseplan
      this.expenseplanData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteExpenseplan(res) {
      if(res.status) {
        await this.getExpenseplans()
        this.$emit('getexpenseplanStatus', {'status': true})
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },

    showExpenseBudgetDialog(expenseplan) {
      this.expenseplan = JSON.parse(JSON.stringify(expenseplan))
      this.expensebudgetDialog = true
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    }
  },

watch: {
  async expenseplanYear() {
    await this.getExpenseplans()
  },

  async personalIDcard() {
    await this.getExpenseplans()
  }
}
}
</script>
