<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มประเภทเอกสารเผยแพร่</span>
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
                    id="documenttypeTitle"
                    v-model="documenttype.documenttypeTitle"
                    label="หัวข้อประเภทเอกสารแผยแพร่"
                    outlined
                    required
                    :rules="[
                        (documenttypeTitle)=>!!documenttypeTitle || 'กรุณากรอกหัวข้อประเภทเอกสาร'
                    ]"
                ></v-text-field>
            </v-col>
            <v-col cols="12">
                <v-textarea
                    id="documenttypeDetail"
                    v-model="documenttype.documenttypeDetail"
                    label="รายละเอียด"
                    rows="5"
                    outlined
                ></v-textarea>
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
    }
  },

  data() {
    return {
      documenttype: {
        token: this.$store.state.jwtToken,
        documenttypeTitle: '',
        documenttypeDetail: '',
      },
      insertProgress: false,
    }
  },

  async mounted() {
    this.insertProgress = false
  },

  methods: {
    async insertData() {
        await this.$refs.insertForm.validate()
        if(this.insertValidate) {
            this.insertProgress = true
            this.documenttype.token = this.$store.state.jwtToken

            let result = await this.$axios.$post('documenttype.insert.php', this.documenttype)

            if(result.message == 'Success') {
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
  }
}
</script>
