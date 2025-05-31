<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลปีงบประมาณ</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updatePeriod"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">ปีงบประมาณ</h3>
            <v-text-field
              v-model="updateData.periodYear"
              label="ปีงบประมาณ"
              type="number"
              outlined
              required
              :rules="[
                ()=>!!updateData.periodYear || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="5">
            <h3 class="mb-2 fontBold">วันเริ่มปีงบประมาณ</h3>
            <v-text-field
              v-model="updateData.periodBegin"
              label="วันเริ่มปีงบประมาณ"
              type="date"
              :hint="thaiDate(updateData.periodBegin)"
              persistent-hint
              outlined
              required
              :rules="[
                ()=>!!updateData.periodBegin || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="5">
            <h3 class="mb-2 fontBold">วันสิ้นสุดปีงบประมาณ</h3>
            <v-text-field
              v-model="updateData.periodEnd"
              label="วันสิ้นสุดปีงบประมาณ"
              type="date"
              :hint="thaiDate(updateData.periodEnd)"
              persistent-hint
              outlined
              required
              :rules="[
                ()=>!!updateData.periodEnd || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="5">
            <h3 class="mb-2 fontBold">วันเริ่มเสนอโครงการ</h3>
            <v-text-field
              v-model="updateData.periodProjectStart"
              label="วันเริ่มเสนอโครงการ"
              type="date"
              :hint="thaiDate(updateData.periodProjectStart)"
              persistent-hint
              outlined
              required
              :rules="[
                ()=>!!updateData.periodProjectStart || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="5">
            <h3 class="mb-2 fontBold">วันสิ้นสุดเสนอโครงการ</h3>
            <v-text-field
              v-model="updateData.periodProjectEnd"
              label="วันสิ้นสุดเสนอโครงการ"
              type="date"
              :hint="thaiDate(updateData.periodProjectEnd)"
              persistent-hint
              outlined
              required
              :rules="[
                ()=>!!updateData.periodProjectEnd || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">สถานะ</h3>
            <v-switch
              v-model="updateData.periodEnable"
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
            @click="cancelUpdate"
            outlined
          >
            ยกเลิก
          </v-btn>
          <v-progress-circular
            indeterminate
            color="success"
            v-if="updateProgress"
          ></v-progress-circular>
          <v-btn
            type="submit"
            color="warning darken-1"
            large
            v-else
          >
            แก้ไข
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
      updateData: {},
      updateProgress: false,
      updateValidate: null,
    }
  },

  async mounted() {
    if(this.period) {
      this.updateData = JSON.parse(JSON.stringify(this.period))
      this.updateData.periodYear = parseInt(this.updateData.periodYear)+543
    }
  },

  methods: {
    async updatePeriod() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        this.updateData.periodYear = parseInt(this.updateData.periodYear)-543


        let result = await this.$axios.$post('period.update.php', this.updateData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.updateProgress = false
            this.$emit('getUpdateStatus', {'status': true})
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.updateProgress = false
            this.$emit('getUpdateStatus', {'status': true})
          })
        }
      }
    },

    cancelUpdate() {
      this.$emit('getUpdateStatus', {'status': true})
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
        this.updateData = JSON.parse(JSON.stringify(this.period))
        this.updateData.periodYear = parseInt(this.updateData.periodYear)+543
      }
    }
  }
}
</script>
