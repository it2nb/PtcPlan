<template>
  <v-card>
    <v-card-title class="red lighten-2">
      <span class="fontBold">ลบข้อมูลจัดซื้อ/เบิกเงิน ปีงบประมาณ พ.ศ.{{ parseInt(disburse.disburseYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="deleteValidate"
      ref="deleteForm"
      lazy-validation
      @submit.prevent="deleteDisburse"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="3">
            <h3 class="mb-2 fontBold">แผนก/งาน</h3>
            {{ deleteData.departmentName }}
          </v-col>
          <v-col cols="12" md="3">
            <h3 class="mb-2 fontBold">ผู้ขอจัดซื้อ/เบิกเงิน</h3>
            {{ deleteData.disburseReqName }}
          </v-col>
          <v-col cols="12" md="3">
            <h3 class="mb-2 fontBold">ประเภทจัดซื้อ/เบิกเงิน</h3>
            {{ deleteData.disburseType }}
          </v-col>
          <v-col cols="12" md="3">
            <h3 class="mb-2 fontBold">วันที่ขอจัดซื้อ/เบิกเงิน</h3>
            {{ thaiDate(deleteData.disburseDate) }}
          </v-col>
          <v-col cols="12" md="6" v-if="deleteData.disburseType=='โครงการ'">
            <h3 class="mb-2 fontBold">โครงการ</h3>
            {{ deleteData.projectName }}
          </v-col>
          <v-col cols="12" md="6" v-if="deleteData.disburseType=='โครงการ'">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่ายและงบประมาณ</h3>
            {{ deleteData.budgetplanDes }} : {{ deleteData.expenseName }}
          </v-col>
          <v-col cols="12" md="6" v-if="deleteData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายจ่าย</h3>
            {{ deleteData.expenseplanDes }}
          </v-col>
          <v-col cols="12" md="6" v-if="deleteData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายรับ</h3>
            {{ deleteData.budgetplanDes }}
          </v-col>
          <v-col cols="12" md="6" v-if="deleteData.disburseType=='โครงการ'||deleteData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">รายการ</h3>
            {{ deleteData.disburseDes }}
          </v-col>
          <v-col cols="12" md="6" v-if="deleteData.disburseType=='โครงการ'||deleteData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            {{ moneyFormat(deleteData.disburseMoney) }}
          </v-col>
          <v-col cols="12" md="6" class="mt-5 mx-auto">
            <v-text-field
              v-model="confirmDelete"
              label="พิมพ์ Delete หรือ ลบ เพื่อยืนยันการลบ"
              outlined
            ></v-text-field>
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
import numeral from 'numeral'
export default {
  props: {
    disburse: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      expensebudgets: [],
      expenseplans: [],
      projects: [],
      pjbudgets: [],
      departments: [],
      confirmDelete: null,
      deleteData: {},
      deleteProgress: false,
      deleteValidate: null,
    }
  },

  async mounted() {
    if(this.disburse) {
      this.confirmDelete = ''
      this.deleteData = JSON.parse(JSON.stringify(this.disburse))
      await this.getDepartment()
      await this.getExpaeseplan()
      if(this.deleteData.disburseType == 'ค่าใช้จ่าย') {
        await this.getExpaesebudget(this.deleteData.expenseplanID)
      }
      await this.getProject()
      if(this.deleteData.disburseType == 'โครงการ') {
        await this.getPjbudget(this.deleteData.projectID)
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
        expenseplanYear: this.deleteData.disburseYear
      }
      let result = await this.$axios.$get('expenseplan.php', {params})
      if(result.message == 'Success') {
        this.expenseplans = JSON.parse(JSON.stringify(result.expenseplan))
      }
    },

    async expenseplanIDChange() {
      await this.getExpaesebudget(this.deleteData.expenseplanID)
    },

    async getProject() {
      let params = {
        token: this.$store.state.jwtToken,
        projectStatus: 'อนุมัติ',
        projectPlanStatus: 'อนุมัติหลักการ',
        projectYear: this.deleteData.disburseYear,
        departmentID: this.deleteData.departmentID
      }
      let result = await this.$axios.$get('project.php', {params})
      if(result.message == 'Success') {
        this.projects = JSON.parse(JSON.stringify(result.project))
      }
    },

    async projectIDChange() {
      await this.getPjbudget(this.deleteData.projectID)
    },

    async getPjbudget(projectID) {
      let params = {
        token: this.$store.state.jwtToken,
        projectID: projectID,
        departmentID: this.deleteData.departmentID
      }
      let result = await this.$axios.$get('pjbudget.php', {params})
      if(result.message == 'Success') {
        this.pjbudgets = JSON.parse(JSON.stringify(result.pjbudget))
        this.pjbudgets = this.pjbudgets.filter(pjbudget=> pjbudget.departmentID==this.deleteData.departmentID || pjbudget.departmentQty>0)
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

    async deleteDisburse() {
      if(this.confirmDelete == 'Delete' || this.confirmDelete == 'ลบ') {
        this.deleteProgress = true

        let result = await this.$axios.$post('disburse.delete.php', this.deleteData)

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
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    }

  },

  watch: {
    async disburse() {
      if(this.disburse) {
        this.confirmDelete = ''
        this.deleteData = JSON.parse(JSON.stringify(this.disburse))
        await this.getDepartment()
        await this.getExpaeseplan()
        if(this.deleteData.disburseType == 'ค่าใช้จ่าย') {
          await this.getExpaesebudget(this.deleteData.expenseplanID)
        }
        await this.getProject()
        if(this.deleteData.disburseType == 'โครงการ') {
          await this.getPjbudget(this.deleteData.projectID)
        }
      }
    }
  }
}
</script>
