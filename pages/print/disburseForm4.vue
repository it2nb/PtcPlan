<template>
  <div style="line-height: 1.8">
    <div class="printPage3x2">
      <v-row no-gutters class="mb-2">
        <v-col cols="12" class="text-center">
            <img
                src="/krut2.jpg"
                class="krut2"
            />
        </v-col>
        <v-col cols="12" class="text-center font17 font-weight-bold">
            คำสั่งวิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="text-center font17 font-weight-bold">
            ที่&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
        </v-col>
        <v-col cols="12" class="text-center font17 font-weight-bold">
            เรื่อง แต่งตั้ง คณะกรรมการตรวจรับพัสดุ สำหรับจัด{{disburse.disburseSubtype}}<span class="font17 font-weight-bold" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span><span class="font17 font-weight-bold" v-if="disburse.disburseType=='ค่าใช้จ่าย'"> {{ subDepartment(disburse.departmentName) }}</span><span class="font17 font-weight-bold" v-if="disburse.disburseType=='โครงการ'"><br>{{ disburse.projectName }} {{ subDepartment(disburse.pjdepartmentName) }}</span> จำนวน {{ disburselists.length }} รายการ 
<br>โดยวิธีเฉพาะเจาะจง
        </v-col>
        <v-col cols="12" class="pt-3 font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;ด้วยวิทยาลัยเทคนิคแพร่ มีความประสงค์จะ{{disburse.disburseSubtype}}<span class="font17" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span><span class="font17" v-if="disburse.disburseType=='ค่าใช้จ่าย'"> {{ subDepartment(disburse.departmentName) }}</span><span class="font17" v-if="disburse.disburseType=='โครงการ'"> {{ disburse.projectName }} {{ subDepartment(disburse.pjdepartmentName) }}</span> จำนวน {{ disburselists.length }} รายการ โดยวิธีเฉพาะเจาะจง และเพื่อให้เป็นไปตามระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 จึงขอแต่งตั้งรายชื่อต่อไปนี้เป็น คณะกรรมการตรวจรับพัสดุสำหรับ{{disburse.disburseSubtype}}<span class="font17" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span><span class="font17" v-if="disburse.disburseType=='ค่าใช้จ่าย'"> {{ subDepartment(disburse.departmentName) }}</span><span class="font17" v-if="disburse.disburseType=='โครงการ'"> {{ disburse.projectName }} {{ subDepartment(disburse.pjdepartmentName) }}</span> จำนวน {{ disburselists.length }} รายการ โดยวิธีเฉพาะเจาะจง
        </v-col>
        <v-col cols="12" class="pt-1 font17">
            &emsp;&emsp;&emsp;&emsp;&emsp;1. {{ disburse.disburseAuditHead }}&emsp;&emsp;&emsp;&emsp;&emsp;ประธานกรรมการฯ<br>
            &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;{{ disburse.disburseAuditHeadPos }}
        </v-col>
        <v-col cols="12" class="pt-1 font17">
            &emsp;&emsp;&emsp;&emsp;&emsp;2. {{ disburse.disburseAuditComm }}&emsp;&emsp;&emsp;&emsp;&emsp;กรรมการ<br>
            &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;{{ disburse.disburseAuditCommPos }}
        </v-col>
        <v-col cols="12" class="pt-1 font17">
            &emsp;&emsp;&emsp;&emsp;&emsp;3. {{ disburse.disburseAuditSecr }}&emsp;&emsp;&emsp;&emsp;&emsp;กรรมการและเลขานุการ<br>
            &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;{{ disburse.disburseAuditSecrPos }}
        </v-col>
        <v-col cols="12" class="pt-2 font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;อำนาจและหน้าที่<br>
          &emsp;&emsp;&emsp;&emsp;&emsp;ทำการตรวจรับพัสดุให้เป็นไปตามเงื่อนไขของสัญญาหรือข้อตกลงนั้น
        </v-col>
        <v-col cols="6" class="mb-5 pt-5 font17 ml-auto">
            สั่ง ณ วันที่ {{  thaiDate(disburse.recDate) }}
        </v-col>
        <v-col cols="8"  class="mt-10 ml-auto text-center font17">
          ({{ directorName }})<br>
          ผู้อำนวยการวิทยาลัยเทคนิคแพร่
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
        formDate: []
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
