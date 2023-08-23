<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มงบประมาณโครงการ</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertPjbudget"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">กิจกรรมย่อย</h3>
            <v-select
              v-model="insertData.pjsubactivityID"
              label="กิจกรรมย่อย"
              :items="pjsubactivities"
              item-text="pjsubactivityFullname"
              item-value="pjsubactivityID"
              outlined
              dense
              :rules="[
                () => !!insertData.pjsubactivityID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-select>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่าย</h3>
            <v-select
              v-model="insertData.expenseID"
              label="หมวดค่าใช้จ่าย"
              :items="expenses"
              item-text="expenseName"
              item-value="expenseID"
              outlined
              dense
              :rules="[
                () => !!insertData.expenseID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-select>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">หมวดงบประมาณ</h3>
            <v-select
              v-model="insertData.budgetplanID"
              label="หมวดงบประมาณ"
              :items="budgetplans"
              item-text="budgetplanDes"
              item-value="budgetplanID"
              outlined
              dense
              :rules="[
                () => !!insertData.budgetplanID || 'กรุณากรอกข้อมูล'
              ]"
            >
              <template v-slot:item="{ item }">
                <div class="col-12 py-2">
                  <div class="body-2">{{ item.budgetFullname }}</div>
                  <div>{{ item.budgetplanDes }}</div>
                  <v-divider class="my-1"></v-divider>
                </div>
              </template>
            </v-select>
          </v-col>
          <v-col cols="12" md="9">
            <h3 class="mb-2 fontBold">รายการ</h3>
            <v-text-field
              v-model="insertData.pjbudgetName"
              label="รายการ"
              outlined
              dense
              :rules="[
                () => !!insertData.pjbudgetName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <!-- <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">จำนวน</h3>
            <v-text-field
              v-model="insertData.pjbudgetQty"
              label="จำนวน"
              type="number"
              outlined
              dense
              :rules="[
                () => !!insertData.pjbudgetQty || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">หน่วยนับ</h3>
            <v-text-field
              v-model="insertData.pjbudgetUnit"
              label="หน่วยนับ"
              outlined
              dense
              :rules="[
                () => !!insertData.pjbudgetUnit || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col> -->
          <v-col cols="12" md="3">
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            <v-text-field
              v-model="insertData.pjbudgetMoney"
              label="จำนวนเงิน"
              outlined
              dense
              :rules="[
                () => !!insertData.pjbudgetMoney || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">รายละเอียดเพิ่มเติม</h3>
            <v-textarea
              v-model="insertData.pjbudgetComment"
              label="รายละเอียดเพิ่มเติม"
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
var numeral = require('numeral')
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
      expenses: [],
      budgetplans: [],
      pjsubactivities: [],
      insertData: {},
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.pjbudget) {
      this.insertData = JSON.parse(JSON.stringify(this.pjbudget))
      await this.getSubactivity()
      await this.getExpenses()
      await this.getBudgetplan()
    }
  },

  methods: {
    async getExpenses() {
      let params = {
        token: this.$store.state.jwtToken,
        fn: 'All'
      }
      let result = await this.$axios.$get('expense.php', {params})
      if(result.message == 'Success') {
        this.expenses = JSON.parse(JSON.stringify(result.expense))
      }
    },

    async getBudgetplan() {
      let params = {
        token: this.$store.state.jwtToken,
        budgetplanYear: this.insertData.projectYear
      }

      let result = await this.$axios.$get('budgetplan.php', {params})

      if(result.message == 'Success') {
        this.budgetplans = JSON.parse(JSON.stringify(result.budgetplan))
      }
    },

    async getSubactivity() {
      let params = {
        token: this.$store.state.jwtToken,
        projectID: this.pjbudget.projectID
      }
      let result = await this.$axios.$get('pjsubactivity.php', {params})

      if(result.message == 'Success') {
        this.pjsubactivities = JSON.parse(JSON.stringify(result.pjsubactivity))
      }
    },

    async insertPjbudget() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        this.insertData.pjbudgetQty = 1
        this.insertData.pjbudgetUnit = "รายการ"
        this.insertData.pjbudgetMoney = numeral(this.insertData.pjbudgetMoney).value()
        let result = await this.$axios.$post('pjbudget.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'pjbudgetID': result.pjbudgetID})
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
    async pjbudget() {
      if(this.pjbudget) {
        this.insertData = JSON.parse(JSON.stringify(this.pjbudget))
        await this.getSubactivity()
        await this.getExpenses()
        await this.getBudgetplan()
      }
    }
  }
}
</script>
