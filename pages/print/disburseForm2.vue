<template>
  <div style="line-height: 1.8">
    <div class="printPage3x2">
      <v-row no-gutters class="mb-2">
        <v-col cols="12" align-self="end" class="text-center font19 font-weight-bold">
            ใบเบิก{{ disburse.budgettypeName }} ({{ disburse.budgetplanDes }})
        </v-col>
        <v-col cols="12" class="mt-5 font17 text-center" v-if="state">
            ชื่อสถานศึกษา &emsp; {{ state.appSubTitle }} &emsp; สำนักงานคณะกรรมการการอาชีวศึกษา
        </v-col>
        <v-col cols="12" class="font17 text-center">
            ใบเบิกที่ ……………… / ……………… ลงวันที่ ……………… เดือน…………………พ.ศ………… <br>
ข้าพเจ้าขอเบิกเงินงบประมาณ  ดังรายการต่อไปนี้ 
        </v-col>
        <v-col cols="12" class="mt-3 font17">
          <table width="100%" class="tableNormal">
            <thead>
              <tr>
                <th class="font17 font-weight-bold">
                    หมวดรายจ่าย<br>ตามงบประมาณ 
                </th>
                <th class="font17 font-weight-bold">
                  รายการ
                </th>
                <th class="font17 font-weight-bold">
                  ใบสำคัญที่
                </th>
                <th class="font17 font-weight-bold">
                  จำนวนเงิน
                </th>
                <th class="font17 font-weight-bold">
                  รวมเงิน
                </th>
                <th class="font17 font-weight-bold">
                  หมายเหตุ
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="disburselist, index in disburselists" :key="disburselist.key">
                <td class="font17 text-center">{{ index==0 ? disburse.expenseName : '' }}</td>
                <td class="font17">
                  {{index+1}}. {{ disburselist.disburselistName }}
                </td>
                <td class="font17 ">

                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
                <td class="font17">
                  <v-icon small color="error" v-if="disburselist.disburselistStatus=='ไม่ถูกต้อง'">fas fa-times</v-icon>
                  {{ disburselist.disburselistStatus=='ไม่ถูกต้อง' ? disburselist.disburselistCommment : '' }}
                </td>
              </tr>
              <tr>
                <td></td>
                <td class="font17">
                  จำนวน {{ disburselists.length }} รายการ
                </td>
                <td class="font17 pl-2">
                  
                </td>
                <td class="font17 text-right  text-no-wrap">
                  
                </td>
                <td class="font17 text-right  text-no-wrap">
                  
                </td>
                <td class="font17">
                  
                </td>
              </tr>
              <tr>
                <td></td>
                <td class="font17">
                  กับ
                </td>
                <td class="font17 pl-2">
                  
                </td>
                <td class="font17 text-right  text-no-wrap">
                  
                </td>
                <td class="font17 text-right  text-no-wrap">
                  
                </td>
                <td class="font17">
                  
                </td>
              </tr>
              <tr>
                <td></td>
                <td colspan="3" class="font17 font-weight-bold">รวมทั้งสิ้น</td>
                <td class="font17 text-right font-weight-bold">{{ disburse.disburseMoney }}</td>
                <td></td>
              </tr>
              <tr>
                <td></td>
                <td colspan="5" class="font17 font-weight-bold">รวมทั้งสิ้น(อักษร) {{ thaiBaht(disburse.disburseMoney) }}</td>
              </tr>
            </tbody>
          </table>
        </v-col>
        <v-col cols="6" class="font17">
            วันที่ {{  thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="12" class="font17">
          เรื่อง ขออนุญาตดำเนินการและขออนุมัติค่าใช้จ่าย
        </v-col>
        <v-col cols="12" class="pt-1 font17" v-if="state">
          เรียน ผู้อำนวยการ{{ state.appSubTitle }}
        </v-col>
        <v-col cols="12" class="pt-1 font17">
          สิ่งที่ส่งมาด้วย แบบโครงการและประมาณการค่าใช้จ่าย
        </v-col>
        <v-col cols="12" class="pt-1 font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;ด้วย{{ disburse.departmentName }} มีความประสงค์จะจัดซื้อ{{ disburse.disburseType=='โครงการ'? disburse.expenseName : disburse.expenseplanDes }} เพื่อ{{ disburse.disburseDes }} {{ disburse.disburseType=='โครงการ'? 'ตาม'+disburse.projectName : '' }} จำนวน {{ disburselists.length }} รายการ โดยมีค่าใช้จ่ายเป็นเงินจำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท  ({{ thaiBaht(disburse.disburseMoney) }})
        </v-col>
        <v-col cols="12" class="pt-1 font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;ดังนั้น เพื่อให้การดำเนินงานเป็นไปด้วยความเรียบร้อย จึงขออนุญาตดำเนินการและขออนุมัติงบประมาณเป็นเงินจำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท  ({{ thaiBaht(disburse.disburseMoney) }}) เพื่อใช้จ่ายตามแบบโครงการและประมาณการค่าใช้จ่ายที่แนบท้าย
        </v-col>
        <v-col cols="12" class="pt-1 font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;จึงเรียนมาเพื่อโปรด<br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;1. ทราบ <br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;2. พิจารณาอนุญาตดำเนินการ <br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;3. อนุมัติค่าใช้จ่ายตามโครงการ 
        </v-col>
        <v-col cols="12" class="mt-10">
          <v-row no-gutters>
            <v-col align-self="start" class="text-center font17">
              <!-- <img :src="departmentSignature" width="150" v-if="departmentSignature && (project.departmentSignName==disburse.departmentHead)" /><br> -->
              ({{ disburse.disburseReqName }})<br>
              หัวหน้างาน{{ disburse.departmentName }}
            </v-col>
            <v-col align-self="start" class="text-center font17">
              ({{ disburse.departmentHead }})<br>
              ผู้รับผิดชอบโครงการ
            </v-col>
            <v-col align-self="start" class="text-center font17">
              ({{ disburse.partyHead }})<br>
              รองผู้อำนวยการฝ่าย{{ disburse.partyName }}
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="12" class="mt-10 pt-10">
          <table width="100%" class="tableNormal">
            <tr>
              <td width="40%" class="font17" valign="top">
                1. งานพัสดุตรวจสอบรายการวัสดุ/ครุภัณฑ์<br/>
                &emsp;&emsp;<v-icon small>far fa-square</v-icon> ถูกต้อง<br>
                &emsp;&emsp;<v-icon small>far fa-square</v-icon> ไม่ถูกต้อง
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font17 text-center">
                    ลงชื่อ...............................
                  </v-col>
                  <v-col cols="12" class="font17 text-center">
                    (นายพงษ์เดช เรียนละหงษ์)
                  </v-col>
                </v-row>
              </td>
              <td class="font17" valign="top">
                2. ความเห็นหัวหน้างานวางแผนและงบประมาณ<br/>
                &emsp;เห็นควรใช้งบ:  {{ disburse.budgettypeName }} {{ String(disburse.budgetplanDes).length <65 ? disburse.budgetplanDes : String(disburse.budgetplanDes).substring(0, 65)+'...ฯ' }}<br>
                  &emsp;โครงการ: {{ disburse.disburseType=='โครงการ'? disburse.projectName : disburse.expenseplanDes }}
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font17 text-center">
                    ลงชื่อ...............................
                  </v-col>
                  <v-col cols="12" class="font17 text-center">
                    (นายวุฒิชัย  คำมีสว่าง)
                  </v-col>
                </v-row>
              </td>
            </tr>
            <tr>
              <td class="font17" valign="top">
                3. ความเห็นหัวหน้างานการเงิน<br/>
                &emsp;&emsp;เห็นควรอนุญาตดำเนินการ<br>
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font17 text-center">
                    ลงชื่อ...............................
                  </v-col>
                  <v-col cols="12" class="font17 text-center">
                    (นางอัญชรี  ภูริปัญญาวรกุล)
                  </v-col>
                </v-row>
              </td>
              <td class="font17" valign="top">
                4. ความเห็นหัวหน้างานบัญชี<br/>
                &emsp;&emsp;เห็นควรอนุญาตดำเนินการ<br>
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font17 text-center">
                    ลงชื่อ...............................
                  </v-col>
                  <v-col cols="12" class="font17 text-center">
                    (นางสาวเรณู  เชี่ยวชาญ)
                  </v-col>
                </v-row>
              </td>
            </tr>
          </table>
        </v-col>
      </v-row>
    </div>
    <div class="printPage3x2">
      <v-row no-gutters class="mb-2">
        <v-col cols="12" class="font17 font-weight-bold text-center">
          แบบโครงการและประมาณการค่าใช้จ่าย
        </v-col>
        <v-col cols="12" class="mb-2 font17 font-weight-bold text-center">
          โครงการ
        </v-col>
        <v-col cols="4" class="font17" v-if="state">
          สถานศึกษา {{ state.appSubTitle }}
        </v-col>
        <v-col cols="4" class="font17">
          ฝ่าย {{ disburse.partyName }}
        </v-col>
        <v-col cols="4" class="font17">
          {{ disburse.departmentName }}
        </v-col>
        <v-col cols="12" class="font17 mb-2">
          ภาคเรียนที่ {{ (parseInt(String(disburse.disburseDate).split('-')[1])>=5&&parseInt(String(disburse.disburseDate).split('-')[1])<=10)? '1':'2'}} &emsp;ปีการศึกษา {{ (parseInt(String(disburse.disburseDate).split('-')[1])>=5&&parseInt(String(disburse.disburseDate).split('-')[1])<=10)? parseInt(disburse.disburseYear)+543:parseInt(disburse.disburseYear)+542}}&emsp;ชื่อโครงการ {{ disburse.disburseType=='โครงการ'? disburse.projectName : disburse.expenseplanDes }} จำนวน {{ disburselists.length }} รายการ 
        </v-col>
        <v-col cols="4" class="font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;ลักษณะโครงการ
        </v-col>
        <v-col cols="8" class="font17">
          <v-icon small>far fa-square</v-icon> ตามโครงการพัฒนาสถานศึกษา<br>
          <v-icon small>far fa-square</v-icon> อื่นๆ
        </v-col>
        <v-col cols="12" class="mb-3 font17 text-center">
          วันที่เริ่มต้น {{ thaiDate(disburse.disburseStart) }}&emsp;&emsp;วันที่สิ้นสุด {{ thaiDate(disburse.disburseEnd) }}
        </v-col>
        <v-col cols="5" class="font17">
          ประมาณการค่าใช้จ่ายดังนี้
          <v-row no-gutters>
            <v-col  class="font17">
              - {{ disburse.expenseName }}
            </v-col>
            <v-col class="font17 text-right pr-3">
              {{ moneyFormat(disburse.disburseMoney) }} บาท
            </v-col>
          </v-row>
          <v-row no-gutters>
            <v-col  class="font17">
              &emsp;&emsp;รวม
            </v-col>
            <v-col class="font17 text-right pr-3">
              {{ moneyFormat(disburse.disburseMoney) }} บาท
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="7" class="font17">
          <table width="100%" class="tableNormal">
            <tr>
              <td class="font17 text-center">
                ผลิตผลที่คาดว่าจะได้
              </td>
            </tr>
            <tr>
              <td class="font17 px-3"><pre class="font17">{{ disburse.disburseProduct }}</pre></td>
            </tr>
          </table>
        </v-col>
        <v-col cols="6" class="font17 text-center mt-2">
          ({{ disburse.departmentHead }}) <br>
          หัวหน้า{{ disburse.departmentName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="6" class="font17 text-center mt-2">
          ({{ disburse.partyHead }}) <br>
          รองผู้อำนวยการฝ่าย{{ disburse.partyName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="12" class="mt-3 font17">
          <table width="100%" class="tableNormal">
            <thead>
              <tr>
                <th colspan="7" class="font17 text-center font-weight-bold">
                  ประมาณการค่าใช้จ่าย  (ค่าใช้สอย / ค่าตอบแทน / ค่าวัสดุ)
                </th>
              </tr>
              <tr>
                <th class="font17 font-weight-bold">
                  ลำดับ
                </th>
                <th class="font17 font-weight-bold">
                  รายการ
                </th>
                <th colspan="2" class="font17 font-weight-bold">
                  จำนวน<br>หน่วย
                </th>
                <th class="font17 font-weight-bold">
                  ราคาต่อหน่วย
                </th>
                <th class="font17 font-weight-bold">
                  รวมเงิน
                </th>
                <th class="font17 font-weight-bold">
                  หมายเหตุ
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="font17 text-center">1</td>
                <td class="font17">{{ disburse.expenseName }}</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
              </tr>
              <tr v-for="disburselist, index in disburselists" :key="disburselist.key">
                <td></td>
                <td class="font17">
                  1.{{index+1}} {{ disburselist.disburselistName }}
                </td>
                <td class="font17 text-right text-no-wrap">
                  {{ qtyFormat(disburselist.disburselistQty) }}
                </td>
                <td class="font17 pl-2">
                  {{ disburselist.disburselistUnit }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
                <td class="font17">
                  <v-icon small color="error" v-if="disburselist.disburselistStatus=='ไม่ถูกต้อง'">fas fa-times</v-icon>
                  {{ disburselist.disburselistStatus=='ไม่ถูกต้อง' ? disburselist.disburselistCommment : '' }}
                </td>
              </tr>
              <tr>
                <td colspan="5" class="font17 text-right font-weight-bold">รวมเงิน</td>
                <td class="font17 text-right font-weight-bold">{{ disburse.disburseMoney }}</td>
                <td></td>
              </tr>
            </tbody>
          </table>
        </v-col>
      </v-row>
    </div>
  </div>
</template>
<script>
var numeral = require('numeral')
const { bahttext } = require('bahttext')
export default {
  layout: 'print_layout',
  data() {
    return {
        state: null,
        disburseID: null,
        disburse: {},
        disburselists: [],
        formDate: []
    }
  },

  async mounted() {
    this.disburseID = this.$route.query.id
    this.state = this.$store.state
    await this.getDisburse()
  },

  methods: {
    async getDisburse() {
        let disburseQuery = await this.$axios.$get('disburse.php', {
            params: {
                token: this.$store.state.jwtToken,
                disburseID: this.disburseID
            }
        })

        if(disburseQuery.message == 'Success') {
            this.disburse = JSON.parse(JSON.stringify(disburseQuery.disburse))
            this.formDate = this.disburse.disburseDate.split('-')

            let disburselistQuery = await this.$axios.$get('disburselist.php', {
              params: {
                token: this.$store.state.jwtToken,
                disburseID: this.disburseID
              }
            })

            if(disburselistQuery.message == 'Success') {
              this.disburselists = JSON.parse(JSON.stringify(disburselistQuery.disburselist))
            }
        }
    },

    // async getOrgstartegics() {
    //   let params = {
    //     token: this.$store.state.jwtToken,
    //     orgstrategicYear: this.periodYear,
    //     projectStatus: this.status,
    //     fn: 'getProductListAll'
    //   }
    //   let result = await this.$axios.$get('orgstrategic.php', { params})

    //   if(result.message === 'Success') {
    //     this.orgstrategics = JSON.parse(JSON.stringify(result.orgstrategic))
    //   }
    // },

    // async getSummary() {
    //   let params = {
    //     token: this.$store.state.jwtToken,
    //     projectYear: this.periodYear,
    //     fn: 'getSummaryByYear'
    //   }
    //   let result = await this.$axios.$get('project.php', {
    //     params: params
    //   })
    //   if(result.message == 'Success') {
    //     this.projectSum = JSON.parse(JSON.stringify(result.project))
    //   }
    // },

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
    },

    qtyFormat(qty){
      return numeral(qty).format('0,0')
    },

    thaiBaht(money) {
      return bahttext(money)
    }

  }
}
</script>

<style scoped>
  
  @page {
    size: A4;
  }
</style>
