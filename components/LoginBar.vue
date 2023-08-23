<template>
  <div class="pa-0 ma-0">
    <v-form
      ref="loginuserForm"
      lazy-validation
      @submit.prevent="loginUser"
    >
      <v-card-text class="col-12">
        <v-row dense class="col-12 mx-auto pb-0">
          <v-col cols="12" md="5">
            <v-text-field
              v-model="user.userName"
              label="ชื่อผู้ใช้"
              outlined
              dense
              :rules="[
                ()=>!!user.userName || 'กรุณากรอกชื่อผู้ใช้',
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="5">
            <v-text-field
              v-model="user.userPassword"
              :type="passwordShow ? 'text' : 'password'"
              label="รหัสผ่าน"
              :append-icon="passwordShow ? 'mdi-eye' : 'mdi-eye-off'"
              outlined
              dense
              :rules="[
                ()=>!!user.userPassword || 'กรุณากรอกรหัสผ่าน'
              ]"
              @click:append="passwordShow = !passwordShow"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="2" class="text-center">
          <v-btn
            type="submit"
            color="success"
            class="col-12 mb-1"
          >เข้าสู่ระบบ</v-btn>
          <v-btn x-small text color="primary" class="col-12 mb-3" @click="showForgetPassword('User')">ลืมรหัสผ่าน</v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-form>

    <v-row justify="center">
      <v-dialog
        v-model="forgetUserPasswordDialog"
        fullscreen
        overlay-color="black"
      >
        <v-card style="background-color: rgba(0, 0, 0, 0.5)">
          <v-container class="col-12 col-md-5">
            <div class="text-right">
              <v-btn
                icon
                dark
                @click="forgetUserPasswordDialog = false"
              >
                <v-icon>fas fa-times-circle</v-icon>
              </v-btn>
            </div>
            <v-card>
              <v-card-title class="elevation-3 primary--text text--darken-2">
                <b>ลืมรหัสผ่าน</b>
              </v-card-title>
              <v-form
                ref="forgetuserpasswordForm"
                lazy-validation
                @submit.prevent="forgetUserPassword"
              >
                <v-card-text class="pa-5">
                  <v-row>
                    <v-col cols="12">
                      <v-text-field
                        v-model="repasswordName"
                        label="ชื่อผู้ใช้"
                        outlined
                        dense
                        :rules="[
                          ()=>!!repasswordName || 'กรุณากรอกชื่อผู้ใช้'
                        ]"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                </v-card-text>
                <v-card-actions class="pa-5" v-if="forgetUserProgress">
                  <v-spacer></v-spacer>
                  <v-progress-circular
                    indeterminate
                    color="primary"
                  ></v-progress-circular>
                </v-card-actions>
                <v-card-actions class="pa-5" v-else>
                  <v-spacer></v-spacer>
                  <v-btn
                    type="submit"
                    color="warning"
                  >
                    ขอกำหนดรหัสผ่านใหม่
                  </v-btn>
                  <v-btn @click="forgetUserPasswordDialog = false">
                    ยกเลิก
                  </v-btn>
                </v-card-actions>
              </v-form>
            </v-card>
          </v-container>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
export default {
  data() {
    return {
      user: {},
      repasswordID: null,
      repasswordName: null,
      passwordShow: false,
      forgetUserPasswordDialog: false,
      forgetUserProgress: false,
    }
  },

  mounted() {

  },

  methods: {
    async loginUser() {
      if(this.$refs.loginuserForm.validate()) {
        this.user.token = this.$store.state.jwtToken
        let result = await this.$axios.$post('user.login.php', this.user)

        if(result.message === 'Success') {
          let user = result.user

          sessionStorage.setItem('loginuser', JSON.stringify({
            type: user.userStatus,
            user: user
          }))

          if(user.userStatus === 'Admin') {
            this.$router.push('/Admin')
          } else if(user.userStatus === 'Department') {
            this.$router.push('/Department')
          } else if(user.userStatus === 'Party') {
            this.$router.push('/Party')
          } else if(user.userStatus === 'Director') {
            this.$router.push('/Director')
          } else if(user.userStatus === 'Plan') {
            this.$router.push('/Plan')
          } else if(user.userStatus === 'Finance') {
            this.$router.push('/Finance')
          } else {
            sessionStorage.clear()
            this.$router.push('/')
          }
        } else {
          swal({
            title: 'ผิดพลาด',
            text: result.msg,
            icon: 'error'
          })
        }
      }
    },

    showForgetPassword(type) {
      this.repasswordID = null
      this.repasswordName = null
      this.forgetUserPasswordDialog = true
    },

    async forgetUserPassword() {
      if(this.$refs.forgetuserpasswordForm.validate()) {
        this.forgetUserProgress = true
        let result = await this.$axios.$get('user.php', {
          params: {
            token: this.$store.state.jwtToken,
            userName: this.repasswordName
          }
        })

        if(result.message === 'Success') {
          let user = JSON.parse(JSON.stringify(result.user))
          if(user) {
            let uPass = user.userPassword
            let otpnum = ''
            let otp = ''
            let rand = 0;
            for (let i = 0; i < 6; i++) {
              rand = Math.floor(Math.random() * uPass.length)
                otp += rand.toString()
                if(i<5) {
                  otp += '.'
                }
                otpnum += uPass.charAt(rand);
            }

            let rescode = otpnum + parseInt(user.userID).toString()
            let emailMessage = '<b>รีเซตรหัสผ่าน</b><br>'
            emailMessage += '<b>ชื่อผู้ใช้</b> '+user.userName+'<br><br>'
            emailMessage += 'เปลี่ยนรหัสผ่านใหม่ คลิ๊ก <a href="http://plan.technicphrae.ac.th/resetpassword/?rescode='+rescode+'&otp='+otp+'&restype=User">plan.technicphrae.ac.th</a> '
            await this.$axios.$post('sendemail.php', {
              token: this.$store.state.jwtToken,
              emailFrom: 'app.technicphrae@gmail.com',
              emailTo: user.userEmail,
              emailSubject: 'รีเซตรหัสผ่านระบบบริหารจัดการแผนปฏิบัติราชการ วิทยาลัยเทคนิคแพร่',
              emailMessage: emailMessage
            })

            if(user.userEmail) {
              swal({
                title: 'เรียบร้อย',
                text: 'ส่งช่องทางการเปลี่ยนรหัสผ่านใหม่ ไปยัง '+user.userEmail+' เป็นที่เรียบร้อยแล้ว',
                icon: 'success'
              })
              this.forgetUserProgress = false
            } else {
              swal({
                title: 'ผิดพลาด',
                text: 'ไม่สามารถส่งข้อมูลการรีเซตรหัสผ่านของท่านได้ เนื่องจากไม่พบข้อมูล Email ในระบบ',
                icon: 'error'
              })
              this.forgetUserProgress = false
            }
          } else {
            swal({
              title: 'ผิดพลาด',
              text: 'ไม่พบข้อมูลท่านในระบบ',
              icon: 'error'
            })
            this.forgetUserProgress = false
          }
        } else {
          swal({
            title: 'ผิดพลาด',
            text: 'ไม่พบข้อมูลท่านในระบบ',
            icon: 'error'
          })
          this.forgetUserProgress = false
        }
      }
    },

    checkIDcard(IDCard) {
        if(IDCard.length != 13)
            return false;
        let sum = 0
        for(let i=0; i < 12; i++) {
            sum += parseFloat(IDCard.charAt(i))*(13-i);
        }
        if((11-sum%11)%10!=parseFloat(IDCard.charAt(12)))
            return false;
        return true;
    },
  }
}
</script>
