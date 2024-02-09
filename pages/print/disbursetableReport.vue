<template>
  <div style="line-height: 1.8">
    <div class="printPageLand">
      <v-row class="mb-2">
        <v-col cols="12" class="text-center font18 fontBold">
          ตารางรายการจัดซื้อ/เบิกเงิน (
            <span class="font18 fontBold" v-if="disp=='all'">ทั้งหมด</span>
            <span class="font18 fontBold" v-else-if="disp=='plan'">ที่ตัดแผนแล้ว</span>
            <span class="font18 fontBold" v-else-if="disp=='complete'">ที่เบิกจ่ายแล้ว</span>
            <span class="font18 fontBold" v-else-if="disp=='cancel'">ที่ยกเลิก</span>
          ) ประจำปีงบประมาณ พ.ศ.2566<br>
          วิทยาลัยเทคนิคแพร่ ประจำปีงบประมาณ พ.ศ. {{ parseInt(disburseYear)+543 }}

        </v-col>
      </v-row>
      <table width="100%" style="border: solid 1px black; border-spacing: 0;">
        <thead>
          <tr class="grey lighten-2">
            <th width="2%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 2px">ลำดับ</th>
            <th width="5%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 2px">รหัสอ้างอิง</th>
            <th width="16%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 2px">รายการ</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 2px">หมวดค่าใช้จ่าย : ค่าใช้จ่าย/โครงการ</th>
            <!-- <th width="10%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 2px">หมวดค่าใช้จ่าย</th> -->
            <th width="8%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 2px">จำนวนเงิน (บาท)</th>
            <th width="13%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 2px">หมวดงบประมาณ</th>
            <th width="10%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 2px">สถานะเบิกจ่าย</th>
            <th width="10%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 2px">วันที่</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="disburse in ShowDisburses" :key="disburse.disburseID">
            <td class="text-center text-no-wrap font16" style="border: solid 1px black; padding: 2px">{{ ShowDisburses.indexOf(disburse)+1 }}</td>
            <td class="text-center text-no-wrap font16" style="border: solid 1px black; padding: 2px">DB-{{ parseInt(disburse.disburseID) }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 2px">
              {{ disburse.disburseDes }}
            </td>
            <td class="text-left font16" style="border: solid 1px black; padding: 2px">{{ disburse.disburseName }}</td>
            <!-- <td class="text-left font16" style="border: solid 1px black; padding: 2px">{{ disburse.expenseName }}</td> -->
            <td class="text-right text-no-wrap font16" style="border: solid 1px black; padding: 2px">{{ moneyFormat(disburse.disburseMoney) }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 2px">{{ disburse.budgetplanFullname }}</td>
            <td class="text-center text-no-wrap font16" style="border: solid 1px black; padding: 2px">
              <span class="success--text font16" x-small v-if="disburse.disburseStatus=='เบิกจ่ายแล้ว'">
                {{ disburse.disburseStatus }}
              </span>
              <span class="primary--text font16" x-small dark v-else-if="disburse.disburseStatus=='ตัดแผนแล้ว'">
                {{ disburse.disburseStatus }}
              </span>
              <span class="red--text text--darken-2 font16" x-small dark v-else-if="disburse.disburseStatus=='ยกเลิก'">
                {{ disburse.disburseStatus }}
              </span>
            </td>
            <td class="text-center font16" style="border: solid 1px black; padding: 2px">
              <span v-if="disburse.disburseStatus=='เบิกจ่ายแล้ว'">
                {{ thaiDateShort(disburse.disburseFinDate) }}
              </span>
              <span v-else>
                {{ thaiDateShort(disburse.disburseDate) }}
              </span>
            </td>
          </tr>
          <tr class="grey lighten-2">
            <td colspan="6" class="pa-2 text-center font16 fontBold" style="border: solid 1px black; padding: 2px">
              รวมทั้งสิ้น {{ ShowDisburses.length }} รายการ
            </td>
            <td colspan="3" class="pa-2 text-right text-no-wrap font16 fontBold" style="border: solid 1px black; padding: 2px">
             <span class="font16 fontBold" v-if="disp=='all'">{{ moneyFormat(budgetSum.disburseMoney) }}</span>
             <span class="font16 fontBold" v-else-if="disp=='plan'">{{ moneyFormat(budgetSum.disbursePlanMoney) }}</span>
             <span class="font16 fontBold" v-else-if="disp=='complete'">{{ moneyFormat(budgetSum.disburseCompleteMoney) }}</span>
             <span class="font16 fontBold" v-else-if="disp=='cancel'">{{ moneyFormat(budgetSum.disburseCancelMoney) }}</span>
            </td>
          </tr>
        </tbody>
        <tfoot>
          <tr>
            <td colspan="8" class="pt-2 pr-2 text-right">
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
      disburseYear: null,
      disburses: [],
      PlanDisburses: [],
      CompleteDisburses: [],
      CancelDisburses: [],
      ShowDisburses: [],
      budgetSum: {},
      disp: null,
    }
  },

  async mounted() {
    this.disburseYear = this.$route.query.year
    this.disp = this.$route.query.disp
    await this.getDisburses()
  },

  methods: {
    async getDisburses() {
      this.disbursesLoading = true
      let params = {
        token: this.$store.state.jwtToken,
        disburseYear: this.disburseYear
      }
      let result = await this.$axios.$get('disburse.php', {params})
      if(result.message === 'Success') {
        this.disburses = JSON.parse(JSON.stringify(result.disburse))
        if(this.disburses) {
          this.PlanDisburses = this.disburses.filter(disburse => disburse.disburseStatus === 'ตัดแผนแล้ว')
          this.CompleteDisburses = this.disburses.filter(disburse => disburse.disburseStatus === 'เบิกจ่ายแล้ว')
          this.CancelDisburses = this.disburses.filter(disburse => disburse.disburseStatus === 'ยกเลิก')
        }
        if(this.disp === 'all') {
          this.ShowDisburses = JSON.parse(JSON.stringify(this.disburses))
        } else if(this.disp === 'plan') {
          this.ShowDisburses = JSON.parse(JSON.stringify(this.PlanDisburses))
        } else if(this.disp === 'complete') {
          this.ShowDisburses = JSON.parse(JSON.stringify(this.CompleteDisburses))
        } else if(this.disp === 'cancel') {
          this.ShowDisburses = JSON.parse(JSON.stringify(this.CancelDisburses))
        }
      }
      params = {
        token: this.$store.state.jwtToken,
        disburseYear: this.disburseYear,
        fn: 'getSummaryByYear'
      }
      let result2 = await this.$axios.$get('disburse.php', {params})
      if(result2.message === 'Success') {
        this.budgetSum = JSON.parse(JSON.stringify(result2.disburse))
      }
      this.disbursesLoading = false
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

    thaiDateShort(inDate) {
      let result = ''
      if(inDate) {
        let thdate = new Date(inDate)
        result = thdate.toLocaleDateString('th-TH', {
          year: 'numeric',
          month: 'short',
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
