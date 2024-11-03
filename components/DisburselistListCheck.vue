<template>
  <div>
    <v-card v-if="departmentSys=='Parcel' || departmentSys=='Plan' || departmentSys=='Account' || departmentSys=='Finance'">
      <v-card-title class="amber lighten-2">
        <span class="fontBold">เพิ่มรายการ{{ disburse.expenseName }}</span>
        <v-spacer></v-spacer>
        <v-btn 
          color="white"
          :to="'/print/disburseForm1/?id='+disburse.disburseID" 
          target="_blank"
          small
          class="mx-1"
        >
          <v-icon class="mr-1" color="primary" small>fas fa-print</v-icon> ขออนุมัติ (สผ.1)
        </v-btn>
        <v-btn 
          color="white"
          :to="'/print/disburseForm2/?id='+disburse.disburseID" 
          target="_blank"
          small
          class="mx-1"
          v-if="disburse.disburseParcCheck=='ถูกต้อง' && disburse.disbursePlanCheck=='ถูกต้อง' && disburse.disburseAccoCheck=='ถูกต้อง' && disburse.disburseFinaCheck=='ถูกต้อง' && departmentSys=='Parcel'"
        >
          <v-icon class="mr-1" color="primary" small>fas fa-print</v-icon> ใบเบิก
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
            <v-col cols="12">
              <h3 class="mb-2 fontBold">ค่าใช้จ่าย : โครงการ</h3>
              {{  disburse.disburseName }}
            </v-col>
            <v-col cols="12">
              <h3 class="mb-2 fontBold">หมวดงบประมาณ</h3>
              {{ disburse.budgettypeName }} : {{ disburse.budgetplanFullname }}
            </v-col>
            <v-col>
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
              :items="disburselistcs"
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
                <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="item.disburselistStatus!='ถูกต้อง'">
                  <v-icon small class="mr-1">fas fa-edit</v-icon>
                </v-btn>
                <v-icon small color="success" v-if="item.disburselistStatus=='ถูกต้อง'">fas fa-check</v-icon>
                <v-icon small color="error" v-if="item.disburselistStatus=='ไม่ถูกต้อง'">fas fa-times</v-icon>
                {{ item.disburselistStatus=='ไม่ถูกต้อง' ? item.disburselistComment : '' }}
              </template>
              <template v-slot:item.actions="{ item }">
                <div v-if="disburse.disburseStatus == 'ตรวจสอบรายการ' && departmentSys=='Parcel'">
                  <v-progress-circular indeterminate color="primary" class="mx-auto" v-if="updateProgress"></v-progress-circular>
                    <div v-if="disburselists[disburselistcs.indexOf(item)].disburselistStatus!='ถูกต้อง'&&disburselists[disburselistcs.indexOf(item)].disburselistStatus!='ไม่ถูกต้อง'">
                        <v-radio-group
                            v-model="item.disburselistStatus"
                            row
                        >
                            <v-radio
                                label="ถูกต้อง"
                                value="ถูกต้อง"
                                color="success"
                            ></v-radio>
                            <v-radio
                                label="ไม่ถูกต้อง"
                                value="ไม่ถูกต้อง"
                                color="error"
                            ></v-radio>
                        </v-radio-group>
                        <v-text-field
                            v-model="item.disburselistComment"
                            label="หมายเหตุ"
                            outlined
                            v-if="item.disburselistStatus=='ไม่ถูกต้อง'"
                        ></v-text-field>
                        <v-btn 
                            color="success" 
                            small 
                            class="mb-1"
                            @click="updateDisburselist(item)"
                        >
                            <v-icon small class="mr-1">fas fa-save</v-icon> บันทึก
                        </v-btn>
                    </div>
                    <div v-else>
                        <v-btn color="warning" icon  small @click="disburselists[disburselistcs.indexOf(item)].disburselistStatus=''">
                        <v-icon small class="mr-1">fas fa-edit</v-icon>
                        </v-btn>
                        <!-- <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)">
                        <v-icon small class="mr-1">fas fa-trash</v-icon>
                        </v-btn> -->
                    </div>
                </div>
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
          <div class="col-12 text-center" v-if="disburse.disburseStatus == 'ขอซื้อ'">
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
          <div class="col-12" v-else-if="disburse.disburseStatus == 'ตรวจสอบรายการ'">
            <div v-if="departmentSys == 'Parcel'">
              <v-row no-gutters>
                <v-col cols="12" md="4" class="mx-auto">
                  <v-radio-group
                    v-model="disburse.disburseParcCheck"
                    row
                    :readonly="!disburseParcCheck"
                    class="text-center justify-center"
                  >
                    <v-radio
                      label="ถูกต้อง"
                      value="ถูกต้อง"
                      color="success"
                    ></v-radio>
                    <v-radio
                      label="ไม่ถูกต้อง"
                      value="ไม่ถูกต้อง"
                      color="error"
                    ></v-radio>
                  </v-radio-group>
                </v-col>
                <v-col cols="12" md="10" class="mx-auto">
                  <v-textarea
                    v-model="disburse.disburseParcDes"
                    label="หมายเหตุ"
                    outlined
                  ></v-textarea>
                </v-col>
              </v-row>
            </div>
            <div v-else-if="departmentSys=='Plan'">
              <v-row no-gutters>
                <v-col cols="12" md="4" class="mx-auto">
                  <v-radio-group
                    v-model="disburse.disbursePlanCheck"
                    row
                    class="text-center justify-center"
                  >
                    <v-radio
                      label="ถูกต้อง"
                      value="ถูกต้อง"
                      color="success"
                    ></v-radio>
                    <v-radio
                      label="ไม่ถูกต้อง"
                      value="ไม่ถูกต้อง"
                      color="error"
                    ></v-radio>
                  </v-radio-group>
                </v-col>
                <v-col cols="12" md="10" class="mx-auto">
                  <v-textarea
                    v-model="disburse.disbursePlanDes"
                    label="หมายเหตุ"
                    outlined
                  ></v-textarea>
                </v-col>
              </v-row>
            </div>
            <div v-else-if="departmentSys=='Account'">
              <v-row no-gutters>
                <v-col cols="12" md="4" class="mx-auto">
                  <v-radio-group
                    v-model="disburse.disburseAccoCheck"
                    row
                    class="text-center justify-center"
                  >
                    <v-radio
                      label="ถูกต้อง"
                      value="ถูกต้อง"
                      color="success"
                    ></v-radio>
                    <v-radio
                      label="ไม่ถูกต้อง"
                      value="ไม่ถูกต้อง"
                      color="error"
                    ></v-radio>
                  </v-radio-group>
                </v-col>
                <v-col cols="12" md="10" class="mx-auto">
                  <v-textarea
                    v-model="disburse.disburseAccoDes"
                    label="หมายเหตุ"
                    outlined
                  ></v-textarea>
                </v-col>
              </v-row>
            </div>
            <div v-else-if="departmentSys=='Finance'">
              <v-row no-gutters>
                <v-col cols="12" md="4" class="mx-auto">
                  <v-radio-group
                    v-model="disburse.disburseFinaCheck"
                    row
                    class="text-center justify-center"
                  >
                    <v-radio
                      label="ถูกต้อง"
                      value="ถูกต้อง"
                      color="success"
                    ></v-radio>
                    <v-radio
                      label="ไม่ถูกต้อง"
                      value="ไม่ถูกต้อง"
                      color="error"
                    ></v-radio>
                  </v-radio-group>
                </v-col>
                <v-col cols="12" md="10" class="mx-auto">
                  <v-textarea
                    v-model="disburse.disburseFinaDes"
                    label="หมายเหตุ"
                    outlined
                  ></v-textarea>
                </v-col>
              </v-row>
            </div>
            <div class="text-center">
              <v-btn small color="success" @click="updateDisburseCheck(disburse)">
                <v-icon small class="mr-1">fas fa-save</v-icon> บันทึก
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
import { readonly } from 'vue';
export default {
  props: {
    disburse: {
      type: Object,
      default: () => {}
    },
    departmentSys: {
        type: String,
        default: null
    }
  },

  data() {
    return {
      user: {},
      disburselists: [],
      disburselistcs: [],
      disburselistQty: {},
      disburseSum: [],
      disburseParcCheck: true,
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
    let loginuser = JSON.parse(sessionStorage.getItem('loginuser'))
    this.user = JSON.parse(JSON.stringify(loginuser.user))
    if(this.disburse) {
      await this.getDisburselist(this.disburse.disburseID)
      await this.getDisburselistQty(this.disburse.disburseID)
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
        this.disburselistcs = JSON.parse(JSON.stringify(result.disburselist))
        this.disburseSum = this.disburselists.reduce((prev, curr)=> parseInt(prev) + parseInt(curr.disburselistSumPrice), 0);
      }
    },

    async getDisburselistQty(disburseID) {
        let result = await this.$axios.$get('disburselist.php', {
        params: {
          token: this.$store.state.jwtToken,
          disburseID: disburseID,
          fn: 'countCorrectWrong'
        }
      })
      if(result.message == 'Success') {
        this.disburselistQty = JSON.parse(JSON.stringify(result.disburselist))
      }
    },

    showUpdateDialog(disburselist) {
      this.updateData = JSON.parse(JSON.stringify(disburselist))
      this.updateDialog = true
    },

    async updateDisburse(disburse) {
      disburse.token = this.$store.state.jwtToken
      let disburseUpdate = await this.$axios.$post('disburse.update.php', disburse)

      if(disburseUpdate.message == 'Success') {
        return true
      } else {
        return false
      }
    },

    async updateDisburseCheck(disburse) {
      if(this.departmentSys == 'Parcel') {
        if(disburse.disburseParcCheck=='ถูกต้อง') {
          disburse.disburseParcHead = this.user.departmentHead
        }
      } else if(this.departmentSys == 'Plan') {
        if(disburse.disbursePlanCheck=='ถูกต้อง') {
          disburse.disbursePlanHead = this.user.departmentHead
        }
      }
      if(this.departmentSys == 'Account') {
        if(disburse.disburseAccoCheck=='ถูกต้อง') {
          disburse.disburseAccoHead = this.user.departmentHead
        }
      }
      if(this.departmentSys == 'Finace') {
        if(disburse.disburseFinaCheck=='ถูกต้อง') {
          disburse.disburseFinaHead = this.user.departmentHead
        }
      }

      if(disburse.disburseParcCheck=='ไม่ถูกต้อง' || disburse.disbursePlanCheck=='ไม่ถูกต้อง' || disburse.disburseAccoCheck=='ไม่ถูกต้อง' || disburse.disburseFinaCheck=='ไม่ถูกต้อง') {
        disburse.disburseStatus = 'ไม่ถูกต้อง'
      } else if(disburse.disburseParcCheck=='ถูกต้อง' && disburse.disbursePlanCheck=='ถูกต้อง' && disburse.disburseAccoCheck=='ถูกต้อง' && disburse.disburseFinaCheck=='ถูกต้อง') {
        disburse.disburseStatus = 'รอยืนยันจัดซื้อ'
      }
      let result = await this.updateDisburse(disburse)

      if(result) {
        Swal.fire({
          title: 'เรียบร้อย',
          text: 'บันทึกข้อมูลเป็นที่เรียบร้อยแล้ว',
          icon: 'success'
        }).then(()=>{
          this.$emit('getUpdateStatus', {'status': true})
        })
      } else {
        Swal.fire({
          title: 'เรียบร้อย',
          text: 'บันทึกข้อมูลแล้ว',
          icon: 'success'
        }).then(()=>{
          this.$emit('getUpdateStatus', {'status': true})
        })
      }
    },

    async updateDisburselist(disburselist) {
        this.updateProgress = true
        disburselist.token = this.$store.state.jwtToken
        let result = await this.$axios.$post('disburselist.update.php', disburselist)
        await this.getDisburselist(this.disburse.disburseID)
        //if(result.message == 'Success') {
        await this.getDisburselistQty(this.disburse.disburseID).then(async ()=>{
            if(this.disburselistQty.wrongQty > 0) {
              this.disburse.disburseParcCheck = 'ไม่ถูกต้อง'
              this.disburseParcCheck = false
              //await this.updateDisburseCheck(this.disburse)
            } else if(this.disburselistQty.allQty == this.disburselistQty.correctQty) {
              this.disburse.disburseParcCheck = 'ถูกต้อง'
              this.disburseParcCheck = true
              //await this.updateDisburseCheck(this.disburse)
            } else {
              this.disburse.disburseParcCheck = ''
              this.disburseParcCheck = true
              //await this.updateDisburseCheck(this.disburse)
            }
            //this.$emit('getUpdateStatus', {'status': true})
          })
        //}
        this.updateProgress = false
        this.updateDialog = false
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
        disburseStatus: 'ตรวจสอบรายการ'
      })

      if(disburseUpdate.message == 'Success') {
        this.$emit('getUpdateStatus', {'status': true})
        this.disburse.disburseStatus = 'ตรวจสอบรายการ'
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
