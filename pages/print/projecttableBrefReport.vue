<template>
  <div style="line-height: 1.8">
    <div class="printPageLand">
      <v-row class="mb-2">
        <v-col class="text-center font18 fontBold">
          รายละเอียดแผนงาน/โครงการ (ย่อ)<br>
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
            <th width="23%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">โครงการ/ผู้รับผิดชอบ</th>
            <!-- <th width="15%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ผู้เสนอโครงการ</th> -->
            <th width="17%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">วัตถุประสงค์</th>
            <th width="16%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">กิจกรรม</th>
            <th width="16%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">เป้าหมาย</th>
            <th width="16%" class="pa-2 font16 fontBold" style="border: solid 1px black; padding: 3px">ตัวชี้วัด</th>
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
                <span v-if="project.projectStatus!='อนุมัติ'">
                  <i class="font14" v-if="project.projectType=='ในแผน'">โครงการตามยุทธศาสตร์</i>
                  <i class="font14" v-if="project.projectType=='เข้าแผน'">โครงการเสนอเข้าแผน</i>
                  <i class="font14" v-if="project.projectType=='เพิ่มเติม'">โครงการเพิ่มเติม</i><br>
                </span>
                {{ project.departmentName }}<br>
                ฝ่าย{{ project.partyName }}
              </p>
            </td>
            <!-- <td class="text-left font16" style="border: solid 1px black; padding: 3px">
              {{ project.departmentName }}<br>
              ฝ่าย{{ project.partyName }}
            </td> -->
            <td class="text-left font14" style="border: solid 1px black; padding: 3px; vertical-align: top;"><pre class="font14">{{ project.projectObjective }}</pre></td>
            <td class="text-left font14" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              <div v-for="pjactivity in pjactivities.filter((act)=> act.projectID==project.projectID)" :key="pjactivity.key">
                <u class="font14">{{pjactivity.pjactivityNum}}. {{ pjactivity.pjactivityName}}</u>
                <div v-for="pjsubactivity in pjactivity.pjsubactivity" :key="pjsubactivity.key" class="pl-2 font14">
                  {{pjactivity.pjactivityNum}}.{{pjsubactivity.pjsubactivityNum}} {{ pjsubactivity.pjsubactivityName}}
                </div>
              </div>
            </td>
            <td class="text-left font14" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              <u class="font14">เชิงปริมาณ</u>
              <pre class="font14">{{ project.projectQuantityGoal }}</pre>
              <u class="font14">เชิงคุณภาพ</u>
              <pre class="font14">{{ project.projectQualityGoal }}</pre>
            </td>
            <td class="text-left font14" style="border: solid 1px black; padding: 3px; vertical-align: top;">
              <u class="font14">เชิงปริมาณ</u>
              <pre class="font14">{{ project.projectQuantityKpi }}</pre>
              <u class="font14">เชิงคุณภาพ</u>
              <pre class="font14">{{ project.projectQualityKpi }}</pre>
            </td>
            <td class="text-right text-on-wrap font14" style="border: solid 1px black; padding: 3px; vertical-align: top;">{{ moneyFormat(project.pjbudgetMoney) }}</td>
          </tr>
          <tr class="grey lighten-2">
            <td colspan="3" class="pa-2 text-center font14 fontBold" style="border: solid 1px black; padding: 3px">
              รวม ยุทธศาสตร์ที่ {{ orgstrategic.orgstrategicNum }} จำนวน {{ orgstrategic.projectQty }} โครงการ
            </td>
            <td colspan="4" class="pa-2 text-center font14 fontBold" style="border: solid 1px black; padding: 3px">
             {{ moneyFormat(orgstrategic.pjbudgetMoney) }} บาท
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
      status: null,
    }
  },

  async mounted() {
    this.periodYear = this.$route.query.year
    this.status = this.$route.query.status
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
