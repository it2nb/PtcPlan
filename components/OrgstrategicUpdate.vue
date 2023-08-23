<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลยุทธศาสตร์ของสถานศึกษา ปีงบประมาณ พ.ศ.{{ parseInt(orgstrategic.orgstrategicYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateOrgstrategic"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">ยุทธศาสตร์ที่</h3>
            <v-text-field
              v-model="updateData.orgstrategicNum"
              label="ยุทธศาสตร์ที่"
              type="number"
              outlined
              required
              :rules="[
                ()=>!!updateData.orgstrategicNum || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="10">
            <h3 class="mb-2 fontBold">ชื่อยุทธศาสตร์</h3>
            <v-text-field
              v-model="updateData.orgstrategicName"
              label="ชื่อยุทธศาสตร์"
              outlined
              required
              :rules="[
                ()=>!!updateData.orgstrategicName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">คำอธิบาย</h3>
            <v-textarea
              v-model="updateData.orgstrategicDetail"
              label="คำอธิบาย"
              outlined
            ></v-textarea>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">สถานุะ</h3>
            <v-switch
              v-model="updateData.orgstrategicEnable"
              label="สถานะ"
              true-value="1"
              false-value="0"
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
    orgstrategic: {
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
    if(this.orgstrategic) {
      this.updateData = JSON.parse(JSON.stringify(this.orgstrategic))
    }
  },

  methods: {
    async updateOrgstrategic() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        let result = await this.$axios.$post('orgstrategic.update.php', this.updateData)

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
    async orgstrategic() {
      if(this.orgstrategic) {
        this.updateData = JSON.parse(JSON.stringify(this.orgstrategic))
      }
    }
  }
}
</script>
