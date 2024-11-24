<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขผู้ใช้งบรายจ่าย</span>
    </v-card-title>
    <v-divider class="amber"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateExpensealloc"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">แผนก/งาน</h3>
            <v-autocomplete
              v-model="updateData.departmentID"
              label="แผนกงาน"
              :items="departments"
              item-text="departmentName"
              item-value="departmentID"
              outlined
              dense
              :rules="[
                () => !!updateData.departmentID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดงบประมาณ</h3>
            <v-autocomplete
              v-model="updateData.budgetplanID"
              label="หมวดงบประมาณ"
              :items="expensebudgets"
              item-text="budgetplanFullname"
              item-value="budgetplanID"
              outlined
              dense
              :rules="[
                () => !!updateData.departmentID || 'กรุณากรอกข้อมูล'
              ]"
              @change="budgetplanChange(updateData.budgetplanID)"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            <v-text-field
              v-model="updateData.expenseallocMoney"
              label="จำนวนเงิน"
              outlined
              dense
              :rules="[
                () => !!updateData.expenseallocMoney || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">หมายเหตุ</h3>
            <v-textarea
              v-model="updateData.expenseallocDes"
              label="หมายเหตุ"
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
    expensealloc: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
        departments: [],
        expensebudgets: [],
        expensebudget: {},
        updateData: {},
        updateProgress: false,
        updateValidate: null,
    }
  },

  async mounted() {
    if(this.expensealloc) {
      this.updateData = JSON.parse(JSON.stringify(this.expensealloc))
      await this.getDepartment()
      await this.getExpensebudget()
    }
  },

  methods: {
    async getDepartment() {
      let params = {
        token: this.$store.state.jwtToken,
      }
      let result = await this.$axios.$get('department.php', {params})
      if(result.message == 'Success') {
        this.departments = JSON.parse(JSON.stringify(result.department))
      }
    },

    async getExpensebudget() {
      let params = {
        token: this.$store.state.jwtToken,
        expenseplanID: this.expensealloc.expenseplanID
      }
      let result = await this.$axios.$get('expensebudget.php', {params})
      if(result.message == 'Success') {
        this.expensebudgets = JSON.parse(JSON.stringify(result.expensebudget))
      }
    },

    async budgetplanChange(budgetplanID) {
       
      this.expensebudget = this.expensebudgets.filter(expensebudget=> expensebudget.budgetplanID==budgetplanID)[0]
      await this.$axios.$get('expensealloc.php', {
        params: {
          token: this.$store.state.jwtToken,
          expenseplanID: this.expensealloc.expenseplanID,
          budgetplanID: budgetplanID,
          fn: 'getSummaryByExpenseplanIDBudgetplanID'
        }
      }).then(result=>{
        if(result.message == 'Success') {
          this.expensebudget.expenseallocMoney = parseFloat(result.expensealloc.expenseallocMoney)-parseFloat(this.expensealloc.expenseallocMoney)
        }
      })
    },

    async updateExpensealloc() {
        await this.budgetplanChange(this.updateData.budgetplanID)
      await this.$refs.updateForm.validate()
        if(this.updateValidate) {
            this.updateData.expenseallocDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
            this.updateData.expenseallocMoney = numeral(this.updateData.expenseallocMoney).value()
            if(parseFloat(this.expensebudget.expenseplanMoney)>=(parseFloat(this.expensebudget.expenseallocMoney)+parseFloat(this.updateData.expenseallocMoney))) {
                this.updateProgress = true
                let result = await this.$axios.$post('expensealloc.update.php', this.updateData)

                if(result.message == 'Success') {
                    Swal.fire({
                        title: 'สำเร็จ',
                        text: result.msg,
                        icon: 'success'
                    }).then(async ()=> {
                        this.updateProgress = false
                        this.$emit('getUpdateStatus', {'status': true, 'expenseallocID': result.expenseallocID})
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
                    text: 'ยอดเงินจัดสรรรวมเกินกว่าวงเงินที่ตั้งไว้',
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
    async expensealloc() {
      if(this.expensealloc) {
        this.updateData = JSON.parse(JSON.stringify(this.expensealloc))
        await this.getDepartment()
        await this.getExpensebudget()
      }
    }
  }
}
</script>
