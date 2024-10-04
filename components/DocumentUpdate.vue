<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลเอกสารเผยแพร่</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateData"
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
            <v-col cols="12" md="4" class="pb-5 text-center" v-if="document.documentLink">
               <v-icon color="red darken-3">fas fa-file-pdf</v-icon> {{ document.documentLink.replace(/^.*[\\/]/, '') }}
               <v-btn color="error" small class="m-1" @click="deleteDocumentFile">
                    <v-icon small>fas fa-trash</v-icon>
                </v-btn>
            </v-col>
            <!-- <v-col cols="12">
                <v-text-field
                    id="documentLink"
                    v-model="document.documentLink"
                    label="ลิงก์ที่อยู่ เอกสาร คู่มือ (URL)"
                    outlined
                    rounded
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
                <div class="border text-right">
                    <v-img :src="getImageUrl(this.documentImage)" v-if="this.documentImage"></v-img>
                    <div v-else-if="documentCover">
                    <v-img :src="this.document.documentCoverPath+this.document.documentCover" ></v-img>
                    <v-btn color="error" small class="m-1" @click="deleteDocumentImg">
                        <v-icon small>fas fa-trash</v-icon>
                    </v-btn>
                    </div>
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
            v-if="updateProgress"
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
    document: {
      type: Object,
      default: ()=>{}
    },
    documenttypeID: {
      type: String,
      default: null
    }
  },

  data() {
    return {
      documentImage: null,
      documentFile: null,
      documentCover: null,
      documenttypes: [],
      updateValidate: null,
      updateProgress: false,
    }
  },

  async mounted() {
    await this.getDocumenttypes()
    this.document.token = this.$store.state.jwtToken
    this.document.documentYear = this.document.documentYearBd
    this.documentCover = this.document.documentCover
    this.updateProgress = false
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

    documentImagesChanged(image) {
      //for Multiple image
      if(image) {
        this.documentImage = image;
      } else {
        this.documentImage = null;
      }
    },

    documentFilesChanged(file) {
      //for Multiple image
      if(file) {
        this.documentFile = file;
      } else {
        this.documentFile = null;
      }
    },

    getImageUrl(image) {
      return URL.createObjectURL(image)
    },

    async deleteFile(documentLink) {
      let formData = new FormData()
      formData.append('token', this.$store.state.jwtToken)
      formData.append('function', 'documentDELETE')
      formData.append('document', documentLink)
      await this.$axios.$post('document.doc.php', formData)
    },

    async deleteImage(documentImage) {
      let formData = new FormData()
      formData.append('token', this.$store.state.jwtToken)
      formData.append('function', 'documentImageDELETE')
      formData.append('documentImage', documentImage)
      await this.$axios.$post('document.image.php', formData)
    },

    async updateData() {
        await this.$refs.updateForm.validate()
        if(this.updateValidate) {
            this.updateProgress = true
            this.document.documentYear = parseInt(this.document.documentYear)-543
            this.document.documentDateTime = new Date().toISOString().slice(0, 19).replace('T', ' ')
            this.document.token = this.$store.state.jwtToken

            let result = await this.$axios.$post('document.update.php', this.document)

            let imgresult = {message: null}

            if(this.documentFile) {
                if(this.document.documentLink) {
                  await this.deleteFile(this.document.documentLink)
                }
                let formData = new FormData()
                formData.append('token', this.document.token)
                formData.append('function', 'documentUpload')
                formData.append('documentID', this.document.documentID)
                formData.append('document', this.documentFile)
                await this.$axios.$post('document.doc.php', formData, {
                    headers: {
                        'Content-Type': 'multipart/form-data'
                    }
                }).then(async result2=>{
                    if(result2.message=='Success') {
                        this.document.documentID = this.document.documentID
                        this.document.documentLink = result2.document
                        await this.$axios.$post('document.update.php', this.document)
                    }
                });
            }

            if(this.documentImage) {
                if(this.document.documentCover) {
                  await this.deleteImage(this.document.documentCover)
                }
                let formData = new FormData()
                formData.append('token', this.document.token)
                formData.append('function', 'documentImageUpload')
                formData.append('documentID', this.document.documentID)
                formData.append('documentImage', this.documentImage)
                imgresult = await this.$axios.$post('document.image.php', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
                })
            }

            if(result.message == 'Success' || imgresult.message == 'Success') {

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
            this.updateProgress = false
        }
    },

    async deleteDocumentFile() {
      Swal.fire({
        title: 'ยืนยันการลบไฟล์เอกสารเผยแพร่',
        text: 'คุณแน่ใจที่จะลบไฟล์เอกสารนี้นี้ ?',
        showCancelButton: true,
        confirmButtonText: 'ยืนยัน',
        cancelButtonText: 'ยกเลิก',
        icon: 'warning'
      }).then(async (result) => {
        if(result.isConfirmed) {
          await this.deleteFile(this.document.documentLink)
          this.document.documentYear = parseInt(this.document.documentYear)-543
          this.document.documentDateTime = new Date().toISOString().slice(0, 19).replace('T', ' ')
          this.document.token = this.$store.state.jwtToken
          this.document.documentLink = null
          let update =await this.$axios.$post('document.update.php', this.document)
          this.documentFile = null
          this.$emit('getStatus', {'status': true})
        }
      })
    },

    async deleteDocumentImg() {
      Swal.fire({
        title: 'ยืนยันการลบภาพปก',
        text: 'คุณแน่ใจที่จะลบภาพปกนี้ ?',
        showCancelButton: true,
        confirmButtonText: 'ยืนยัน',
        cancelButtonText: 'ยกเลิก',
        icon: 'warning'
      }).then(async (result) => {
        if(result.isConfirmed) {
          await this.deleteImage(this.document.documentCover)
          this.documentCover = null
        }
      })
    },

    cancel() {
      this.updateProgress = false
      this.$emit('getStatus', {'status': false})
    }
  },
}
</script>
