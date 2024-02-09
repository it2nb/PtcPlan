<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ข้อมูลฝ่ายบริหาร</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text class="pa-md-5">
            <v-row dense class="px-5 pa-md-5">
              <v-col cols="12" md="4" class="py-2">
                ชื่อผู้ใช้ระบบ <b>{{ user.userName }}</b>
              </v-col>
              <v-col cols="12" md="8" class="py-2">
                คำอธิบาย <b>{{ user.userDes }}</b>
              </v-col>
              <v-col cols="12" md="4" class="py-2">
                เบอร์โทรศัพท์ <b>{{ user.userPhone }}</b>
              </v-col>
              <v-col cols="12" md="8" class="py-2">
                Email <b>{{ user.userEmail }}</b>
              </v-col>
              <v-col cols="12" md="8" class="py-2">
                (1-on-1) Line TOKEN
                <span v-if="user.userLineToken">
                  <v-icon color="success" class="ml-1">fas fa-check-circle</v-icon>
                </span>
                <span v-else>
                  <v-icon small color="grey" class="ml-1">fas fa-minus-circle</v-icon>
                </span>
              </v-col>
              <v-col cols="12"><v-divider></v-divider></v-col>
              <v-col cols="12" md="4" class="py-2">
                ฝ่าย <b>{{ party.partyName }}</b>
              </v-col>
              <v-col cols="12" md="4" class="py-2">
                {{ user.userStatus=='Director'?'ชื่อ ผอ.':'ชื่อ รองฯฝ่าย' }} <b>{{ party.partyHead }}</b>
              </v-col>
              <v-col cols="12" md="4" class="py-2">
                ลายมือชื่อ <v-icon color="success" v-if="signature">fas fa-check-circle</v-icon>
                <v-icon color="red darken-2" v-else>fas fa-times-circle</v-icon>
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
                  <span class="fontBold">แก้ไขข้อมูลฝ่าย</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="updateUserValidate"
                  ref="updateUserForm"
                  lazy-validation
                  @submit.prevent="updateUser"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold">ชื่อผู้ใช้ระบบ</h3>
                        <v-text-field
                          v-model="userUpdate.userName"
                          label="ชื่อผู้ใช้ระบบ"
                          dense
                          outlined
                          readonly
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="8">
                        <h3 class="mb-2 fontBold">คำอธิบาย</h3>
                        <v-text-field
                          v-model="userUpdate.userDes"
                          label="คำอธิบาย"
                          dense
                          outlined
                          readonly
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold">เบอร์โทรศัพท์</h3>
                        <v-text-field
                          v-model="userUpdate.userPhone"
                          label="เบอร์โทรศัพท์"
                          dense
                          outlined
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="8">
                        <h3 class="mb-2 fontBold">Email</h3>
                        <v-text-field
                          v-model="userUpdate.userEmail"
                          label="Email"
                          dense
                          outlined
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">(1-on-1) Line TOKEN</h3>
                        <v-text-field
                          v-model="userUpdate.userLineToken"
                          label="Line TOKEN"
                          dense
                          outlined
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12">
                        <v-divider></v-divider>
                      </v-col>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold">ฝ่าย</h3>
                        <v-text-field
                          v-model="userUpdate.partyName"
                          label="ฝ่าย"
                          dense
                          outlined
                          readonly
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold" v-if="user.userStatus=='Director'">ชื่อ ผอ.</h3>
                        <h3 class="mb-2 fontBold" v-else>ชื่อ รองฯฝ่าย</h3>
                        <v-text-field
                          v-model="userUpdate.partyHead"
                          :label="user.userStatus=='Director'?'ชื่อ ผอ.':'ชื่อ รองฯฝ่าย'"
                          dense
                          outlined
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold">ลายมือชื่อ</h3>
                        <v-file-input
                          v-model="userSignature"
                          ref="userSignature"
                          dense
                          outlined
                          small-chips
                          show-size
                          counter
                          accept="image/jpeg"
                          label="ภาพลายมือชื่อ"
                          @change="userImagesChanged"
                        ></v-file-input>
                        <div class="col-12" v-if="userSignature">
                          <v-img
                            :src="getImageUrl(userSignature)"
                            contain
                          >
                            <template v-slot:placeholder>
                              <v-row
                                  class="fill-height ma-0 "
                                  justify="center"
                              >
                                <v-icon large>fas fa-images</v-icon>
                              </v-row>
                            </template>
                          </v-img>
                        </div>
                        <div class="col-12" v-else-if="userUpdate.userSignature">
                          <v-img
                            :src="userUpdate.imagePath+usignature+'?d='+(new Date().getTime())"
                            contain
                            class="align-end text-right"
                            gradient="to bottom, rgba(255,255,255,.1), rgba(255,255,255,.5)"
                            v-for="usignature in userUpdate.userSignature" :key="usignature.key"
                          >
                            <v-btn icon small color="red darken-2" @click="showDeleteSignatureDialog(usignature)">
                              <v-icon small>fas fa-trash</v-icon>
                            </v-btn>
                          </v-img>
                        </div>
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
                        v-if="updateUserProgress"
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
                        <h3 class="mb-2 fontBold">ชื่อผู้ใช้ระบบ</h3>
                        <v-text-field
                          v-model="userUpdate.userName"
                          label="ชื่อผู้ใช้ระบบ"
                          dense
                          outlined
                          readonly
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="8">
                        <h3 class="mb-2 fontBold">คำอธิบาย</h3>
                        <v-text-field
                          v-model="userUpdate.userDes"
                          label="คำอธิบาย"
                          dense
                          outlined
                          readonly
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">รหัสผ่านเดิม</h3>
                        <v-text-field
                          v-model="userUpdate.userPasswordOld"
                          label="รหัสผ่าน"
                          :type="oldPasswordShow ? 'text' : 'password'"
                          :append-icon="oldPasswordShow ? 'mdi-eye' : 'mdi-eye-off'"
                          dense
                          outlined
                          :rules="[
                            ()=> !!userUpdate.userPasswordOld || 'กรุณากรอกข้อมูล'
                          ]"
                          @click:append="oldPasswordShow = !oldPasswordShow"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">รหัสผ่านใหม่</h3>
                        <v-text-field
                          v-model="userUpdate.userPassword"
                          label="รหัสผ่าน"
                          :type="passwordShow ? 'text' : 'password'"
                          :append-icon="passwordShow ? 'mdi-eye' : 'mdi-eye-off'"
                          dense
                          outlined
                          :rules="[
                            ()=> !!userUpdate.userPassword || 'กรุณากรอกข้อมูล'
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

    <v-row justify="center">
      <v-dialog
        v-model="deleteDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-8 mx-auto my-5">
              <v-card>
                <v-card-actions class="red lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="deleteDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="red lighten-2">
                  <span class="fontBold black--text">ลบภาพลายมือชื่อ</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  @submit.prevent="deleteUserSignature"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ภาพลายมือชื่อ</h3>
                        <v-row v-if="signatureDeleteName">
                          <v-col class="col-12 col-md-6 mx-auto">
                            <v-img
                              :src="user.imagePath+signatureDeleteName+'?d='+(new Date().getTime())"
                            >
                            </v-img>
                          </v-col>
                        </v-row>
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions>
                    <div class="col-12 text-center">
                      <v-btn
                        @click="deleteDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="deleteProgress"
                      ></v-progress-circular>
                      <v-btn
                        type="submit"
                        color="red darken-1"
                        large
                        dark
                        v-else
                      >
                        ลบ
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
    userID: {
      type: String,
      default: null
    }
  },

  data() {
    return {
      user: {},
      signature: false,
      userSignature: null,
      party: {},
      userUpdate: {},
      partyUpdate: {},
      updateDialog: false,
      changePasswordDialog: false,
      updateUserValidate: false,
      changePasswordValidate: false,
      updateUserProgress: false,
      changePasswordProgress: false,
      passwordShow: false,
      oldPasswordShow: false,
      signatureDeleteName: null,
      deleteDialog: false,
      deleteProgress: false,
    }
  },

  async mounted() {
    await this.getUser()
    await this.getParty()
  },

  methods: {
    async getUser() {
      let result = await this.$axios.$get('user.php', {
        params: {
          token: this.$store.state.jwtToken,
          userID: this.userID
        }
      })

      if(result.message == 'Success') {
        this.user = JSON.parse(JSON.stringify(result.user))
        let result2 = await this.$axios.$get('signature.image.php', {
          params: {
            token: this.$store.state.jwtToken,
            signatureType: 'Party',
            signatureID: this.user.userID,
            function: 'signatureImageGet'
          }
        })
        if(result2.message == 'Success') {
          this.user.userSignature = JSON.parse(JSON.stringify(result2.signatureImages))
          this.user.imagePath = result2.signatureImagePath
          this.signature = true
        }
      }
    },

    async getParty() {
      let result = await this.$axios.$get('party.php', {
        params: {
          token: this.$store.state.jwtToken,
          partyID: this.user.partyID
        }
      })

      if(result.message == 'Success') {
        this.party = JSON.parse(JSON.stringify(result.party))
      }
    },

    showUpdateDialog() {
      this.userUpdate = JSON.parse(JSON.stringify(this.user))
      if(this.userUpdate.userPrefix!='นาย' && this.userUpdate.userPrefix!='นาง' && this.userUpdate.userPrefix!='นางสาว'){
        this.userUpdate.userPrefixOther = this.userUpdate.userPrefix
        this.userUpdate.userPrefix = 'อื่น ๆ'
      }
      delete this.userUpdate.userPassword
      this.userSignature = null
      this.updateDialog = true
    },

    showChangePasswordDialog() {
      this.userUpdate = JSON.parse(JSON.stringify(this.user))
      delete this.userUpdate.userPassword
      this.changePasswordDialog = true
    },

    signatureImagesChanged(image) {
      if(image) {
        this.userSignature = image;
      } else {
        this.userSignature = null;
      }
    },

    getImageUrl(image) {
      return URL.createObjectURL(image)
    },

    async updateUser() {
      this.updateUserProgress = true
      if(this.$refs.updateUserForm.validate()) {
        this.userUpdate.token = this.$store.state.jwtToken

        let result = await this.$axios.$post('user.update.php', this.userUpdate)
        let result2 = await this.$axios.$post('party.update.php', this.userUpdate)

        let result3 = {message: null}

        if(this.userSignature) {
            let formData = new FormData()
            formData.append('token', this.userUpdate.token)
            formData.append('function', 'signatureImageUpload')
            formData.append('signatureType', 'Party')
            formData.append('signatureID', this.userUpdate.userID)
            formData.append('signatureImage', this.userSignature)
            result3 = await this.$axios.$post('signature.image.php', formData, {
              headers: {
                  'Content-Type': 'multipart/form-data'
              }
            });
        }
        if(result.message == 'Success' || result2.message == 'Success' || result3.message == 'Success') {
          if(this.userUpdate.userLineToken && (this.user.userLineToken!=this.userUpdate.userLineToken)) {
            await this.$axios.$post('sendline.php', {
              token: this.userUpdate.userLineToken,
              message: 'ระบบอัพเดทการรับการแจ้งเตือนผ่าน Line Notify ของคุณเรียบร้อยแล้ว'
            })
          }
          let msg = result.msg
          if(result2.message == 'Success') {
            msg = result2.msg
          } else if(result3.message == 'Success') {
            msg = result3.msg
          }
          swal({
            title: 'เรียบร้อย',
            text: msg,
            icon: 'success'
          }).then(async ()=> {
            await this.getUser()
            await this.getParty()
            this.updateDialog = false
          })
        } else {
          let msg = ''
          if(result.message != 'Success') {
            msg = result.msg
          } else {
            msg = result2.msg
          }
          swal({
            title: 'ผิดพลาด',
            text: msg,
            icon: 'error'
          }).then(()=> {
            this.updateDialog = false
          })
        }
      }
      this.updateUserProgress = false
    },

    async changePassword() {
      this.changePasswordProgress = true
      if(this.$refs.changePasswordForm.validate()) {
        this.userUpdate.token = this.$store.state.jwtToken
        let result = await this.$axios.$post('user.login.php', {
          token: this.userUpdate.token,
          userName: this.userUpdate.userName,
          userPassword: this.userUpdate.userPasswordOld
        })

        if(result.message == 'Success') {
          let result2 = await this.$axios.$post('user.update.php', this.userUpdate)
          if(result2.message == 'Success') {
            swal({
              title: 'เรียบร้อย',
              text: result2.msg,
              icon: 'success'
            }).then(async ()=> {
              await this.getUser()
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
    },

    showDeleteSignatureDialog(imageName) {
      this.signatureDeleteName = imageName
      this.deleteDialog = true
    },

    async deleteUserSignature() {
        if(this.signatureDeleteName) {
          let formData = new FormData()
          formData.append('token', this.$store.state.jwtToken)
          formData.append('function', 'signatureImageDelete')
          formData.append('signatureImage', this.signatureDeleteName)
          let result = await this.$axios.$post('signature.image.php', formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
          });

          if(result.message == 'Success') {
            swal({
              title: 'สำเร็จ',
              text: result.msg,
              icon: 'success'
            })
            delete this.user.userSignature
            delete this.user.imagePath
            delete this.userUpdate.userSignature
            delete this.userUpdate.imagePath
            this.signature = false
          } else {
            swal({
              title: 'ผิดพลาด',
              text: result.msg,
              icon: 'error'
            })
          }
        }
        this.deleteDialog = false
    },
  },

  watch: {
    async userID() {
      await this.getUser()
      await this.getParty()
    }
  }
}
</script>
