<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขผู้ใช้งบโครงการ</span>
    </v-card-title>
    <v-divider class="amber"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updatePjbudgetalloc"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="8">
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
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            <v-text-field
              v-model="updateData.pjbudgetallocMoney"
              label="จำนวนเงิน"
              outlined
              dense
              :rules="[
                () => !!updateData.pjbudgetallocMoney || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">หมายเหตุ</h3>
            <v-textarea
              v-model="updateData.pjbudgetallocDes"
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
    pjbudgetalloc: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
        departments: [],
        updateData: {},
        updateProgress: false,
        updateValidate: null,
    }
  },

  async mounted() {
    if(this.pjbudgetalloc) {
      this.updateData = JSON.parse(JSON.stringify(this.pjbudgetalloc))
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

    async updatePjbudgetalloc() {
      await this.$refs.updateForm.validate()
        if(this.updateValidate) {
            this.updateData.pjbudgetallocDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
            this.updateData.pjbudgetallocMoney = numeral(this.updateData.pjbudgetallocMoney).value()
            if(this.updateData.pjbudgetMoney>=(this.updateData.pjbudgetallocTotalMoney+this.updateData.pjbudgetallocMoney)) {
                this.updateProgress = true
                let result = await this.$axios.$post('pjbudgetalloc.update.php', this.updateData)

                if(result.message == 'Success') {
                    Swal.fire({
                        title: 'สำเร็จ',
                        text: result.msg,
                        icon: 'success'
                    }).then(async ()=> {
                        this.updateProgress = false
                        this.$emit('getUpdateStatus', {'status': true, 'pjbudgetallocID': result.pjbudgetallocID})
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
    async pjbudgetalloc() {
      if(this.pjbudgetalloc) {
        this.updateData = JSON.parse(JSON.stringify(this.pjbudgetalloc))
        await this.getDepartment()
      }
    }
  }
}
</script>
