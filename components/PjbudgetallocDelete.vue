<template>
  <v-card>
    <v-card-title class="red lighten-2">
      <span class="fontBold">ลบผู้ใช้งบโครงการ</span>
    </v-card-title>
    <v-divider class="amber"></v-divider>
    <v-form
      v-model="deleteValidate"
      ref="deleteForm"
      lazy-validation
      @submit.prevent="deletePjbudgetalloc"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">แผนก/งาน</h3>
            {{ deleteData.departmentName }}
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่าย</h3>
            {{ deleteData.expenseName }}
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            {{ deleteData.pjbudgetallocMoney }}
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">หมายเหตุ</h3>
            <pre class="fontPrompt">{{ deleteData.pjbudgetallocDes }}</pre>
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
            color="success"
            v-if="deleteProgress"
          ></v-progress-circular>
          <v-btn
            type="submit"
            color="red darken-1"
            large
            dark
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
    pjbudgetalloc: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      expense: {},
      budget: {},
      pjsubactivity: {},
      deleteData: {},
      deleteProgress: false,
      deleteValidate: null,
    }
  },

  async mounted() {
    if(this.pjbudgetalloc) {
      this.deleteData = JSON.parse(JSON.stringify(this.pjbudgetalloc))
    }
  },

  methods: {
    async deletePjbudgetalloc() {
      await this.$refs.deleteForm.validate()
      if(this.deleteValidate) {
        this.deleteProgress = true

        let result = await this.$axios.$post('pjbudgetalloc.delete.php', this.deleteData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.deleteProgress = false
            this.$emit('getDeleteStatus', {'status': true, 'pjbudgetallocID': result.pjbudgetallocID})
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
    },

    thaiDate(inDate) {
      let result = ''
      if(inDate) {
        let thdate = new Date(inDate)
        result = thdate.toLocaleDateString('th-TH', {
          year: 'numeric',
          month: 'long',
          day: 'numeric',
        })
      }
      return result
    }

  },

  watch: {
    async pjbudgetalloc() {
      if(this.pjbudgetalloc) {
        this.deleteData = JSON.parse(JSON.stringify(this.pjbudgetalloc))
      }
    }
  }
}
</script>
