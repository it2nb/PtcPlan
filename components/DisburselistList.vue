<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">เพิ่มรายการ{{ disburse.expenseName }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">แผนก/งาน</h3>
            {{ disburse.departmentName }}
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ผู้ขอจัดซื้อ/เบิกเงิน</h3>
            {{ disburse.disburseReqName }}
          </v-col>
          <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">วันที่ขอจัดซื้อ/เบิกเงิน</h3>
            {{ thaiDate(disburse.disburseDate) }}
          </v-col>
          <!-- <v-col cols="12" md="6">
            <h3 class="mb-2 fontBold">ประเภทจัดซื้อ/เบิกเงิน</h3>
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
          </v-col> -->
          <v-col cols="12" v-if="disburse.disburseType=='โครงการ'">
            <h3 class="mb-2 fontBold">โครงการ</h3>
            {{  disburse.projectName }}
          </v-col>
          <v-col cols="12" v-if="disburse.disburseType=='โครงการ'">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่ายและงบประมาณ</h3>
            {{ disburse.expenseName }}
          </v-col>
          <v-col cols="12" v-if="disburse.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายจ่าย</h3>
            {{ disburse.expenseName }}( {{ disburse.expenseplanDes }} )
          </v-col>
          <!-- <v-col cols="12" md="6" v-if="updateData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายรับ</h3>
            <v-autocomplete
              v-model="updateData.budgetplanID"
              label="หมวดงบประมาณ"
              :items="expensebudgets"
              item-text="budgetplanFullname"
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
          </v-col> -->
          <!-- <v-col cols="12" v-if="updateData.disburseType=='โครงการ'||updateData.disburseType=='ค่าใช้จ่าย'">
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
          </v-col> -->
          <!-- <v-col cols="12" md="4" v-if="updateData.disburseType=='โครงการ'||updateData.disburseType=='ค่าใช้จ่าย'">
            <h3 class="mb-2 fontBold">จำนวนเงิน(บาท)</h3>
            <v-text-field
              v-model="updateData.disburseMoney"
              label="จำนวนเงิน (บาท)"
              outlined
              required
              :rules="[
                ()=>!!updateData.disburseMoney || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col> -->
          <v-col>
            <v-form
              v-model="insertValidate"
              ref="insertForm"
              lazy-validation
              @submit.prevent="insertDisburselist"
              class="mt-4"
            >
              <v-card-text>
                <v-row dense>
                  <v-col cols="12" md="6">
                    <v-text-field
                      v-model="insertData.disburselistName"
                      label="รายการ"
                      outlined
                      dense
                      required
                      :rules="[
                        ()=>!!insertData.disburselistName || 'กรุณากรอกข้อมูล'
                      ]"
                     />
                  </v-col>
                  <v-col cols="6" md="1">
                    <v-text-field
                      v-model="insertData.disburselistQty"
                      label="จำนวน"
                      outlined
                      type="number"
                      dense
                      required
                      :rules="[
                        ()=>!!insertData.disburselistQty || 'กรุณากรอกข้อมูล'
                      ]"
                     />
                  </v-col>
                  <v-col cols="6" md="2">
                    <v-text-field
                      v-model="insertData.disburselistUnit"
                      label="หน่วยนับ"
                      outlined
                      dense
                      required
                      :rules="[
                        ()=>!!insertData.disburselistUnit || 'กรุณากรอกข้อมูล'
                      ]"
                     />
                  </v-col>
                  <v-col cols="12" md="2">
                    <v-text-field
                      v-model="insertData.disburselistPrice"
                      label="ราคา"
                      outlined
                      dense
                      required
                      :rules="[
                        ()=>!!insertData.disburselistPrice || 'กรุณากรอกข้อมูล'
                      ]"
                     />
                  </v-col>
                  <v-col class="text-center">
                    <v-progress-circular indeterminate color="primary" class="mx-auto" v-if="insertProgress"></v-progress-circular>
                    <v-btn large color="success" type="submit" class="col-12" v-else>
                      <v-icon>fas fa-plus</v-icon>
                    </v-btn>
                  </v-col>
                </v-row>
              </v-card-text>
            </v-form>
            <v-data-table
            :headers="[
              {text: 'รายการ', value: 'disburselistName', align: 'left', class: 'text-center'},
              {text: 'จำนวน', value: 'disburselistQty', align: 'right', class: 'text-center'},
              {text: 'หน่วยนับ', value: 'disburselistUnit', align: 'center', class: 'text-center'},
              {text: 'ราคา', value: 'disburselistPrice', align: 'right', class: 'text-center'},
              {text: 'รวม', value: 'disburselistSumPrice', align: 'right', class: 'text-center'},
              {text: '', value:'actions', align: 'right'}
            ]"
            :items="disburselists"
            :items-per-page="-1"
            hide-default-footer
          >
            <template v-slot:item.disburselistQty="{ item }">
              {{ qtyFormat(item.disburselistQty) }}
            </template>
            <template v-slot:item.disburselistPrice="{ item }">
              {{ moneyFormat(item.disburselistPrice) }}
            </template>
            <template v-slot:item.disburselistSumPrice="{ item }">
              {{ moneyFormat(item.disburselistSumPrice) }}
            </template>
            <template v-slot:item.actions="{ item }">
              <v-btn color="warning" icon  small>
                <v-icon small class="mr-1">fas fa-edit</v-icon>
              </v-btn>
              <v-btn color="red darken-2" icon  smal>
                <v-icon small class="mr-1">fas fa-trash</v-icon>
              </v-btn>
            </template>
            <template slot="foot">
              <tr class="grey lighten-3">
                <td colspan="4" class="px-4 py-2 text-center font-weight-bold">รวม</td>
                <td class="px-4 py-2 text-right font-weight-bold">{{ moneyFormat(disburseSum) }}</td>
                <td class="px-4 py-2 text-right font-weight-bold"></td>
              </tr>
            </template>
          </v-data-table>
          </v-col>
        </v-row>
      </v-card-text>
      <v-divider class="green lighten-2"></v-divider>
      <v-card-actions>
        <div class="col-12 text-center">
          <!-- <v-btn
            @click="cancelUpdate"
            outlined
          >
            ยกเลิก
          </v-btn> -->
          <v-progress-circular
            indeterminate
            color="success"
            v-if="updateProgress"
          ></v-progress-circular>
          <v-btn
            type="submit"
            color="warning darken-1"
            large
            v-if="disburselists.length > 0"
          >
            ส่งตรวจสอบรายการ
          </v-btn>
        </div>
      </v-card-actions>
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
      disburselists: [],
      disburseSum: [],
      insertData: {},
      expensebudgets: [],
      expenseplans: [],
      projects: [],
      pjbudgets: [],
      departments: [],
      updateData: {},
      insertProgress: false,
      insertValidate: null,
    }
  },

  async mounted() {
    if(this.disburse) {
      await this.getDisburselist(this.disburse.disburseID)
    }
  },

  methods: {
    async getDisburselist(disburseID) {
      let result = await this.$axios.$get('disburselist.php', {
        params: {
          token: this.$store.state.jwtToken,
          disburseID: disburseID
        }
      })

      if(result.message == 'Success') {
        this.disburselists = JSON.parse(JSON.stringify(result.disburselist))
        this.disburseSum = this.disburselists.reduce((prev, curr)=> parseInt(prev) + parseInt(curr.disburselistSumPrice), 0);
      }
    },

    async insertDisburselist() {
      await this.$refs.insertForm.validate()
      if(this.insertValidate) {
        this.insertProgress = true
        this.insertData.token = this.$store.state.jwtToken
        this.insertData.disburseID = this.disburse.disburseID
        let result = await this.$axios.$post('disburselist.insert.php', this.insertData)
        if(result.message == 'Success') {
          this.insertData = {}
          await this.getDisburselist(this.disburse.disburseID)
        }
        this.insertProgress = false
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

    qtyFormat(qty) {
      return numeral(qty).format('0,0')
    },

  },

  watch: {
    async disburse() {
      await this.getDisburselist(this.disburse.disburseID)
      this.insertData = {}
    }
  }
}
</script>
