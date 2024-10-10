<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>งบประมาณที่ได้รับจัดสรร ประจำปีงบประมาณ พ.ศ.{{ parseInt(budgetYear)+543 }} (ไตรมาตร {{ subperiod }})</b>
            <v-spacer></v-spacer>
            <v-btn fab small color="white" :to="'/print/budgetsliptableReport/?year='+budgetYear" target="_blank" v-if="userType=='Admin'||userType=='Director'||userType=='Plan'||userType=='Finance'">
              <v-icon color="primary">fas fa-print</v-icon>
            </v-btn>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="budgetslips"
              :search="search"
              :items-per-page="-1"
              :loading="budgetslipsLoading"
              hide-default-footer
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="2">
                    <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || userType=='Plan'">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มแผนงบประมาณรายรับ
                    </v-btn>
                  </v-col>
                  <v-col cols="12" md="4">
                    <v-select
                      v-model="subperiod"
                      :items="subperiods"
                      label="ไตรมาตรที่"
                      outlined
                      hide-details
                      dense
                    ></v-select>
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

              <template v-slot:item.budgetslipID="{ item }">
                <div  class="text-no-wrap">{{ budgetslips.indexOf(item)+1 }}</div>
              </template>
              <template v-slot:item.budgetYear="{ item }">
                {{ parseInt(item.budgetYear)+543 }}
              </template>
              <template v-slot:item.budgetslipMoney="{ item }">
                <div>
                  {{ moneyFormat(item.budgetslipMoney) }}
                  <div class="mt-1">
                    <v-progress-linear
                      :value="parseFloat(item.disburseMoney)/parseFloat(item.budgetslipMoney)*100"
                      background-color="green lighten-3"
                      color="red lighten-3"
                      height="8"
                    >
                    </v-progress-linear>
                  </div>
                </div>
              </template>
              <template v-slot:item.budgetrealMoney="{ item }">
                <div class="text-no-wrap">
                  {{ moneyFormat(item.budgetrealMoney) }}
                  <v-btn icon @click="showBudgetslipDialog(item)" v-if="userType=='Admin' || userType=='Plan' || userType=='Finance'">
                    <v-icon color="success">fas fa-wallet</v-icon>
                  </v-btn>
                </div>
              </template>
              <template v-slot:item.disburseMoney="{ item }">
                <!-- <span class="black--text" v-if="parseInt(item.disburseRealMoney) > 0">{{ moneyFormat(item.disburseMoney) }}</span>
                <span class="grey--text" v-else><i>{{ moneyFormat(item.disburseMoney) }}</i></span> -->
                <!-- <div class="py-2">
                  <span class="grey--text"><i>{{ moneyFormat(item.disbursePlanMoney) }}</i></span>
                  <v-divider></v-divider>
                  <span class="black--text">{{ moneyFormat(item.disburseRealMoney) }}</span>
                </div> -->
                <div class="py-2" v-if="parseFloat(item.disburseMoney) <= parseFloat(item.budgetslipMoney)">
                  <span>
                    {{ moneyFormat(item.disburseMoney) }}
                  </span>
                  <div class="mt-1">
                    <v-progress-linear
                      :value="parseFloat(item.disburseMoney)/parseFloat(item.budgetslipMoney)*100"
                      color="red lighten-3"
                      height="20"

                    >
                      <template v-slot:default="{}">
                        <div class="pa-1 col-12 text-right text-no-wrap">
                          <strong>{{ moneyFormat(parseFloat(item.disburseMoney)/parseFloat(item.budgetslipMoney)*100) }}%</strong>
                        </div>
                      </template>
                    </v-progress-linear>
                  </div>
                </div>
                <div class="py-2" v-else>
                  <span>
                    {{ moneyFormat(item.budgetslipMoney) }}
                  </span>
                  <div class="mt-1">
                    <v-progress-linear
                      value="100"
                      color="red lighten-3"
                      height="20"

                    >
                      <template v-slot:default="{}">
                        <div class="pa-1 col-12 text-right text-no-wrap">
                          <strong>100.00%</strong>
                        </div>
                      </template>
                    </v-progress-linear>
                  </div>
                </div>
              </template>
              <template v-slot:item.budgetdifrealMoney="{ item }">
               <span class="fontBold" v-if="parseFloat(item.disburseMoney) <= parseFloat(item.budgetslipMoney)">
                {{ moneyFormat(parseFloat(item.budgetslipMoney)-parseFloat(item.disburseMoney)) }}
                <div class="mt-1">
                  <v-progress-linear
                    :value="100-(parseFloat(item.disburseMoney)/parseFloat(item.budgetslipMoney)*100)"
                    color="green lighten-3"
                    height="20"
                    reverse
                  >
                    <template v-slot:default="{}">
                      <div class="pa-1 col-12 text-right text-no-wrap">
                        <strong>{{ moneyFormat(100-(parseFloat(item.disburseMoney)/parseFloat(item.budgetslipMoney)*100)) }}%</strong>
                      </div>
                    </template>
                  </v-progress-linear>
                </div>
               </span>
               <span class="fontBold" v-else>
                0.00
                <div class="mt-1">
                  <v-progress-linear
                    value="0"
                    color="green lighten-3"
                    height="20"
                    reverse
                  >
                    <template v-slot:default="{}">
                      <div class="pa-1 col-12 text-right text-no-wrap">
                        <strong>0.00%</strong>
                      </div>
                    </template>
                  </v-progress-linear>
                </div>
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
                <tr class="d-none d-md-table-row">
                  <td colspan="3" class="fontBold text-center">รวม</td>
                  <td class="fontBold text-right">
                    {{ moneyFormat(budgetSum.budgetslipMoney) }}
                    <div class="mt-1">
                      <v-progress-linear
                        :value="parseFloat(budgetSum.disburseMoney)/parseFloat(budgetSum.budgetslipMoney)*100"
                        background-color="green lighten-2"
                        color="red lighten-2"
                        height="10"
                      >
                      </v-progress-linear>
                    </div>
                  </td>
                  <!-- <td class="py-2 fontBold text-right">
                    <span class="grey--text"><i class="fontBold">{{ moneyFormat(budgetSum.disbursePlanMoney) }}</i></span>
                    <v-divider></v-divider>
                    {{ moneyFormat(budgetSum.disburseRealMoney) }}
                  </td> -->
                  <td class="py-2 fontBold text-right">
                    <div class="py-2 fontBold">
                      {{ moneyFormat(budgetSum.disburseMoney) }}
                      <div class="mt-1">
                        <v-progress-linear
                          :value="parseFloat(budgetSum.disburseMoney)/parseFloat(budgetSum.budgetslipMoney)*100"
                          color="red lighten-2"
                          height="20"

                        >
                          <template v-slot:default="{}">
                            <div class="pa-0 col-12 text-right text-no-wrap">
                              <strong>{{ moneyFormat(parseFloat(budgetSum.disburseMoney)/parseFloat(budgetSum.budgetslipMoney)*100) }}%</strong>
                            </div>
                          </template>
                        </v-progress-linear>
                      </div>
                    </div>
                  </td>
                  <td class="fontBold text-right">
                    {{ moneyFormat(parseFloat(budgetSum.budgetslipMoney)-parseFloat(budgetSum.disburseMoney)) }}
                    <div class="mt-1">
                      <v-progress-linear
                        :value="100-(parseFloat(budgetSum.disburseMoney)/parseFloat(budgetSum.budgetslipMoney)*100)"
                        color="green lighten-2"
                        height="20"
                        reverse
                      >
                        <template v-slot:default="{}">
                          <div class="pa-0 col-12 text-right text-no-wrap">
                            <strong>{{ moneyFormat(100-(parseFloat(budgetSum.disburseMoney)/parseFloat(budgetSum.budgetslipMoney)*100)) }}%</strong>
                          </div>
                        </template>
                      </v-progress-linear>
                    </div>
                    <!-- <span class="success--text fontBold" v-if="(parseFloat(budgetSum.budgetslipMoney)-parseFloat(budgetSum.disburseMoney)) > 0">
                      {{ moneyFormat(parseFloat(budgetSum.budgetslipMoney)-parseFloat(budgetSum.disburseMoney)) }}
                    </span>
                    <span class="red--text fontBold" v-else-if="(parseFloat(budgetSum.budgetrealMoney)-parseFloat(budgetSum.disburseMoney)) < 0">
                      {{ moneyFormat(parseFloat(budgetSum.budgetslipMoney)-parseFloat(budgetSum.disburseMoney)) }}
                    </span>
                    <span class="fontBold" v-else>
                      {{ moneyFormat(parseFloat(budgetSum.budgetslipMoney)-parseFloat(budgetSum.disburseMoney)) }}
                    </span> -->
                  </td>
                  <!-- <td></td> -->
                </tr>
              </template>
            </v-data-table>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

  </div>
