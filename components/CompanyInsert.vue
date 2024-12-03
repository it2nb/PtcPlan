<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มข้อมูลร้านค้า</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertCompany"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
            <v-col cols="12">
            <h3 class="mb-2 fontBold">ชื่อร้านค้า</h3>
            <v-text-field
              v-model="insertData.companyName"
              label="ชื่อร้านค้า"
              outlined
              required
              :rules="[
                ()=>!!insertData.companyName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ที่อยู่</h3>
            <v-text-field
              v-model="insertData.companyAddress"
              label="ที่อยู่"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">เบอร์โทรศัพท์</h3>
            <v-text-field
              v-model="insertData.companyPhone"
              label="เบอร์โทรศัพท์"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">หมายเลขประจำตัวผุ้เสียภาษี</h3>
            <v-text-field
              v-model="insertData.companyTaxID"
              label="หมายเลขประจำตัวผุ้เสียภาษี"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="3">
            <h3 class="mb-2 fontBold">ชื่อเจ้าของ/ผู้จัดการ</h3>
            <v-text-field
              v-model="insertData.companyOwner"
              label="ชื่อเจ้าของ/ผู้จัดการ"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="3">
            <h3 class="mb-2 fontBold">ชื่อตำแหน่ง</h3>
            <v-text-field
              v-model="insertData.companyPosition"
              label="ชื่อตำแหน่ง"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">เลขบัญชีธนาคาร</h3>
            <v-text-field
              v-model="insertData.companyBankNo"
              label="เลขบัญชีธนาคาร"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อบัญชีธนาคาร</h3>
            <v-text-field
              v-model="insertData.companyBankOwner"
              label="ชื่อบัญชีธนาคาร"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อธนาคาร</h3>
            <v-text-field
              v-model="insertData.companyBankName"
              label="ชื่อธนาคาร"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">สถานุะ</h3>
            <v-switch
              v-model="insertData.companyEnable"
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
    company: {
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
    if(this.company) {
      this.insertData = JSON.parse(JSON.stringify(this.company))
    }
  },

  methods: {
    async insertCompany() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        let result = await this.$axios.$post('company.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'companyID': result.companyID})
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
    async company() {
      if(this.company) {
        this.insertData = JSON.parse(JSON.stringify(this.company))
      }
    }
  }
}
</script>
