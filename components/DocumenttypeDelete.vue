<template>
  <v-card>
    <v-card-title class="red lighten-2">
      <span class="fontBold">ลบข้อมูลประเภทเอกสารเผยแพร่</span>
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
                    id="documenttypeTitle"
                    v-model="documenttype.documenttypeTitle"
                    label="หัวข้อประเภทเอกสารเผยแพร่"
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
    documenttype: {
      type: Object,
      default: ()=>{}
    }
  },

  data() {
    return {
      deleteProgress: false,
    }
  },

  async mounted() {
    this.documenttype.token = this.$store.state.jwtToken
    this.deleteProgress = false
  },

  methods: {
    async deleteData() {
      this.deleteProgress = true
      this.documenttype.token = this.$store.state.jwtToken

      let result = await this.$axios.$post('documenttype.delete.php', this.documenttype)

      if(result.message == 'Success') {
        await this.$axios.$post('document.delete.php', this.documenttype)

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
