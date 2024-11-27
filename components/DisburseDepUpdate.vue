<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลขอซื้อ/เบิกเงิน ปีงบประมาณ พ.ศ.{{ parseInt(disburse.disburseYear)+543 }}</span>
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
              :rules="[
                ()=>!!updateData.departmentID || 'กรุณากรอกข้อมูล'
              ]"
              readonly
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ผู้ขอจัดซื้อ/เบิกเงิน</h3>
            <v-text-field
              v-model="updateData.disburseReqName"
              label="ผู้ขอจัดซื้อ/เบิกเงิน"
              outlined
              required
              :rules="[
                ()=>!!updateData.disburseReqName || 'กรุณากรอกข้อมูล'
              ]"
              readonly
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">วันที่ขอจัดซื้อ/เบิกเงิน</h3>
            <v-text-field
              v-model="updateData.disburseDate"
              label="วันที่ขอจัดซื้อ/เบิกเงิน"
              type="date"
              outlined
              required
              persistent-hint
              :hint="thaiDate(updateData.disburseDate)"
              :rules="[
                ()=>!!updateData.disburseDate || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">ประเภทคำขอ</h3>
            <v-radio-group
              v-model="updateData.disburseSubtype"
              row
              :rules="[
                ()=>!!updateData.disburseSubtype || 'กรุณากรอกข้อมูล'
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
            </v-radio-group>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">ประเภทกิจกรรม</h3>
            <v-radio-group
              v-model="updateData.disburseType"
              row
              :rules="[
                ()=>!!updateData.disburseType || 'กรุณากรอกข้อมูล'
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
          <v-col cols="12" md="6" v-if="updateData.disburseType=='โครงการ'">
            <h3 class="mb-2 fontBold">โครงการ</h3>
            <v-autocomplete
              v-model="updateData.projectID"
              label="โครงการ"
              :items="projects"
              item-text="projectName"
              item-value="projectID"
              outlined
              required
              :rules="[
                ()=>!!updateData.projectID || 'กรุณากรอกข้อมูล'
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
          <v-col cols="12" md="6" v-if="updateData.disburseType=='โครงการ'">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่ายและงบประมาณ</h3>
            <v-autocomplete
              v-model="updateData.pjbudgetID"
              label="หมวดค่าใช้จ่ายและงบประมาณ"
              :items="pjbudgets"
              item-text="expensebudgetplan"
              item-value="pjbudgetID"
              outlined
              required
              :rules="[
                ()=>!!updateData.pjbudgetID || 'กรุณากรอกข้อมูล'
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
                    <span class="success--text text--darken-2" v-if="item.departmentQty > 0">{{ moneyFormat(item.pjbudgetallocMoney) }}</span>
                    <span class="success--text text--darken-2" v-else-if="(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) > 0">{{ moneyFormat(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) }}</span>
                    <span class="red--text text--darken-2" v-else-if="(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) < 0">{{ moneyFormat(parseFloat(item.pjbudgetMoney)-parseFloat(item.disburseMoney)) }}</span>
                    <span v-else>0</span>)
                  </div>
                  <v-divider></v-divider>
                </div>
              </template>
            </v-autocomplete>
          </v-col>
          <v-col cols="12" md="6" v-if="updateData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายจ่าย</h3>
            <v-autocomplete
              v-model="updateData.expenseplanID"
              label="หมวดงบประมาณรายจ่าย"
              :items="expenseplans"
              item-text="expenseplanDes"
              item-value="expenseplanID"
              outlined
              required
              :rules="[
                ()=>!!updateData.expenseplanID || 'กรุณากรอกข้อมูล'
              ]"
              @change="expenseplanIDChange"
            >
              <template v-slot:item="{ item }">
                <div class="py-2 col-12">
                  <div class="body-2">{{ item.expenseName }}</div>
                  <div>
                    {{ item.expenseplanDes }}
                    (คงเหลือ
                    <span class="success--text text--darken-2" v-if="item.departmentQty > 0">{{ moneyFormat(item.expenseallocMoney) }}</span>
                    <span class="success--text text--darken-2" v-else-if="(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) > 0">{{ moneyFormat(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) }}</span>
                    <span class="red--text text--darken-2" v-else-if="(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) < 0">{{ moneyFormat(parseFloat(item.expenseplanMoney)-parseFloat(item.disburseMoney)) }}</span>
                    <span v-else>0</span>)
                  </div>
                  <v-divider></v-divider>
                </div>
              </template>
            </v-autocomplete>
          </v-col>
          <v-col cols="12" md="6" v-if="updateData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายรับ</h3>
            <v-autocomplete
              v-model="updateData.budgetplanID"
              label="หมวดงบประมาณ"
              :items="expensebudgets"
              item-text="budgetplanDes"
              item-value="budgetplanID"
              outlined
              required
              :rules="[
                ()=>!!updateData.budgetplanID || 'กรุณากรอกข้อมูล'
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
          <v-col cols="12" v-if="updateData.disburseType=='โครงการ'||updateData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">วัตถุประสงค์เพื่อ</h3>
            <v-text-field
              v-model="updateData.disburseDes"
              label="เพื่อ"
              outlined
              required
              :rules="[
                ()=>!!updateData.disburseDes || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">วันที่เริ่มต้น</h3>
            <v-text-field
              v-model="updateData.disburseStart"
              label="วันที่เริ่มต้น"
              type="date"
              outlined
              required
              persistent-hint
              :hint="thaiDate(updateData.disburseStart)"
              :rules="[
                ()=>!!updateData.disburseStart || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">วันที่สิ้นสุด</h3>
            <v-text-field
              v-model="updateData.disburseEnd"
              label="วันที่สิ้นสุด"
              type="date"
              outlined
              required
              persistent-hint
              :hint="thaiDate(updateData.disburseEnd)"
              :rules="[
                ()=>!!updateData.disburseEnd || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">ผลผลิตที่คาดว่าจะได้</h3>
            <v-textarea
              v-model="updateData.disburseProduct"
              label="ระบุผลผลิต และจำนวน(หน่วย)"
              outlined
              required
              :rules="[
                ()=>!!updateData.disburseProduct || 'กรุณากรอกข้อมูล'
              ]"
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
        expenseplanYear: this.updateData.disburseYear,
        departmentID: this.updateData.departmentID
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
        projectYear: this.updateData.disburseYear,
        departmentID: this.updateData.departmentID
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
        projectID: projectID,
        departmentID: this.updateData.departmentID
      }
      let result = await this.$axios.$get('pjbudget.php', {params})
      if(result.message == 'Success') {
        this.pjbudgets = JSON.parse(JSON.stringify(result.pjbudget))
        this.pjbudgets = this.pjbudgets.filter(pjbudget=> pjbudget.departmentID==this.updateData.departmentID || pjbudget.departmentQty>0)
      }
    },

    async getExpaesebudget(expenseplanID) {
      let params = {
        token: this.$store.state.jwtToken,
        expenseplanID: expenseplanID,
        departmentID: this.updateData.departmentID
      }
      let result = await this.$axios.$get('expensebudget.php', {params})
      if(result.message == 'Success') {
        this.expensebudgets = JSON.parse(JSON.stringify(result.expensebudget))
        this.expensebudgets = this.expensebudgets.filter(expensebudget=> expensebudget.departmentQty>0)
      }
    },

    async updateDisburse() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        if(new Date(this.updateData.disburseDate).getDay()!=0&&new Date(this.updateData.disburseDate).getDay()!=6) {

          if(this.updateData.disburseType=='โครงการ') {
            this.updateData.expenseplanID = ''
          }
          else if(this.updateData.disburseType=='ค่าใช้จ่าย') {
            this.updateData.projectID = ''
            this.updateData.expenseID = ''
            this.updateData.pjbudgetID = ''
          }

          this.updateData.disburseMoney = numeral(this.updateData.disburseMoney).value()
          if(this.expensebudgets.length > 0) {
            let budgetplan = await this.expensebudgets.find(budgetplan => budgetplan.expenseplanID==this.updateData.expenseplanID)
            if(budgetplan.expenseID) {
              this.updateData.expenseID = budgetplan.expenseID
            }
          }
          if(this.pjbudgets.length > 0 && this.updateData.disburseType=='โครงการ') {
            let pjbudget = await this.pjbudgets.find(pjbudget => pjbudget.pjbudgetID==this.updateData.pjbudgetID)
            if(pjbudget) {
              this.updateData.budgetplanID = pjbudget.budgetplanID
              this.updateData.expenseID = pjbudget.expenseID
            }
          }

          let result = await this.$axios.$post('disburse.update.php', this.updateData)

          if(result.message == 'Success') {
            if(this.updateData.disburseType==='โครงการ' && this.disburse==='ค่าใช้จ่าย') {
              let updateProject = {
                token: this.$store.state.jwtToken,
                projectID: this.updateData.projectID,
                projectProgress: 'อยู่ระหว่างดำเนินการ'
              }
              await this.$axios.$post('project.update.php', updateProject)
            }
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
        } else {
          Swal.fire({
            title: 'ผิดพลาด',
            text: 'วันจัดซื้อตรงกับเสาร์ หรือ อาทิตย์ กรุณาเลือกวันอื่น',
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
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    },

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
