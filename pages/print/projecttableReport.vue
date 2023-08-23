<template>
  <div style="line-height: 1.8">
    <div class="printPage">
      <v-row class="mb-2">
        <v-col class="text-center font18 fontBold">
          แผนงาน/โครงการ<br>
          วิทยาลัยเทคนิคแพร่ ประจำปีงบประมาณ พ.ศ. {{ parseInt(periodYear)+543 }}<br>
          จำนวนทั้งสิ้น {{ projectSum.projectQty }} โครงการ &emsp; งบประมาณ {{ moneyFormat(projectSum.pjbudgetMoney) }} บาท
        </v-col>
      </v-row>
      <table width="100%" style="border: solid 1px black; border-spacing: 0;" v-for="orgstrategic in orgstrategics" :key="orgstrategic.orgstrategicID">
        <thead>
          <tr class="grey lighten-2">
            <th width="2%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ลำดับ</th>
            <th width="35%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">โครงการ</th>
            <th width="30%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ผู้เสนอโครงการ</th>
            <th width="13%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">งบประมาณ</th>
            <!-- <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">สถานะ</th>
            <th class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ความก้าวหน้า</th> -->
          </tr>
          <tr>
            <th colspan="6" class="pa-2 text-left font16 fontBold" style="border: solid 1px black; padding: 3px">
              ยุทธศาสตร์ที่ {{ orgstrategic.orgstrategicNum }} {{ orgstrategic.orgstrategicName }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="project in orgstrategic.projects" :key="project.projectID">
            <td class="text-center font16" style="border: solid 1px black; padding: 3px">{{ orgstrategic.projects.indexOf(project)+1 }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px">{{ project.projectName }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px">
              {{ project.personalName }} {{ project.personalSer }}<br>
              {{ project.departmentName }}<br>
              ฝ่าย{{ project.partyName }}
            </td>
            <td class="text-right text-on-wrap font16" style="border: solid 1px black; padding: 3px">{{ moneyFormat(project.pjbudgetMoney) }}</td>
            <!-- <td class="text-left font16" style="border: solid 1px black; padding: 3px">{{ project.projectStatus }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px">{{ project.projectProgress }}</td> -->
          </tr>
          <tr class="grey lighten-2">
            <td colspan="3" class="pa-2 text-center font16 fontBold" style="border: solid 1px black; padding: 3px">
              รวม ยุทธศาสตร์ที่ {{ orgstrategic.orgstrategicNum }} จำนวน {{ orgstrategic.projectQty }} โครงการ
            </td>
            <td class="pa-2 text-center font16 fontBold" style="border: solid 1px black; padding: 3px">
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
    }
  },

  async mounted() {
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
    size: A4;
  }
</style>
