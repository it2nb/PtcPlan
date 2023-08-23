<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขหัวข้อย่อยของนโยบาย ปีงบประมาณ พ.ศ.{{ parseInt(strategy.strategyYear)+543 }}</span>
    </v-card-title>
    <v-divider class="amber"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateStrategy"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" class="mx-auto">
            <h3 class="mb-2 fontBold">นโยบาย</h3>
            <v-text-field
              v-model="updateData.policyName"
              label="นโยบาย"
              outlined
              dense
              readonly
            ></v-text-field>
          </v-col>
          <v-col cols="12" class="mx-auto">
            <h3 class="mb-2 fontBold">ชื่อหัวข้อหลัก</h3>
            <v-text-field
              v-model="updateData.strategicName"
              label="ชื่อหัวข้อหลัก"
              outlined
              dense
              readonly
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="2" class="mx-auto">
            <h3 class="mb-2 fontBold">หัวข้อที่</h3>
            <v-text-field
              v-model="updateData.strategyNum"
              label="หัวข้อที่"
              type="number"
              outlined
              dense
              :rules="[
                () => !!updateData.strategyNum || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="10" class="mx-auto">
            <h3 class="mb-2 fontBold">ชื่อหัวข้อย่อย</h3>
            <v-text-field
              v-model="updateData.strategyName"
              label="ชื่อหัวข้อหลัก"
              outlined
              dense
              :rules="[
                () => !!updateData.strategyName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" class="mx-auto">
            <h3 class="mb-2 fontBold">คำอธิบายเพิ่มเติม</h3>
            <v-textarea
              v-model="updateData.strategyDetail"
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
    strategy: {
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
    if(this.strategy) {
      this.updateData = JSON.parse(JSON.stringify(this.strategy))
    }
  },

  methods: {
    async updateStrategy() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        let result = await this.$axios.$post('strategy.update.php', this.updateData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.updateProgress = false
            this.$emit('getUpdateStatus', {'status': true, 'strategyID': result.strategyID})
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
    async strategy() {
      if(this.strategy) {
        this.updateData = JSON.parse(JSON.stringify(this.strategy))
      }
    }
  }
}
</script>
