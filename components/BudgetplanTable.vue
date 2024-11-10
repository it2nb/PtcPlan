<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>แผนงบประมาณรายรับ ประจำปีงบประมาณ พ.ศ.{{ parseInt(budgetplanYear)+543 }}</b>
            <v-spacer></v-spacer>
            <v-btn fab small color="white" :to="'/print/budgetplantableReport/?year='+budgetplanYear" target="_blank" v-if="userType=='Admin'||userType=='Director'||userType=='Plan'||userType=='Finance'||userType=='Party'">
              <v-icon color="primary">fas fa-print</v-icon>
            </v-btn>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="budgetplans"
              :search="search"
              :items-per-page="-1"
              :loading="budgetplansLoading"
              hide-default-footer
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || userType=='Plan'">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มแผนงบประมาณรายรับ
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

              <template v-slot:item.budgetplanID="{ item }">
                <div  class="text-no-wrap">BJ-{{ parseInt(item.budgetplanID) }}</div>
              </template>
              <template v-slot:item.budgetplanYear="{ item }">
                {{ parseInt(item.budgetplanYear)+543 }}
              </template>
              <template v-slot:item.budgetplanMoney="{ item }">
                {{ moneyFormat(item.budgetplanMoney) }}
              </template>
              <template v-slot:item.budgetrealMoney="{ item }">
                <div class="text-no-wrap grey lighten-3">
                  {{ moneyFormat(item.budgetrealMoney) }}
                  <v-btn icon @click="showBudgetslipDialog(item)">
                    <v-icon color="success">fas fa-wallet</v-icon>
                  </v-btn>
                </div>
              </template>
              <template v-slot:item.disburseMoney="{ item }">
                <!-- <span class="black--text" v-if="parseFloat(item.disburseRealMoney) > 0">{{ moneyFormat(item.disburseMoney) }}</span>
                <span class="grey--text" v-else><i>{{ moneyFormat(item.disburseMoney) }}</i></span> -->
                <div class="py-2">
                  <div class="px-1 grey--text deep-purple lighten-5"><i>{{ moneyFormat(item.disbursePlanMoney) }}</i></div>
                  <v-divider></v-divider>
                  <div class="px-1 black--text green lighten-4">{{ moneyFormat(item.disburseRealMoney) }}</div>
                </div>
              </template>
              <template v-slot:item.budgetdifplanMoney="{ item }">
                <div v-if="parseFloat(item.budgetplanMoney) > parseFloat(item.budgetrealMoney)">
                  <span class="success--text " v-if="(parseFloat(item.budgetplanMoney)-(parseFloat(item.disbursePlanMoney)+parseFloat(item.disburseRealMoney))) > 0">
                    {{ moneyFormat(parseFloat(item.budgetplanMoney)-(parseFloat(item.disbursePlanMoney)+parseFloat(item.disburseRealMoney))) }}
                  </span>
                  <span class="red--text " v-else-if="(parseFloat(item.budgetplanMoney)-(parseFloat(item.disbursePlanMoney)+parseFloat(item.disburseRealMoney))) < 0">
                    {{ moneyFormat(parseFloat(item.budgetplanMoney)-(parseFloat(item.disbursePlanMoney)+parseFloat(item.disburseRealMoney))) }}
                  </span>
                  <span class="" v-else>
                    {{ moneyFormat(parseFloat(item.budgetplanMoney)-(parseFloat(item.disbursePlanMoney)+parseFloat(item.disburseRealMoney))) }}
                  </span>
                </div>
                <div v-else>
                  <span class="success--text " v-if="(parseFloat(item.budgetrealMoney)-(parseFloat(item.disbursePlanMoney)+parseFloat(item.disburseRealMoney))) > 0">
                    {{ moneyFormat(parseFloat(item.budgetrealMoney)-(parseFloat(item.disbursePlanMoney)+parseFloat(item.disburseRealMoney))) }}
                  </span>
                  <span class="red--text " v-else-if="(parseFloat(item.budgetrealMoney)-(parseFloat(item.disbursePlanMoney)+parseFloat(item.disburseRealMoney))) < 0">
                    {{ moneyFormat(parseFloat(item.budgetrealMoney)-(parseFloat(item.disbursePlanMoney)+parseFloat(item.disburseRealMoney))) }}
                  </span>
                  <span class="" v-else>
                    {{ moneyFormat(parseFloat(item.budgetrealMoney)-(parseFloat(item.disbursePlanMoney)+parseFloat(item.disburseRealMoney))) }}
                  </span>
                </div>
              </template>
              <template v-slot:item.budgetdifrealMoney="{ item }">
                <div class="pa-1 blue lighten-5">
                  <span class="success--text fontBold" v-if="(parseFloat(item.budgetrealMoney)-parseFloat(item.disburseRealMoney)) > 0">
                  {{ moneyFormat(parseFloat(item.budgetrealMoney)-parseFloat(item.disburseRealMoney)) }}
                </span>
                <span class="red--text fontBold" v-else-if="(parseFloat(item.budgetrealMoney)-parseFloat(item.disburseRealMoney)) < 0">
                  {{ moneyFormat(parseFloat(item.budgetrealMoney)-parseFloat(item.disburseRealMoney)) }}
                </span>
                <span class="fontBold" v-else>
                  {{ moneyFormat(parseFloat(item.budgetrealMoney)-parseFloat(item.disburseRealMoney)) }}
                </span>
                </div>

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
                <tr class="d-none d-md-table-row">
                  <td colspan="3" class="fontBold text-center">รวม</td>
                  <td class="fontBold text-right">{{ moneyFormat(budgetSum.budgetplanMoney) }}</td>
                  <td class="fontBold text-right grey lighten-3">{{ moneyFormat(budgetSum.budgetrealMoney) }}</td>
                  <td class="py-2 fontBold text-right">
                    <div class="px-1 grey--text deep-purple lighten-5"><i class="fontBold">{{ moneyFormat(budgetSum.disbursePlanMoney) }}</i></div>
                    <v-divider></v-divider>
                    <div class="px-1 fontBold green lighten-4">{{ moneyFormat(budgetSum.disburseRealMoney) }}</div>
                    </td>
                  <td class="fontBold text-right">
                    <div v-if="parseFloat(budgetSum.budgetplanMoney) > parseFloat(budgetSum.budgetrealMoney)">
                      <span class="success--text " v-if="(parseFloat(budgetSum.budgetplanMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) > 0">
                        {{ moneyFormat(parseFloat(budgetSum.budgetplanMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                      </span>
                      <span class="red--text " v-else-if="(parseFloat(budgetSum.budgetplanMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) < 0">
                        {{ moneyFormat(parseFloat(budgetSum.budgetplanMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                      </span>
                      <span class="fontBold" v-else>
                        {{ moneyFormat(parseFloat(budgetSum.budgetplanMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                      </span>
                    </div>
                    <div v-else>
                      <span class="success--text " v-if="(parseFloat(budgetSum.budgetrealMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) > 0">
                        {{ moneyFormat(parseFloat(budgetSum.budgetrealMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                      </span>
                      <span class="red--text " v-else-if="(parseFloat(budgetSum.budgetrealMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) < 0">
                        {{ moneyFormat(parseFloat(budgetSum.budgetrealMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                      </span>
                      <span class="" v-else>
                        {{ moneyFormat(parseFloat(budgetSum.budgetrealMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                      </span>
                    </div>
                  </td>
                  <td class="fontBold text-right blue lighten-5">
                    <span class="success--text fontBold" v-if="(parseFloat(budgetSum.budgetrealMoney)-parseFloat(budgetSum.disburseRealMoney)) > 0">
                      {{ moneyFormat(parseFloat(budgetSum.budgetrealMoney)-parseFloat(budgetSum.disburseRealMoney)) }}
                    </span>
                    <span class="red--text fontBold" v-else-if="(parseFloat(budgetSum.budgetrealMoney)-parseFloat(budgetSum.disburseRealMoney)) < 0">
                      {{ moneyFormat(parseFloat(budgetSum.budgetrealMoney)-parseFloat(budgetSum.disburseRealMoney)) }}
                    </span>
                    <span class="fontBold" v-else>
                      {{ moneyFormat(parseFloat(budgetSum.budgetrealMoney)-parseFloat(budgetSum.disburseRealMoney)) }}
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
                <BudgetplanInsertVue :budgetplan="budgetplanData" @getInsertStatus="insertBudgetplan"/>
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
                <BudgetplanUpdateVue :budgetplan="budgetplanData" @getUpdateStatus="updateBudgetplan"/>
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
                <BudgetplanDeleteVue :budgetplan="budgetplanData" @getDeleteStatus="deleteBudgetplan"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="budgetslipDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="blue-grey lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="budgetslipDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <BudgetslipTableVue :budgetplanID="budgetplanData.budgetplanID" :budgetslipYear="budgetplanData.budgetplanYear" :userType="userType" @getTableStatus="getBudgetslip"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
import BudgetplanInsertVue from './BudgetplanInsert.vue'
import BudgetplanUpdateVue from './BudgetplanUpdate.vue'
import BudgetplanDeleteVue from './BudgetplanDelete.vue'
import BudgetslipTableVue from './BudgetslipTable.vue'
import numeral from 'numeral'
export default {
  components: {
    BudgetplanInsertVue,
    BudgetplanUpdateVue,
    BudgetplanDeleteVue,
    BudgetslipTableVue,
  },

  props: {
    // budgetplans: {
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
    budgetplanYear: {
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
          value: 'budgetplanID',
        },
        // { text: 'ปีงบประมาณ พ.ศ.', value: 'budgetplanYear', align: 'center', class: 'text-center' },
        { text: 'หมวดงบประมาณ', value: 'budgetFullname', align: 'left', class: 'text-center' },
        { text: 'รายการ', value: 'budgetplanDes', align: 'left', class: 'text-center' },
        { text: 'ประมาณการ', value: 'budgetplanMoney', align: 'right', class: 'text-center' },
        { text: 'ได้รับจัดสรร', value: 'budgetrealMoney', align: 'right', class: 'text-center' },
        { text: 'รอเบิกจ่าย/เบิกจ่ายแล้ว', value: 'disburseMoney', align: 'right', class: 'text-center' },
        { text: 'คงเหลือ (ยอดแผน)', value: 'budgetdifplanMoney', align: 'right', class: 'text-center' },
        { text: 'คงเหลือ (ยอดจัดสรรร)', value: 'budgetdifrealMoney', align: 'right', class: 'text-center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      budgetplansLoading: true,
      budgetplans: [],
      budgetSum: {},
      budgetplanData: {},
      insertDialog: false,
      insertProgress: false,
      budgetplanInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      budgetplanUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      budgetplanDeleteValidate: null,

      budgetslipDialog: false,
    }
  },

  async mounted() {
    await this.getBudgetplans()
  },

  methods: {
    async getBudgetplans() {
      this.budgetplansLoading = true
      let params = {
        token: this.$store.state.jwtToken,
        budgetplanYear: this.budgetplanYear
      }
      let result = await this.$axios.$get('budgetplan.php', {params})
      if(result.message === 'Success') {
        this.budgetplans = JSON.parse(JSON.stringify(result.budgetplan))
      }
      params = {
        token: this.$store.state.jwtToken,
        budgetplanYear: this.budgetplanYear,
        fn: 'getSummaryByYear'
      }
      let result2 = await this.$axios.$get('budgetplan.php', {params})
      if(result2.message === 'Success') {
        this.budgetSum = JSON.parse(JSON.stringify(result2.budgetplan))
      }
      this.budgetplansLoading = false
    },

    showInsertDialog() {
      this.budgetplanData = {
        token: this.$store.state.jwtToken,
        budgetplanYear: this.budgetplanYear,
        budgetplanEnable: 1
      }
      this.insertDialog = true
    },

    async insertBudgetplan(res) {
      if(res.status) {
        await this.getBudgetplans()
        this.$emit('getbudgetplanStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(budgetplan) {
      this.budgetplanData = budgetplan
      this.budgetplanData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updateBudgetplan(res) {
      if(res.status) {
        await this.getBudgetplans()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(budgetplan) {
      this.budgetplanData = budgetplan
      this.budgetplanData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteBudgetplan(res) {
      if(res.status) {
        await this.getBudgetplans()
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },

    showBudgetslipDialog(budgetplan) {
      this.budgetplanData = budgetplan
      this.budgetplanData.token = this.$store.state.jwtToken
      this.budgetslipDialog = true
    },

    async getBudgetslip(res) {
      if(res.status) {
        await this.getBudgetplans()
      }
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    }
  },

watch: {
  async budgetplanYear() {
    await this.getBudgetplans()
  },

  async personalIDcard() {
    await this.getBudgetplans()
  }
}
}
</script>
