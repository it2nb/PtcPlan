<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="light-blue lighten-5">
            <b>ข้อมูลส่วนตัว</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text class="pa-md-5">
            <v-row dense class="px-5 pa-md-5">
              <v-col cols="12" md="4" class="py-2">
                เลขประจำตัวประชาชน <b>{{ personal.personalIDcard }}</b>
              </v-col>
              <v-col cols="12" md="4" class="py-2">
                ชื่อ - สกุล <b>{{ personal.personalPrefix+personal.personalName + ' ' + personal.personalSer }}</b>
              </v-col>
              <v-col cols="12" md="2" class="py-2">
                ตำแหน่ง <b>{{ personal.personalPosition }}</b>
              </v-col>
              <v-col cols="12" md="2" class="py-2">
                วิทยฐานะ <b>{{ personal.personalStanding }}</b>
              </v-col>
              <v-col cols="12" md="4" class="py-2">
                เบอร์โทรศัพท์ <b>{{ personal.personalPhone }}</b>
              </v-col>
              <v-col cols="12" md="8" class="py-2">
                Email <b>{{ personal.personalEmail }}</b>
              </v-col>
            </v-row>
          </v-card-text>
          <v-card-actions class="pa-5 justify-end">
            <v-btn small outlined color="warning" @click="showUpdateDialog">
              <v-icon small class="mr-1">fas fa-edit</v-icon>แก้ไข
            </v-btn>
            <v-btn small outlined color="red darken-3" @click="showChangePasswordDialog">
              <v-icon small class="mr-1">fas fa-key</v-icon>เปลี่ยนรหัสผ่าน
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="updateDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-8 mx-auto my-5">
              <v-card>
                <v-card-actions class="warning lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="warning lighten-2">
                  <span class="fontBold">แก้ไขข้อมูลส่วนตัว</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="updatePersonalValidate"
                  ref="updatePersonalForm"
                  lazy-validation
                  @submit.prevent="updatePersonal"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold">เลขประจำตัวประชาชน</h3>
                        <v-text-field
                          v-model="personalUpdate.personalIDcard"
                          label="เลขประจำตัวประชาชน"
                          dense
                          outlined
                          readonly
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="2">
                        <h3 class="mb-2 fontBold">คำนำหน้าชื่อ</h3>
                        <v-select
                          v-model="personalUpdate.personalPrefix"
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
                            ()=> !!personalUpdate.personalPrefix || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select>
                      </v-col>
                      <v-col cols="12" md="6" v-if="personalUpdate.personalPrefix=='อื่น ๆ'">
                        <h3 class="mb-2 fontBold">คำนำหน้าชื่อ</h3>
                        <v-text-field
                          v-model="personalUpdate.personalPrefixOther"
                          label="คำนำหน้าชื่อ"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personalUpdate.personalPrefixOther || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="3">
                        <h3 class="mb-2 fontBold">ชื่อ</h3>
                        <v-text-field
                          v-model="personalUpdate.personalName"
                          label="ชื่อ"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personalUpdate.personalName || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="3">
                        <h3 class="mb-2 fontBold">สกุล</h3>
                        <v-text-field
                          v-model="personalUpdate.personalSer"
                          label="สกุล"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personalUpdate.personalSer || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="3">
                        <h3 class="mb-2 fontBold">ตำแหน่ง</h3>
                        <v-select
                          v-model="personalUpdate.personalPosition"
                          label="ตำแหน่ง"
                          :items="[
                            'ผู้อำนวยการ',
                            'รองผู้อำนวยการ',
                            'ครู',
                            'ครูผู้ช่วย',
                            'พนักงานราชการ',
                            'ครูพิเศษสอน',
                            'เจ้าหน้าที่',
                            'นักการภารโรง',
                            'ยามรักษาการณ์'
                          ]"
                          dense
                          outlined
                        ></v-select>
                      </v-col>
                      <v-col cols="12" md="3">
                        <h3 class="mb-2 fontBold">วิทยฐานะ</h3>
                        <v-select
                          v-model="personalUpdate.personalStanding"
                          label="ตำแหน่ง"
                          :items="[
                            '',
                            'ชำนาญการ',
                            'ชำนาญการพิเศษ',
                            'เชี่ยวชาญ',
                            'เชี่ยวชาญพิเศษ'
                          ]"
                          dense
                          outlined
                        ></v-select>
                      </v-col>
                      <v-col cols="12" md="5">
                        <h3 class="mb-2 fontBold">เบอร์โทรศัพท์</h3>
                        <v-text-field
                          v-model="personalUpdate.personalPhone"
                          label="เบอร์โทรศัพท์"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personalUpdate.personalPhone || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="7">
                        <h3 class="mb-2 fontBold">Email</h3>
                        <v-text-field
                          v-model="personalUpdate.personalEmail"
                          label="Email"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personalUpdate.personalEmail || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions>
                    <div class="col-12 text-center">
                      <v-btn
                        @click="updateDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="updatePersonalProgress"
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
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="changePasswordDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-8 mx-auto my-5">
              <v-card>
                <v-card-actions class="warning lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="changePasswordDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="warning lighten-2">
                  <span class="fontBold">เปลี่ยนรหัสผ่าน</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="changePasswordValidate"
                  ref="changePasswordForm"
                  lazy-validation
                  @submit.prevent="changePassword"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold">เลขประจำตัวประชาชน</h3>
                        <v-text-field
                          v-model="personalUpdate.personalIDcard"
                          label="เลขประจำตัวประชาชน"
                          dense
                          outlined
                          readonly
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="2">
                        <h3 class="mb-2 fontBold">คำนำหน้าชื่อ</h3>
                        <v-select
                          v-model="personalUpdate.personalPrefix"
                          label="คำนำหน้าชื่อ"
                          :items="[
                            'นาย',
                            'นางสาว',
                            'นาง',
                            'อื่น ๆ'
                          ]"
                          dense
                          outlined
                          readonly
                        ></v-select>
                      </v-col>
                      <v-col cols="12" md="3">
                        <h3 class="mb-2 fontBold">ชื่อ</h3>
                        <v-text-field
                          v-model="personalUpdate.personalName"
                          label="ชื่อ"
                          dense
                          outlined
                          readonly
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="3">
                        <h3 class="mb-2 fontBold">สกุล</h3>
                        <v-text-field
                          v-model="personalUpdate.personalSer"
                          label="สกุล"
                          dense
                          outlined
                          readonly
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">รหัสผ่านเดิม</h3>
                        <v-text-field
                          v-model="personalUpdate.personalPasswordOld"
                          label="รหัสผ่าน"
                          :type="oldPasswordShow ? 'text' : 'password'"
                          :append-icon="oldPasswordShow ? 'mdi-eye' : 'mdi-eye-off'"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personalUpdate.personalPasswordOld || 'กรุณากรอกข้อมูล'
                          ]"
                          @click:append="oldPasswordShow = !oldPasswordShow"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">รหัสผ่านใหม่</h3>
                        <v-text-field
                          v-model="personalUpdate.personalPassword"
                          label="รหัสผ่าน"
                          :type="passwordShow ? 'text' : 'password'"
                          :append-icon="passwordShow ? 'mdi-eye' : 'mdi-eye-off'"
                          dense
                          outlined
                          :rules="[
                            ()=> !!personalUpdate.personalPassword || 'กรุณากรอกข้อมูล'
                          ]"
                          @click:append="passwordShow = !passwordShow"
                        ></v-text-field>
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions>
                    <div class="col-12 text-center">
                      <v-btn
                        @click="changePasswordDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="changePasswordProgress"
                      ></v-progress-circular>
                      <v-btn
                        type="submit"
                        color="warning darken-1"
                        large
                        v-else
                      >
                        เปลี่ยนรหัสผ่าน
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
var swal = require('sweetalert')
export default {
  props: {
    personalIDcard: {
      type: String,
      default: null
    }
  },

  data() {
    return {
      personal: {},
      personalUpdate: {},
      updateDialog: false,
      changePasswordDialog: false,
      updatePersonalValidate: false,
      changePasswordValidate: false,
      updatePersonalProgress: false,
      changePasswordProgress: false,
      passwordShow: false,
      oldPasswordShow: false,
    }
  },

  async mounted() {
    await this.getPersonal()
  },

  methods: {
    async getPersonal() {
      let result = await this.$axios.$get('personal.php', {
        params: {
          token: this.$store.state.jwtToken,
          personalIDcard: this.personalIDcard
        }
      })

      if(result.message == 'Success') {
        this.personal = JSON.parse(JSON.stringify(result.personal))
      }
    },

    showUpdateDialog() {
      this.personalUpdate = JSON.parse(JSON.stringify(this.personal))
      if(this.personalUpdate.personalPrefix!='นาย' && this.personalUpdate.personalPrefix!='นาง' && this.personalUpdate.personalPrefix!='นางสาว'){
        this.personalUpdate.personalPrefixOther = this.personalUpdate.personalPrefix
        this.personalUpdate.personalPrefix = 'อื่น ๆ'
      }
      delete this.personalUpdate.personalPassword
      this.updateDialog = true
    },

    showChangePasswordDialog() {
      this.personalUpdate = JSON.parse(JSON.stringify(this.personal))
      delete this.personalUpdate.personalPassword
      this.changePasswordDialog = true
    },

    async updatePersonal() {
      this.updatePersonalProgress = true
      if(this.$refs.updatePersonalForm.validate()) {
        this.personalUpdate.token = this.$store.state.jwtToken
        if(this.personalUpdate.personalPrefix == "อื่น ๆ") {
          this.personalUpdate.personalPrefix = this.personalUpdate.personalPrefixOther
        }
        let result = await this.$axios.$post('personal.update.php', this.personalUpdate)
        if(result.message == 'Success') {
          swal({
            title: 'เรียบร้อย',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            await this.getPersonal()
            this.updateDialog = false
          })
        } else {
          swal({
            title: 'ผิดพลาด',
            text: result.msg,
            icon: 'error'
          }).then(()=> {
            this.updateDialog = false
          })
        }
      }
      this.updatePersonalProgress = false
    },

    async changePassword() {
      this.changePasswordProgress = true
      if(this.$refs.changePasswordForm.validate()) {
        this.personalUpdate.token = this.$store.state.jwtToken
        let result = await this.$axios.$post('personal.login.php', {
          token: this.personalUpdate.token,
          personalIDcard: this.personalUpdate.personalIDcard,
          personalPassword: this.personalUpdate.personalPasswordOld
        })

        if(result.message == 'Success') {
          let result2 = await this.$axios.$post('personal.update.php', this.personalUpdate)
          if(result2.message == 'Success') {
            swal({
              title: 'เรียบร้อย',
              text: result2.msg,
              icon: 'success'
            }).then(async ()=> {
              await this.getPersonal()
              this.changePasswordDialog = false
            })
          } else {
            swal({
              title: 'ผิดพลาด',
              text: result2.msg,
              icon: 'error'
            }).then(()=> {
              this.changePasswordDialog = false
            })
          }
        } else {
          swal({
            title: 'ผิดพลาด',
            text: result.msg,
            icon: 'error'
          }).then(()=> {
            this.changePasswordDialog = false
          })
        }
      }
      this.changePasswordProgress = false
    }
  },

  watch: {
    async personalIDcard() {
      await this.getPersonal()
    }
  }
}
</script>
