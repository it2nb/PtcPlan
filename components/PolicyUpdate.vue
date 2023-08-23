<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขนโยบาย ปีงบประมาณ พ.ศ.{{ parseInt(policy.policyYear)+543 }}</span>
    </v-card-title>
    <v-divider class="amber"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updatePolicy"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="10" class="mx-auto">
            <h3 class="mb-2 fontBold">นโยบาย</h3>
            <v-text-field
              v-model="updateData.policyName"
              label="นโยบาย"
              outlined
              dense
              :rules="[
                () => !!updateData.policyName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="10" class="mx-auto">
            <h3 class="mb-2 fontBold">คำอธิบายเพิ่มเติม</h3>
            <v-textarea
              v-model="updateData.policyDetail"
              label="คำอธิบายเพิ่มเติม"
              outlined
              dense
            ></v-textarea>
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
            color="warning"
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
    policy: {
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
    if(this.policy) {
      this.updateData = JSON.parse(JSON.stringify(this.policy))
    }
  },

  methods: {
    async updatePolicy() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true
        this.updateData.policyEnable = 1;

        let result = await this.$axios.$post('policy.update.php', this.updateData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.updateProgress = false
            this.$emit('getUpdateStatus', {'status': true, 'policyID': result.policyID})
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
    async policy() {
      if(this.policy) {
        this.updateData = JSON.parse(JSON.stringify(this.policy))
      }
    }
  }
}
</script>
