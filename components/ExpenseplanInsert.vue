<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มข้อมูลรายการค่าใช้จ่าย ปีงบประมาณ พ.ศ.{{ parseInt(expenseplan.expenseplanYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertExpenseplan"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่าย</h3>
            <v-autocomplete
              v-model="insertData.expenseID"
              label="หมวดค่าใช้จ่าย"
              :items="expenses"
              item-text="expenseName"
              item-value="expenseID"
              outlined
              required
              :rules="[
                ()=>!!insertData.expenseID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="8">
            <h3 class="mb-2 fontBold">รายการ</h3>
            <v-text-field
              v-model="insertData.expenseplanDes"
              label="รายการ"
              outlined
              required
              :rules="[
                ()=>!!insertData.expenseplanDes || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
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
var numeral = require('numeral')
import Swal from 'sweetalert2'
export default {
  props: {
    expenseplan: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      expenses: [],
      // budgetplans: [],
      insertData: {},
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.expenseplan) {
      this.insertData = JSON.parse(JSON.stringify(this.expenseplan))
      await this.getExpense()
      // await this.getBudgetplan()
    }
  },

  methods: {
    async getExpense() {
      let params = {
        token: this.$store.state.jwtToken,
        fn: 'All'
      }
      let result = await this.$axios.$get('expense.php', {params})
      if(result.message == 'Success') {
        this.expenses = JSON.parse(JSON.stringify(result.expense))
      }
    },

    // async getBudgetplan() {
    //   let params = {
    //     token: this.$store.state.jwtToken,
    //     budgetplanYear: this.insertData.expenseplanYear
    //   }
    //   let result = await this.$axios.$get('budgetplan.php', {params})
    //   if(result.message == 'Success') {
    //     this.budgetplans = JSON.parse(JSON.stringify(result.budgetplan))
    //   }
    // },

    async insertExpenseplan() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        let result = await this.$axios.$post('expenseplan.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'expenseplanID': result.expenseplanID})
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
    async expenseplan() {
      if(this.expenseplan) {
        this.insertData = JSON.parse(JSON.stringify(this.expenseplan))
        await this.getExpense()
        // await this.getBudgetplan()
      }
    }
  }
}
</script>
