<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มข้อมูลแผนงบประมาณรายจ่าย</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertExpensebudget"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่าย</h3>
            {{ insertData.expenseName }}
          </v-col>
          <v-col cols="12" md="8">
            <h3 class="mb-2 fontBold">รายการ</h3>
            {{ insertData.expenseplanDes }}
          </v-col>
          <v-col cols="12" md="8">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายรับ</h3>
            <v-autocomplete
              v-model="insertData.budgetplanID"
              label="หมวดงบประมาณรายรับ"
              :items="budgetplans"
              item-text="budgetplanDes"
              item-value="budgetplanID"
              outlined
              required
              :rules="[
                ()=>!!insertData.budgetplanID || 'กรุณากรอกข้อมูล'
              ]"
            >
              <template v-slot:item="{ item }">
                <div class="col-12 py-2">
                  <div class="body-2">{{ item.budgetFullname }}</div>
                  <div>{{ item.budgetplanDes }}</div>
                  <v-divider class="my-1"></v-divider>
                </div>
              </template>
            </v-autocomplete>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">ประมาณการรายจ่าย(บาท)</h3>
            <v-text-field
              v-model="insertData.expenseplanMoney"
              label="ประมาณการรายจ่าย"
              outlined
              required
              :rules="[
                ()=>!!insertData.expenseplanMoney || 'กรุณากรอกข้อมูล'
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
    expensebudget: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      budgetplans: [],
      insertData: {},
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.expensebudget) {
      this.insertData = JSON.parse(JSON.stringify(this.expensebudget))
      await this.getBudgetplan()
    }
  },

  methods: {

    async getBudgetplan() {
      let params = {
        token: this.$store.state.jwtToken,
        budgetplanYear: this.insertData.expenseplanYear
      }
      let result = await this.$axios.$get('budgetplan.php', {params})
      if(result.message == 'Success') {
        this.budgetplans = JSON.parse(JSON.stringify(result.budgetplan))
      }
    },

    async insertExpensebudget() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        this.insertData.expenseplanMoney = numeral(this.insertData.expenseplanMoney).value()
        let result = await this.$axios.$post('expensebudget.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'expensebudgetID': result.expensebudgetID})
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
    async expensebudget() {
      if(this.expensebudget) {
        this.insertData = JSON.parse(JSON.stringify(this.expensebudget))
        await this.getBudgetplan()
      }
    }
  }
}
</script>
