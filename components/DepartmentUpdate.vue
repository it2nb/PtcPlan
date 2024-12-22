<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลข้อมูลแผนก/งาน</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateDepartment"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
            <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ฝ่าย</h3>
            <v-select
              v-model="updateData.partyID"
              label="ฝ่าย"
              :items="parties"
              item-text="partyName"
              item-value="partyID"
              outlined
              :rules="[
                ()=>!!updateData.partyID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-select>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อแผนก/งาน</h3>
            <v-text-field
              v-model="updateData.departmentName"
              label="ชื่อแผนก/งาน"
              outlined
              required
              :rules="[
                ()=>!!updateData.departmentName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">คำอธิบาย</h3>
            <v-textarea
              v-model="updateData.departmentDetail"
              label="คำอธิบาย"
              outlined
            ></v-textarea>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">หัวหน้าแผนก/งาน</h3>
            <!-- <v-text-field
              v-model="updateData.departmentHead"
              label="ชื่อ-สกุล หัวหน้าแผนก/งาน"
              outlined
            ></v-text-field> -->
            <v-autocomplete
              v-model="updateData.departmentHeadUserID"
              :items="users"
              item-text="userFullname"
              item-value="userID"
              outlined
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">รักษาราชการแทนหัวหน้าแผนก/งาน</h3>
            <v-autocomplete
              v-model="updateData.departmentReheadUserID"
              :items="users"
              item-text="userFullname"
              item-value="userID"
              outlined
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">สิทธิ์ของระบบ</h3>
            <v-select
              v-model="updateData.departmentSys"
              label="สิทธิ์ของระบบ"
              :items="departmentSyses"
              outlined
            ></v-select>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">สถานะ</h3>
            <v-switch
              v-model="updateData.departmentEnable"
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
    department: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
        parties: [],
      updateData: {},
      users: [],
      departmentSyses: [
        {text: 'ไม่มี', value: 'none'},
        {text: 'งานพัสดุ', value: 'Parcel'},
        {text: 'งานวางแผน', value: 'Plan'},
        {text: 'งานบัญชี', value: 'Account'},
        {text: 'งานการเงิน', value: 'Finance'}
      ],
      updateProgress: false,
      updateValidate: null,
    }
  },

  async mounted() {
    if(this.department) {
        await this.getParties()
        await this.getUsers()
      this.updateData = JSON.parse(JSON.stringify(this.department))
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

    async getUsers() {
        let result = await this.$axios.$get('user.php', {
            params: {
                token: this.$store.state.jwtToken,
                departmentID: this.department.departmentID
            }
        })
        if(result.message == 'Success') {
            this.users = JSON.parse(JSON.stringify(result.user))
            this.users = this.users.filter(user=>user.userEnable=='Enable')
            this.users.unshift({
              userID: 0,
              userFullname: 'ไม่มี'
            })
        }
    },

    async updateDepartment() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        let result = await this.$axios.$post('department.update.php', this.updateData)

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
    async department() {
      if(this.department) {
        await this.getParties()
        await this.getUsers()
        this.updateData = JSON.parse(JSON.stringify(this.department))
      }
    }
  }
}
</script>
