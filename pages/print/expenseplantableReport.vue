<template>
  <div style="line-height: 1.8">
    <div class="printPageLand">
      <v-row class="mb-2">
        <v-col cols="12" class="text-center font18 fontBold">
          ตารางสรุปผลตามแผนงบประมาณรายจ่าย<br>
          วิทยาลัยเทคนิคแพร่ ประจำปีงบประมาณ พ.ศ. {{ parseInt(expenseplanYear)+543 }}
        </v-col>
      </v-row>
      <table width="100%" style="border: solid 1px black; border-spacing: 0;">
        <thead>
          <tr class="grey lighten-2">
            <th width="2%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ลำดับ</th>
            <th width="15%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">หมวดค่าใช้จ่าย</th>
            <th width="20%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">รายการ</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ประมาณการ (บาท)</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">รอเบิกจ่าย (บาท)</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">เบิกจ่ายแล้ว (บาท)</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">คงเหลือ</th>
          </tr>
        </thead>
        <tbody>
          <template v-for="expense in expenses" >
          <tr v-for="expenseplan in expense.expenseplans" :key="expenseplan.expenseplanID">
            <td class="text-center font16" style="border: solid 1px black; padding: 3px">{{ expense.expenseplans.indexOf(expenseplan)+1 }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px">{{ expense.expenseName }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px">
              {{ expenseplan.expenseplanDes }}
            </td>
            <td class="text-right text-no-wrap font16" style="border: solid 1px black; padding: 3px">{{ moneyFormat(expenseplan.expenseplanMoney) }}</td>
            <td class="text-right text-no-wrap font16" style="border: solid 1px black; padding: 3px">{{ moneyFormat(expenseplan.disbursePlanMoney) }}</td>
            <td class="text-right text-no-wrap font16" style="border: solid 1px black; padding: 3px">{{ moneyFormat(expenseplan.disburseRealMoney) }}</td>
            <td class="text-right text-no-wrap font16" style="border: solid 1px black; padding: 3px">
              <span class="success--text fontBold" v-if="(parseFloat(expenseplan.expenseplanMoney)-(parseFloat(expenseplan.disbursePlanMoney)+parseFloat(expenseplan.disburseRealMoney))) > 0">
                {{ moneyFormat(parseFloat(expenseplan.expenseplanMoney)-(parseFloat(expenseplan.disbursePlanMoney)+parseFloat(expenseplan.disburseRealMoney))) }}
              </span>
              <span class="red--text fontBold" v-else-if="(parseFloat(expenseplan.expenseplanMoney)-(parseFloat(expenseplan.disbursePlanMoney)+parseFloat(expenseplan.disburseRealMoney))) < 0">
                {{ moneyFormat(parseFloat(expenseplan.expenseplanMoney)-(parseFloat(expenseplan.disbursePlanMoney)+parseFloat(expenseplan.disburseRealMoney))) }}
              </span>
              <span class="fontBold" v-else>
                {{ moneyFormat(parseFloat(expenseplan.expenseplanMoney)-(parseFloat(expenseplan.disbursePlanMoney)+parseFloat(expenseplan.disburseRealMoney))) }}
              </span>
            </td>
          </tr>
          <tr :key="expense.key" class="grey lighten-3">
            <td colspan="3" class="text-center font16 fontBold" style="border: solid 1px black; padding: 3px"> รวม {{ expense.expenseName }}</td>
            <td class="text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px">{{ moneyFormat(expense.expenseplanMoney) }}</td>
            <td class="text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px">{{ moneyFormat(expense.disbursePlanMoney) }}</td>
            <td class="text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px">{{ moneyFormat(expense.disburseRealMoney) }}</td>
            <td class="text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px">
              <span class="success--text fontBold" v-if="(parseFloat(expense.expenseplanMoney)-(parseFloat(expense.disbursePlanMoney)+parseFloat(expense.disburseRealMoney))) > 0">
                {{ moneyFormat(parseFloat(expense.expenseplanMoney)-(parseFloat(expense.disbursePlanMoney)+parseFloat(expense.disburseRealMoney))) }}
              </span>
              <span class="red--text fontBold" v-else-if="(parseFloat(expense.expenseplanMoney)-(parseFloat(expense.disbursePlanMoney)+parseFloat(expense.disburseRealMoney))) < 0">
                {{ moneyFormat(parseFloat(expense.expenseplanMoney)-(parseFloat(expense.disbursePlanMoney)+parseFloat(expense.disburseRealMoney))) }}
              </span>
              <span class="fontBold" v-else>
                {{ moneyFormat(parseFloat(expense.expenseplanMoney)-(parseFloat(expense.disbursePlanMoney)+parseFloat(expense.disburseRealMoney))) }}
              </span>
            </td>
          </tr>
          </template>
          <tr class="grey lighten-2">
            <td colspan="3" class="pa-2 text-center font16 fontBold" style="border: solid 1px black; padding: 3px">
              รวมทั้งสิ้น {{ expenseSum.orgstrategicNum }} จำนวน {{ expenseSum.expenseplanQty }} รายการ
            </td>
            <td class="pa-2 text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px">
             {{ moneyFormat(expenseSum.expenseplanMoney) }}
            </td>
            <td class="pa-2 text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px">
             {{ moneyFormat(expenseSum.disbursePlanMoney) }}
            </td>
            <td class="pa-2 text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px">
             {{ moneyFormat(expenseSum.disburseRealMoney) }}
            </td>
            <td class="pa-2 text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px">
              <span class="success--text fontBold" v-if="(parseFloat(expenseSum.expenseplanMoney)-(parseFloat(expenseSum.disbursePlanMoney)+parseFloat(expenseSum.disburseRealMoney))) > 0">
                {{ moneyFormat(parseFloat(expenseSum.expenseplanMoney)-(parseFloat(expenseSum.disbursePlanMoney)+parseFloat(expenseSum.disburseRealMoney))) }}
              </span>
              <span class="red--text fontBold" v-else-if="(parseFloat(expenseSum.expenseplanMoney)-(parseFloat(expenseSum.disbursePlanMoney)+parseFloat(expenseSum.disburseRealMoney))) < 0">
                {{ moneyFormat(parseFloat(expenseSum.expenseplanMoney)-(parseFloat(expenseSum.disbursePlanMoney)+parseFloat(expenseSum.disburseRealMoney))) }}
              </span>
              <span class="fontBold" v-else>
                {{ moneyFormat(parseFloat(expenseSum.expenseplanMoney)-(parseFloat(expenseSum.disbursePlanMoney)+parseFloat(expenseSum.disburseRealMoney))) }}
              </span>
            </td>
          </tr>
        </tbody>
        <tfoot>
          <tr>
            <td colspan="9" class="pt-2 pr-2 text-right">
              ข้อมูลจากระบบบริหารจัดการแผนปฏิบัติราชการ วิทยาลัยเทคนิคแพร่ ณ วันที่ {{ thaiDate(new Date())}}
            </td>
          </tr>
        </tfoot>
      </table>
    </div>
  </div>
</template>
<script>
var numeral = require('numeral')
export default {
  layout: 'print_layout',
  data() {
    return {
      expenseplanYear: null,
      expenses: [],
      expenseSum: {}
    }
  },

  async mounted() {
    this.expenseplanYear = this.$route.query.year
    await this.getExpenseplans()
  },

  methods: {
    async getExpenseplans() {
      let params = {
        token: this.$store.state.jwtToken,
        expenseplanYear: this.expenseplanYear,
        fn: 'getSummaryByExpenseYearDetail'
      }
      let result = await this.$axios.$get('expenseplan.php', {params})

      if(result.message === 'Success') {
        this.expenses = JSON.parse(JSON.stringify(result.expenseplan))
      }
      params = {
        token: this.$store.state.jwtToken,
        expenseplanYear: this.expenseplanYear,
        fn: 'getSummaryByYear'
      }
      let result2 = await this.$axios.$get('expenseplan.php', {params})
      if(result2.message === 'Success') {
        this.expenseSum = JSON.parse(JSON.stringify(result2.expenseplan))
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

    thaiMonthShort(inDate) {
      let result = ''
      if(inDate) {
        let thdate = new Date(inDate)
        result = thdate.toLocaleDateString('th-TH', {
          month: 'short',
        })
      }
      return result
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    }

  }
}
</script>

<style scoped>
  @page {
    size: A4 landscape;
  }
</style>
