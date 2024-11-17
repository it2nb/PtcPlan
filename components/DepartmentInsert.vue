<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มข้อมูลแผนก/งาน</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertDepartment"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
            <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ฝ่าย</h3>
            <v-select
              v-model="insertData.partyID"
              label="ฝ่าย"
              :items="parties"
              item-text="partyName"
              item-value="partyID"
              outlined
              :rules="[
                ()=>!!insertData.partyID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-select>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อแผนก/งาน</h3>
            <v-text-field
              v-model="insertData.departmentName"
              label="ชื่อแผนก/งาน"
              outlined
              required
              :rules="[
                ()=>!!insertData.departmentName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">คำอธิบาย</h3>
            <v-textarea
              v-model="insertData.departmentDetail"
              label="คำอธิบาย"
              outlined
            ></v-textarea>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อ-สกุล หัวหน้าแผนก/งาน</h3>
            <v-text-field
              v-model="insertData.departmentHead"
              label="ชื่อ-สกุล หัวหน้าแผนก/งาน"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">สิทธิ์ของระบบ</h3>
            <v-select
              v-model="insertData.departmentSys"
              label="สิทธิ์ของระบบ"
              :items="departmentSyses"
              outlined
            ></v-select>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">สถานุะ</h3>
            <v-switch
              v-model="insertData.departmentEnable"
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
    department: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
        parties: [],
      insertData: {},
      departmentSyses: [
        {text: 'ไม่มี', value: 'none'},
        {text: 'งานพัสดุ', value: 'Parcel'},
        {text: 'งานวางแผน', value: 'Plan'},
        {text: 'งานบัญชี', value: 'Account'},
        {text: 'งานการเงิน', value: 'Finance'},
        {text: 'งานสารบัญ', value: 'Finance'}
      ],
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.department) {
        await this.getParties()
      this.insertData = JSON.parse(JSON.stringify(this.department))
    }
  },

  methods: {
    async getParties() {
        let result = await this.$axios.$get('party.php', {
            params: {
                token: this.$store.state.jwtToken,
            }
        })
        if(result.message == 'Success') {
            this.parties = JSON.parse(JSON.stringify(result.party))
        }
    },
    async insertDepartment() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        let result = await this.$axios.$post('department.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'departmentID': result.departmentID})
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
    async department() {
      if(this.department) {
        await this.getParties()
        this.insertData = JSON.parse(JSON.stringify(this.department))
      }
    }
  }
}
</script>
