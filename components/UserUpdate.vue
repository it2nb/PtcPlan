<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลผู้ใช้ระบบ</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateUser"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อผู้ใช้ระบบ</h3>
            <v-text-field
              v-model="updateData.userName"
              label="ชื่อผู้ใช้ระบบ"
              outlined
              required
              :rules="[
                ()=>!!updateData.userName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">รหัสผ่าน</h3>
            <v-text-field
              v-model="updateData.userPassword"
              label="รหัสผ่าน"
              :type="passwordShow ? 'text' : 'password'"
              :append-icon="passwordShow ? 'mdi-eye' : 'mdi-eye-off'"
              outlined
              @click:append="passwordShow = !passwordShow"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อ-สกุล</h3>
            <v-text-field
              v-model="updateData.userFullname"
              label="ชื่อ-สกุล"
              outlined
              :rules="[
                ()=>!!updateData.userFullname || 'กรุณากรอกชื่อ-สกุล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">เลขประจำตัวประชาชน</h3>
            <v-text-field
              v-model="updateData.personalIDcard"
              label="เลขประจำตัวประชาชน"
              outlined
              required
              :rules="[
                ()=>!!updateData.personalIDcard || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">สถานะ</h3>
            <v-autocomplete
              v-model="updateData.userStatus"
              label="สถานะ"
              :items="userStatuses"
              outlined
              required
              :rules="[
                ()=>!!updateData.userStatus || 'กรุณากรอกข้อมูล'
              ]"
              :readonly="userType=='Department' || userType=='Party'"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6" v-if="updateData.userStatus=='Department'">
            <h3 class="mb-2 fontBold">แผนก/งาน</h3>
            <v-autocomplete
              v-model="updateData.departmentID"
              label="แผนก/งาน"
              :items="departments"
              item-text="departmentName"
              item-value="departmentID"
              outlined
              required
              :rules="[
                ()=>!!updateData.departmentID || 'กรุณากรอกข้อมูล'
              ]"
              :readonly="userType=='Department' || userType=='Party'"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6" v-if="updateData.userStatus=='Party'">
            <h3 class="mb-2 fontBold">ฝ่าย</h3>
            <v-autocomplete
              v-model="updateData.partyID"
              label="ฝ่าย"
              :items="parties"
              item-text="partyName"
              item-value="partyID"
              outlined
              required
              :rules="[
                ()=>!!updateData.partyID || 'กรุณากรอกข้อมูล'
              ]"
              :readonly="userType=='Department' || userType=='Party'"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">คำอธิบาย</h3>
            <v-text-field
              v-model="updateData.userDes"
              label="คำอธิบาย"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">อนุญาตใช้งาน</h3>
            <v-switch
              v-model="updateData.userEnable"
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
    user: {
      type: Object,
      default: () => {}
    },
    userType: {
      type: String,
      default: null
    }
  },

  data() {
    return {
      updateData: {},
      updateProgress: false,
      updateValidate: null,
      passwordShow: false,
      userStatuses: [
        {'text': 'แผนก/งาน', 'value': 'Department'},
        {'text': 'ฝ่ายบริหาร', 'value': 'Party'},
        {'text': 'งานวางแผนและงบประมาณ', 'value': 'Plan'},
        {'text': 'งานพัสดุ', 'value': 'Supply'},
        {'text': 'งานการเงิน', 'value': 'Finance'},
        {'text': 'งานบัญชี', 'value': 'Accountant'},
        {'text': 'งานสารบัญ', 'value': 'Index'},
        {'text': 'ผู้อำนวยการ', 'value': 'Director'},
        {'text': 'ผู้ดูแลระบบ', 'value': 'Admin'},
      ],
      departments: [],
      parties: [],
    }
  },

  async mounted() {
    if(this.user) {
      this.updateData = JSON.parse(JSON.stringify(this.user))
      delete this.updateData.userPassword
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

    async updateUser() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        if(this.updateData.userStatus == 'Director') {
          let params = {
            token: this.$store.state.jwtToken,
            partyName: 'อำนวยการ'
          }
          let partry = await this.$axios.$get('party.php', {params})
          if(partry.message == 'Success') {
            let bossparty = JSON.parse(JSON.stringify(partry.party))
            this.updateData.partyID = bossparty.partyID
          }
        }

        let result = await this.$axios.$post('user.update.php', this.updateData)

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
    async user() {
      if(this.user) {
        this.updateData = JSON.parse(JSON.stringify(this.user))
        delete this.updateData.userPassword
        await this.getDepartments()
        await this.getParties()
      }
    }
  }
}
</script>