</template>

<script>
import numeral from 'numeral'
export default {
  components: {

  },

  props: {
    // budgetslips: {
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
    budgetYear: {
      type: String,
      default: null
    },
    budgetPeriod: {
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
          value: 'budgetslipID',
        },
        // { text: 'ปีงบประมาณ พ.ศ.', value: 'budgetYear', align: 'center', class: 'text-center' },
        { text: 'หมวดงบประมาณ', value: 'budgettypeName', align: 'left', class: 'text-center' },
        { text: 'รายการ', value: 'budgetplanDes', align: 'left', class: 'text-center' },
        { text: 'ได้รับจัดสรร', value: 'budgetslipMoney', align: 'right', class: 'text-center' },
        // { text: 'รอเบิกจ่าย/เบิกจ่ายแล้ว', value: 'disburseMoney', align: 'right', class: 'text-center' },
        { text: 'เบิกจ่าย', value: 'disburseMoney', align: 'right', class: 'text-center' },
        { text: 'คงเหลือ ', value: 'budgetdifrealMoney', align: 'right', class: 'text-center' },
        // { text: '%เบิกจ่าย', value: 'disbursePercent', align: 'right', class: 'text-center' },
      ],
      search: '',
      budgetslipsLoading: true,
      budgetslips: [],
      budgetSum: {},
      budgetslipData: {},
      insertDialog: false,
      insertProgress: false,
      budgetslipInsertValidate: null,

      subperiod: null,
      subperiods: [
        {
          value: 1,
          text: 'ไตรมาตร 1',
          startDate: (parseInt(this.budgetYear)-1)+'-10-01',
          endDate: (parseInt(this.budgetYear)-1)+'-12-31'
        },
        {
          value: 2,
          text: 'ไตรมาตร 2',
          startDate: this.budgetYear+'-01-01',
          endDate: this.budgetYear+'-03-31'
        },
        {
          value: 3,
          text: 'ไตรมาตร 3',
          startDate: this.budgetYear+'-04-01',
          endDate: this.budgetYear+'-06-30'
        },{
          value: 4,
          text: 'ไตรมาตร 4',
          startDate: this.budgetYear+'-07-01',
          endDate: this.budgetYear+'-09-30'
        }
      ],

      updateDialog: false,
      updateProgress: false,
      budgetslipUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      budgetslipDeleteValidate: null,

      budgetslipDialog: false,
    }
  },

  async mounted() {
    if(this.budgetPeriod>=1 && this.budgetPeriod<=4) {
      this.subperiod = parseInt(this.budgetPeriod)
    } else {
      let period = this.subperiods.filter(period => new Date().getTime()>=new Date(period.startDate+' 00:00:01').getTime())
      if(period.length>0) {
        this.subperiod = period.length
      }
    }
    await this.getBudgetplans()
  },

  methods: {
    async getBudgetplans() {
      this.budgetslipsLoading = true
      let period = this.subperiods.filter(period => period.value==this.subperiod)
      let params = {
        token: this.$store.state.jwtToken,
        budgetslipYear: this.budgetYear,
        budgetslipStart: (parseInt(this.budgetYear)-1)+'-10-01',
        budgetslipEnd: period[0]?.endDate,
        fn: 'getSummaryByBudgetplanYear'
      }
      let result = await this.$axios.$get('budgetslip.php', {params})
      if(result.message === 'Success') {
        this.budgetslips = JSON.parse(JSON.stringify(result.budgetslip))
      }

      params = {
        token: this.$store.state.jwtToken,
        budgetslipYear: this.budgetYear,
        budgetslipStart: (parseInt(this.budgetYear)-1)+'-10-01',
        budgetslipEnd: period[0]?.endDate,
        fn: 'getSummaryByYear'
      }

      let result2 = await this.$axios.$get('budgetslip.php', {params})
      if(result2.message === 'Success') {
        this.budgetSum = JSON.parse(JSON.stringify(result2.budgetslip))
      }
      this.budgetslipsLoading = false
    },

    showInsertDialog() {
      this.budgetslipData = {
        token: this.$store.state.jwtToken,
        budgetYear: this.budgetYear,
        budgetslipEnable: 1
      }
      this.insertDialog = true
    },

    async insertBudgetplan(res) {
      if(res.status) {
        await this.getBudgetplans()
        this.$emit('getbudgetslipStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(budgetslip) {
      this.budgetslipData = budgetslip
      this.budgetslipData.token = this.$store.state.jwtToken
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

    showDeleteDialog(budgetslip) {
      this.budgetslipData = budgetslip
      this.budgetslipData.token = this.$store.state.jwtToken
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

    showBudgetslipDialog(budgetslip) {
      this.budgetslipData = budgetslip
      this.budgetslipData.token = this.$store.state.jwtToken
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
  async budgetYear() {
    this.subperiods = [
      {
        value: 1,
        text: 'ไตรมาตร 1',
        startDate: (parseInt(this.budgetYear)-1)+'-10-01',
        endDate: (parseInt(this.budgetYear)-1)+'-12-31'
      },
      {
        value: 2,
        text: 'ไตรมาตร 2',
        startDate: this.budgetYear+'-01-01',
        endDate: this.budgetYear+'-03-31'
      },
      {
        value: 3,
        text: 'ไตรมาตร 3',
        startDate: this.budgetYear+'-04-01',
        endDate: this.budgetYear+'-06-30'
      },{
        value: 4,
        text: 'ไตรมาตร 4',
        startDate: this.budgetYear+'-07-01',
        endDate: this.budgetYear+'-09-30'
      }
    ]
    let period = this.subperiods.filter(period => new Date().getTime()>=new Date(period.startDate+' 00:00:01').getTime())
    if(period.length>0) {
      this.subperiod = period.length
    } else {
      this.subperiod = 1
    }
    await this.getBudgetplans()
  },

  async subperiod() {
    await this.getBudgetplans()
  },

  async personalIDcard() {
    await this.getBudgetplans()
  }
}
}
</script>
