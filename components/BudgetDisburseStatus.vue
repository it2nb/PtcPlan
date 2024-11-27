<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>รายงานสถานะการใช้จ่ายงบประมาณ ประจำปีงบประมาณ พ.ศ.{{ parseInt(budgetYear)+543 }}</b>
            <v-spacer></v-spacer>
            <!-- <v-btn fab small color="white" :to="'/print/budgetsliptableReport/?year='+budgetYear" target="_blank" v-if="userType=='Admin'||userType=='Director'||userType=='Plan'||userType=='Finance'">
              <v-icon color="primary">fas fa-print</v-icon>
            </v-btn> -->
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
              <template v-slot:item.budgetslipID="{ item }">
                <div  class="text-no-wrap">{{ budgetslips.indexOf(item)+1 }}</div>
              </template>
              <template v-slot:item.budgetYear="{ item }">
                {{ parseInt(item.budgetYear)+543 }}
              </template>
              <template v-slot:item.budgetslipMoney1="{ item }">
                <div class="py-2" v-if="new Date().getTime()>=new Date((budgetYear-1)+'-10-01 00:00:01').getTime()">
                  <span class="green--text text--darken-3">ได้รับจัดสรร</span> {{ moneyFormat(item.budgetslipMoney1) }}<br>
                  <span class="red--text text--darken-3">เบิกจ่าย</span> {{ moneyFormat(parseFloat(item.disburseMoney1)>parseFloat(item.budgetslipMoney1)? item.budgetslipMoney1 : item.disburseMoney1) }}

                  <div class="mt-1">
                    <v-progress-linear
                      :value="100-(parseFloat(parseFloat(item.disburseMoney1)>parseFloat(item.budgetslipMoney1)? item.budgetslipMoney1 : item.disburseMoney1)/parseFloat(item.budgetslipMoney1)*100)"
                      background-color="red lighten-4"
                      color="green lighten-4"
                      height="16"
                    >
                      <template v-slot:default="{}">
                        <div class="pa-1 col-12 text-right text-no-wrap">
                          <strong>{{ moneyFormat(parseFloat(parseFloat(item.disburseMoney1)>parseFloat(item.budgetslipMoney1)? item.budgetslipMoney1 : item.disburseMoney1)/parseFloat(item.budgetslipMoney1)*100) }}%</strong>
                        </div>
                      </template>
                    </v-progress-linear>
                  </div>
                </div>
              </template>
              <template v-slot:item.budgetslipMoney2="{ item }">
                <div class="py-2" v-if="new Date().getTime()>=new Date(budgetYear+'-01-01 00:00:01').getTime()">
                  <span class="green--text text--darken-3">ได้รับจัดสรร</span> {{ moneyFormat(item.budgetslipMoney2) }}<br>
                  <span class="red--text text--darken-3">เบิกจ่าย</span> {{ moneyFormat(parseFloat(item.disburseMoney2)>parseFloat(item.budgetslipMoney2)? item.budgetslipMoney2 : item.disburseMoney2) }}

                  <div class="mt-1">
                    <v-progress-linear
                      :value="100-(parseFloat(parseFloat(item.disburseMoney2)>parseFloat(item.budgetslipMoney2)? item.budgetslipMoney2 : item.disburseMoney2)/parseFloat(item.budgetslipMoney2)*100)"
                      background-color="red lighten-4"
                      color="green lighten-4"
                      height="16"
                    >
                      <template v-slot:default="{}">
                        <div class="pa-1 col-12 text-right text-no-wrap">
                          <strong>{{ moneyFormat(parseFloat(parseFloat(item.disburseMoney2)>parseFloat(item.budgetslipMoney2)? item.budgetslipMoney2 : item.disburseMoney2)/parseFloat(item.budgetslipMoney2)*100) }}%</strong>
                        </div>
                      </template>
                    </v-progress-linear>
                  </div>
                </div>
              </template>
              <template v-slot:item.budgetslipMoney3="{ item }">
                <div class="py-2" v-if="new Date().getTime()>=new Date(budgetYear+'-04-01 00:00:01').getTime()">
                  <span class="green--text text--darken-3">ได้รับจัดสรร</span> {{ moneyFormat(item.budgetslipMoney3) }}<br>
                  <span class="red--text text--darken-3">เบิกจ่าย</span> {{ moneyFormat(parseFloat(item.disburseMoney3)>parseFloat(item.budgetslipMoney3)? item.budgetslipMoney3 : item.disburseMoney3) }}

                  <div class="mt-1">
                    <v-progress-linear
                      :value="100-(parseFloat(parseFloat(item.disburseMoney3)>parseFloat(item.budgetslipMoney3)? item.budgetslipMoney3 : item.disburseMoney3)/parseFloat(item.budgetslipMoney3)*100)"
                      background-color="red lighten-4"
                      color="green lighten-4"
                      height="16"
                    >
                      <template v-slot:default="{}">
                        <div class="pa-1 col-12 text-right text-no-wrap">
                          <strong>{{ moneyFormat(parseFloat(parseFloat(item.disburseMoney3)>parseFloat(item.budgetslipMoney3)? item.budgetslipMoney3 : item.disburseMoney3)/parseFloat(item.budgetslipMoney3)*100) }}%</strong>
                        </div>
                      </template>
                    </v-progress-linear>
                  </div>
                </div>
              </template>
              <template v-slot:item.budgetslipMoney4="{ item }">
                <div class="py-2" v-if="new Date().getTime()>=new Date(budgetYear+'-07-01 00:00:01').getTime()">
                  <span class="green--text text--darken-3">ได้รับจัดสรร</span> {{ moneyFormat(item.budgetslipMoney4) }}<br>
                  <span class="red--text text--darken-3">เบิกจ่าย</span> {{ moneyFormat(parseFloat(item.disburseMoney4)>parseFloat(item.budgetslipMoney4)? item.budgetslipMoney4 : item.disburseMoney4) }}

                  <div class="mt-1">
                    <v-progress-linear
                      :value="100-(parseFloat(parseFloat(item.disburseMoney4)>parseFloat(item.budgetslipMoney4)? item.budgetslipMoney4 : item.disburseMoney4)/parseFloat(item.budgetslipMoney4)*100)"
                      background-color="red lighten-4"
                      color="green lighten-4"
                      height="16"
                    >
                      <template v-slot:default="{}">
                        <div class="pa-1 col-12 text-right text-no-wrap">
                          <strong>{{ moneyFormat(parseFloat(parseFloat(item.disburseMoney4)>parseFloat(item.budgetslipMoney4)? item.budgetslipMoney4 : item.disburseMoney4)/parseFloat(item.budgetslipMoney4)*100) }}%</strong>
                        </div>
                      </template>
                    </v-progress-linear>
                  </div>
                </div>
              </template>
              <template slot="body.append">
                <tr class="d-none d-md-table-row">
                  <td colspan="2" class="fontBold text-center">รวม</td>
                  <td class="py-2 text-right">
                    <span class="font-weight-bold" v-if="new Date().getTime()>=new Date((budgetYear-1)+'-10-01 00:00:01').getTime()">
                      <span class="green--text text--darken-3 font-weight-bold">ได้รับจัดสรร</span> {{ moneyFormat(budgetSum.budgetslipMoney1) }}<br>
                      <span class="red--text text--darken-3 font-weight-bold">เบิกจ่าย</span> {{ moneyFormat(parseFloat(budgetSum.disburseMoney1)>parseFloat(budgetSum.budgetslipMoney1)? budgetSum.budgetslipMoney1 : budgetSum.disburseMoney1) }}
                      <div class="mt-1">
                        <v-progress-linear
                          :value="100-(parseFloat(parseFloat(budgetSum.disburseMoney1)>parseFloat(budgetSum.budgetslipMoney1)? budgetSum.budgetslipMoney1 : budgetSum.disburseMoney1)/parseFloat(budgetSum.budgetslipMoney1)*100)"
                          background-color="red lighten-3"
                          color="green lighten-2"
                          height="20"
                        >
                          <template v-slot:default="{}">
                            <div class="pa-0 col-12 text-right text-no-wrap">
                              <strong>{{ moneyFormat(parseFloat(parseFloat(budgetSum.disburseMoney1)>parseFloat(budgetSum.budgetslipMoney1)? budgetSum.budgetslipMoney1 : budgetSum.disburseMoney1)/parseFloat(budgetSum.budgetslipMoney1)*100) }}%</strong>
                            </div>
                          </template>
                        </v-progress-linear>
                      </div>
                    </span>
                  </td>
                  <td class="py-2 fontBold text-right">
                    <span class="font-weight-bold" v-if="new Date().getTime()>=new Date(budgetYear+'-01-01 00:00:01').getTime()">
                      <span class="green--text text--darken-3 font-weight-bold">ได้รับจัดสรร</span> {{ moneyFormat(budgetSum.budgetslipMoney2) }}<br>
                      <span class="red--text text--darken-3 font-weight-bold">เบิกจ่าย</span> {{ moneyFormat(parseFloat(budgetSum.disburseMoney2)>parseFloat(budgetSum.budgetslipMoney2)? budgetSum.budgetslipMoney2 : budgetSum.disburseMoney2) }}
                      <div class="mt-1">
                        <v-progress-linear
                          :value="100-(parseFloat(parseFloat(budgetSum.disburseMoney2)>parseFloat(budgetSum.budgetslipMoney2)? budgetSum.budgetslipMoney2 : budgetSum.disburseMoney2)/parseFloat(budgetSum.budgetslipMoney2)*100)"
                          background-color="red lighten-3"
                          color="green lighten-2"
                          height="20"
                        >
                          <template v-slot:default="{}">
                            <div class="pa-0 col-12 text-right text-no-wrap">
                              <strong>{{ moneyFormat(parseFloat(parseFloat(budgetSum.disburseMoney2)>parseFloat(budgetSum.budgetslipMoney2)? budgetSum.budgetslipMoney2 : budgetSum.disburseMoney2)/parseFloat(budgetSum.budgetslipMoney2)*100) }}%</strong>
                            </div>
                          </template>
                        </v-progress-linear>
                      </div>
                    </span>
                  </td>
                  <td class="py-2 fontBold text-right">
                    <span class="font-weight-bold" v-if="new Date().getTime()>=new Date(budgetYear+'-04-01 00:00:01').getTime()">
                      <span class="green--text text--darken-3 font-weight-bold">ได้รับจัดสรร</span> {{ moneyFormat(budgetSum.budgetslipMoney3) }}<br>
                      <span class="red--text text--darken-3 font-weight-bold">เบิกจ่าย</span> {{ moneyFormat(parseFloat(budgetSum.disburseMoney3)>parseFloat(budgetSum.budgetslipMoney3)? budgetSum.budgetslipMoney3 : budgetSum.disburseMoney3) }}
                      <div class="mt-1">
                        <v-progress-linear
                          :value="100-(parseFloat(parseFloat(budgetSum.disburseMoney3)>parseFloat(budgetSum.budgetslipMoney3)? budgetSum.budgetslipMoney3 : budgetSum.disburseMoney3)/parseFloat(budgetSum.budgetslipMoney3)*100)"
                          background-color="red lighten-3"
                          color="green lighten-2"
                          height="20"
                        >
                          <template v-slot:default="{}">
                            <div class="pa-0 col-12 text-right text-no-wrap">
                              <strong>{{ moneyFormat(parseFloat(parseFloat(budgetSum.disburseMoney3)>parseFloat(budgetSum.budgetslipMoney3)? budgetSum.budgetslipMoney3 : budgetSum.disburseMoney3)/parseFloat(budgetSum.budgetslipMoney3)*100) }}%</strong>
                            </div>
                          </template>
                        </v-progress-linear>
                      </div>
                    </span>
                  </td>
                  <td class="py-2 fontBold text-right">
                    <span class="font-weight-bold" v-if="new Date().getTime()>=new Date(budgetYear+'-07-01 00:00:01').getTime()">
                      <span class="green--text text--darken-3 font-weight-bold">ได้รับจัดสรร</span> {{ moneyFormat(parseFloat(budgetSum.budgetslipMoney4)) }}<br>
                      <span class="red--text text--darken-3 font-weight-bold">เบิกจ่าย</span> {{ moneyFormat(parseFloat(budgetSum.disburseMoney4)>parseFloat(budgetSum.budgetslipMoney4)? budgetSum.budgetslipMoney4 : budgetSum.disburseMoney4) }}
                      <div class="mt-1">
                        <v-progress-linear
                          :value="100-(parseFloat(parseFloat(budgetSum.disburseMoney4)>parseFloat(budgetSum.budgetslipMoney4)? budgetSum.budgetslipMoney4 : budgetSum.disburseMoney4)/parseFloat(budgetSum.budgetslipMoney4)*100)"
                          background-color="red lighten-3"
                          color="green lighten-2"
                          height="20"
                        >
                          <template v-slot:default="{}">
                            <div class="pa-0 col-12 text-right text-no-wrap">
                              <strong>{{ moneyFormat(parseFloat(parseFloat(budgetSum.disburseMoney4)>parseFloat(budgetSum.budgetslipMoney4)? budgetSum.budgetslipMoney4 : budgetSum.disburseMoney4)/parseFloat(budgetSum.budgetslipMoney4)*100) }}%</strong>
                            </div>
                          </template>
                        </v-progress-linear>
                      </div>
                    </span>
                  </td>
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
        { text: 'หมวดงบประมาณ', value: 'budgettypeName', align: 'left', class: 'text-center' },
        { text: 'ไตรมาตร 1', value: 'budgetslipMoney1', align: 'right', class: 'text-center' },
        { text: 'ไตรมาตร 2', value: 'budgetslipMoney2', align: 'right', class: 'text-center' },
        { text: 'ไตรมาตร 3', value: 'budgetslipMoney3', align: 'right', class: 'text-center' },
        { text: 'ไตรมาตร 4', value: 'budgetslipMoney4', align: 'right', class: 'text-center' },
      ],
      search: '',
      budgetslipsLoading: true,
      budgetslips: [],
      budgetSum: {},
      budgetslipData: {},
      insertDialog: false,
      insertProgress: false,
      budgetslipInsertValidate: null,

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
    await this.getBudgetplans()
  },

  methods: {
    async getBudgetplans() {
      this.budgetslipsLoading = true
      let params = {
        token: this.$store.state.jwtToken,
        budgetslipYear: this.budgetYear,
        fn: 'getSummaryPeriodByBudgetYear'
      }
      let result = await this.$axios.$get('budgetslip.php', {params})
      //console.log(result)
      if(result.message === 'Success') {
        this.budgetslips = JSON.parse(JSON.stringify(result.budgetslip))
      }

      params = {
        token: this.$store.state.jwtToken,
        budgetslipYear: this.budgetYear,
        fn: 'getSummaryPeriodByYear'
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
    await this.getBudgetplans()
  },

  async personalIDcard() {
    await this.getBudgetplans()
  }
}
}
</script>
