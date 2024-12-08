<template>
  <div style="line-height: 1.8">
    <div class="printPage3x2">
      <v-row no-gutters class="mb-2">
        <v-col cols="2">
            <img
                src="/krut.jpg"
                class="krut"
            />
        </v-col>
        <v-col cols="8" align-self="end" class="text-center font25 font-weight-bold">
            บันทึกข้อความ
        </v-col>
        <v-col cols="12" class="font17">
            ส่วนราชการ &emsp; งานพัสดุ ฝ่ายบริหารทรัพยากร วิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="6" class="font17">
            ที่ &emsp; {{ disburse.reportRecNo }}
        </v-col>
        <v-col cols="6" class="font17">
            วันที่ &nbsp; {{  thaiDate(disburse.recDate) }}
        </v-col>
        <v-col cols="12" class="font17">
          เรื่อง รายงานขอ{{disburse.disburseSubtype}}
        </v-col>
        <v-col cols="12" class="pt-1 font17">
          เรียน ผู้อำนวยการวิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="pt-3 font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;ด้วย งานพัสดุ ฝ่ายบริหารทรัพยากร วิทยาลัยเทคนิคแพร่มีความประสงค์จะจัด{{disburse.disburseSubtype}}<span class="font17" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span> เพื่อ{{ disburse.disburseDes }} <span class="font17" v-if="disburse.disburseType=='ค่าใช้จ่าย'"> {{ subDepartment(disburse.departmentName) }}</span><span class="font17" v-if="disburse.disburseType=='โครงการ'">{{ disburse.projectName }} {{ subDepartment(disburse.pjdepartmentName) }}</span> จำนวน {{ disburselists.length }} รายการ โดยวิธีเฉพาะเจาะจง ซึ่งมีรายละเอียด ดังต่อไปนี้
        </v-col>
        <v-col cols="12" class="pt-1 font17">
            &emsp;&emsp;&emsp;&emsp;&emsp;1. เหตุผลความจำเป็นที่ต้อง<span class="font17" v-if="disburse.expenseName=='ค่าใช้สอย'">จ้าง</span><span class="font17" v-else>ซื้อ</span> เพื่อ{{ disburse.disburseDes }}
        </v-col>
        <v-col cols="12" class="font17" v-if="disburse.disburseType">
            &emsp;&emsp;&emsp;&emsp;&emsp;2. รายละเอียดของพัสดุ
            <!-- <div class="font17"  v-for="disburselist, index in disburselists" :key="disburselist.key">
                &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;{{ index+1 }}. {{ disburselist.disburselistName }} &emsp;{{ disburselist.disburselistQty }} {{ disburselist.disburselistUnit }}
            </div> --><br>
            &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;(ตามรายละเอียดแนบท้าย จำนวน {{ disburselists.length }} รายการ)
        </v-col>
        <v-col cols="12" class="font17">
            &emsp;&emsp;&emsp;&emsp;&emsp;3. ราคากลางของพัสดุที่จะ<span class="font17" v-if="disburse.expenseName=='ค่าใช้สอย'">จ้าง</span><span class="font17" v-else>ซื้อ</span> จำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท
        </v-col>
        <v-col cols="12" class="font17">
            &emsp;&emsp;&emsp;&emsp;&emsp;4. วงเงินที่จะ<span class="font17" v-if="disburse.expenseName=='ค่าใช้สอย'">จ้าง</span><span class="font17" v-else>ซื้อ</span><br>
            &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;{{ disburse.budgettypeName }} {{ (disburse.budgettypeName!=disburse.budgetplanDes)? disburse.budgetplanDes : '' }} พ.ศ.{{parseInt(disburse.disburseYear)+543}} จำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท
        </v-col>
        <v-col cols="12" class="font17">
            &emsp;&emsp;&emsp;&emsp;&emsp;5. กำหนดเวลาที่ต้องการใช้พัสดุนั้น หรือให้งานนั้นแล้วเสร็จ<br>
            &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;กำหนดเวลาการส่งมอบพัสดุ หรืองานให้แล้วเสร็จภายใน 5 วัน นับถัดจากวันลงนามในสัญญา
        </v-col>
        <v-col cols="12" class="font17">
            &emsp;&emsp;&emsp;&emsp;&emsp;6. วิธีที่จะ<span class="font17" v-if="disburse.expenseName=='ค่าใช้สอย'">จ้าง</span><span class="font17" v-else>ซื้อ</span> และเหตุผลที่ต้อง<span class="font17" v-if="disburse.expenseName=='ค่าใช้สอย'">จ้าง</span><span class="font17" v-else>ซื้อ</span><br>
            &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;ดำเนินการด้วยวิธีเฉพาะเจาะจง เนื่องจากการจัดซื้อจัดจ้างพัสดุที่มีการผลิต จำหน่าย ก่อสร้าง หรือให้บริการทั่วไป และมีวงเงินในการจัดซื้อจัดจ้างครั้งหนึ่งไม่เกินวงเงินตามที่กำหนดในกฎกระทรวง
        </v-col>
        <v-col cols="12" class="font17">
            &emsp;&emsp;&emsp;&emsp;&emsp;7. หลักเกณฑ์การพิจารณาคัดเลือกข้อเสนอ<br>
            &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;การพิจารณาคัดเลือกข้อเสนอโดยใช้เกณฑ์ราคา
        </v-col>
        <v-col cols="12" class="font17">
            &emsp;&emsp;&emsp;&emsp;&emsp;8. การขออนุมัติแต่งตั้งคณะกรรมการต่าง ๆ<br>
            &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;การแต่งตั้งคณะกรรมการตรวจรับพัสดุโดยวิธีเฉพาะเจาะจง
        </v-col>
        <v-col cols="12" class="pt-3 font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;จึงเรียนมาเพื่อโปรดพิจารณา หากเห็นชอบขอได้โปรด<br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;1. อนุมัติให้ดำเนินการ ตามรายละเอียดในรายงานขอ<span class="font17" v-if="disburse.expenseName=='ค่าใช้สอย'">จ้าง</span><span class="font17" v-else>ซื้อ</span>ดังกล่าวข้างต้น <br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;2. ลงนามในคำสั่งแต่งตั้งคณะกรรมการตรวจรับพัสดุโดยวิธีเฉพาะเจาะจง
        </v-col>
        <v-col cols="5" class="mt-10 ml-auto text-center font17">
          <img :src="parcSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="parcSign && disburse.disburseParcCheck=='ถูกต้อง'" /><br>
          ({{ disburse.reparcHead? disburse.reparcHead : disburse.disburseParcHead }})<br>
          {{ disburse.reparcHead? 'รักษาราชการแทน' : ''}}หัวหน้าเจ้าหน้าที่พัสดุ
        </v-col>
      </v-row>
    </div>
  </div>
