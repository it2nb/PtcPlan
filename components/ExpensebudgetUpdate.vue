<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลแผนงบประมาณรายจ่าย </span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateExpensebudget"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่าย</h3>
            {{ updateData.expenseName }}
          </v-col>
          <v-col cols="12" md="8">
            <h3 class="mb-2 fontBold">รายการ</h3>
            {{ updateData.expenseplanDes }}
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายรับ</h3>
            {{ updateData.budgetName }} : {{ updateData.budgetplanDes }}
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">ประมาณการรายจ่าย(บาท)</h3>
            <v-text-field
              v-model="updateData.expenseplanMoney"
              label="ประมาณการรายจ่าย"
              outlined
              required
              :rules="[
                ()=>!!updateData.expenseplanMoney || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
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
var numeral = require('numeral')
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
      budgetplans: [],
      expensealloc: {},
      updateData: {},
      updateProgress: false,
      updateValidate: null,
    }
  },

  async mounted() {
    if(this.expensebudget) {
      this.updateData = JSON.parse(JSON.stringify(this.expensebudget))
      await this.getBudgetplan()
      await this.getExpensealloc()
    }
  },

  methods: {
    async getBudgetplan() {
      let params = {
        token: this.$store.state.jwtToken,
        budgetplanYear: this.updateData.expenseplanYear
      }
      let result = await this.$axios.$get('budgetplan.php', {params})
      if(result.message == 'Success') {
        this.budgetplans = JSON.parse(JSON.stringify(result.budgetplan))
      }
    },

    async getExpensealloc() {
      let params = {
        token: this.$store.state.jwtToken,
        expenseplanID: this.updateData.expenseplanID,
        budgetplanID: this.updateData.budgetplanID,
        fn: 'getSummaryByExpenseplanIDBudgetplanID'
      }
      let result = await this.$axios.$get('expensealloc.php', {params})
      if(result.message == 'Success') {
        this.expensealloc = JSON.parse(JSON.stringify(result.expensealloc))
        console.log(this.expensealloc)
      }
    },

    async updateExpensebudget() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true
        this.updateData.expenseplanMoney = numeral(this.updateData.expenseplanMoney).value()
        if(parseFloat(this.updateData.expenseplanMoney)>=parseFloat(this.expensealloc.expenseallocMoney)) {
          let result = await this.$axios.$post('expensebudget.update.php', this.updateData)

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
        } else {
          Swal.fire({
              title: 'ข้อมูลผิดพลาด',
              text: 'งบประมาณที่ตั้งนี้ไม่เพียงพอกับยอดเงินจัดสรรไว้แล้ว',
              icon: 'warning'
          }).then(()=>{
            this.updateProgress = false
          })
        }
      }
    },

    cancelUpdate() {
      this.$emit('getUpdateStatus', {'status': true})
    }

  },

  watch: {
    async expensebudget() {
      if(this.expensebudget) {
        this.updateData = JSON.parse(JSON.stringify(this.expensebudget))
        await this.getBudgetplan()
        await this.getExpensealloc()
      }
    }
  }
}
</script>
