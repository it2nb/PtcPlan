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
      @submit.prevent="updateParty"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อแผนก/งาน</h3>
            <v-text-field
              v-model="updateData.partyName"
              label="ชื่อแผนก/งาน"
              outlined
              required
              :rules="[
                ()=>!!updateData.partyName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">คำอธิบาย</h3>
            <v-textarea
              v-model="updateData.partyDetail"
              label="คำอธิบาย"
              outlined
            ></v-textarea>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">หัวหน้าฝ่าย</h3>
            <!-- <v-text-field
              v-model="updateData.partyHead"
              label="ชื่อ-สกุล หัวหน้าแผนก/งาน"
              outlined
            ></v-text-field> -->
            <v-autocomplete
              v-model="updateData.partyHeadUserID"
              :items="users"
              item-text="userFullname"
              item-value="userID"
              outlined
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">รักษาราชการแทนหัวหน้าฝ่าย</h3>
            <v-autocomplete
              v-model="updateData.partyReheadUserID"
              :items="users"
              item-text="userFullname"
              item-value="userID"
              outlined
            ></v-autocomplete>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">สถานะ</h3>
            <v-switch
              v-model="updateData.partyEnable"
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
    party: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      updateData: {},
      users: [],
      partySyses: [
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
    if(this.party) {
        await this.getUsers()
      this.updateData = JSON.parse(JSON.stringify(this.party))
    }
  },

  methods: {

    async getUsers() {
        let result = await this.$axios.$get('user.php', {
            params: {
                token: this.$store.state.jwtToken,
                partyID: this.party.partyID
            }
        })
        if(result.message == 'Success') {
            this.users = JSON.parse(JSON.stringify(result.user))
            this.users = this.users.filter(user=>user.userEnable=='Enable')
        }
    },

    async updateParty() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        let result = await this.$axios.$post('party.update.php', this.updateData)

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
    async party() {
      if(this.party) {
        await this.getUsers()
        this.updateData = JSON.parse(JSON.stringify(this.party))
      }
    }
  }
}
</script>
