<template>
  <div>
    <div class="printPage">
      <v-row no-gutters>
        <v-col cols="12" class="printHead text-center">
          แบบสรุปรายงานผลการดำเนินงานตามโครงการ ปีงบประมาณ พ.ศ. {{parseInt(project.projectYear)+543}}
        </v-col>
        <v-col cols="12" class="mt-2 printHead text-center">
          {{ project.projectName }}
        </v-col>
        <v-col cols="12" class="mt-2 text-center font18 fontBold">
          ผู้รับผิดชอบ {{project.departmentName}}
        </v-col>
        <v-col cols="12" class="mt-2 text-center font18 fontBold">
          ฝ่าย{{project.partyName}}&emsp;&emsp;วิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="mt-2"><v-divider class="black"></v-divider></v-col>
        <v-col cols="12" class="mt-5 px-5">
          <div class="mb-2 fontBold font18">1. หลักการและเหตุผล</div>
          <pre class="font18 ml-5">{{ project.projectPrinciple }}</pre>
        </v-col>
        <v-col cols="12" class="mt-3 px-5">
          <div class="mb-2 fontBold font18">2. วัตถุประสงค์</div>
          <pre class="font18 ml-5">{{ project.projectObjective }}</pre>
        </v-col>
        <v-col cols="12" class="mt-3 px-5">
          <div class="mb-2 fontBold font18">3. งบประมาณ</div>
          <pre class="font18 ml-5">{{ moneyFormat(project.disburseMoney) }} บาท</pre>
        </v-col>
        <v-col cols="12" class="mt-3 px-5">
          <div class="mb-2 fontBold font18">4. ผลการดำเนินงาน/กิจกรรม</div>
          <div class="ml-5">
            <div class="mb-2 fontBold font18">4.1 เชิงปริมาณ</div>
            <pre class="font18 ml-5">{{ project.pjsummaryQtyResult }}</pre>
          </div>
          <div class="ml-5">
            <div class="mb-2 fontBold font18">4.2 เชิงคุณภาพ</div>
            <pre class="font18 ml-5">{{ project.pjsummaryQlyResult }}</pre>
          </div>
        </v-col>
        <v-col cols="12" class="mt-3 px-5">
          <div class="mb-2 fontBold font18">5. ประโยชน์ที่คาดว่าจะได้รับ</div>
          <pre class="font18 ml-5">{{ project.projectBenefit }}</pre>
        </v-col>
        <v-col cols="12" class="mt-3 px-5">
          <div class="mb-2 fontBold font18">6. ปัญหาอุปสรรค</div>
          <pre class="font18 ml-5">{{ project.pjsummaryProblem }}</pre>
        </v-col>
        <v-col cols="12" class="mt-3 px-5">
          <div class="mb-2 fontBold font18">7. ข้อเสนอแนะ</div>
          <pre class="font18 ml-5">{{ project.pjsummarySuggestion }}</pre>
        </v-col>
      </v-row>
    </div>
    <div class="printPage">
      <v-row no-gutters>
        <v-col cols="12">
          <div class="mb-2 fontBold font18">7. ภาพการดำเนินโครงการ</div>
          <v-row class="mt-5" v-if="imageNames.length > 0">
            <v-col cols="6" class="text-center" v-for="imageName in imageNames" :key="imageName.key">
              <img :src="imagePath+imageName" width="100%">
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </div>
  </div>
</template>
<script>
var numeral = require('numeral')
export default {
  layout: 'print_layout',
  data() {
    return {
      project: {},
      imageNames: [],
      imagePath: '',
    }
  },

  async mounted() {
    await this.getProject()
  },

  methods: {
    async getProject() {
      let projectID = this.$route.query.id

      let result = await this.$axios.$get('project.php', {
        params: {
          token: this.$store.state.jwtToken,
          projectID: projectID
        }
      })
      if(result.message == 'Success') {
        this.project = JSON.parse(JSON.stringify(result.project))

        if(this.project != false) {
          let result2 = await this.$axios.$get('project.image.php', {
            params: {
              token: this.project.token,
              projectYear: this.project.projectYear,
              projectID: this.project.projectID,
              function: 'projectImageGet'
            }
          })
          if(result2.message == 'Success') {
            this.imageNames = JSON.parse(JSON.stringify(result2.projectImages))
            this.imagePath = result2.projectImagePath
          }
        }
      }
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
