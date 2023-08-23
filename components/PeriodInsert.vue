<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มข้อมูลยุทธศาสตร์ของสถานศึกษา</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertPeriod"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">ปีงบประมาณ</h3>
            <v-text-field
              v-model="insertData.periodYear"
              label="ปีงบประมาณ"
              type="number"
              outlined
              required
              :rules="[
                ()=>!!insertData.periodYear || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="5">
            <h3 class="mb-2 fontBold">วันเริ่มปีงบประมาณ</h3>
            <v-text-field
              v-model="insertData.periodBegin"
              label="วันเริ่มปีงบประมาณ"
              type="date"
              :hint="thaiDate(insertData.periodBegin)"
              persistent-hint
              outlined
              required
              :rules="[
                ()=>!!insertData.periodBegin || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="5">
            <h3 class="mb-2 fontBold">วันสิ้นสุดปีงบประมาณ</h3>
            <v-text-field
              v-model="insertData.periodEnd"
              label="วันสิ้นสุดปีงบประมาณ"
              type="date"
              :hint="thaiDate(insertData.periodEnd)"
              persistent-hint
              outlined
              required
              :rules="[
                ()=>!!insertData.periodEnd || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="5">
            <h3 class="mb-2 fontBold">วันเริ่มเสนอโครงการ</h3>
            <v-text-field
              v-model="insertData.periodProjectStart"
              label="วันเริ่มเสนอโครงการ"
              type="date"
              :hint="thaiDate(insertData.periodProjectStart)"
              persistent-hint
              outlined
              required
              :rules="[
                ()=>!!insertData.periodProjectStart || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="5">
            <h3 class="mb-2 fontBold">วันสิ้นสุดเสนอโครงการ</h3>
            <v-text-field
              v-model="insertData.periodProjectEnd"
              label="วันสิ้นสุดเสนอโครงการ"
              type="date"
              :hint="thaiDate(insertData.periodProjectEnd)"
              persistent-hint
              outlined
              required
              :rules="[
                ()=>!!insertData.periodProjectEnd || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">สถานะ</h3>
            <v-switch
              v-model="insertData.periodEnable"
              label="สถานะ"
              true-value="1"
              false-value="0"
              inset
              class="ml-3"
            ></v-switch>
          </v-col>
        </v-row>
      </v-card-text>
      <v-divider class="green lighten-2"></v-divider>
      <v-card-actions>
        <div class="col-12 text-center">
          <v-btn
            @click="cancelInsert"
            outlined
          >
            ยกเลิก
          </v-btn>
          <v-progress-circular
            indeterminate
            color="success"
            v-if="insertProgress"
          ></v-progress-circular>
          <v-btn
            type="submit"
            color="success darken-1"
            large
            v-else
          >
            บันทึก
          </v-btn>
        </div>
      </v-card-actions>
    </v-form>
  </v-card>
</template>

<script>
import Swal from 'sweetalert2'
export default {
  props: {
    period: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      insertData: {},
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.period) {
      this.insertData = JSON.parse(JSON.stringify(this.period))
    }
  },

  methods: {
    async insertPeriod() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        this.insertData.periodYear = parseInt(this.insertData.periodYear)-543
        let result = await this.$axios.$post('period.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'periodYear': result.periodYear})
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true})
          })
        }
      }
    },

    cancelInsert() {
      this.$emit('getInsertStatus', {'status': true})
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
    }

  },

  watch: {
    async period() {
      if(this.period) {
        this.insertData = JSON.parse(JSON.stringify(this.period))
      }
    }
  }
}
</script>
