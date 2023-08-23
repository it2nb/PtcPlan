<template>
  <v-card>
    <v-card-title class="red lighten-2">
      <span class="fontBold">ลบงบประมาณโครงการ</span>
    </v-card-title>
    <v-divider class="amber"></v-divider>
    <v-form
      v-model="deleteValidate"
      ref="deleteForm"
      lazy-validation
      @submit.prevent="deletePjbudget"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">กิจกรรมย่อย</h3>
            {{ deleteData.pjsubactivityName }}
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่าย</h3>
            {{ deleteData.expenseName }}
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดงบประมาณ</h3>
            {{ deleteData.budgetName}} : {{ deleteData.budgetplanDes}}
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">รายการ</h3>
            {{ deleteData.pjbudgetName }}
          </v-col>
          <!-- <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">จำนวน</h3>
            {{ deleteData.pjbudgetQty }}
          </v-col>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">หน่วยนับ</h3>
            {{ deleteData.pjbudgetUnit }}
          </v-col> -->
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            {{ deleteData.pjbudgetMoney }}
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">รายละเอียดเพิ่มเติม</h3>
            <pre>{{ deleteData.pjbudgetComment }}</pre>
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
    pjbudget: {
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
    if(this.pjbudget) {
      this.deleteData = JSON.parse(JSON.stringify(this.pjbudget))
    }
  },

  methods: {
    async deletePjbudget() {
      await this.$refs.deleteForm.validate()
      if(this.deleteValidate) {
        this.deleteProgress = true

        let result = await this.$axios.$post('pjbudget.delete.php', this.deleteData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.deleteProgress = false
            this.$emit('getDeleteStatus', {'status': true, 'pjbudgetID': result.pjbudgetID})
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
    async pjbudget() {
      if(this.pjbudget) {
        this.deleteData = JSON.parse(JSON.stringify(this.pjbudget))
      }
    }
  }
}
</script>
