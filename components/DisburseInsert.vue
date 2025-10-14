<template>
  <v-card>
    <v-card-title class="light-green lighten-2">
      <span class="fontBold">เพิ่มข้อมูลจัดซื้อ/เบิกเงิน ปีงบประมาณ พ.ศ.{{ parseInt(disburse.disburseYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="insertValidate"
      ref="insertForm"
      lazy-validation
      @submit.prevent="insertDisburse"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">แผนก/งาน</h3>
            <v-autocomplete
             v-model="insertData.departmentID"
              label="แผนก/งาน"
              :items="departments"
              item-text="departmentName"
              item-value="departmentID"
              outlined
              required
              :rules="[
                ()=>!!insertData.departmentID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ผู้ขอจัดซื้อ/เบิกเงิน</h3>
            <v-text-field
              v-model="insertData.disburseReqName"
              label="ผู้ขอจัดซื้อ/เบิกเงิน"
              outlined
              required
              :rules="[
                ()=>!!insertData.disburseReqName || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">วันที่ขอจัดซื้อ/เบิกเงิน</h3>
            <v-text-field
              v-model="insertData.disburseDate"
              label="วันที่ขอจัดซื้อ/เบิกเงิน"
              type="date"
              outlined
              required
              persistent-hint
              :hint="thaiDate(insertData.disburseDate)"
              :rules="[
                ()=>!!insertData.disburseDate || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="4" md="1">
            <h3 class="mb-2 fontBold">ภาคเรียนที่</h3>
            <v-text-field
              v-model="insertData.disburseEduTerm"
              label="ภาคเรียนที่"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="8" md="2">
            <h3 class="mb-2 fontBold">ปีการศึกษา</h3>
            <v-text-field
              v-model="insertData.disburseEduYear"
              label="ปีการศึกษา"
              type="number"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">ประเภทคำขอ</h3>
            <v-radio-group
              v-model="insertData.disburseSubtype"
              row
              :rules="[
                ()=>!!insertData.disburseSubtype || 'กรุณากรอกข้อมูล'
              ]"
            >
              <v-radio
                label="ขอซื้อ"
                value="ซื้อ"
              ></v-radio>
              <v-radio
                label="ขอจ้าง"
                value="จ้าง"
              ></v-radio>
              <v-radio
                label="ขอเช่า"
                value="เช่า"
              ></v-radio>
              <v-radio
                label="ขอเบิกจ่ายอื่นๆ"
                value="เบิกจ่าย"
              ></v-radio>
            </v-radio-group>
          </v-col>
          <v-col cols="12" md="3">
            <h3 class="mb-2 fontBold">ประเภทกิจกรรม</h3>
            <v-radio-group
              v-model="insertData.disburseType"
              row
              :rules="[
                ()=>!!insertData.disburseType || 'กรุณากรอกข้อมูล'
              ]"
            >
              <v-radio
                label="โครงการ"
                value="โครงการ"
              ></v-radio>
              <v-radio
                label="ค่าใช้จ่าย"
                value="ค่าใช้จ่าย"
              ></v-radio>
            </v-radio-group>
          </v-col>
          <v-col cols="12" md="6" v-if="insertData.disburseType=='โครงการ'">
            <h3 class="mb-2 fontBold">โครงการ</h3>
            <v-autocomplete
              v-model="insertData.projectID"
              label="โครงการ"
              :items="projects"
              item-text="projectName"
              item-value="projectID"
              outlined
              required
              :rules="[
                ()=>!!insertData.projectID || 'กรุณากรอกข้อมูล'
              ]"
              @change="projectIDChange"
            >
            <template v-slot:item="{ item }">
                <div class="py-2 col-12">
                  <div>{{ item.projectName }}</div>
                  <div class="pl-2 body-2">
                    งบประมาณ {{ moneyFormat(item.pjbudgetMoney) }}
                    (คงเหลือ
                    <span class="success--text text--darken-2" v-if="(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) > 0">{{ moneyFormat(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) }}</span>
                    <span class="red--text text--darken-2" v-else-if="(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) < 0">{{ moneyFormat(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) }}</span>
                    <span v-else>0</span>)
                  </div>
                  <v-divider></v-divider>
                </div>
              </template>
            </v-autocomplete>
          </v-col>
          <v-col cols="12" md="6" v-if="insertData.disburseType=='โครงการ'">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่ายและงบประมาณ</h3>
            <v-autocomplete
              v-model="insertData.pjbudgetID"
              label="หมวดค่าใช้จ่ายและงบประมาณ"
              :items="pjbudgets"
              item-text="expensebudgetplan"
              item-value="pjbudgetID"
              outlined
              required
              :rules="[
                ()=>!!insertData.pjbudgetID || 'กรุณากรอกข้อมูล'
              ]"
            >
              <template v-slot:item="{ item }">
                <div class="py-2">
                  <div class="body-2">{{ item.pjsubactivityName }}</div>
                  <div class="caption">{{ item.pjsubactivityName }}</div>
                  <div class="pl-2">
                    {{ item.budgetName }} : {{ item.budgetplanDes }}
                    (คงเหลือ
                    <span class="success--text text--darken-2" v-if="(parseFloat(item.bpbudgetrealMoney)-parseFloat(item.bpdisburseMoney)) > 0">{{ moneyFormat(parseFloat(item.bpbudgetrealMoney)-parseFloat(item.bpdisburseMoney)) }}</span>
                    <span class="red--text text--darken-2" v-else-if="(parseFloat(item.bpbudgetrealMoney)-parseFloat(item.bpdisburseMoney)) < 0">{{ moneyFormat(parseFloat(item.bpbudgetrealMoney)-parseFloat(item.bpdisburseMoney)) }}</span>
                    <span v-else>0</span>)
                  </div>
                  <div class="pl-2">
                    {{ item.expenseName }} : {{ item.pjbudgetName }}
                    (คงเหลือ
                    <span class="success--text text--darken-2" v-if="(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) > 0">{{ moneyFormat(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) }}</span>
                    <span class="red--text text--darken-2" v-else-if="(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) < 0">{{ moneyFormat(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) }}</span>
                    <span v-else>0</span>)
                  </div>
                  <v-divider></v-divider>
                </div>
              </template>
            </v-autocomplete>
          </v-col>
          <v-col cols="12" md="6" v-if="insertData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายจ่าย</h3>
            <v-autocomplete
              v-model="insertData.expenseplanID"
              label="หมวดงบประมาณรายจ่าย"
              :items="expenseplans"
              item-text="expenseplanFullname"
              item-value="expenseplanID"
              outlined
              required
              :rules="[
                ()=>!!insertData.expenseplanID || 'กรุณากรอกข้อมูล'
              ]"
              @change="expenseplanIDChange"
            >
              <template v-slot:item="{ item }">
                <div class="py-2 col-12">
                  <div class="body-2">{{ item.expenseName }}</div>
                  <div>
                    {{ item.expenseplanDes }}
                    (คงเหลือ
                    <span class="success--text text--darken-2" v-if="(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) > 0">{{ moneyFormat(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) }}</span>
                    <span class="red--text text--darken-2" v-else-if="(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) < 0">{{ moneyFormat(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) }}</span>
                    <span v-else>0</span>)
                  </div>
                  <v-divider></v-divider>
                </div>
              </template>
            </v-autocomplete>
          </v-col>
          <v-col cols="12" md="6" v-if="insertData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายรับ</h3>
            <v-autocomplete
              v-model="insertData.budgetplanID"
              label="หมวดงบประมาณ"
              :items="expensebudgets"
              item-text="budgetplanFullname"
              item-value="budgetplanID"
              outlined
              required
              :rules="[
                ()=>!!insertData.budgetplanID || 'กรุณากรอกข้อมูล'
              ]"
            >
              <template v-slot:item="{ item }">
                <div class="py-2 col-12">
                  <div class="body-2">{{ item.budgetName }}</div>
                  <div>
                    {{ item.budgetplanDes }}
                    (คงเหลือ
                    <span class="success--text text--darken-2" v-if="(parseFloat(item.budgetslipMoney)-parseFloat(item.bpdisburseMoney)) > 0">{{ moneyFormat(parseFloat(item.budgetslipMoney)-parseFloat(item.bpdisburseMoney)) }}</span>
                    <span class="red--text text--darken-2" v-else-if="(parseFloat(item.budgetslipMoney)-parseFloat(item.bpdisburseMoney)) < 0">{{ moneyFormat(parseFloat(item.budgetslipMoney)-parseFloat(item.bpdisburseMoney)) }}</span>
                    <span v-else>0</span>)
                  </div>
                  <v-divider></v-divider>
                </div>
              </template>
            </v-autocomplete>
          </v-col>
          <v-col cols="12" md="8" v-if="insertData.disburseType=='โครงการ'||insertData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">วัตถุประสงค์เพื่อ</h3>
            <v-text-field
              v-model="insertData.disburseDes"
              label="รายการ"
              outlined
              required
              :rules="[
                ()=>!!insertData.disburseDes || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4" v-if="insertData.disburseType=='โครงการ'||insertData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            <v-text-field
              v-model="insertData.disburseMoney"
              label="จำนวนเงิน (บาท)"
              outlined
              required
              :rules="[
                ()=>!!insertData.disburseMoney || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6" v-if="insertData.disburseType=='โครงการ'||insertData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">ต้องการใช้ในวันที่</h3>
            <v-text-field
              v-model="insertData.disburseStart"
              label="วันที่เริ่มต้น"
              type="date"
              outlined
              required
              persistent-hint
              :hint="thaiDate(insertData.disburseStart)"
              :rules="[
                ()=>!!insertData.disburseStart || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6" v-if="insertData.disburseType=='โครงการ'||insertData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">สิ้นสุดวันที่</h3>
            <v-text-field
              v-model="insertData.disburseEnd"
              label="วันที่สิ้นสุด"
              type="date"
              outlined
              required
              persistent-hint
              :hint="thaiDate(insertData.disburseEnd)"
              :rules="[
                ()=>!!insertData.disburseEnd || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" v-if="insertData.disburseType=='โครงการ'||insertData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">ผลผลิตที่คาดว่าจะได้</h3>
            <v-textarea
              v-model="insertData.disburseProduct"
              label="ระบุผลผลิต และจำนวน(หน่วย)"
              outlined
              required
              :rules="[
                ()=>!!insertData.disburseProduct || 'กรุณากรอกข้อมูล'
              ]"
            ></v-textarea>
          </v-col>
          <v-col cols="12" md="8" v-if="(insertData.disburseType=='โครงการ'||insertData.disburseType=='ค่าใช้จ่าย') && insertData.disburseStatus == 'เบิกจ่ายแล้ว'">
            <h3 class="mb-2 fontBold">หมายเหตุ</h3>
            <v-text-field
              v-model="insertData.disburseFinDes"
              label="หมายเหตุ"
              outlined
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4" v-if="(insertData.disburseType=='โครงการ'||insertData.disburseType=='ค่าใช้จ่าย') && insertData.disburseStatus == 'เบิกจ่ายแล้ว'">
            <h3 class="mb-2 fontBold">วันที่เบิกจ่าย</h3>
            <v-text-field
              v-model="insertData.disburseFinDate"
              label="วันที่เบิกจ่าย"
              type="date"
              outlined
              required
              persistent-hint
              :hint="thaiDate(insertData.disburseFinDate)"
              :rules="[
                ()=>!!insertData.disburseFinDate || 'กรุณากรอกข้อมูล'
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
      insertData: {},
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.disburse) {
      this.insertData = JSON.parse(JSON.stringify(this.disburse))
      await this.getDepartment()
      await this.getExpaeseplan()
      await this.getProject()
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
        expenseplanYear: this.insertData.disburseYear
      }
      let result = await this.$axios.$get('expenseplan.php', {params})
      if(result.message == 'Success') {
        this.expenseplans = JSON.parse(JSON.stringify(result.expenseplan))
      }
    },

    async expenseplanIDChange() {
      await this.getExpaesebudget(this.insertData.expenseplanID)
    },

    async getProject() {
      let params = {
        token: this.$store.state.jwtToken,
        projectStatus: 'อนุมัติ',
        projectPlanStatus: 'อนุมัติหลักการ',
        projectYear: this.insertData.disburseYear
      }

      let result = await this.$axios.$get('project.php', {params})

      if(result.message == 'Success') {
        this.projects = JSON.parse(JSON.stringify(result.project))
      }
    },

    async projectIDChange() {
      await this.getPjbudget(this.insertData.projectID)
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

    async insertDisburse() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        this.insertData.disburseMoney = numeral(this.insertData.disburseMoney).value()
        if(this.insertData.disburseStatus == 'เบิกจ่ายแล้ว') {
          this.insertData.disburseFinMoney = this.insertData.disburseMoney
        }
        if(this.expensebudgets.length > 0) {
          let budgetplan = await this.expensebudgets.find(budgetplan => budgetplan.expenseplanID==this.insertData.expenseplanID)
          if(budgetplan) {
            this.insertData.expenseID = budgetplan.expenseID
          }
        }
        if(this.pjbudgets.length > 0) {
          let pjbudget = await this.pjbudgets.find(pjbudget => pjbudget.pjbudgetID==this.insertData.pjbudgetID)
          if(pjbudget) {
            this.insertData.budgetplanID = pjbudget.budgetplanID
            this.insertData.expenseID = pjbudget.expenseID
          }
        }
        // this.insertData.disburseStatus = 'ตัดแผนแล้ว'
        let result = await this.$axios.$post('disburse.insert.php', this.insertData)

        if(result.message == 'Success') {
          if(this.insertData.disburseType==='โครงการ') {
            let updateProject = {
              token: this.$store.state.jwtToken,
              projectID: this.insertData.projectID,
              projectProgress: 'อยู่ระหว่างดำเนินการ'
            }
            await this.$axios.$post('project.update.php', updateProject)
          }

          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.insertProgress = false
            this.$emit('getInsertStatus', {'status': true, 'disburseID': result.disburseID})
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
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    },

  },

  watch: {
    async disburse() {
      if(this.disburse) {
        this.insertData = JSON.parse(JSON.stringify(this.disburse))
        await this.getDepartment()
        await this.getExpaeseplan()
        await this.getProject()
      }
    }
  }
}
</script>
