<template>
  <div>
    <v-row>
      <v-col cols="12" md="6" class="mx-auto">
        <v-card>
          <v-card-title>
            <h3 class="col-12 text-center fontBold">รีเซตรหัสผ่าน</h3>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text class="pa-5 py-10">
            <v-form
              ref="resetPasswordForm"
              lazy-validation
              @submit.prevent="changePassword"
            >
              <v-row dense>
                <v-col cols="12" v-if="type=='Personal'">
                  <v-text-field
                    v-model="personalIDcard"
                    label="เลขประจำตัวประชาชน"
                    outlined
                    dense
                    :rules="[
                      () => !!personalIDcard || 'กรุณากรอกข้อมูล'
                    ]"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" v-if="type=='User'">
                  <v-text-field
                    v-model="userName"
                    label="ชื่อผู้ใช้"
                    outlined
                    dense
                    :rules="[
                      () => !!userName || 'กรุณากรอกข้อมูล'
                    ]"
                  ></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-text-field
                    v-model="newpassword"
                    label="รหัสผ่านใหม่"
                    :type="passwordShow ? 'text': 'password'"
                    :append-icon="passwordShow ? 'mdi-eye' : 'mdi-eye-off'"
                    outlined
                    dense
                    :rules="[
                      () => !!newpassword || 'กรุณากรอกข้อมูล'
                    ]"
                    @click:append="passwordShow=!passwordShow"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" class="text-center" v-if="resetPasswordProgress">
                  <v-progress-circular
                    indeterminate
                    color="primary"
                  ></v-progress-circular>
                </v-col>
                <v-col cols="12" class="text-center" v-else>
                  <v-btn type="submit" color="primary">เปลี่ยนรหัสผ่าน</v-btn>
                </v-col>
              </v-row>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import swal from 'sweetalert'
