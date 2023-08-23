<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มข้อมูลงบประมาณที่ได้รับจัดสรร ปีงบประมาณ พ.ศ.{{ parseInt(budgetslip.budgetslipYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertBudgetslip"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายรับ</h3>
            <v-autocomplete
              v-model="insertData.budgetplanID"
              label="หมวดงบประมาณรายรับ"
              :items="budgetplans"
              item-text="budgetplanDes"
              item-value="budgetplanID"
              :readonly="readonlyBudetplanID"
              outlined
              required
              :rules="[
                ()=>!!insertData.budgetplanID || 'กรุณากรอกข้อมูล'
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
              v-model="insertData.budgetslipNo"
              label="เลขที่ใบจัดสรร"
              outlined
              required
              :rules="[
                ()=>!!insertData.budgetslipNo || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">วันที่ได้รับจัดสรร</h3>
            <v-text-field
              v-model="insertData.budgetslipDate"
              label="วันที่ได้รับจัดสรร"
              type="date"
              outlined
              required
              :hint="thaiDate(insertData.budgetslipDate)"
              persistent-hint
              :rules="[
                ()=>!!insertData.budgetslipDate || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">จำนวนเงิน</h3>
            <v-text-field
              v-model="insertData.budgetslipMoney"
              label="จำนวนเงิน(บาท)"
              outlined
              required
              :rules="[
                ()=>!!insertData.budgetslipMoney || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">รหัสงบประมาณ</h3>
            <v-text-field
              v-model="insertData.budgetslipBudCode"
              label="รหัสงบประมาณ(ถ้ามี)"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">รหัสกิจกรรม</h3>
            <v-text-field
              v-model="insertData.budgetslipActCode"
              label="รหัสกิจกรรม(ถ้ามี)"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">ที่อยู่ไฟล์ใบโอนจัดสรร</h3>
            <v-text-field
              v-model="insertData.budgetslipFile"
              label="ที่อยู่ไฟล์ใบโอนจัดสรร(ถ้ามี)"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">หมายเหตุ</h3>
            <v-textarea
              v-model="insertData.budgetslipDetail"
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
      readonlyBudetplanID: false,
      insertData: {},
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.budgetslip) {
      await this.getBudgetplan()
      if(this.budgetslip.budgetplanID) {
        this.readonlyBudetplanID = true
      }
      this.insertData = JSON.parse(JSON.stringify(this.budgetslip))
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

    async insertBudgetslip() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        this.insertData.budgetslipMoney = numeral(this.insertData.budgetslipMoney).value()
        let result = await this.$axios.$post('budgetslip.insert.php', this.insertData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'budgetslipID': result.budgetslipID})
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
    async budgetslip() {
      await this.getBudgetplan()
      if(this.budgetslip) {
        this.insertData = JSON.parse(JSON.stringify(this.budgetslip))
      }
    }
  }
}
</script>
