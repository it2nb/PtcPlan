<template>
  <v-card>
    <v-card-title class="red lighten-2">
      <span class="fontBold">ลบข้อมูลแผนงบประมาณรายจ่าย</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="deleteValidate"
      ref="deleteForm"
      lazy-validation
      @submit.prevent="deleteExpensebudget"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่าย</h3>
            {{ deleteData.expenseName }}
          </v-col>
          <v-col cols="12" md="8">
            <h3 class="mb-2 fontBold">รายการ</h3>
            {{ deleteData.expenseplanDes }}
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายรับ</h3>
            {{ deleteData.budgetName }} : {{ deleteData.budgetplanDes }}
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">ประมาณการรายจ่าย</h3>
            {{ deleteData.expenseplanMoney }} บาท
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
    expensebudget: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      budget: {},
      deleteData: {},
      deleteProgress: false,
      deleteValidate: null,
    }
  },

  async mounted() {
    if(this.expensebudget) {
      this.deleteData = JSON.parse(JSON.stringify(this.expensebudget))
    }
  },

  methods: {
    async deleteExpensebudget() {
      await this.$refs.deleteForm.validate()
      if(this.deleteValidate) {
        this.deleteProgress = true

        let result = await this.$axios.$post('expensebudget.delete.php', this.deleteData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.deleteProgress = false
            this.$emit('getDeleteStatus', {'status': true})
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
    async expensebudget() {
      if(this.expensebudget) {
        this.deleteData = JSON.parse(JSON.stringify(this.expensebudget))
      }
    }
  }
}
</script>
