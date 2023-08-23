<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มนโยบาย ปีงบประมาณ พ.ศ.{{ parseInt(policy.policyYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertPolicy"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="10" class="mx-auto">
            <h3 class="mb-2 fontBold">นโยบาย</h3>
            <v-text-field
              v-model="insertData.policyName"
              label="นโยบาย"
              outlined
              dense
              :rules="[
                () => !!insertData.policyName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="10" class="mx-auto">
            <h3 class="mb-2 fontBold">คำอธิบายเพิ่มเติม</h3>
            <v-textarea
              v-model="insertData.policyDetail"
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
            @click="cancelInsert"
            outlined
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
    policy: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      insertData: {},
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.policy) {
      this.insertData = JSON.parse(JSON.stringify(this.policy))
    }
  },

  methods: {
    async insertPolicy() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        this.insertData.policyEnable = 1;

        let result = await this.$axios.$post('policy.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'policyID': result.policyID})
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true})
          })
        }
      }
    },

    cancelInsert() {
      this.$emit('getInsertStatus', {'status': true})
    }

  },

  watch: {
    async policy() {
      if(this.policy) {
        this.insertData = JSON.parse(JSON.stringify(this.policy))
      }
    }
  }
}
</script>
