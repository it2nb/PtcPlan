<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มข้อมูลผู้ใช้ระบบ</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertUser"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อผู้ใช้ระบบ</h3>
            <v-text-field
              v-model="insertData.userName"
              label="ชื่อผู้ใช้ระบบ"
              outlined
              required
              :rules="[
                ()=>!!insertData.userName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">รหัสผ่าน</h3>
            <v-text-field
              v-model="insertData.userPassword"
              label="รหัสผ่าน"
              :type="passwordShow ? 'text' : 'password'"
              :append-icon="passwordShow ? 'mdi-eye' : 'mdi-eye-off'"
              outlined
              :rules="[
                ()=>!!insertData.userPassword || 'กรุณากรอกรหัสผ่าน'
              ]"
              @click:append="passwordShow = !passwordShow"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">สถานะ</h3>
            <v-autocomplete
              v-model="insertData.userStatus"
              label="สถานะ"
              :items="userStatuses"
              outlined
              required
              :rules="[
                ()=>!!insertData.userStatus || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">คำอธิบาย</h3>
            <v-text-field
              v-model="insertData.userDes"
              label="คำอธิบาย"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">เลขประจำตัวประชาชน</h3>
            <v-text-field
              v-model="insertData.personalIDcard"
              label="เลขประจำตัวประชาชน"
              outlined
              required
              :rules="[
                ()=>!!insertData.personalIDcard || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6" v-if="insertData.userStatus=='Department'">
            <h3 class="mb-2 fontBold">แผนก/งาน</h3>
            <v-autocomplete
              v-model="insertData.departmentID"
              label="แผนก/งาน"
              :items="departments"
              item-text="departmentName"
              item-value="departmentID"
              outlined
              required
              :rules="[
                ()=>!!insertData.departmentID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6" v-if="insertData.userStatus=='Party'">
            <h3 class="mb-2 fontBold">ฝ่าย</h3>
            <v-autocomplete
              v-model="insertData.partyID"
              label="ฝ่าย"
              :items="parties"
              item-text="partyName"
              item-value="partyID"
              outlined
              required
              :rules="[
                ()=>!!insertData.partyID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">อนุญาตใช้งาน</h3>
            <v-switch
              v-model="insertData.userEnable"
              label="อนุญาตใช้งาน"
              true-value="Enable"
              false-value="Disable"
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
    user: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      insertData: {},
      insertProgress: false,
      insertValidate: null,
      passwordShow: false,
      userStatuses: [
        {'text': 'แผนก/งาน', 'value': 'Department'},
        {'text': 'ฝ่ายบริหาร', 'value': 'Party'},
        {'text': 'งานวางแผนและงบประมาณ', 'value': 'Plan'},
        {'text': 'งานพัสดุ', 'value': 'Supply'},
        {'text': 'งานการเงิน', 'value': 'Finance'},
        {'text': 'งานบัญชี', 'value': 'Accountant'},
        {'text': 'ผู้อำนวยการ', 'value': 'Director'},
        {'text': 'ผู้ดูแลระบบ', 'value': 'Admin'},
      ],
      departments: [],
      parties: [],
    }
  },

  async mounted() {
    if(this.user) {
      this.insertData = JSON.parse(JSON.stringify(this.user))
      await this.getDepartments()
      await this.getParties()
    }
  },

  methods: {
    async getDepartments() {
      let params = {
        token: this.$store.state.jwtToken
      }
      let result = await this.$axios.$get('department.php', {params})
      if(result.message === 'Success') {
        this.departments = JSON.parse(JSON.stringify(result.department))
      }
    },

    async getParties() {
      let params = {
        token: this.$store.state.jwtToken
      }
      let result = await this.$axios.$get('party.php', {params})
      if(result.message === 'Success') {
        this.parties = JSON.parse(JSON.stringify(result.party))
      }
    },

    async insertUser() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        if(this.insertData.userStatus == 'Director') {
          let params = {
            token: this.$store.state.jwtToken,
            partyName: 'อำนวยการ'
          }
          let partry = await this.$axios.$get('party.php', {params})
          if(partry.message == 'Success') {
            let bossparty = JSON.parse(JSON.stringify(partry.party))
            this.insertData.partyID = bossparty.partyID
          }
        }
        let result = await this.$axios.$post('user.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'userID': result.userID})
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
    async user() {
      if(this.user) {
        this.insertData = JSON.parse(JSON.stringify(this.user))
        await this.getDepartments()
        await this.getParties()
      }
    }
  }
}
</script>