</template>
<script>
import { nullFormat } from 'numeral';

var numeral = require('numeral')
const { bahttext } = require('bahttext')
export default {
  layout: 'print_layout',
  data() {
    return {
        state: null,
        disburseID: null,
        directorName: null,
        dedirectorName: null,
        parcelName: null,
        financeName: null,
        disburse: {},
        disburselistall: [],
        disburselists: [],
        disburselistdis: [],
        formDate: [],
        parcSign: null
    }
  },

  async mounted() {
    this.disburseID = this.$route.query.id
    this.state = this.$store.state
    await this.getDisburse()
    await this.getName()
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
            if(this.disburse.parcUserID) {
              this.parcSign = await this.getDepartmentSignature(this.disburse.parcUserID)
            }

            this.formDate = this.disburse.disburseDate.split('-')

            let disburselistQuery = await this.$axios.$get('disburselist.php', {
              params: {
                token: this.$store.state.jwtToken,
                disburseID: this.disburseID
              }
            })

            if(disburselistQuery.message == 'Success') {
              this.disburselistall = JSON.parse(JSON.stringify(disburselistQuery.disburselist))
              this.disburselists = this.disburselistall.filter(disburselist => disburselist.disburselistPrice>=0)
              this.disburselistdis = this.disburselistall.filter(disburselist => disburselist.disburselistPrice<0)
            }
        }
    },

    async getName() {
      let token = this.$store.state.jwtToken
      await this.$axios.$get('party.php', {
        params: {
          token: token,
          partyName: 'อำนวยการ'
        }
      }).then(result=> {
        if(result.message == 'Success') {
          this.directorName = result.party.partyHead
        }
      })

      await this.$axios.$get('party.php', {
        params: {
          token: token,
          partyName: 'บริหารทรัพยากร'
        }
      }).then(result=> {
        if(result.message == 'Success') {
          this.dedirectorName = result.party.partyHead
        }
      })

      await this.$axios.$get('department.php', {
        params: {
          token: token,
          departmentSys: 'Parcel'
        }
      }).then(result=> {
        if(result.message == 'Success') {
          if(result.department.length>0){
            this.parcelName = result.department[0].departmentHead
          }
        }
      })

      await this.$axios.$get('department.php', {
        params: {
          token: token,
          departmentSys: 'Finance'
        }
      }).then(result=> {
        if(result.message == 'Success') {
          if(result.department.length>0){
            this.financeName = result.department[0].departmentHead
          }
        }
      })
    },

    async getDepartmentSignature(userID) {
      let result = await this.$axios.$get('signature.image.php', {
          params: {
            token: this.$store.state.jwtToken,
            signatureType: 'Department',
            signatureID: userID,
            function: 'signatureImageGet'
          }
        })

        if(result.message == 'Success') {
          return result.signatureImagePath+JSON.parse(JSON.stringify(result.signatureImages))[0]
        } else {
          return null
        }
    },

    subDepartment(departmentName) {
      if(departmentName) {
        let subd = departmentName.substring(departmentName.indexOf("(") + 1, departmentName.lastIndexOf(")"))
        if(subd){
          return subd
        } else {
          return departmentName
        }
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
    },

    qtyFormat(qty){
      if(qty%1) {
        return numeral(qty).format('0,0.00')
      } else {
        return numeral(qty).format('0,0')
      }
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
