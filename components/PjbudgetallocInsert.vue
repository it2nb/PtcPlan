<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มผู้ใช้งบโครงการ</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertPjbudgetalloc"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="8">
            <h3 class="mb-2 fontBold">แผนก/งาน</h3>
            <v-autocomplete
              v-model="insertData.departmentID"
              label="แผนกงาน"
              :items="departments"
              item-text="departmentName"
              item-value="departmentID"
              outlined
              dense
              :rules="[
                () => !!insertData.departmentID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            <v-text-field
              v-model="insertData.pjbudgetallocMoney"
              label="จำนวนเงิน"
              outlined
              dense
              :rules="[
                () => !!insertData.pjbudgetallocMoney || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">หมายเหตุ</h3>
            <v-textarea
              v-model="insertData.pjbudgetallocDes"
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
    pjbudgetalloc: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      departments: [],
      insertData: {},
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.pjbudgetalloc) {
      this.insertData = JSON.parse(JSON.stringify(this.pjbudgetalloc))
      await this.getDepartment()
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

    async insertPjbudgetalloc() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertData.pjbudgetallocDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
        this.insertData.pjbudgetallocMoney = numeral(this.insertData.pjbudgetallocMoney).value()
        if(this.insertData.pjbudgetMoney>=(this.insertData.pjbudgetallocTotalMoney+this.insertData.pjbudgetallocMoney)) {
            this.insertProgress = true
            let result = await this.$axios.$post('pjbudgetalloc.insert.php', this.insertData)

            if(result.message == 'Success') {
            Swal.fire({
                title: 'สำเร็จ',
                text: result.msg,
                icon: 'success'
            }).then(async ()=> {
                this.insertProgress = false
                this.$emit('getInsertStatus', {'status': true, 'pjbudgetallocID': result.pjbudgetallocID})
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
        } else {
            Swal.fire({
                title: 'ข้อมูลผิดพลาด',
                text: 'ยอดเงินจัดสรรรวมเกินกว่าวงเงินที่ตั้งไว้',
                icon: 'warning'
            }).then(()=>{
              this.insertProgress = false
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
    async pjbudgetalloc() {
      if(this.pjbudgetalloc) {
        this.insertData = JSON.parse(JSON.stringify(this.pjbudgetalloc))
        await this.getDepartment()
      }
    }
  }
}
</script>
