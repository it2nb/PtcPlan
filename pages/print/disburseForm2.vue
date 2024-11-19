<template>
  <div style="line-height: 1.8">
    <div class="printPage3x2">
      <v-row no-gutters class="mb-2">
        <v-col cols="12" align-self="end" class="text-center font19 font-weight-bold">
            ใบเบิกเงิน{{ disburse.budgettypeName }} ({{ disburse.budgetplanDes }})
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
              <!-- <tr v-for="disburselist, index in disburselists" :key="disburselist.key">
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
              </tr> -->

              <tr>
                <td></td>
                <td class="font17">
                  {{ disburse.disburseType=='โครงการ'? subDepartment(disburse.pjdepartmentName) : subDepartment(disburse.departmentName) }}
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
                  กับ {{ disburse.companyName }}
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
        <v-col cols="6" class="mt-3 font17">
          ได้ตรวจรายการจ่ายและใบสำคัญที่ขอเบิกมานี้<br>
          รวม .................................ฉบับ เห็นถูกต้องแล้ว<br>
          <div class="mt-2 font17">........................................ เจ้าหน้าที่</div>
          (........................................)<br>
          <div class="mt-2 font17">........................................รองผู้อำนวยการวิทยาลัย</div>
          ({{ dedirectorName }})
        </v-col>
        <v-col cols="6" class="mt-3 font17">
          ขอรับรองว่า การเบิกเงินตามรายการข้างต้นนี้ ได้ดำเนินการตามระเบียบกระทรวงการคลัง ว่าด้วยการจัดซื้อจัดจ้าง และการบริหารพัสดุภาครัฐ พ.ศ.2560 โดยวิธีเฉพาะเจาะจง เป็นการถูกต้องตามระเบียบแล้ว <br>
          <div class="mt-2 font17">........................................ผู้เบิก</div>
          ({{ disburse.disburseParcHead }})
        </v-col>
        <v-col cols="6" class="mt-3 font17">
          <b class="font17 font-weight-bold">อนุมัติจ่ายได้</b><br>
          <div class="mt-3 font17">........................................ผู้อำนวยการวิทยาลัย</div>
          ({{ directorName }})<br>
          วันที่……….เดือน………………….พ.ศ…………
        </v-col>
        <v-col cols="6" class="mt-3 font17">
          <br>
          ........................................จ่ายเงิน<br>
          ({{ disburse.disburseFinaHead }})<br>
          วันที่……….เดือน………………….พ.ศ…………
        </v-col>
        <v-col cols="6" class="mt-3 font17">
          ได้รับเงิน<br>
          (………………………………………)<br>
          ไว้ถูกต้องแล้ว<br>
          <div class="mt-2 font17">(……………………………………………) ผู้รับเงิน</div>
          (……………………………………………)<br>
          วันที่…………เดือน…………………พ.ศ…………
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
        parcelName: null,
        financeName: null,
        dedirectorName: null,
        directorName: null,
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
