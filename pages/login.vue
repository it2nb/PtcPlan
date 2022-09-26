<template>
  <div>
    <v-row justify="center" align="center">
      <v-col cols="12" sm="8" md="6" class="mt-5 text-center">
        <v-card rounded elevation="3" class="">
          <v-card-title>
            <h3 class="col-12 fontBold text-center">ลงชื่อเข้าสู่ระบบ</h3>
          </v-card-title>
          <v-divider class="mb-5"></v-divider>
          <v-tabs
            v-model="loginTypeTab"
            color="orange darken-4"
            fixed-tabs
          >
            <v-tab><b>ครูและบุคลากรทางการศึกษา</b></v-tab>
            <v-tab><b>ผู้ดูแลระบบ</b></v-tab>
          </v-tabs>
          <v-tabs-items
            v-model="loginTypeTab"
          >
            <v-tab-item>
              <v-form
                ref="loginpersonalForm"
                lazy-validation
                @submit.prevent="loginPersonal"
              >
                <v-card-text class="px-5">
                  <v-row no-gutters>
                    <v-col cols="12">
                      <v-text-field
                        v-model="personal.personalIDcard"
                        label="เลขประจำตัวประชาชน"
                        outlined
                        dense
                        :rules="[
                          ()=>!!personal.personalIDcard || 'กรุณากรอกเลขประจำตัวประชาชน',
                        ]"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12">
                      <v-text-field
                        v-model="personal.personalPassword"
                        :type="passwordShow ? 'text' : 'password'"
                        label="รหัสผ่าน"
                        :append-icon="passwordShow ? 'mdi-eye' : 'mdi-eye-off'"
                        outlined
                        dense
                        :rules="[
                          ()=>!!personal.personalPassword || 'กรุณากรอกรหัสผ่าน'
                        ]"
                        @click:append="passwordShow = !passwordShow"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                </v-card-text>
                <v-divider></v-divider>
                <v-card-actions>
                  <div class="col-12 text-center">
                    <v-btn
                      type="submit"
                      color="success"
                    >เข้าสู่ระบบ</v-btn>
                    <!-- <div class="mt-3">
                      <v-btn text color="primary" @click="showForgetPassword('User')">ลืมรหัสผ่าน</v-btn>
                    </div> -->
                    <v-divider class="mt-3"></v-divider>
                    <div class="mt-3">
                      <v-btn rounded outlined color="success" @click="showPersonalRegis">ลงทะเบียน</v-btn>
                    </div>
                  </div>
                </v-card-actions>
              </v-form>
            </v-tab-item>
            <v-tab-item>
              <v-form
                ref="loginuserForm"
                lazy-validation
                @submit.prevent="loginUser"
              >
                <v-card-text class="px-5">
                  <v-row no-gutters>
                    <v-col cols="12">
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
                    <v-col cols="12">
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
                  </v-row>
                </v-card-text>
                <v-divider></v-divider>
                <v-card-actions>
                  <div class="col-12 text-center">
                    <v-btn
                      type="submit"
                      color="success"
                    >เข้าสู่ระบบ</v-btn>
                    <!-- <div class="mt-3">
                      <v-btn text color="primary" @click="showForgetPassword('User')">ลืมรหัสผ่าน</v-btn>
                    </div> -->
                    <!-- <v-divider class="mt-3"></v-divider>
                    <div class="mt-3">
                      <v-btn rounded outlined color="success" @click="showPersonalRegis">ลงทะเบียน</v-btn>
                    </div> -->
                  </div>
                </v-card-actions>
              </v-form>
            </v-tab-item>
          </v-tabs-items>
        </v-card>
      </v-col>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="forgetUserPasswordDialog"
        fullscreen
        overlay-color="black"
      >
        <v-card style="background-color: rgba(0, 0, 0, 0.5)">
          <v-container class="col-12 col-md-4">
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
                        v-model="user.userUsername"
                        label="ชื่อผู้ใช้"
                        outlined
                        dense
                        :rules="[
                          ()=>!!user.userUsername || 'กรุณากรอกชื่อผู้ใช้'
                        ]"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                </v-card-text>
                <v-card-actions class="pa-5">
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

    <v-row justify="center">
      <v-dialog
        v-model="registerDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-8 mx-auto my-5">
              <v-card>
                <v-card-actions class="light-green lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="registerDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="light-green lighten-2">
                  <span class="fontBold">ลงทะเบียนเข้าใช้งานระบบ</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="personalRegisterValidate"
                  ref="personalRegisForm"
                  lazy-validation
                  @submit.prevent="regisPersonal"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">เลขประจำตัวประชาชน(ใช้เป็นชื่อผู้ใช้)</h3>
                        <v-text-field
                          v-model="personal.personalIDcard"
                          label="เลขประจำตัวประชาชน"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personal.personalIDcard || 'กรุณากรอกข้อมูล',
                            ()=> checkIDcard(personal.personalIDcard || '') || 'เลขประจำตัวประชาชนไม่ถูกต้อง'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">รหัสผ่าน</h3>
                        <v-text-field
                          v-model="personal.personalPassword"
                          label="รหัสผ่าน"
                          :type="regisPasswordShow ? 'text' : 'password'"
                          :append-icon="regisPasswordShow ? 'mdi-eye' : 'mdi-eye-off'"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personal.personalPassword || 'กรุณากรอกข้อมูล'
                          ]"
                          @click:append="regisPasswordShow = !regisPasswordShow"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="2">
                        <h3 class="mb-2 fontBold">คำนำหน้าชื่อ</h3>
                        <v-select
                          v-model="personal.personalPrefix"
                          label="คำนำหน้าชื่อ"
                          :items="[
                            'นาย',
                            'นางสาว',
                            'นาง',
                            'อื่น ๆ'
                          ]"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personal.personalPrefix || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select>
                      </v-col>
                      <v-col cols="12" md="10" v-if="personal.personalPrefix=='อื่น ๆ'">
                        <h3 class="mb-2 fontBold">คำนำหน้าชื่อ</h3>
                        <v-text-field
                          v-model="personal.personalPrefixOther"
                          label="คำนำหน้าชื่อ"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personal.personalPrefixOther || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="5">
                        <h3 class="mb-2 fontBold">ชื่อ</h3>
                        <v-text-field
                          v-model="personal.personalName"
                          label="ชื่อ"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personal.personalName || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="5">
                        <h3 class="mb-2 fontBold">สกุล</h3>
                        <v-text-field
                          v-model="personal.personalSer"
                          label="สกุล"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personal.personalSer || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="5">
                        <h3 class="mb-2 fontBold">เบอร์โทรศัพท์</h3>
                        <v-text-field
                          v-model="personal.personalPhone"
                          label="เบอร์โทรศัพท์"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personal.personalPhone || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="7">
                        <h3 class="mb-2 fontBold">Email</h3>
                        <v-text-field
                          v-model="personal.personalEmail"
                          label="Email"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personal.personalEmail || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions>
                    <div class="col-12 text-center">
                      <v-btn
                        @click="registerDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="registerProgress"
                      ></v-progress-circular>
                      <v-btn
                        type="submit"
                        color="success darken-1"
                        large
                        v-else
                      >
                        ลงทะเบียน
                      </v-btn>
                    </div>
                  </v-card-actions>
                </v-form>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
