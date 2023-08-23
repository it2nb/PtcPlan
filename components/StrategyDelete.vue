<template>
  <v-card>
    <v-card-title class="red lighten-2">
      <span class="fontBold">ลบหัวข้อย่อยของนโยบาย ปีงบประมาณ พ.ศ.{{ parseInt(strategy.strategyYear)+543 }}</span>
    </v-card-title>
    <v-divider class="red"></v-divider>
    <v-form
      v-model="deleteValidate"
      ref="deleteForm"
      lazy-validation
      @submit.prevent="deleteStrategy"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="10" class="mx-auto">
            <h3 class="mb-2 fontBold">นโยบาย</h3>
            {{ deleteData.policyName }}
          </v-col>
          <v-col cols="12" md="10" class="mx-auto">
            <h3 class="mb-2 fontBold">ชื่อหัวข้อหลัก</h3>
            {{ deleteData.strategicName }}
          </v-col>
          <v-col cols="12" md="10" class="mx-auto">
            <h3 class="mb-2 fontBold">หัวข้อที่</h3>
            {{ deleteData.strategyNum }}. {{ deleteData.strategyName }}
          </v-col>
          <v-col cols="12" md="10" class="mx-auto">
            <h3 class="mb-2 fontBold">คำอธิบายเพิ่มเติม</h3>
            <pre class="fontPrompt">{{ deleteData.strategyDetail }}</pre>
          </v-col>
        </v-row>
      </v-card-text>
      <v-divider class="green lighten-2"></v-divider>
      <v-card-actions>
        <div class="col-12 text-center">
          <v-btn
            @click="cancelDelete"
            outlined
          >
            ยกเลิก
          </v-btn>
          <v-progress-circular
            indeterminate
            color="error"
            v-if="deleteProgress"
          ></v-progress-circular>
          <v-btn
            type="submit"
            color="error darken-1"
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
    strategy: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      deleteData: {},
      deleteProgress: false,
      deleteValidate: null,
    }
  },

  async mounted() {
    if(this.strategy) {
      this.deleteData = JSON.parse(JSON.stringify(this.strategy))
    }
  },

  methods: {
    async deleteStrategy() {
      await this.$refs.deleteForm.validate()
      if(this.deleteValidate) {
        this.deleteProgress = true

        let result = await this.$axios.$post('strategy.delete.php', {
          token: this.deleteData.token,
          strategyID: this.deleteData.strategyID
        })

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.deleteProgress = false
            this.$emit('getDeleteStatus', {'status': true, 'strategyID': result.strategyID})
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.deleteProgress = false
            this.$emit('getDeleteStatus', {'status': true})
          })
        }
      }
    },

    cancelDelete() {
      this.$emit('getDeleteStatus', {'status': true})
    }

  },

  watch: {
    async strategy() {
      if(this.strategy) {
        this.deleteData = JSON.parse(JSON.stringify(this.strategy))
      }
    }
  }
}
</script>
