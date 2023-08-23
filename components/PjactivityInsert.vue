<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มกิจกรรมหลัก</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertPjactivity"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">กิจกรรมหลักที่</h3>
            <v-text-field
              v-model="insertData.pjactivityNum"
              label="กิจกรรมหลักที่"
              type="number"
              outlined
              dense
              :rules="[
                () => !!insertData.pjactivityNum || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="10">
            <h3 class="mb-2 fontBold">ชื่อกิจกรรมหลัก</h3>
            <v-text-field
              v-model="insertData.pjactivityName"
              label="ชื่อกิจกรรมหลัก"
              outlined
              dense
              :rules="[
                () => !!insertData.pjactivityName || 'กรุณากรอกข้อมูล'
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
    pjactivity: {
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
    if(this.pjactivity) {
      this.insertData = JSON.parse(JSON.stringify(this.pjactivity))
    }
  },

  methods: {
    async insertPjactivity() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true

        let result = await this.$axios.$post('pjactivity.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'pjactivityID': result.pjactivityID})
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
    }

  },

  watch: {
    async pjactivity() {
      if(this.pjactivity) {
        this.insertData = JSON.parse(JSON.stringify(this.pjactivity))
      }
    }
  }
}
</script>
