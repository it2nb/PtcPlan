<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลงบประมาณที่ได้รับจัดสรร ปีงบประมาณ พ.ศ.{{ parseInt(budgetslip.budgetslipYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateBudgetslip"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายรับ</h3>
            <v-autocomplete
              v-model="updateData.budgetplanID"
              label="หมวดงบประมาณรายรับ"
              :items="budgetplans"
              item-text="budgetplanDes"
              item-value="budgetplanID"
              outlined
              required
              :rules="[
                ()=>!!updateData.budgetplanID || 'กรุณากรอกข้อมูล'
              ]"
            >
              <template v-slot:item="{ item }">
                <div class="py-2">
                  <div class="body-2">{{ item.budgetFullname }}</div>
                  <div>{{ item.budgetplanDes }}</div>
                </div>
              </template>
            </v-autocomplete>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">เลขที่ใบจัดสรร</h3>
            <v-text-field
              v-model="updateData.budgetslipNo"
              label="เลขที่ใบจัดสรร"
              outlined
              required
              :rules="[
                ()=>!!updateData.budgetslipNo || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">วันที่ได้รับจัดสรร</h3>
            <v-text-field
              v-model="updateData.budgetslipDate"
              label="วันที่ได้รับจัดสรร"
              type="date"
              outlined
              required
              :hint="thaiDate(updateData.budgetslipDate)"
              persistent-hint
              :rules="[
                ()=>!!updateData.budgetslipDate || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">จำนวนเงิน</h3>
            <v-text-field
              v-model="updateData.budgetslipMoney"
              label="จำนวนเงิน(บาท)"
              outlined
              required
              :rules="[
                ()=>!!updateData.budgetslipMoney || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">รหัสงบประมาณ</h3>
            <v-text-field
              v-model="updateData.budgetslipBudCode"
              label="รหัสงบประมาณ(ถ้ามี)"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">รหัสกิจกรรม</h3>
            <v-text-field
              v-model="updateData.budgetslipActCode"
              label="รหัสกิจกรรม(ถ้ามี)"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">ที่อยู่ไฟล์ใบโอนจัดสรร</h3>
            <v-text-field
              v-model="updateData.budgetslipFile"
              label="ที่อยู่ไฟล์ใบโอนจัดสรร(ถ้ามี)"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">หมายเหตุ</h3>
            <v-textarea
              v-model="updateData.budgetslipDetail"
              label="หมายเหตุ(ถ้ามี)"
              outlined
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
import numeral from 'numeral'
import Swal from 'sweetalert2'
export default {
  props: {
    budgetslip: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      budgetplans: [],
      updateData: {},
      updateProgress: false,
      updateValidate: null,
    }
  },

  async mounted() {
    if(this.budgetslip) {
      await this.getBudgetplan()
      this.updateData = JSON.parse(JSON.stringify(this.budgetslip))
    }
  },

  methods: {
    async getBudgetplan() {
      let params = {
        token: this.budgetslip.token,
        budgetplanYear: this.budgetslip.budgetslipYear
      }
      let result = await this.$axios.$get('budgetplan.php', {params})

      if(result.message === 'Success') {
        this.budgetplans = JSON.parse(JSON.stringify(result.budgetplan))
      }
    },

    async updateBudgetslip() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true
        this.updateData.budgetslipMoney = numeral(this.updateData.budgetslipMoney).value()
        let result = await this.$axios.$post('budgetslip.update.php', this.updateData)

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
    async budgetslip() {
      await this.getBudgetplan()
      if(this.budgetslip) {
        this.updateData = JSON.parse(JSON.stringify(this.budgetslip))
      }
    }
  }
}
</script>
