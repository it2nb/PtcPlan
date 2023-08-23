<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขกิจกรรมย่อย</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updatePjsubactivity"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">กิจกรรมหลักที่ {{ pjsubactivity.pjactivityNum }} {{ pjsubactivity.pjactivityName }}</h3>
          </v-col>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">กิจกรรมย่อยที่</h3>
            <v-text-field
              v-model="updateData.pjsubactivityNum"
              label="กิจกรรมย่อยที่"
              type="number"
              outlined
              dense
              :rules="[
                () => !!updateData.pjsubactivityNum || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="10">
            <h3 class="mb-2 fontBold">ชื่อกิจกรรมย่อย</h3>
            <v-text-field
              v-model="updateData.pjsubactivityName"
              label="ชื่อกิจกรรมย่อย"
              outlined
              dense
              :rules="[
                () => !!updateData.pjsubactivityName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">เริ่ม</h3>
            <v-text-field
              v-model="updateData.pjsubactivityStart"
              type="date"
              label="เริ่ม"
              locale="th-TH"
              outlined
              dense
              persistent-hint
              :hint="thaiDate(updateData.pjsubactivityStart)"
              :rules="[
                () => !!updateData.pjsubactivityStart || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">สิ้นสุด</h3>
            <v-text-field
              v-model="updateData.pjsubactivityEnd"
              type="date"
              label="เริ่ม"
              locale="th-TH"
              outlined
              dense
              persistent-hint
              :hint="thaiDate(updateData.pjsubactivityEnd)"
              :rules="[
                () => !!updateData.pjsubactivityEnd || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
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
    pjsubactivity: {
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
    if(this.pjsubactivity) {
      this.updateData = JSON.parse(JSON.stringify(this.pjsubactivity))
    }
  },

  methods: {
    async updatePjsubactivity() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        let result = await this.$axios.$post('pjsubactivity.update.php', this.updateData)

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
    async pjsubactivity() {
      if(this.pjsubactivity) {
        this.updateData = JSON.parse(JSON.stringify(this.pjsubactivity))
      }
    }
  }
}
</script>
