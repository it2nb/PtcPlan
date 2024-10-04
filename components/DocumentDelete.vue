<template>
  <v-card>
    <v-card-title class="red lighten-2">
      <span class="fontBold">ลบข้อมูลเอกสารเผยแพร่</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="deleteValidate"
      ref="deleteForm"
      lazy-validation
      @submit.prevent="deleteData"
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
                    readonly
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
                    readonly
                ></v-select>
            </v-col>
            <v-col cols="12">
                <v-text-field
                    id="documentYear"
                    v-model="document.documentYear"
                    type="number"
                    label="ปีงบประมาณ พ.ศ."
                    outlined
                    required
                    readonly
                ></v-text-field>
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
            v-if="deleteProgress"
          ></v-progress-circular>
          <v-btn
            type="submit"
            color="red darken-1"
            dark
            large
            v-else
          >
            ลบ
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
      documentCover: null,
      documenttypes: [],
      deleteProgress: false,
      deleteValidate: null
    }
  },

  async mounted() {
    await this.getDocumenttypes()
    this.document.token = this.$store.state.jwtToken
    this.document.documentYear = (parseInt(this.document.documentYear)+543).toString()
    this.documentCover = this.document.documentCover
    this.deleteProgress = false
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

    async deleteData() {
      this.deleteProgress = true
      this.document.token = this.$store.state.jwtToken

      let result = await this.$axios.$post('document.delete.php', this.document)

      if(result.message == 'Success') {
        if(this.document.documentLink) {
          await this.deleteFile(this.document.documentLink)
        }
        if(this.document.documentCover) {
          await this.deleteImage(this.document.documentCover)
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
      this.deleteProgress = false
    },

    cancel() {
      this.deleteProgress = false
      this.$emit('getStatus', {'status': false})
    }
  },
}
</script>
