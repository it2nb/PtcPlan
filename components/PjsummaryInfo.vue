<template>
  <div>
    <v-row>
      <v-col cols="12" class="text-center">
        <h3 class="fontBold">{{ project.projectName }}</h3>
      </v-col>
      <v-col cols="12" md="6" class="text-center">
        <b>ฝ่าย</b> {{project.partyName}}
      </v-col>
      <v-col cols="12" md="6" class="text-center">
        <b>แผนก/งาน</b> {{project.departmentName}}
      </v-col>
      <v-col cols="12">
        <div class="mb-2 fontBold">1. หลักการและเหตุผล</div>
        <pre class="fontPrompt ml-5">{{ project.projectPrinciple }}</pre>
      </v-col>
      <v-col cols="12">
        <div class="mb-2 fontBold">2. วัตถุประสงค์</div>
        <pre class="fontPrompt ml-5">{{ project.projectObjective }}</pre>
      </v-col>
      <v-col cols="12">
        <div class="mb-2 fontBold">3. งบประมาณ</div>
        <pre class="fontPrompt ml-5">{{ moneyFormat(project.pjbudgetMoney) }} บาท</pre>
      </v-col>
      <v-col cols="12">
        <div class="mb-2 fontBold">4. ผลการดำเนินงาน/กิจกรรม</div>
        <div class="ml-5">
          <div class="mb-2 fontBold">4.1 เชิงปริมาณ</div>
          <pre class="fontPrompt ml-5">{{ project.pjsummaryQtyResult }}</pre>
        </div>
        <div class="ml-5">
          <div class="mb-2 fontBold">4.2 เชิงคุณภาพ</div>
          <pre class="fontPrompt ml-5">{{ project.pjsummaryQlyResult }}</pre>
        </div>
        <div class="ml-5">
          <div class="mb-2 fontBold">4.3 ผลกระทบ</div>
          <pre class="fontPrompt ml-5">{{ project.pjsummaryImpact }}</pre>
        </div>
        <div class="ml-5">
          <div class="mb-2 fontBold">4.4 ผลการประเมินความประสิทธิภาพหรือความพึงพอใจ</div>
          <pre class="fontPrompt ml-5">{{ project.pjsummarySatisfaction }}</pre>
        </div>
      </v-col>
      <v-col cols="12">
        <div class="mb-2 fontBold">5. ปัญหาอุปสรรค</div>
        <pre class="fontPrompt ml-5">{{ project.pjsummaryProblem }}</pre>
      </v-col>
      <v-col cols="12">
        <div class="mb-2 fontBold">6. ข้อเสนอแนะ</div>
        <pre class="fontPrompt ml-5">{{ project.pjsummarySuggestion }}</pre>
      </v-col>
      <v-col cols="12">
        <div class="mb-2 fontBold">7. ภาพการดำเนินโครงการ</div>
        <div class="ml-5 mb-2 fontBold font18">ภาพขั้นตอนการวางแผน (P)</div>
        <v-row  class="pl-5" v-if="imagePNames.length > 0">
          <v-col cols="6" class="text-center" v-for="imageName in imagePNames" :key="imageName.key">
            <img :src="imagePPath+imageName" width="100%">
          </v-col>
        </v-row>
        <pre class="mb-2 pl-8 font18">{{ project.pjsummaryPlan }}</pre>
        <div class="ml-5 mb-2 fontBold font18">ภาพขั้นตอนการปฏิบัติ (D)</div>
        <v-row  class="pl-5" v-if="imageDNames.length > 0">
          <v-col cols="6" class="text-center" v-for="imageName in imageDNames" :key="imageName.key">
            <img :src="imageDPath+imageName" width="100%">
          </v-col>
        </v-row>
        <pre class="mb-2 pl-8 font18">{{ project.pjsummaryDo }}</pre>
        <div class="ml-5 mb-2 fontBold font18">ภาพขั้นตอนการตรวจสอบ (C)</div>
        <v-row  class="pl-5" v-if="imageCNames.length > 0">
          <v-col cols="6" class="text-center" v-for="imageName in imageCNames" :key="imageName.key">
            <img :src="imageCPath+imageName" width="100%">
          </v-col>
        </v-row>
        <pre class="mb-2 pl-8 font18">{{ project.pjsummaryCheck }}</pre>
        <div class="ml-5 mb-2 fontBold font18">ภาพขั้นตอนการปรับปรุง (A)</div>
        <v-row  class="pl-5" v-if="imageANames.length > 0">
          <v-col cols="6" class="text-center" v-for="imageName in imageANames" :key="imageName.key">
            <img :src="imageAPath+imageName" width="100%">
          </v-col>
        </v-row>
        <pre class="mb-2 pl-8 font18">{{ project.pjsummaryCheck }}</pre>
        <div class="ml-5 mb-2 fontBold font18">ภาพบรรยากาศการดำเนินโครงการ</div>
        <v-row class="pl-5" v-if="imageNames.length > 0">
          <v-col cols="6" class="text-center" v-for="imageName in imageNames" :key="imageName.key">
            <img :src="imagePath+imageName" width="100%">
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </div>
</template>
<script>
var numeral = require('numeral')
export default {
  props: {
    project: {
      type: Object,
      default: ()=> {}
    },
    imageNames: {
      type: Array,
      default: ()=> []
    },
    imagePath: {
      type: String,
      default: ''
    },
    imagePNames: {
      type: Array,
      default: ()=> []
    },
    imagePPath: {
      type: String,
      default: ''
    },
    imageDNames: {
      type: Array,
      default: ()=> []
    },
    imageDPath: {
      type: String,
      default: ''
    },
    imageCNames: {
      type: Array,
      default: ()=> []
    },
    imageCPath: {
      type: String,
      default: ''
    },
    imageANames: {
      type: Array,
      default: ()=> []
    },
    imageAPath: {
      type: String,
      default: ''
    }
  },

  methods: {
    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    }
  }
}
</script>
