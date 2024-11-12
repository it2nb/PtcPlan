<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มเอกสารเผยแพร่</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertData"
    >
      <v-card-text>
        <v-row dense>
            <v-col cols="12">
                <v-text-field
                    id="documentTitle"
                    v-model="document.documentTitle"
                    label="หัวข้อเอกสารเผยแพร่"
                    outlined
                    required
                    :rules="[
                        (documentTitle)=>!!documentTitle || 'กรุณากรอกหัวข้อเอกสารเผยแพร่'
                    ]"
                ></v-text-field>
            </v-col>
            <v-col cols="12">
                <v-select
                    id="documenttypeID"
                    v-model="document.documenttypeID"
                    :items="documenttypes"
                    item-text="documenttypeTitle"
                    item-value="documenttypeID"
                    :disabled="documenttypeID != null"
                    outlined
                    required
                    :rules="[
                        (documenttypeID)=>!!documenttypeID || 'กรุณาเลือกประเภท'
                    ]"
                ></v-select>
            </v-col>
            <v-col cols="12" lg="6">
                <v-text-field
                    id="documentYear"
                    v-model="document.documentYear"
                    type="number"
                    label="ปีงบประมาณ พ.ศ."
                    outlined
                    required
                    :rules="[
                        (documentYear)=>!!documentYear || 'กรุณากรอกปีงบประมาณ พ.ศ.'
                    ]"
                ></v-text-field>
            </v-col>
            <v-col cols="12">
                <v-textarea
                    id="documentDetail"
                    v-model="document.documentDetail"
                    label="รายละเอียด"
                    rows="5"
                    outlined
                ></v-textarea>
            </v-col>
            <v-col cols="12" md="8">
                <v-file-input
                  id="documentFile"
                  v-model="documentFile"
                  ref="documentFile"
                  type="file"
                  accept=".pdf, .PDF"
                  label="ไฟล์เอกสาร"
                  outlined
                ></v-file-input>
            </v-col>
            <!-- <v-col cols="12">
                <v-text-field
                    id="documentLink"
                    v-model="document.documentLink"
                    label="ลิงก์ที่อยู่ เอกสาร คู่มือ (URL)"
                    outlined
                ></v-text-field>
            </v-col> -->
            <v-col cols="12" md="8">
                <v-file-input
                id="documentImage"
                v-model="documentImage"
                ref="documentImage"
                type="file"
                accept="image/jpeg, image/png, image/gif"
                label="ภาพปก"
                outlined
                ></v-file-input>
            </v-col>
            <v-col cols="12" lg="4">
            <div class="border">
                <v-img :src="getImageUrl(this.documentImage)+'?t='+new Date()" v-if="this.documentImage"></v-img>
                <v-img blank blank-color="grey" class="col-12" v-else></v-img>
            </div>
            </v-col>
        </v-row>
      </v-card-text>
      <v-divider class="green lighten-2"></v-divider>
      <v-card-actions>
        <div class="col-12 text-center">
          <v-btn
            outlined
            @click="cancel"
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
    userID: {
      type: String,
      default: null
    },

    documenttypeID: {
      type: String,
      default: null
    }
  },

  data() {
    return {
      document: {
        token: this.$store.state.jwtToken,
        documentTitle: '',
        documentDetail: '',
        documentLink: '',
        documentDateTime: '',
        documenttypeID: '',
        documentYear: '',
        userID: '',
      },
      documentImage: null,
      documentFile: null,
      documenttypes: [],
      insertProgress: false,
    }
  },

  async mounted() {
    await this.getDocumenttypes()
    if(this.documenttypeID) {
      this.document.documenttypeID = this.documenttypeID
    }
    this.insertProgress = false
  },

  methods: {
    async getDocumenttypes() {
      let result = await this.$axios.$get('documenttype.php', {
        params: {
          token: this.$store.state.jwtToken,
          fn: 'All'
        }
      })

      if(result.message == 'Success') {
        this.documenttypes = JSON.parse(JSON.stringify(result.documenttype))
      }
    },

    documentFileChanged(file) {
      //for Multiple image
      if(file) {
        this.documentFile = file;
      } else {
        this.documentFile = null;
      }
    },

    documentImagesChanged(image) {
      //for Multiple image
      if(image) {
        this.documentImage = image;
      } else {
        this.documentImage = null;
      }
    },

    getImageUrl(image) {
      return URL.createObjectURL(image)
    },

    async insertData() {
        await this.$refs.insertForm.validate()
        if(this.insertValidate) {
            this.insertProgress = true
            this.document.userID = this.userID
            this.document.documentYear = parseInt(this.document.documentYear)-543
            this.document.documentDateTime = new Date().toISOString().slice(0, 19).replace('T', ' ')
            this.document.token = this.$store.state.jwtToken

            let result = await this.$axios.$post('document.insert.php', this.document)

            if(result.message == 'Success') {
                if(this.documentFile) {
                    let formData = new FormData()
                    formData.append('token', this.document.token)
                    formData.append('function', 'documentUpload')
                    formData.append('documentID', result.documentID)
                    formData.append('document', this.documentFile)
                    await this.$axios.$post('document.doc.php', formData, {
                        headers: {
                            'Content-Type': 'multipart/form-data'
                        }
                    }).then(async result2=>{
                        if(result2.message=='Success') {
                            this.document.documentID = result.documentID
                            this.document.documentLink = result2.document
                            await this.$axios.$post('document.update.php', this.document)
                        }
                    });
                }
                if(this.documentImage) {
                    let formData = new FormData()
                    formData.append('token', this.document.token)
                    formData.append('function', 'documentImageUpload')
                    formData.append('documentID', result.documentID)
                    formData.append('documentImage', this.documentImage)
                    await this.$axios.$post('document.image.php', formData, {
                        headers: {
                            'Content-Type': 'multipart/form-data'
                        }
                    });
                }
                Swal.fire({
                    title: 'สำเร็จ',
                    text: result.msg,
                    icon: 'success'
                })
                this.$emit('getStatus', {'status': true})
            } else {
                Swal.fire({
                    title: 'ผิดพลาด',
                    text: result.msg,
                    icon: 'error'
                })
                this.$emit('getStatus', {'status': false})
            }
            this.insertProgress = false
        }
    },

    cancel() {
      this.insertProgress = false
      this.$emit('getStatus', {'status': false})
    }
  },
}
</script>
