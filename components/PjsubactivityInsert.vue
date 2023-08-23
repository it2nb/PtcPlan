<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มกิจกรรมย่อย</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertPjsubactivity"
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
              v-model="insertData.pjsubactivityNum"
              label="กิจกรรมย่อยที่"
              type="number"
              outlined
              dense
              :rules="[
                () => !!insertData.pjsubactivityNum || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="10">
            <h3 class="mb-2 fontBold">ชื่อกิจกรรมย่อย</h3>
            <v-text-field
              v-model="insertData.pjsubactivityName"
              label="ชื่อกิจกรรมย่อย"
              outlined
              dense
              :rules="[
                () => !!insertData.pjsubactivityName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">เริ่ม</h3>
            <v-text-field
              v-model="insertData.pjsubactivityStart"
              type="date"
              label="เริ่ม"
              locale="th-TH"
              outlined
              dense
              persistent-hint
              :hint="thaiDate(insertData.pjsubactivityStart)"
              :rules="[
                () => !!insertData.pjsubactivityStart || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">สิ้นสุด</h3>
            <v-text-field
              v-model="insertData.pjsubactivityEnd"
              type="date"
              label="เริ่ม"
              locale="th-TH"
              outlined
              dense
              persistent-hint
              :hint="thaiDate(insertData.pjsubactivityEnd)"
              :rules="[
                () => !!insertData.pjsubactivityEnd || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
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
    pjsubactivity: {
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
    if(this.pjsubactivity) {
      this.insertData = JSON.parse(JSON.stringify(this.pjsubactivity))
    }
  },

  methods: {
    async insertPjsubactivity() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true

        let result = await this.$axios.$post('pjsubactivity.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'pjsubactivityID': result.pjsubactivityID})
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
    async pjsubactivity() {
      if(this.pjsubactivity) {
        this.insertData = JSON.parse(JSON.stringify(this.pjsubactivity))
      }
    }
  }
}
</script>
