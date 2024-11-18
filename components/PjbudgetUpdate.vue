<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขงบประมาณโครงการ</span>
    </v-card-title>
    <v-divider class="amber"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updatePjbudget"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">กิจกรรมย่อย</h3>
            <v-autocomplete
              v-model="updateData.pjsubactivityID"
              label="กิจกรรมย่อย"
              :items="pjsubactivities"
              item-text="pjsubactivityFullname"
              item-value="pjsubactivityID"
              outlined
              dense
              :rules="[
                () => !!updateData.pjsubactivityID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่าย</h3>
            <v-autocomplete
              v-model="updateData.expenseID"
              label="หมวดค่าใช้จ่าย"
              :items="expenses"
              item-text="expenseName"
              item-value="expenseID"
              outlined
              dense
              :readonly="updateData.disburseMoney>0"
              :rules="[
                () => !!updateData.expenseID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">หมวดงบประมาณ</h3>
            <v-autocomplete
              v-model="updateData.budgetplanID"
              label="หมวดงบประมาณ"
              :items="budgetplans"
              item-text="budgetplanDes"
              item-value="budgetplanID"
              outlined
              dense
              :readonly="updateData.disburseMoney>0"
              :rules="[
                () => !!updateData.budgetplanID || 'กรุณากรอกข้อมูล'
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
          <v-col cols="12" md="9">
            <h3 class="mb-2 fontBold">รายการ</h3>
            <v-text-field
              v-model="updateData.pjbudgetName"
              label="รายการ"
              outlined
              dense
              :rules="[
                () => !!updateData.pjbudgetName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <!-- <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">จำนวน</h3>
            <v-text-field
              v-model="updateData.pjbudgetQty"
              label="จำนวน"
              type="number"
              outlined
              dense
              :rules="[
                () => !!updateData.pjbudgetQty || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">หน่วยนับ</h3>
            <v-text-field
              v-model="updateData.pjbudgetUnit"
              label="หน่วยนับ"
              outlined
              dense
              :rules="[
                () => !!updateData.pjbudgetUnit || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col> -->
          <v-col cols="12" md="3">
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            <v-text-field
              v-model="updateData.pjbudgetMoney"
              label="จำนวนเงิน"
              outlined
              dense
              :rules="[
                () => !!updateData.pjbudgetMoney || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">รายละเอียดเพิ่มเติม</h3>
            <v-textarea
              v-model="updateData.pjbudgetComment"
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
      updateData: {},
      updateProgress: false,
      updateValidate: null,
    }
  },

  async mounted() {
    if(this.pjbudget) {
      this.updateData = JSON.parse(JSON.stringify(this.pjbudget))
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
        budgetplanYear: this.updateData.projectYear
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

    async updatePjbudget() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        this.updateData.pjbudgetQty = 1
        this.updateData.pjbudgetUnit = "รายการ"
        this.updateData.pjbudgetMoney = numeral(this.updateData.pjbudgetMoney).value()
        if(this.updateData.pjbudgetMoney>=this.updateData.pjbudgetallocMoney) {
          let result = await this.$axios.$post('pjbudget.update.php', this.updateData)

          if(result.message == 'Success') {
            Swal.fire({
              title: 'สำเร็จ',
              text: result.msg,
              icon: 'success'
            }).then(async ()=> {
              this.updateProgress = false
              this.$emit('getUpdateStatus', {'status': true, 'pjbudgetID': result.pjbudgetID})
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
        this.updateData = JSON.parse(JSON.stringify(this.pjbudget))
        console.log(this.updateData)
        await this.getSubactivity()
        await this.getExpenses()
        await this.getBudgetplan()
      }
    }
  }
}
</script>
