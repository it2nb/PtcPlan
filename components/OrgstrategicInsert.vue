<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มข้อมูลยุทธศาสตร์ของสถานศึกษา ปีงบประมาณ พ.ศ.{{ parseInt(orgstrategic.orgstrategicYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertOrgstrategic"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">ยุทธศาสตร์ที่</h3>
            <v-text-field
              v-model="insertData.orgstrategicNum"
              label="ยุทธศาสตร์ที่"
              type="number"
              outlined
              required
              :rules="[
                ()=>!!insertData.orgstrategicNum || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="10">
            <h3 class="mb-2 fontBold">ชื่อยุทธศาสตร์</h3>
            <v-text-field
              v-model="insertData.orgstrategicName"
              label="ชื่อยุทธศาสตร์"
              outlined
              required
              :rules="[
                ()=>!!insertData.orgstrategicName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">คำอธิบาย</h3>
            <v-textarea
              v-model="insertData.orgstrategicDetail"
              label="คำอธิบาย"
              outlined
            ></v-textarea>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">สถานุะ</h3>
            <v-switch
              v-model="insertData.orgstrategicEnable"
              label="สถานะ"
              true-value="1"
              false-value="0"
              inset
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
    orgstrategic: {
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
    if(this.orgstrategic) {
      this.insertData = JSON.parse(JSON.stringify(this.orgstrategic))
    }
  },

  methods: {
    async insertOrgstrategic() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        let result = await this.$axios.$post('orgstrategic.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'orgstrategicID': result.orgstrategicID})
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
    async orgstrategic() {
      if(this.orgstrategic) {
        this.insertData = JSON.parse(JSON.stringify(this.orgstrategic))
      }
    }
  }
}
</script>
