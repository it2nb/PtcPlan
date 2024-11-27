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
            ที่ &emsp;{{ disburse.resultRecNo }}
        </v-col>
        <v-col cols="6" class="font17">
            วันที่ &nbsp; {{  thaiDate(disburse.recDate) }}
        </v-col>
        <v-col cols="12" class="font17">
          เรื่อง รายงานผลการพิจารณาและขออนุมัติสั่ง{{disburse.disburseSubtype}}
        </v-col>
        <v-col cols="12" class="pt-1 font17">
          เรียน ผู้อำนวยการวิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="pt-3 font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;ขอรายงานผลการพิจารณาการจัด{{disburse.disburseSubtype}}<span class="font17" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span> เพื่อ{{ disburse.disburseDes }} <span class="font17" v-if="disburse.disburseType=='ค่าใช้จ่าย'"> {{ subDepartment(disburse.departmentName) }}</span><span class="font17" v-if="disburse.disburseType=='โครงการ'"> {{ disburse.projectName }} {{ subDepartment(disburse.pjdepartmentName) }}</span> จำนวน {{ disburselists.length }} รายการ โดยวิธีเฉพาะเจาะจง ดังนี้
        </v-col>
        <v-col cols="12" class="pt-2 font17">
            <table width="100%" class="tableNormal">
                <thead>
                    <tr>
                        <th class="font17 font-weight-bold text-no-wrap">รายการพิจารณา</th>
                        <th class="font17 font-weight-bold text-no-wrap">รายชื่อผู้ยื่นข้อเสนอ</th>
                        <th class="font17 font-weight-bold text-no-wrap">ราคาที่เสนอ*</th>
                        <th class="font17 font-weight-bold text-no-wrap">ราคาที่ตกลง<span class="font17 font-weight-bold" v-if="disburse.expenseName=='ค่าใช้สอย'">จ้าง</span><span class="font17 font-weight-bold" v-else>ซื้อ</span>*</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="font17">จัด{{disburse.disburseSubtype}}<span class="font17" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span> เพื่อ{{ disburse.disburseDes }} <span class="font17" v-if="disburse.disburseType=='ค่าใช้จ่าย'"> {{ subDepartment(disburse.departmentName) }}</span><span class="font17" v-if="disburse.disburseType=='โครงการ'"> {{ disburse.projectName }} {{ subDepartment(disburse.pjdepartmentName) }}</span> จำนวน {{ disburselists.length }} รายการ</td>
                        <td class="font17">{{ disburse.companyName }}</td>
                        <td class="font17 text-right text-no-wrap">{{ moneyFormat(disburse.disburseMoney) }}</td>
                        <td class="font17 text-right text-no-wrap">{{ moneyFormat(disburse.disburseMoney) }}</td>
                    </tr>
                    <tr>
                        <td colspan="2" class="font17 font-weight-bold text-right">รวม</td>
                        <td class="font17 font-weight-bold text-right text-no-wrap">{{ moneyFormat(disburse.disburseMoney) }}</td>
                        <td class="font17 font-weight-bold text-right text-no-wrap">{{ moneyFormat(disburse.disburseMoney) }}</td>
                    </tr>
                </tbody>
            </table>
        </v-col>
        <v-col cols="12" class="mt-1 font17">
            *ราคาที่เสนอ และราคาที่ตกลง<span class="font17" v-if="disburse.expenseName=='ค่าใช้สอย'">จ้าง</span><span class="font17" v-else>ซื้อ</span> เป็นราคารวมภาษีมูลค่าเพิ่มและภาษีอื่น ค่าขนส่ง ค่าจดทะเบียน และค่าใช้จ่ายอื่นๆ ทั้งปวง
        </v-col>
        <v-col cols="12" class="mt-2 font17">
            โดยเกณฑ์การพิจารณาผลการยื่นข้อเสนอครั้งนี้ จะพิจารณาตัดสินโดยใช้หลักเกณฑ์ราคา
        </v-col>
        <v-col cols="12" class="mt-2 font17">
            &emsp;&emsp;&emsp;&emsp;วิทยาลัยเทคนิคแพร่พิจารณาแล้ว เห็นสมควรจัด<span class="font17" v-if="disburse.expenseName=='ค่าใช้สอย'">จ้าง</span><span class="font17" v-else>ซื้อ</span>จากผู้เสนอราคาดังกล่าว<br>
            &emsp;&emsp;&emsp;&emsp;จึงเรียนมาเพื่อโปรดพิจารณา หากเห็นชอบขอได้โปรดอนุมัติให้สั่ง<span class="font17" v-if="disburse.expenseName=='ค่าใช้สอย'">จ้าง</span><span class="font17" v-else>ซื้อ</span>จากผู้เสนอราคาดังกล่าว
        </v-col>
        <v-col cols="5" class="mt-10 pt-5 ml-auto text-center font17">
          <img :src="parcSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="parcSign && disburse.disburseParcCheck=='ถูกต้อง'" /><br>
          ({{ disburse.disburseParcHead }})<br>
          หัวหน้าเจ้าหน้าที่พัสดุ
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
        disburselists: [],
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
              this.disburselists = JSON.parse(JSON.stringify(disburselistQuery.disburselist))
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