export default {
  data() {
    return {
      personalIDcard: null,
      userName: null,
      newpassword: null,
      passwordShow: false,
      type: null,
      otp: null,
      code: null,
      resetPasswordProgress: false,
    }
  },

  async mounted() {
    this.code = this.$route.query.rescode
    this.type = this.$route.query.restype
    this.otp = this.$route.query.otp
  },

  methods: {
    async changePassword() {
      if(this.$refs.resetPasswordForm.validate()) {
        let otpnum = this.code.substr(0, 6)
        let params = {
          token: this.$store.state.jwtToken
        }
        if(this.type == 'Personal') {
          this.resetPasswordProgress = true
          let idcard = (this.code.substr(6, this.code.length-6))-1234567890123
          if(parseInt(this.personalIDcard) == idcard) {
            params.personalIDcard = this.personalIDcard
            let result = await this.$axios.$get('personal.php', {params})
            if(result.message == 'Success') {
              let personal = JSON.parse(JSON.stringify(result.personal))
              let otps = this.otp.split('.')
              let passnum = ''
              otps.forEach(element => {
                passnum += personal.personalPassword.charAt(element);
              });
              if(passnum == otpnum) {
                personal.token = this.$store.state.jwtToken
                personal.personalPassword = this.newpassword
                let repass = await this.$axios.$post('personal.update.php', personal)
                if(repass.message == 'Success') {
                  let emailMessage = '<b>ชื่อผู้ใช้และรหัสผ่าน</b><br>'
                  emailMessage += '<b>ชื่อ-สกุล</b> '+personal.personalName+'<br>'
                  emailMessage += '<hr>'
                  emailMessage += '<b>ชื่อผู้ใช้</b> '+personal.personalIDcard+'<br><br>'
                  emailMessage += '<b>รหัสผ่าน</b> '+this.newpassword+'<br><br>'
                  emailMessage += 'เข้าใช้งานระบบ คลิ๊ก <a href="http://plan.technicphrae.ac.th/login">plan.technicphrae.ac.th</a> '
                  await this.$axios.$post('sendemail.php', {
                    token: this.$store.state.jwtToken,
                    emailFrom: 'app.technicphrae@gmail.com',
                    emailTo: personal.personalEmail,
                    emailSubject: 'ข้อมูลสำหรับเข้าใช้งานระบบบริหารจัดการแผนปฏิบัติราชการ วิทยาลัยเทคนิคแพร่',
                    emailMessage: emailMessage
                  })
                  swal({
                    title: 'เรียบร้อย',
                    text: 'ส่งข้อมูลผู้ใช้และรหัสผ่านใหม่ ไปยัง '+personal.personalEmail+' เป็นที่เรียบร้อยแล้ว',
                    icon: 'success'
                  }).then(()=>{
                    this.$router.replace('../login')
                  })
                  this.resetPasswordProgress = false
                }
              } else {
                swal({
                  title: 'ผิดพลาด',
                  text: 'ข้อมูลผิดพลาด',
                  icon: 'error'
                }).then(()=>{
                  this.$router.replace('../login')
                })
                this.resetPasswordProgress = false
              }
            } else {
              swal({
                title: 'ผิดพลาด',
                text: 'ไม่พบข้อมูลในระบบ',
                icon: 'error'
              })
              this.resetPasswordProgress = false
            }
          } else {
            swal({
              title: 'ผิดพลาด',
              text: 'ข้อมูลเลขประจำตัวประชาชนไม่ถูกต้อง',
              icon: 'error'
            })
            this.resetPasswordProgress = false
          }
        } else if(this.type == 'User') {
          this.resetPasswordProgress = true
          let userID = this.code.substr(6, this.code.length-6)
          params.userID = userID
          let result = await this.$axios.$get('user.php', {params})
          if(result.message == 'Success') {
            let user = JSON.parse(JSON.stringify(result.user))
            if(user.userName == this.userName) {
              let otps = this.otp.split('.')
              let passnum = ''
              otps.forEach(element => {
                passnum += user.userPassword.charAt(element);
              });
              if(passnum == otpnum) {
                user.token = this.$store.state.jwtToken
                user.userPassword = this.newpassword
                let repass = await this.$axios.$post('user.update.php', user)
                if(repass.message == 'Success') {
                  let emailMessage = '<b>ชื่อผู้ใช้และรหัสผ่าน</b><br>'
                  emailMessage += '<b>รายละเอียดผู้ใช้</b> '+user.userDes+'<br>'
                  emailMessage += '<hr>'
                  emailMessage += '<b>ชื่อผู้ใช้</b> '+user.userName+'<br><br>'
                  emailMessage += '<b>รหัสผ่าน</b> '+this.newpassword+'<br><br>'
                  emailMessage += 'เข้าใช้งานระบบ คลิ๊ก <a href="http://plan.technicphrae.ac.th/login">plan.technicphrae.ac.th</a> '
                  await this.$axios.$post('sendemail.php', {
                    token: this.$store.state.jwtToken,
                    emailFrom: 'app.technicphrae@gmail.com',
                    emailTo: user.userEmail,
                    emailSubject: 'ข้อมูลสำหรับเข้าใช้งานระบบบริหารจัดการแผนปฏิบัติราชการ วิทยาลัยเทคนิคแพร่',
                    emailMessage: emailMessage
                  })
                  swal({
                    title: 'เรียบร้อย',
                    text: 'ส่งข้อมูลผู้ใช้และรหัสผ่านใหม่ ไปยัง '+user.userEmail+' เป็นที่เรียบร้อยแล้ว',
                    icon: 'success'
                  }).then(()=>{
                    this.$router.replace('../login')
                  })
                  this.resetPasswordProgress = false
                }
              } else {
                swal({
                  title: 'ผิดพลาด',
                  text: 'ข้อมูลผิดพลาด',
                  icon: 'error'
                }).then(()=>{
                  this.$router.replace('../login')
                })
                this.resetPasswordProgress = false
              }
            } else {
              swal({
                title: 'ผิดพลาด',
                text: 'ชื่อผู้ใช้ไม่ถูกต้อง',
                icon: 'error'
              })
              this.resetPasswordProgress = false
            }
          } else {
            swal({
              title: 'ผิดพลาด',
              text: 'ไม่พบข้อมูลในระบบ',
              icon: 'error'
            })
            this.resetPasswordProgress = false
          }
        }
      }
    }
  },
}
</script>
