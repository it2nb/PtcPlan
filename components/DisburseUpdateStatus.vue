<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขสถานะข้อมูลจัดซื้อ/เบิกเงิน ปีงบประมาณ พ.ศ.{{ parseInt(disburse.disburseYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateDisburse"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">แผนก/งาน</h3>
            <v-autocomplete
             v-model="updateData.departmentID"
              label="แผนก/งาน"
              :items="departments"
              item-text="departmentName"
              item-value="departmentID"
              outlined
              required
              readonly
              dense
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ผู้ขอจัดซื้อ/เบิกเงิน</h3>
            <v-text-field
              v-model="updateData.disburseReqName"
              label="ผู้ขอจัดซื้อ/เบิกเงิน"
              outlined
              required
              readonly
              dense
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">รายการ</h3>
            <v-text-field
              v-model="updateData.disburseDes"
              label="รายการ"
              outlined
              required
              readonly
              dense
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">วันที่ขอจัดซื้อ/เบิกเงิน</h3>
            <v-text-field
              v-model="updateData.disburseDate"
              label="วันที่ขอจัดซื้อ/เบิกเงิน"
              type="date"
              outlined
              required
              persistent-hint
              :hint="thaiDate(updateData.disburseDate)"
              readonly
              dense
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            <v-text-field
              v-model="updateData.disburseMoney"
              label="จำนวนเงิน (บาท)"
              outlined
              required
              readonly
              dense
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <v-radio-group
              v-model="updateData.disburseStatus"
              row
              v-if="userType=='Plan' || userType=='Admin' || userType=='Finance'"
            >
              <v-radio label="ตัดแผนแล้ว" value="ตัดแผนแล้ว" color="primary"></v-radio>
              <v-radio label="เบิกจ่ายแล้ว" value="เบิกจ่ายแล้ว" color="success" v-if="userType=='Finance'"></v-radio>
              <v-radio label="ยกเลิก" value="ยกเลิก"  color="red darken-2" v-if="userType=='Finance'"></v-radio>
            </v-radio-group>
          </v-col>
          <v-col cols="12" md="6" v-if="updateData.disburseStatus=='เบิกจ่ายแล้ว'">
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            <v-text-field
              v-model="updateData.disburseFinMoney"
              label="จำนวนเงิน (บาท)"
              outlined
              required
              dense
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6" v-if="updateData.disburseStatus=='เบิกจ่ายแล้ว'">
            <h3 class="mb-2 fontBold">วันที่เบิกจ่าย</h3>
            <v-text-field
              v-model="updateData.disburseFinDate"
              label="วันที่เบิกจ่าย"
              type="date"
              outlined
              required
              persistent-hint
              :hint="thaiDate(updateData.disburseFinDate)"
              dense
            ></v-text-field>
          </v-col>
          <v-col cols="12" v-if="updateData.disburseStatus=='เบิกจ่ายแล้ว' || updateData.disburseStatus=='ยกเลิก'">
            <h3 class="mb-2 fontBold">หมายเหตุ</h3>
            <v-text-field
              v-model="updateData.disburseFinDes"
              label="หมายเหตุ"
              outlined
              required
              dense
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
    disburse: {
      type: Object,
      default: () => {}
    },
    userType: {
      type: String,
      default: null
    }
  },

  data() {
    return {
      expensebudgets: [],
      expenseplans: [],
      projects: [],
      pjbudgets: [],
      departments: [],
      updateData: {},
      updateProgress: false,
      updateValidate: null,
    }
  },

  async mounted() {
    if(this.disburse) {
      this.updateData = JSON.parse(JSON.stringify(this.disburse))
      await this.getDepartment()
      await this.getExpaeseplan()
      if(this.updateData.disburseType == 'ค่าใช้จ่าย') {
        await this.getExpaesebudget(this.updateData.expenseplanID)
      }
      await this.getProject()
      if(this.updateData.disburseType == 'โครงการ') {
        await this.getPjbudget(this.updateData.projectID)
      }
    }
  },

  methods: {
    async getDepartment() {
      let params = {
        token: this.$store.state.jwtToken
      }
      let result = await this.$axios.$get('department.php', {params})
      if(result.message == 'Success') {
        this.departments = JSON.parse(JSON.stringify(result.department))
      }
    },

    async getExpaeseplan() {
      let params = {
        token: this.$store.state.jwtToken,
        expenseplanYear: this.updateData.disburseYear
      }
      let result = await this.$axios.$get('expenseplan.php', {params})
      if(result.message == 'Success') {
        this.expenseplans = JSON.parse(JSON.stringify(result.expenseplan))
      }
    },

    async expenseplanIDChange() {
      await this.getExpaesebudget(this.updateData.expenseplanID)
    },

    async getProject() {
      let params = {
        token: this.$store.state.jwtToken,
        projectStatus: 'อนุมัติ',
        projectPlanStatus: 'อนุมัติหลักการ',
        projectYear: this.updateData.disburseYear
      }
      let result = await this.$axios.$get('project.php', {params})
      if(result.message == 'Success') {
        this.projects = JSON.parse(JSON.stringify(result.project))
      }
    },

    async projectIDChange() {
      await this.getPjbudget(this.updateData.projectID)
    },

    async getPjbudget(projectID) {
      let params = {
        token: this.$store.state.jwtToken,
        projectID: projectID
      }
      let result = await this.$axios.$get('pjbudget.php', {params})
      if(result.message == 'Success') {
        this.pjbudgets = JSON.parse(JSON.stringify(result.pjbudget))
      }
    },

    async getExpaesebudget(expenseplanID) {
      let params = {
        token: this.$store.state.jwtToken,
        expenseplanID: expenseplanID
      }
      let result = await this.$axios.$get('expensebudget.php', {params})
      if(result.message == 'Success') {
        this.expensebudgets = JSON.parse(JSON.stringify(result.expensebudget))
      }
    },

    async updateDisburse() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        this.updateData.disburseMoney = numeral(this.updateData.disburseMoney).value()
        this.updateData.disburseFinMoney = numeral(this.updateData.disburseFinMoney).value()
        if(this.expensebudgets.length > 0) {
          let budgetplan = await this.expensebudgets.find(budgetplan => budgetplan.expenseplanID==this.updateData.expenseplanID)
          if(budgetplan) {
            this.updateData.expenseID = budgetplan.expenseID
          }
        }
        if(this.pjbudgets.length > 0) {
          let pjbudget = await this.pjbudgets.find(pjbudget => pjbudget.pjbudgetID==this.updateData.pjbudgetID)
          if(pjbudget) {
            this.updateData.budgetplanID = pjbudget.budgetplanID
            this.updateData.expenseID = pjbudget.expenseID
          }
        }

        let result = await this.$axios.$post('disburse.update.php', this.updateData)

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
    async disburse() {
      if(this.disburse) {
        this.updateData = JSON.parse(JSON.stringify(this.disburse))
        await this.getDepartment()
        await this.getExpaeseplan()
        if(this.updateData.disburseType == 'ค่าใช้จ่าย') {
          await this.getExpaesebudget(this.updateData.expenseplanID)
        }
        await this.getProject()
        if(this.updateData.disburseType == 'โครงการ') {
          await this.getPjbudget(this.updateData.projectID)
        }
      }
    }
  }
}
</script>
