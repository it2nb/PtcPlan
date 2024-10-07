<template>
  <div style="line-height: 1.8">
    <div class="printPageLand">
      <v-row class="mb-2">
        <v-col class="text-center font18 fontBold">
          สรุปผลการดำเนินงานแผนงาน/โครงการ<br>
          แผนปฏิบัติราชการ ประจำปีงบประมาณ พ.ศ. {{ parseInt(periodYear)+543 }} ( วิทยาลัยเทคนิคแพร่ )<br>
          ดำเนินการเสร็จสิ้นแล้วจำนวน
          <span class="font18 fontBold">{{ projectSum.projectDoneProgressQty }} </span>
          โครงการ &emsp; งบประมาณ
          <span class="font18 fontBold">{{ moneyFormat(projectSum.disburseDoneProgressMoney) }} </span>
          บาท
        </v-col>
      </v-row>
      <table width="100%" style="border: solid 1px black; border-spacing: 0;" v-for="orgstrategic in orgstrategics" :key="orgstrategic.orgstrategicID">
        <thead>
          <tr class="grey lighten-2">
            <th width="2%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ลำดับ</th>
            <th width="23%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">โครงการ/ผู้รับผิดชอบ</th>
            <!-- <th width="15%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ผู้เสนอโครงการ</th> -->
            <th width="16%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">วัตถุประสงค์</th>
            <!-- <th width="16%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">กิจกรรม</th> -->
            <th width="16%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">เป้าหมาย/ตัวชี้วัด</th>
            <th width="17%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ผลการดำเนินงาน</th>
            <th width="16%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ปัญหาอุปสรรค/<br>ข้อเสนอแนะ</th>
            <th width="10%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">งบประมาณ</th>
          </tr>
          <tr>
            <th colspan="8" class="pa-2 text-left font16 fontBold" style="border: solid 1px black; padding: 3px">
              ยุทธศาสตร์ที่ {{ orgstrategic.orgstrategicNum }} {{ orgstrategic.orgstrategicName }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="project in orgstrategic.projects" :key="project.projectID">
            <td class="text-center font14" style="border: solid 1px black; padding: 3px; vertical-align: top;">{{ orgstrategic.projects.indexOf(project)+1 }}</td>
            <td class="text-left font16" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              {{ project.projectName }}
              <v-divider class="my-2"></v-divider>
              <p class="font14">
                <!-- <span>
                  <i class="font14" v-if="project.projectType=='ในแผน'">โครงการตามยุทธศาสตร์</i>
                  <i class="font14" v-if="project.projectType=='เข้าแผน'">โครงการเสนอเข้าแผน</i>
                  <i class="font14" v-if="project.projectType=='เพิ่มเติม'">โครงการเพิ่มเติม</i><br>
                </span> -->
                {{ project.departmentName }}<br>
                ฝ่าย{{ project.partyName }}
              </p>
            </td>
            <!-- <td class="text-left font16" style="border: solid 1px black; padding: 3px">
              {{ project.departmentName }}<br>
              ฝ่าย{{ project.partyName }}
            </td> -->
            <td class="text-left font14" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              <b class="font14 fontBold">วัตถุประสงค์</b><br>
              <pre class="font14">{{ project.projectObjective }}</pre>
            </td>
            <!-- <td class="text-left font14" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              <div v-for="pjactivity in pjactivities.filter((act)=> act.projectID==project.projectID)" :key="pjactivity.key">
                <u class="font14">{{pjactivity.pjactivityNum}}. {{ pjactivity.pjactivityName}}</u>
                <div v-for="pjsubactivity in pjactivity.pjsubactivity" :key="pjsubactivity.key" class="pl-2 font14">
                  {{pjactivity.pjactivityNum}}.{{pjsubactivity.pjsubactivityNum}} {{ pjsubactivity.pjsubactivityName}}
                </div>
              </div>
            </td> -->
            <td class="text-left font14" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              <b class="font14 fontBold">เป้าหมาย</b><br>
              <u class="font14">เชิงปริมาณ</u>
              <pre class="font14">{{ project.projectQuantityGoal }}</pre>
              <u class="font14">เชิงคุณภาพ</u>
              <pre class="font14">{{ project.projectQualityGoal }}</pre>
              <v-divider class="my-1"></v-divider>
              <b class="font14 fontBold">ตัวชี้วัด</b><br>
              <u class="font14">เชิงปริมาณ</u>
              <pre class="font14">{{ project.projectQuantityKpi }}</pre>
              <u class="font14">เชิงคุณภาพ</u>
              <pre class="font14">{{ project.projectQualityKpi }}</pre>
            </td>
            <td class="text-left font14" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              <b class="font14 fontBold">ผลการดำเนินงาน</b><br>
              <u class="font14">เชิงปริมาณ</u>
              <pre class="font14" v-if="project.pjsummaryQtyResult">{{ project.pjsummaryQtyResult }}</pre>
              <pre class="font14" v-else>-</pre>
              <u class="font14">เชิงคุณภาพ</u>
              <pre class="font14" v-if="project.pjsummaryQlyResult">{{ project.pjsummaryQlyResult }}</pre>
              <pre class="font14" v-else>-</pre>
              <u class="font14">ผลกระทบ</u>
              <pre class="font14" v-if="project.pjsummaryImpact">{{ project.pjsummaryImpact }}</pre>
              <pre class="font14" v-else>-</pre>
            </td>
            <td class="text-left font14" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              <b class="font14 fontBold">ปัญหาอุปสรรค</b><br>
              <pre class="font14" v-if="project.pjsummaryProblem">{{ project.pjsummaryProblem }}</pre>
              <pre class="font14" v-else>-</pre>
              <v-divider class="my-1"></v-divider>
              <b class="font14 fontBold">ข้อเสนอแนะ</b><br>
              <pre class="font14" v-if="project.pjsummarySuggestion">{{ project.pjsummarySuggestion }}</pre>
              <pre class="font14" v-else>-</pre>
            </td>
            <td class="text-right text-on-wrap font14" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              <b class="font14 fontBold">งบประมาณ</b><br>
              {{ moneyFormat(project.disburseMoney) }}
            </td>
          </tr>
          <tr class="grey lighten-2">
            <td colspan="3" class="pa-2 text-center font14 fontBold" style="border: solid 1px black; padding: 3px">
              รวม ยุทธศาสตร์ที่ {{ orgstrategic.orgstrategicNum }} จำนวน {{ orgstrategic.doneProgress }} โครงการ
            </td>
            <td colspan="4" class="pa-2 text-center font14 fontBold" style="border: solid 1px black; padding: 3px">
             {{ moneyFormat(orgstrategic.doneDisburseMoney) }} บาท
            </td>
          </tr>
        </tbody>
        <tfoot>
          <tr>
            <td colspan="7" class="pt-2 pr-2 text-right">
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
      pjactivities: [],
      projectSum: {},
      status: 'อนุมัติ',
    }
  },

  async mounted() {
    this.periodYear = this.$route.query.year
    this.partyID = this.$route.query.paid
    this.departmentID = this.$route.query.dpid
    await this.getOrgstartegics()
    await this.getPjactivity()
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
        let orgmap = await this.orgstrategics.map(orgstrategic => {
          orgstrategic.projects = orgstrategic.projects.filter(project => project.projectProgress=='ดำเนินการเสร็จสิ้น')
        })

        Promise.all(orgmap)
      }
    },

    async getPjactivity() {
      let params = {
        token: this.$store.state.jwtToken,
        projectYear: this.periodYear
      }
      let result = await this.$axios.$get('pjactivity.php', { params})
      if(result.message === 'Success') {
        this.pjactivities = JSON.parse(JSON.stringify(result.pjactivity))
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
