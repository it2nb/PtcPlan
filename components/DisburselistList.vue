<template>
  <div>
    <v-card>
      <v-card-title class="amber lighten-2">
        <span class="fontBold">รายการ{{ disburse.expenseName }}</span>
        <v-spacer></v-spacer>
        <v-btn 
          color="white"
          :to="'/print/disburseForm1/?id='+disburse.disburseID" 
          target="_blank"
        >
          <v-icon class="mr-1" color="primary">fas fa-print</v-icon> พิมพ์
        </v-btn>
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
            <v-col cols="12" md="6">
              <h3 class="mb-2 fontBold">ผลผลิตที่คาดว่าจะได้</h3>
              {{ disburse.disburseProduct }}
            </v-col>
            <!-- <v-col cols="12" v-if="disburse.disburseType=='โครงการ'">
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
            </v-col> -->
            <v-col cols="12">
              <h3 class="mb-2 fontBold">ค่าใช้จ่าย : โครงการ</h3>
              {{  disburse.disburseName }}
            </v-col>
            <v-col cols="12">
              <h3 class="mb-2 fontBold">หมวดงบประมาณ</h3>
              {{ disburse.budgettypeName }} : {{ disburse.budgetplanFullname }}
            </v-col>
            <v-col>
              <v-form
                v-model="insertValidate"
                ref="insertForm"
                lazy-validation
                @submit.prevent="insertDisburselist"
                class="mt-4"
                v-if="(disburse.disburseStatus == 'ขอซื้อ' || disburse.disburseStatus == 'ไม่ถูกต้อง') && userType=='Department'"
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
                {text: 'หมายเหตุ', value: 'disburselistStatus', align: 'left', class: 'text-center'},
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
              <template v-slot:item.disburselistStatus="{ item}">
                <v-icon small color="success" v-if="item.disburselistStatus=='ถูกต้อง'">fas fa-check</v-icon>
                <v-icon small color="error" v-if="item.disburselistStatus=='ไม่ถูกต้อง'">fas fa-times</v-icon>
                {{ item.disburselistStatus=='ไม่ถูกต้อง' ? item.disburselistCommment : '' }}
              </template>
              <template v-slot:item.actions="{ item }" v-if="(disburse.disburseStatus == 'ขอซื้อ' || disburse.disburseStatus == 'ไม่ถูกต้อง') && userType=='Department'">
                <v-btn color="warning" icon  small @click="showUpdateDialog(item)">
                  <v-icon small class="mr-1">fas fa-edit</v-icon>
                </v-btn>
                <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)">
                  <v-icon small class="mr-1">fas fa-trash</v-icon>
                </v-btn>
              </template>
              <template slot="foot">
                <tr class="grey lighten-3">
                  <td colspan="4" class="px-4 py-2 text-center font-weight-bold">รวม</td>
                  <td class="px-4 py-2 text-right font-weight-bold">{{ moneyFormat(disburseSum) }}</td>
                  <td class="px-4 py-2 text-right font-weight-bold"></td>
                  <td class="px-4 py-2 text-right font-weight-bold"></td>
                </tr>
              </template>
            </v-data-table>
            </v-col>
            <v-col cols="12" class="mt-2 red--text" v-if="disburse.disburseParcCheck=='ไม่ถูกต้อง'">
              <h3 class="mb-2 fontBold"><v-icon small color="error">fas fa-times</v-icon> งานพัสดุ</h3>
              <pre class="pl-5 font16">{{ disburse.disburseParcDes }}</pre>
            </v-col>
            <v-col cols="12" class="mt-2 red--text" v-if="disburse.disbursePlanCheck=='ไม่ถูกต้อง'">
              <h3 class="mb-2 fontBold"><v-icon small color="error">fas fa-times</v-icon> งานวางแผน</h3>
              <pre class="pl-5 font16">{{ disburse.disbursePlanDes }}</pre>
            </v-col>
            <v-col cols="12" class="mt-2 red--text" v-if="disburse.disburseAccoCheck=='ไม่ถูกต้อง'">
              <h3 class="mb-2 fontBold"><v-icon small color="error">fas fa-times</v-icon> งานบัญชี</h3>
              <pre class="pl-5 font16">{{ disburse.disburseAccoDes }}</pre>
            </v-col>
            <v-col cols="12" class="mt-2 red--text" v-if="disburse.disburseFinaCheck=='ไม่ถูกต้อง'">
              <h3 class="mb-2 fontBold"><v-icon small color="error">fas fa-times</v-icon> งานการเงิน</h3>
              <pre class="pl-5 font16">{{ disburse.disburseFinaDes }}</pre>
            </v-col>
          </v-row>
        </v-card-text>
        <v-divider class="green lighten-2"></v-divider>
        <v-card-actions>
          <div class="col-12 text-center" v-if="(disburse.disburseStatus == 'ขอซื้อ' || disburse.disburseStatus == 'ไม่ถูกต้อง') && userType=='Department'">
            <v-progress-circular
              indeterminate
              color="success"
              v-if="updateProgress"
            ></v-progress-circular>
            <div v-else-if="disburselists.length > 0">
              <v-row class="mb-1 justify-center"  >
                <v-checkbox
                  v-model="confirmCheck"
                  label="เมื่อยืนยันและส่งตรวจสอบรายการแล้วจะไม่สามารถแก้ไขได้"
                ></v-checkbox>
              </v-row>
              <v-btn
                color="warning darken-1"
                large
                @click="confirmList"
                v-if="confirmCheck"
              >
                ยืนยันและส่งตรวจสอบรายการ
              </v-btn>
            </div>  
          </div>
          <div class="col-12 text-center" v-else-if="disburse.disburseStatus == 'รอยืนยันจัดซื้อ' && userType=='Department'">
            <v-progress-circular
              indeterminate
              color="success"
              v-if="updateProgress"
            ></v-progress-circular>
            <div v-else-if="disburselists.length > 0">
              <v-row class="mb-1 justify-center"  >
                <v-checkbox
                  v-model="confirmCheck"
                  label="เมื่อยืนยันขอจัดซื้อแล้วจะไม่สามารถแก้ไขได้"
                ></v-checkbox>
              </v-row>
              <v-btn
                color="warning darken-1"
                large
                @click="confirmRequest"
                v-if="confirmCheck"
              >
                ยืนยันขอจัดซื้อ
              </v-btn>
            </div>  
          </div>
          <div class="col-12 text-center" v-else-if="disburse.disburseStatus == 'รอฝ่ายเห็นชอบ' && userType=='Party'">
            <v-progress-circular
              indeterminate
              color="success"
              v-if="updateProgress"
            ></v-progress-circular>
            <div v-else-if="disburselists.length > 0">
              <v-row class="mb-1 justify-center"  >
                <v-radio-group
                  v-model="disburseParStatus"
                  row
                >
                  <v-radio 
                    label="เห็นชอบ"
                    value="ตัดแผนแล้ว"
                    color="success"
                  > 
                  </v-radio>
                  <v-radio 
                    label="ไม่เห็นชอบ"
                    value="ฝ่ายไม่เห็นชอบ"
                    color="error"
                  > 
                  </v-radio>
                </v-radio-group>
              </v-row>
              <v-btn
                color="success"
                large
                @click="confirmParty"
                v-if="disburseParStatus"
              >
                บันทึก
              </v-btn>
            </div>  
          </div>
        </v-card-actions>
    </v-card>

    <v-row justify="center">
      <v-dialog
        v-model="updateDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="amber lighten-2">
                  <span class="fontBold">แก้ไขรายการค่าวัสดุ</span>
                </v-card-title>
                <v-form
                  v-model="updateValidate"
                  ref="updateForm"
                  lazy-validation
                  @submit.prevent="updateDisburselist"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row dense>
                      <v-col cols="12" md="6">
                        <v-text-field
                          v-model="updateData.disburselistName"
                          label="รายการ"
                          outlined
                          dense
                          required
                          :rules="[
                            ()=>!!updateData.disburselistName || 'กรุณากรอกข้อมูล'
                          ]"
                        />
                      </v-col>
                      <v-col cols="6" md="1">
                        <v-text-field
                          v-model="updateData.disburselistQty"
                          label="จำนวน"
                          outlined
                          type="number"
                          dense
                          required
                          :rules="[
                            ()=>!!updateData.disburselistQty || 'กรุณากรอกข้อมูล'
                          ]"
                        />
                      </v-col>
                      <v-col cols="6" md="2">
                        <v-text-field
                          v-model="updateData.disburselistUnit"
                          label="หน่วยนับ"
                          outlined
                          dense
                          required
                          :rules="[
                            ()=>!!updateData.disburselistUnit || 'กรุณากรอกข้อมูล'
                          ]"
                        />
                      </v-col>
                      <v-col cols="12" md="2">
                        <v-text-field
                          v-model="updateData.disburselistPrice"
                          label="ราคา"
                          outlined
                          dense
                          required
                          :rules="[
                            ()=>!!updateData.disburselistPrice || 'กรุณากรอกข้อมูล'
                          ]"
                        />
                      </v-col>
                      <v-col class="text-center">
                        <v-progress-circular indeterminate color="primary" class="mx-auto" v-if="updateProgress"></v-progress-circular>
                        <v-btn large color="warning" type="submit" class="col-12" v-else>
                          <v-icon>fas fa-edit</v-icon>
                        </v-btn>
                      </v-col>
                    </v-row>
                  </v-card-text>
                </v-form>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="deleteDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="red lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="deleteDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="red lighten-2">
                  <span class="fontBold">ลบรายการค่าวัสดุ</span>
                </v-card-title>
                <v-form
                  v-model="deleteValidate"
                  ref="deleteForm"
                  lazy-validation
                  @submit.prevent="deleteDisburselist"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row dense>
                      <v-col cols="12" md="6">
                        <v-text-field
                          v-model="deleteData.disburselistName"
                          label="รายการ"
                          outlined
                          dense
                          readonly
                        />
                      </v-col>
                      <v-col cols="6" md="1">
                        <v-text-field
                          v-model="deleteData.disburselistQty"
                          label="จำนวน"
                          outlined
                          type="number"
                          dense
                          readonly
                        />
                      </v-col>
                      <v-col cols="6" md="2">
                        <v-text-field
                          v-model="deleteData.disburselistUnit"
                          label="หน่วยนับ"
                          outlined
                          dense
                          readonly
                        />
                      </v-col>
                      <v-col cols="12" md="2">
                        <v-text-field
                          v-model="deleteData.disburselistPrice"
                          label="ราคา"
                          outlined
                          dense
                          readonly
                        />
                      </v-col>
                      <v-col class="text-center">
                        <v-progress-circular indeterminate color="primary" class="mx-auto" v-if="deleteProgress"></v-progress-circular>
                        <v-btn large color="error" type="submit" class="col-12" v-else>
                          <v-icon>fas fa-trash</v-icon>
                        </v-btn>
                      </v-col>
                    </v-row>
                  </v-card-text>
                </v-form>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
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
      user: {},
      userType: null,
      disburselists: [],
      disburseSum: [],
      disburseParStatus: null,
      insertData: {},
      insertProgress: false,
      insertValidate: null,
      expensebudgets: [],
      expenseplans: [],
      projects: [],
      pjbudgets: [],
      departments: [],
      updateData: {},
      updateProgress: false,
      updateValidate: null,
      deleteData: {},
      deleteProgress: false,
      deleteValidate: null,
      updateDialog: false,
      deleteDialog: false,
      confirmCheck: null,
    }
  },

  async mounted() {
    let userlogin = JSON.parse(sessionStorage.getItem('loginuser'))
    this.userType = userlogin.type
    this.user = JSON.parse(JSON.stringify(userlogin.user))
    console.log(this.user)
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
          await this.getDisburselist(this.disburse.disburseID).then(async ()=>{
              await this.$axios.$post('disburse.update.php', {
              token: this.$store.state.jwtToken,
              disburseID: this.disburse.disburseID,
              disburseMoney: this.disburseSum
            })
          })
          this.$emit('getUpdateStatus', {'status': true})
        }
        this.insertProgress = false
      }
    },

    showUpdateDialog(disburselist) {
      this.updateData = JSON.parse(JSON.stringify(disburselist))
      this.updateDialog = true
    },

    async updateDisburselist() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true
        this.updateData.token = this.$store.state.jwtToken
        this.updateData.disburselistStatus = ''
        let result = await this.$axios.$post('disburselist.update.php', this.updateData)
        if(result.message == 'Success') {
          await this.getDisburselist(this.disburse.disburseID).then(async ()=>{
              await this.$axios.$post('disburse.update.php', {
              token: this.$store.state.jwtToken,
              disburseID: this.disburse.disburseID,
              disburseMoney: this.disburseSum
            })
          })
          this.$emit('getUpdateStatus', {'status': true})
        }
        this.updateProgress = false
        this.updateDialog = false
      }
    },


    showDeleteDialog(disburselist) {
      this.deleteData = JSON.parse(JSON.stringify(disburselist))
      this.deleteDialog = true
    },

    async deleteDisburselist() {
      await this.$refs.deleteForm.validate()
      if(this.deleteValidate) {
        this.deleteProgress = true
        this.deleteData.token = this.$store.state.jwtToken
        let result = await this.$axios.$post('disburselist.delete.php', this.deleteData)
        if(result.message == 'Success') {
          await this.getDisburselist(this.disburse.disburseID).then(async ()=>{
              await this.$axios.$post('disburse.update.php', {
              token: this.$store.state.jwtToken,
              disburseID: this.disburse.disburseID,
              disburseMoney: this.disburseSum
            })
          })
          this.$emit('getUpdateStatus', {'status': true})
        }
        this.deleteProgress = false
        this.deleteDialog = false
      }
    },

    async confirmList() {
      this.updateProgress = true
      let disburseUpdate = await this.$axios.$post('disburse.update.php', {
        token: this.$store.state.jwtToken,
        disburseID: this.disburse.disburseID,
        disburseStatus: 'ตรวจสอบรายการ',
        disburseParcCheck: '',
        disbursePlanCheck: '',
        disburseAccoCheck: '',
        disburseFinaCheck: ''
      })

      if(disburseUpdate.message == 'Success') {
        Swal.fire({
          title: 'เรียบร้อย',
          text: 'บันทึกข้อมูลเป็นที่เรียบร้อยแล้ว',
          icon: 'success'
        })
        this.$emit('getUpdateStatus', {'status': true})
        this.disburse.disburseStatus = 'ตรวจสอบรายการ'
        let result = await this.$axios.$post('disburselist.update.php', {
          token: this.$store.state.jwtToken,
          disburseID: this.disburse.disburseID,
          disburselistStatus: '',
          disburselistComment: '',
          fn: 'byDisburse'
        })
      }
      this.updateProgress = false
    },

    async confirmRequest() {
      this.updateProgress = true
      let disburseUpdate = await this.$axios.$post('disburse.update.php', {
        token: this.$store.state.jwtToken,
        disburseID: this.disburse.disburseID,
        disburseStatus: 'รอฝ่ายเห็นชอบ',
      })

      if(disburseUpdate.message == 'Success') {
        Swal.fire({
          title: 'เรียบร้อย',
          text: 'บันทึกข้อมูลเป็นที่เรียบร้อยแล้ว',
          icon: 'success'
        })
        this.$emit('getUpdateStatus', {'status': true})
        this.disburse.disburseStatus = 'รอฝ่ายเห็นชอบ'
      }
      this.updateProgress = false
    },

    async confirmParty() {
      this.updateProgress = true
      let disburseUpdate = await this.$axios.$post('disburse.update.php', {
        token: this.$store.state.jwtToken,
        disburseID: this.disburse.disburseID,
        disburseStatus: this.disburseParStatus,
        disburseParReqName: this.user.partyHead
      })

      if(disburseUpdate.message == 'Success') {
        Swal.fire({
          title: 'เรียบร้อย',
          text: 'บันทึกข้อมูลเป็นที่เรียบร้อยแล้ว',
          icon: 'success'
        })
        this.$emit('getUpdateStatus', {'status': true})
        this.disburse.disburseStatus = this.disburseParStatus
      }
      this.updateProgress = false
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
