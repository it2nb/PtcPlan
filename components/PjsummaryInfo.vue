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
        <div class="mb-2 fontBold">1. ที่มาและความสำคัญ</div>
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
        <v-row v-if="imageNames.length > 0">
          <v-col cols="6" md="3" v-for="imageName in imageNames" :key="imageName.key">
            <v-img :src="imagePath+imageName"></v-img>
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
    }
  },

  methods: {
    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    }
  }
}
</script>
