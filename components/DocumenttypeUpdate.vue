<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลประเภทเอกสารเผยแพร่</span>
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
                    id="documenttypeTitle"
                    v-model="documenttype.documenttypeTitle"
                    label="หัวข้อประเภทเอกสารเผยแพร่"
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
    documenttype: {
      type: Object,
      default: ()=>{}
    }
  },

  data() {
    return {
      updateProgress: false,
    }
  },

  async mounted() {
    this.documenttype.token = this.$store.state.jwtToken
    this.updateProgress = false
  },

  methods: {
    async updateData() {
        await this.$refs.updateForm.validate()
        if(this.updateValidate) {
            this.updateProgress = true
            this.documenttype.token = this.$store.state.jwtToken

            let result = await this.$axios.$post('documenttype.update.php', this.documenttype)

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
            this.updateProgress = false
        }
    },

    cancel() {
      this.updateProgress = false
      this.$emit('getStatus', {'status': false})
    }
  },
}
</script>
