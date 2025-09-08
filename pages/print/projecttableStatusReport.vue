<template>
  <div style="line-height: 1.8">
    <div class="printPageLand">
      <v-row class="mb-2">
        <v-col class="text-center font18 fontBold">
          สถานะการดำเนินงานแผนงาน/โครงการ<br>
          แผนปฏิบัติราชการ ประจำปีงบประมาณ พ.ศ. {{ parseInt(periodYear)+543 }} ( วิทยาลัยเทคนิคแพร่ )<br>
          {{ status }}จำนวนทั้งสิ้น
          <span class="font18 fontBold" v-if="status=='เสนอโครงการ'">{{ projectSum.projectWaitApproveQty }} </span>
          <span class="font18 fontBold" v-else-if="status=='ฝ่ายเห็นชอบ'">{{ projectSum.projectParQty }} </span>
          <span class="font18 fontBold" v-else-if="status=='อนุมัติ'">{{ projectSum.projectApproveQty }} </span>
          <span class="font18 fontBold" v-else>{{ projectSum.projectQty }} </span>
          โครงการ &emsp; งบประมาณ
          <span class="font18 fontBold" v-if="status=='เสนอโครงการ'">{{ moneyFormat(projectSum.pjbudgetWaitApproveMoney) }} </span>
          <span class="font18 fontBold" v-else-if="status=='ฝ่ายเห็นชอบ'">{{ moneyFormat(projectSum.pjbudgetParApproveMoney) }} </span>
          <span class="font18 fontBold" v-else-if="status=='อนุมัติ'">{{ moneyFormat(projectSum.pjbudgetApproveMoney) }} </span>
          <span class="font18 fontBold" v-else>{{ moneyFormat(projectSum.pjbudgetMoney) }} </span>
          บาท
        </v-col>
      </v-row>
      <table width="100%" style="border: solid 1px black; border-spacing: 0;" v-for="orgstrategic in orgstrategics" :key="orgstrategic.orgstrategicID">
        <thead>
          <tr class="grey lighten-2">
            <th width="2%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ลำดับ</th>
            <th width="25%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">โครงการ</th>
            <th width="20%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ผู้รับผิดชอบโครงการ</th>
            <th width="10%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">งบประมาณ</th>
            <th width="10%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">เบิกจ่าย</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">การอนุมัติ</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">การดำเนินกิจกรรม</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">การรายงานผล</th>
          </tr>
          <tr>
            <th colspan="8" class="pa-2 text-left font16 fontBold" style="border: solid 1px black; padding: 3px">
              ยุทธศาสตร์ที่ {{ orgstrategic.orgstrategicNum }} {{ orgstrategic.orgstrategicName }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="project in orgstrategic.projects" :key="project.projectID" v-if="project.projectStatus!='ไม่ผ่าน'">
            <td class="text-center font16" style="border: solid 1px black; padding: 3px; vertical-align: top;">{{ orgstrategic.projects.indexOf(project)+1 }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px; vertical-align: top;">{{ project.projectName }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              {{ project.departmentName }}<br>
              ฝ่าย{{ project.partyName }}
            </td>
            <td class="text-right text-on-wrap font16" style="border: solid 1px black; padding: 3px; vertical-align: top;">{{ moneyFormat(project.pjbudgetMoney) }}</td>
            <td class="text-right text-on-wrap font16" style="border: solid 1px black; padding: 3px; vertical-align: top;">{{ moneyFormat(project.disburseMoney) }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px; vertical-align: top;">{{ project.projectStatus }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px; vertical-align: top;">{{ project.projectProgress }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              <span v-if="project.projectProgress=='ดำเนินการเสร็จสิ้น'">
                <span class="text-left font16" v-if="project.projectReport=='ไม่รายงาน' || (project.projectReport=='ครบถ้วน' && (project.imageQty>=2 || (project.imagePQty>=2 && project.imageDQty>=2 && project.imageCQty>=2 && project.imageAQty>=2)))">
                  {{ project.projectReport }}
                </span>
                <span class="text-left font16" v-else>
                  เข้ารายงาน
                </span>
              </span>
            </td>
          </tr>
          <tr class="grey lighten-2">
            <td colspan="3" class="pa-2 text-center font16 fontBold" style="border: solid 1px black; padding: 3px">
              รวม ยุทธศาสตร์ที่ {{ orgstrategic.orgstrategicNum }} จำนวน {{ orgstrategic.projectQty }} โครงการ
            </td>
            <td colspan="5" class="pa-2 text-center font16 fontBold" style="border: solid 1px black; padding: 3px">
             {{ moneyFormat(orgstrategic.pjbudgetMoney) }} บาท
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
      periodYear: null,
      partyID: null,
      departmentID: null,
      party: {},
      department: {},
      orgstrategics: [],
      projectSum: {},
      status: null,
    }
  },

  async mounted() {
    this.status = this.$route.query.status
    this.periodYear = this.$route.query.year
    this.partyID = this.$route.query.paid
    this.departmentID = this.$route.query.dpid
    await this.getOrgstartegics()
    await this.getSummary()
  },

  methods: {
    async getOrgstartegics() {
      let params = {
        token: this.$store.state.jwtToken,
        orgstrategicYear: this.periodYear,
        projectStatus: this.status,
        fn: 'getProductListAll'
      }
      let result = await this.$axios.$get('orgstrategic.php', { params})

      if(result.message === 'Success') {
        this.orgstrategics = JSON.parse(JSON.stringify(result.orgstrategic))
      }
    },

    async getSummary() {
      let params = {
        token: this.$store.state.jwtToken,
        projectYear: this.periodYear,
        fn: 'getSummaryByYear'
      }
      let result = await this.$axios.$get('project.php', {
        params: params
      })
      if(result.message == 'Success') {
        this.projectSum = JSON.parse(JSON.stringify(result.project))
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
