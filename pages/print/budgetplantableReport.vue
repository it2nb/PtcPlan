<template>
  <div style="line-height: 1.8">
    <div class="printPageLand">
      <v-row class="mb-2">
        <v-col cols="12" class="text-center font18 fontBold">
          ตารางสรุปผลตามแผนงบประมาณรายรับ<br>
          วิทยาลัยเทคนิคแพร่ ประจำปีงบประมาณ พ.ศ. {{ parseInt(budgetplanYear)+543 }}
        </v-col>
      </v-row>
      <table width="100%" style="border: solid 1px black; border-spacing: 0;">
        <thead>
          <tr class="grey lighten-2">
            <th width="2%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ลำดับ</th>
            <th width="15%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">หมวดงบประมาณ</th>
            <th width="15%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">รายการ</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ประมาณการ (บาท)</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">งบที่ไดัรับจัดสรร (บาท)</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">รอเบิกจ่าย (บาท)</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">เบิกจ่ายแล้ว (บาท)</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">คงเหลือ (ยอดแผน : บาท)</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">คงเหลือ (ยอดจัดสรร : บาท)</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="budgetplan in budgetplans" :key="budgetplan.budgetplanID">
            <td class="text-center font16" style="border: solid 1px black; padding: 3px">{{ budgetplans.indexOf(budgetplan)+1 }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px">{{ budgetplan.budgetFullname }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px">
              {{ budgetplan.budgetplanDes }}
            </td>
            <td class="text-right text-no-wrap font16" style="border: solid 1px black; padding: 3px">{{ moneyFormat(budgetplan.budgetplanMoney) }}</td>
            <td class="text-right text-no-wrap font16" style="border: solid 1px black; padding: 3px; background-color: #EEEEEE;">{{ moneyFormat(budgetplan.budgetrealMoney) }}</td>
            <td class="text-right text-no-wrap font16" style="border: solid 1px black; padding: 3px; background-color: #EDE7F6;" >{{ moneyFormat(budgetplan.disbursePlanMoney) }}</td>
            <td class="text-right text-no-wrap font16" style="border: solid 1px black; padding: 3px; background-color: #E8F5E9;">{{ moneyFormat(budgetplan.disburseRealMoney) }}</td>
            <td class="text-right text-no-wrap font16" style="border: solid 1px black; padding: 3px">
              <div v-if="parseFloat(budgetplan.budgetplanMoney) > parseFloat(budgetplan.budgetrealMoney)">
                <span class="success--text" v-if="(parseFloat(budgetplan.budgetplanMoney)-(parseFloat(budgetplan.disbursePlanMoney)+parseFloat(budgetplan.disburseRealMoney))) > 0">
                  {{ moneyFormat(parseFloat(budgetplan.budgetplanMoney)-(parseFloat(budgetplan.disbursePlanMoney)+parseFloat(budgetplan.disburseRealMoney))) }}
                </span>
                <span class="red--text" v-else-if="(parseFloat(budgetplan.budgetplanMoney)-(parseFloat(budgetplan.disbursePlanMoney)+parseFloat(budgetplan.disburseRealMoney))) < 0">
                  {{ moneyFormat(parseFloat(budgetplan.budgetplanMoney)-(parseFloat(budgetplan.disbursePlanMoney)+parseFloat(budgetplan.disburseRealMoney))) }}
                </span>
                <span class="" v-else>
                  {{ moneyFormat(parseFloat(budgetplan.budgetplanMoney)-(parseFloat(budgetplan.disbursePlanMoney)+parseFloat(budgetplan.disburseRealMoney))) }}
                </span>
              </div>
              <div v-else>
                <span class="success--text" v-if="(parseFloat(budgetplan.budgetrealMoney)-(parseFloat(budgetplan.disbursePlanMoney)+parseFloat(budgetplan.disburseRealMoney))) > 0">
                  {{ moneyFormat(parseFloat(budgetplan.budgetrealMoney)-(parseFloat(budgetplan.disbursePlanMoney)+parseFloat(budgetplan.disburseRealMoney))) }}
                </span>
                <span class="red--text" v-else-if="(parseFloat(budgetplan.budgetrealMoney)-(parseFloat(budgetplan.disbursePlanMoney)+parseFloat(budgetplan.disburseRealMoney))) < 0">
                  {{ moneyFormat(parseFloat(budgetplan.budgetrealMoney)-(parseFloat(budgetplan.disbursePlanMoney)+parseFloat(budgetplan.disburseRealMoney))) }}
                </span>
                <span class="" v-else>
                  {{ moneyFormat(parseFloat(budgetplan.budgetrealMoney)-(parseFloat(budgetplan.disbursePlanMoney)+parseFloat(budgetplan.disburseRealMoney))) }}
                </span>
              </div>
            </td>
            <td class="text-right text-no-wrap font16" style="border: solid 1px black; padding: 3px; background-color: #E1F5FE;">
              <span class="success--text fontBold" v-if="(parseFloat(budgetplan.budgetrealMoney)-parseFloat(budgetplan.disburseRealMoney)) > 0">
                {{ moneyFormat(parseFloat(budgetplan.budgetrealMoney)-parseFloat(budgetplan.disburseRealMoney)) }}
              </span>
              <span class="red--text fontBold" v-else-if="(parseFloat(budgetplan.budgetrealMoney)-parseFloat(budgetplan.disburseRealMoney)) < 0">
                {{ moneyFormat(parseFloat(budgetplan.budgetrealMoney)-parseFloat(budgetplan.disburseRealMoney)) }}
              </span>
              <span class="fontBold" v-else>
                {{ moneyFormat(parseFloat(budgetplan.budgetrealMoney)-parseFloat(budgetplan.disburseRealMoney)) }}
              </span>
            </td>
          </tr>
          <tr class="">
            <td colspan="3" class="pa-2 text-center font16 fontBold" style="border: solid 1px black; padding: 3px">
              รวมทั้งสิ้น {{ budgetSum.budgetplanQty }} รายการ
            </td>
            <td class="pa-2 text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px">
             {{ moneyFormat(budgetSum.budgetplanMoney) }}
            </td>
            <td class="pa-2 text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px; background-color: #EEEEEE;">
             {{ moneyFormat(budgetSum.budgetrealMoney) }}
            </td>
            <td class="pa-2 text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px; background-color: #EDE7F6">
             {{ moneyFormat(budgetSum.disbursePlanMoney) }}
            </td>
            <td class="pa-2 text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px; background-color: #E8F5E9">
             {{ moneyFormat(budgetSum.disburseRealMoney) }}
            </td>
            <td class="pa-2 text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px">
             <div v-if="parseFloat(budgetSum.budgetplanMoney) > parseFloat(budgetSum.budgetrealMoney)">
                <span class="success--text fontBold" v-if="(parseFloat(budgetSum.budgetplanMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) > 0">
                  {{ moneyFormat(parseFloat(budgetSum.budgetplanMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                </span>
                <span class="red--text fontBold" v-else-if="(parseFloat(budgetSum.budgetplanMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) < 0">
                  {{ moneyFormat(parseFloat(budgetSum.budgetplanMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                </span>
                <span class="fontBold" v-else>
                  {{ moneyFormat(parseFloat(budgetSum.budgetplanMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                </span>
              </div>
              <div v-else>
                <span class="success--text fontBold" v-if="(parseFloat(budgetSum.budgetrealMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) > 0">
                  {{ moneyFormat(parseFloat(budgetSum.budgetrealMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                </span>
                <span class="red--text fontBold" v-else-if="(parseFloat(budgetSum.budgetrealMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) < 0">
                  {{ moneyFormat(parseFloat(budgetSum.budgetrealMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                </span>
                <span class="fontBold" v-else>
                  {{ moneyFormat(parseFloat(budgetSum.budgetrealMoney)-(parseFloat(budgetSum.disbursePlanMoney)+parseFloat(budgetSum.disburseRealMoney))) }}
                </span>
              </div>
            </td>
            <td class="pa-2 text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 3px; background-color: #E1F5FE;">
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
      budgetplanYear: null,
      budgetplans: [],
      budgetSum: {}
    }
  },

  async mounted() {
    this.budgetplanYear = this.$route.query.year
    await this.getBudgetplans()
  },

  methods: {
    async getBudgetplans() {
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
