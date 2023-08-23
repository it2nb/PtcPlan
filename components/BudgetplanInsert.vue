<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มข้อมูลแผนงบประมาณรายรับ ปีงบประมาณ พ.ศ.{{ parseInt(budgetplan.budgetplanYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertBudgetplan"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">หมวดงบประมาณ</h3>
            <v-autocomplete
              v-model="insertData.budgetID"
              label="หมวดงบประมาณ"
              :items="budgets"
              item-text="budgetFullname"
              item-value="budgetID"
              outlined
              required
              :rules="[
                ()=>!!insertData.budgetID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="8">
            <h3 class="mb-2 fontBold">รายการ</h3>
            <v-text-field
              v-model="insertData.budgetplanDes"
              label="รายการ"
              outlined
              required
              :rules="[
                ()=>!!insertData.budgetplanDes || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">ประมาณการรายรับ</h3>
            <v-text-field
              v-model="insertData.budgetplanMoney"
              label="ประมาณการรายรับ (บาท)"
              outlined
              required
              :rules="[
                ()=>!!insertData.budgetplanMoney || 'กรุณากรอกข้อมูล'
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
    budgetplan: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      budgets: [],
      insertData: {},
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.budgetplan) {
      this.insertData = JSON.parse(JSON.stringify(this.budgetplan))
      await this.getBudget()
    }
  },

  methods: {
    async getBudget() {
      let params = {
        token: this.$store.state.jwtToken,
        fn: 'All'
      }
      let result = await this.$axios.$get('budget.php', {params})
      if(result.message == 'Success') {
        this.budgets = JSON.parse(JSON.stringify(result.budget))
      }
    },

    async insertBudgetplan() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        this.insertData.budgetplanMoney = numeral(this.insertData.budgetplanMoney).value()
        let result = await this.$axios.$post('budgetplan.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'budgetplanID': result.budgetplanID})
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
    async budgetplan() {
      if(this.budgetplan) {
        this.insertData = JSON.parse(JSON.stringify(this.budgetplan))
        await this.getBudget()
      }
    }
  }
}
</script>
