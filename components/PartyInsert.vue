<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มข้อมูลฝ่าย</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertParty"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อฝ่าย</h3>
            <v-text-field
              v-model="insertData.partyName"
              label="ชื่อฝ่าย"
              outlined
              required
              :rules="[
                ()=>!!insertData.partyName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">คำอธิบาย</h3>
            <v-textarea
              v-model="insertData.partyDetail"
              label="คำอธิบาย"
              outlined
            ></v-textarea>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ชื่อ-สกุล หัวหน้าฝ่าย</h3>
            <!-- <v-text-field
              v-model="insertData.partyHead"
              label="ชื่อ-สกุล หัวหน้าแผนก/งาน"
              outlined
            ></v-text-field> -->
            <v-autocomplete
              v-model="insertData.partyHeadUserID"
              :items="users"
              item-text="userFullname"
              item-value="userID"
              outlined
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">รักษาราชการแทนหัวหน้าฝ่าย</h3>
            <v-autocomplete
              v-model="insertData.partyReheadUserID"
              :items="userReheads"
              item-text="departmentHeadFullname"
              item-value="departmentHeadUserID"
              outlined
            ></v-autocomplete>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">สถานุะ</h3>
            <v-switch
              v-model="insertData.partyEnable"
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
    party: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      insertData: {},
      users: [],
      userReheads: [],
      partySyses: [
        {text: 'ไม่มี', value: 'none'},
        {text: 'งานพัสดุ', value: 'Parcel'},
        {text: 'งานวางแผน', value: 'Plan'},
        {text: 'งานบัญชี', value: 'Account'},
        {text: 'งานการเงิน', value: 'Finance'}
      ],
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.party) {
        await this.getUsers()
      this.insertData = JSON.parse(JSON.stringify(this.party))
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
          result = await this.$axios.$get('user.php', {
            params: {
                token: this.$store.state.jwtToken,
                userStatus: 'Party'
            }
          })
          if(result.message == 'Success') {
            this.userReheads = JSON.parse(JSON.stringify(result.user))
            //this.userReheads = this.userReheads.filter(user=>user.userEnable=='Enable'&&user.userID!=this.party.partyHeadUserID)
            await Promise.all(this.userReheads.map(user=>{
              user.departmentHeadUserID = user.userID,
              user.departmentHeadFullname = user.userFullname
            }))
            result = await this.$axios.$get('department.php', {
              params: {
                  token: this.$store.state.jwtToken
              }
            })
            if(result.message == 'Success') {
              this.userReheads = this.userReheads.concat(JSON.parse(JSON.stringify(result.department)))
              this.userReheads.unshift({
                departmentHeadFullname: 'ไม่มี',
                departmentHeadUserID: 0
              })
              this.userReheads = this.userReheads.filter(department=>department.departmentHeadUserID!=this.party.partyHeadUserID&&department.departmentHeadFullname!=null)
            }
          }
        }
    },

    async insertParty() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        let result = await this.$axios.$post('party.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'partyID': result.partyID})
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
    async party() {
      if(this.party) {
        await this.getUsers()
        this.insertData = JSON.parse(JSON.stringify(this.party))
      }
    }
  }
}
</script>