import swal from 'sweetalert'
export default {
  data() {
    return {
      college: {},
      committee: {},
      user: {},
      loginTypeTab: 0,
      personal: {},
      passwordShow: false,
      regisPasswordShow: false,
      registerDialog: false,
      registerProgress: false,
      personalRegisterValidate: null,
      forgetUserPasswordDialog: false,
      forgetCollegePasswordDialog: false,
    }
  },

  async mounted() {

  },

  methods: {
    async loginPersonal() {
      if(this.$refs.loginpersonalForm.validate()) {
        this.personal.token = this.$store.state.jwtToken
        let result = await this.$axios.$post('personal.login.php', this.personal)

        if(result.message === 'Success') {
          let personal = result.personal

          sessionStorage.setItem('loginuser', JSON.stringify({
            type: 'Personal',
            personal: personal
          }))

          this.$router.push('/Personal')
        } else {
          swal({
            title: 'ผิดพลาด',
            text: result.msg,
            icon: 'error'
          })
        }
      }
    },

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
      if(type === 'User') {
        this.forgetUserPasswordDialog = true
      }
    },

    async forgetUserPassword() {
      if(this.$refs.forgetuserpasswordForm.validate()) {
        let result = await this.$axios.$get('user.php', {
          params: {
            token: this.$store.state.jwtToken,
            userUsername: this.user.userUsername
          }
        })

        if(result.message === 'Success') {
          let user = result.user
          if(user) {
            let otpnum = '123456789'
            let otp = ''
            for (let i = 0; i < 6; i++) {
                otp += otpnum.charAt(Math.floor(Math.random() * otpnum.length));
            }

            result = await this.$axios.$post('user.update.php', {
              token: this.$store.state.jwtToken,
              userID: user.userID,
              userOTP: otp,
              userOTPDatetime: new Date().toISOString().slice(0, 19).replace('T', ' ')
            })

            let rescode = otp + user.userID
            rescode = parseInt(rescode) + 99
            let emailMessage = '<b>รีเซตรหัสผ่าน</b><br>'
            emailMessage += '<b>ชื่อ-สกุล</b> '+user.userName+'<br>'
            emailMessage += '<b>หน่วยงาน</b> '+user.userOrg+'<br>'
            emailMessage += '<hr>'
            emailMessage += '<b>ชื่อผู้ใช้</b> '+user.userUsername+'<br><br>'
            emailMessage += 'เปลี่ยนรหัสผ่านใหม่ คลิ๊ก <a href="https://bvcas.org/resetpassword/?rescode='+rescode+'&restype=User">bvcas.org</a> '
            await this.$axios.$post('sendemail.php', {
              token: this.$store.state.jwtToken,
              emailFrom: 'noreply@bvcas.org',
              emailTo: user.userEmail,
              emailSubject: 'รีเซตรหัสผ่านระบบประเมินสถานศึกษาอาชีวศึกษาวิถีพุทธ',
              emailMessage: emailMessage
            })
            swal({
              title: 'เรียบร้อย',
              text: 'ส่งช่องทางการเปลี่ยนรหัสผ่านใหม่ ไปยัง '+user.userEmail+' เป็นที่เรียบร้อยแล้ว',
              icon: 'success'
            })
          } else {
            swal({
              title: 'ผิดพลาด',
              text: 'ไม่พบข้อมูลสถานศึกษาท่านในระบบ',
              icon: 'error'
            })
          }
        }
      }
    },

    showPersonalRegis() {
      this.personal = {}
      this.registerDialog = true
    },

    async regisPersonal() {
      this.registerProgress = true
      if(this.$refs.personalRegisForm.validate()) {
        if(this.personal.personalPrefix == "อื่น ๆ") {
          this.personal.personalPrefix = this.personal.personalPrefixOther
        }

        this.personal.token = this.$store.state.jwtToken
        this.personal.personalEnable = 'Enable'

        let result = await this.$axios.$post('personal.insert.php', this.personal)
        if(result.message=='Success') {
          swal({
            title: 'เรียบร้อย',
            text: result.msg,
            icon: 'success'
          }).then(()=> {
            this.registerDialog = false
          })
        } else {
          swal({
            title: 'ผิดพลาด',
            text: result.msg,
            icon: 'error'
          }).then(()=> {
            this.registerDialog = false
          })
        }
      }
      this.registerProgress = false
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
