<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลร้านค้า</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateCompany"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
            <v-col cols="12">
            <h3 class="mb-2 fontBold">ชื่อร้านค้า</h3>
            <v-text-field
              v-model="updateData.companyName"
              label="ชื่อร้านค้า"
              outlined
              required
              :rules="[
                ()=>!!updateData.companyName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ที่อยู่</h3>
            <v-text-field
              v-model="updateData.companyAddress"
              label="ที่อยู่"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">เบอร์โทรศัพท์</h3>
            <v-text-field
              v-model="updateData.companyPhone"
              label="เบอร์โทรศัพท์"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">หมายเลขประจำตัวผุ้เสียภาษี</h3>
            <v-text-field
              v-model="updateData.companyTaxID"
              label="หมายเลขประจำตัวผุ้เสียภาษี"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อเจ้าของ/ผู้จัดการ</h3>
            <v-text-field
              v-model="updateData.companyOwner"
              label="ชื่อเจ้าของ/ผู้จัดการ"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">เลขบัญชีธนาคาร</h3>
            <v-text-field
              v-model="updateData.companyBankNo"
              label="เลขบัญชีธนาคาร"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อบัญชีธนาคาร</h3>
            <v-text-field
              v-model="updateData.companyBankOwner"
              label="ชื่อบัญชีธนาคาร"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อธนาคาร</h3>
            <v-text-field
              v-model="updateData.companyBankName"
              label="ชื่อธนาคาร"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">สถานุะ</h3>
            <v-switch
              v-model="updateData.companyEnable"
              label="สถานะ"
              :true-value="1"
              :false-value="0"
              inset
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
    company: {
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
    if(this.company) {
      this.updateData = JSON.parse(JSON.stringify(this.company))
    }
  },

  methods: {
    async updateCompany() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        let result = await this.$axios.$post('company.update.php', this.updateData)

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
    }

  },

  watch: {
    async company() {
      if(this.company) {
        this.updateData = JSON.parse(JSON.stringify(this.company))
      }
    }
  }
}
</script>
