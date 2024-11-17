<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลรหัสบัญชีแยกประภท</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateLedger"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
            <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">รหัสบัญชี</h3>
            <v-text-field
              v-model="updateData.ledgerID"
              label="รหัสบัญชี"
              outlined
              required
              :rules="[
                ()=>!!updateData.ledgerID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="8">
            <h3 class="mb-2 fontBold">ชื่อบัญชี</h3>
            <v-text-field
              v-model="updateData.ledgerName"
              label="ชื่อบัญชี"
              outlined
              required
              :rules="[
                ()=>!!updateData.ledgerName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">สถานุะ</h3>
            <v-switch
              v-model="updateData.ledgerEnable"
              label="สถานะ"
              :true-value="1"
              :false-value="0"
              inset
            ></v-switch>
          </v-col>
        </v-row>
      </v-card-text>
      <v-divider class="green lighten-2"></v-divider>
      <v-card-actions>
        <div class="col-12 text-center">
          <v-btn
            @click="cancelUpdate"
            outlined
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
</template>

<script>
import Swal from 'sweetalert2'
export default {
  props: {
    ledger: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      updateData: {},
      updateProgress: false,
      updateValidate: null,
    }
  },

  async mounted() {
    if(this.ledger) {
      this.updateData = JSON.parse(JSON.stringify(this.ledger))
      this.updateData.OldledgerID = this.updateData.ledgerID
    }
  },

  methods: {
    async updateLedger() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        let result = await this.$axios.$post('ledger.update.php', this.updateData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.updateProgress = false
            this.$emit('getUpdateStatus', {'status': true})
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.updateProgress = false
            this.$emit('getUpdateStatus', {'status': true})
          })
        }
      }
    },

    cancelUpdate() {
      this.$emit('getUpdateStatus', {'status': true})
    }

  },

  watch: {
    async ledger() {
      if(this.ledger) {
        this.updateData = JSON.parse(JSON.stringify(this.ledger))
        this.updateData.OldledgerID = this.updateData.ledgerID
      }
    }
  }
}
</script>
