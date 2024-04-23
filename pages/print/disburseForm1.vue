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
        <v-col cols="8" align-self="end" class="text-center font26 font-weight-bold">
            บันทึกข้อความ
        </v-col>
        <v-col cols="12" class="font18">
            ส่วนราชการ &emsp; {{ disburse.departmentName }} ฝ่าย{{ disburse.partyName}}
        </v-col>
        <v-col cols="6" class="font18">
            ที่&emsp;&emsp;&emsp;&emsp;&emsp;/{{ parseInt(formDate[0])+543 }}
        </v-col>
        <v-col cols="6" class="font18">
            วันที่ {{  thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="12" class="font18">
          เรื่อง ขออนุญาตดำเนินการและขออนุมัติค่าใช้จ่าย
        </v-col>
        <v-col cols="12" class="pt-2 font18">
          เรียน ผู้อำนวยการวิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="pt-2 font18">
          สิ่งที่ส่งมาด้วย แบบโครงการและประมาณการค่าใช้จ่าย
        </v-col>
        <v-col cols="12" class="pt-2 font18">
          &emsp;&emsp;&emsp;&emsp;&emsp;ด้วย{{ disburse.departmentName }} มีความประสงค์จะจัดซื้อ{{ disburse.disburseType=='โครงการ'? disburse.expenseName : disburse.expenseplanDes }} เพื่อ{{ disburse.disburseDes }} {{ disburse.disburseType=='โครงการ'? 'ตาม'+disburse.projectName : '' }} จำนวน {{ disburselists.length }} รายการ โดยมีค่าใช้จ่ายเป็นเงินจำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท  ({{ thaiBaht(disburse.disburseMoney) }})
        </v-col>
        <v-col cols="12" class="pt-2 font18">
          &emsp;&emsp;&emsp;&emsp;&emsp;ดังนั้น เพื่อให้การดำเนินงานเป็นไปด้วยความเรียบร้อย จึงขออนุญาตดำเนินการและขออนุมัติงบประมาณเป็นเงินจำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท  ({{ thaiBaht(disburse.disburseMoney) }}) เพื่อใช้จ่ายตามแบบโครงการและประมาณการค่าใช้จ่ายที่แนบท้าย
        </v-col>
        <v-col cols="12" class="pt-2 font18">
          &emsp;&emsp;&emsp;&emsp;&emsp;จึงเรียนมาเพื่อโปรด<br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;1. ทราบ <br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;2. พิจารณาอนุญาตดำเนินการ <br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;3. อนุมัติค่าใช้จ่ายตามโครงการ 
        </v-col>
        <v-col cols="12" class="mt-10 pt-5">
          <v-row no-gutters>
            <v-col align-self="start" class="text-center font18">
              <!-- <img :src="departmentSignature" width="150" v-if="departmentSignature && (project.departmentSignName==disburse.departmentHead)" /><br> -->
              ({{ disburse.disburseReqName }})<br>
              หัวหน้างาน{{ disburse.departmentName }}
            </v-col>
            <v-col align-self="start" class="text-center font18">
              ({{ disburse.departmentHead }})<br>
              ผู้รับผิดชอบโครงการ
            </v-col>
            <v-col align-self="start" class="text-center font18">
              ({{ disburse.partyHead }})<br>
              รองผู้อำนวยการฝ่าย{{ disburse.partyName }}
            </v-col>
          </v-row>
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
        disburseID: null,
        disburse: {},
        disburselists: [],
        formDate: [] 
    }
  },

  async mounted() {
    this.disburseID = this.$route.query.id
    console.log(sessionStorage.getItem('loginuser'))
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
