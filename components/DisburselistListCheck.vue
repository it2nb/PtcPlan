<template>
  <div v-if="user">
    <v-card v-if="departmentSys=='Parcel' || departmentSys=='Plan' || departmentSys=='Account' || departmentSys=='Finance' || user.userStatus=='Index'">
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
        <v-btn 
          color="white"
          :to="'/print/disburseForm3/?id='+disburse.disburseID" 
          target="_blank"
          small
          class="mx-1"
          v-if="disburse.disburseParcCheck=='ถูกต้อง' && disburse.disbursePlanCheck=='ถูกต้อง' && disburse.disburseAccoCheck=='ถูกต้อง' && disburse.disburseFinaCheck=='ถูกต้อง' && departmentSys=='Parcel'"
        >
          <v-icon class="mr-1" color="primary" small>fas fa-print</v-icon> รายงานขอซื้อขอจ้าง
        </v-btn>
        <v-btn 
          color="white"
          :to="'/print/disburseForm4/?id='+disburse.disburseID" 
          target="_blank"
          small
          class="mx-1"
          v-if="disburse.disburseParcCheck=='ถูกต้อง' && disburse.disbursePlanCheck=='ถูกต้อง' && disburse.disburseAccoCheck=='ถูกต้อง' && disburse.disburseFinaCheck=='ถูกต้อง' && departmentSys=='Parcel'"
        >
          <v-icon class="mr-1" color="primary" small>fas fa-print</v-icon> คำสั่งตรวจรับ
        </v-btn>
        <v-btn 
          color="white"
          :to="'/print/disburseForm5/?id='+disburse.disburseID" 
          target="_blank"
          small
          class="mx-1"
          v-if="disburse.disburseParcCheck=='ถูกต้อง' && disburse.disbursePlanCheck=='ถูกต้อง' && disburse.disburseAccoCheck=='ถูกต้อง' && disburse.disburseFinaCheck=='ถูกต้อง' && departmentSys=='Parcel'"
        >
          <v-icon class="mr-1" color="primary" small>fas fa-print</v-icon> รายงานผล
        </v-btn>
        <v-btn 
          color="white"
          :to="'/print/disburseForm6/?id='+disburse.disburseID" 
          target="_blank"
          small
          class="mx-1"
          v-if="disburse.disburseParcCheck=='ถูกต้อง' && disburse.disbursePlanCheck=='ถูกต้อง' && disburse.disburseAccoCheck=='ถูกต้อง' && disburse.disburseFinaCheck=='ถูกต้อง' && departmentSys=='Parcel'"
        >
          <v-icon class="mr-1" color="primary" small>fas fa-print</v-icon> ใบสั่ง
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
            <v-col cols="12" md="6">
              <h3 class="mb-2 fontBold">ค่าใช้จ่าย : โครงการ</h3>
              {{  disburse.disburseName }}
            </v-col>
            <v-col cols="12" md="6">
              <h3 class="mb-2 fontBold">หมวดงบประมาณ</h3>
              {{ disburse.budgettypeName }} : {{ disburse.budgetplanFullname }}
            </v-col>
            <v-col cols="12" md="4">
              <h3 class="mb-2 fontBold">ร้านค้า</h3>
              {{ disburse.companyName }}
            </v-col>
            <v-col cols="12" md="6">
              <h3 class="mb-2 fontBold">กรรมการตรวจรับ</h3>
              {{ disburse.disburseAuditHead }} {{ disburse.disburseAuditHeadPos }} ประธานกรรมการ<br>
              {{ disburse.disburseAuditComm }} {{ disburse.disburseAuditCommPos }} กรรมการ<br>
              {{ disburse.disburseAuditSecr }} {{ disburse.disburseAuditSecrPos }} กรรมการและเลขานุการ
            </v-col>
            <v-col cols="12" md="6">
              <h3 class="mb-2 fontBold">เลขที่หนังสือ</h3>
              เลขที่บันทึกขอซื้อฯ {{ disburse.disburseAuditHeadPos }} วันที่ <br>
              เลขที่บันทึกรายงานขอซื้อฯ {{ disburse.disburseAuditComm }} วันที่ <br>
              เลขที่คำสั่งคณะกรรมการตรวจรับ {{ disburse.disburseAuditSecr }} วันที่ <br>
              เลขที่บันทึกรายงานผลการพิจารณาฯ {{ disburse.disburseAuditSecr }} วันที่ 
            </v-col>
            <v-col cols="12" class="text-center" v-if="departmentSys=='Parcel'">
              <v-btn 
                small 
                color="warning"
                @click="showUpdateCompanyDialog(disburse)"
              >กำหนดร้านค้าและคณะกรรมการตรวจรับ</v-btn>
            </v-col>
            <v-col cols="12" class="text-center" v-if="user.userStatus=='Index'&&disburse.disburseStatus=='ตัดแผนแล้ว'">
              <v-btn 
                small 
                color="warning"
                @click="showUpdateCompanyDialog(disburse)"
              >กำหนดเลขที่หนังสืองานสารบัญ</v-btn>
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
                <v-col cols="12" md="4" class="ml-auto">
                  <v-radio-group
                    v-model="disburse.disburseAccoCheck"
                    row
                    class="text-center justify-center"
                    required
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
                <v-col cols="12" md="6"  class="mr-auto">
                  <v-autocomplete
                    v-model="disburse.ledgerID"
                    label="รหัสบัญชีแยกประเภท"
                    :items="ledgers"
                    item-text="ledgerID"
                    item-value="ledgerID"
                    outlined
                  >
                  <template v-slot:item="{ item }">
                    GL-{{ item.ledgerID }} : {{ item.ledgerName }}
                  </template>
                  </v-autocomplete>
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
                  @submit.prevent="updateDisburselist(updateData)"
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

    <v-row justify="center">
      <v-dialog
        v-model="updateCompanyDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateCompanyDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="amber lighten-2">
                  <span class="fontBold">แก้ไขร้านค้าและคณะกรรมการตรวจรับ</span>
                </v-card-title>
                <v-form
                  v-model="updateCompanyValidate"
                  ref="updateCompanyForm"
                  lazy-validation
                  @submit.prevent="updateDisburseCompany"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row dense>
                      <v-col cols="12">
                        <v-autocomplete
                          v-model="updateData.companyID"
                          label="ชื่อร้านค้า"
                          :items="companies"
                          item-text="companyName"
                          item-value="companyID"
                          dense
                          outlined
                        ></v-autocomplete>
                      </v-col>
                      <v-col cols="12" class="pb-3">
                        <v-divider></v-divider>
                      </v-col>
                      <v-col cols="12" md="4">
                        <v-text-field
                          v-model="updateData.disburseAuditHead"
                          label="ประธานกรรมการตรวจรับ"
                          outlined
                          dense
                        />
                        <v-text-field
                          v-model="updateData.disburseAuditHeadPos"
                          label="ตำแหน่ง"
                          outlined
                          dense
                        />
                      </v-col>
                      <v-col cols="12" md="4">
                        <v-text-field
                          v-model="updateData.disburseAuditComm"
                          label="กรรมการตรวจรับ"
                          outlined
                          dense
                        />
                        <v-text-field
                          v-model="updateData.disburseAuditCommPos"
                          label="ตำแหน่ง"
                          outlined
                          dense
                        />
                      </v-col>
                      <v-col cols="12" md="4">
                        <v-text-field
                          v-model="updateData.disburseAuditSecr"
                          label="กรรมการและเลขานุการตรวจรับ"
                          outlined
                          dense
                        />
                        <v-text-field
                          v-model="updateData.disburseAuditSecrPos"
                          label="ตำแหน่ง"
                          outlined
                          dense
                        />
                      </v-col>
                      <v-col cols="12" class="text-center">
                        <v-progress-circular indeterminate color="primary" class="mx-auto" v-if="updateProgress"></v-progress-circular>
                        <v-btn large color="warning" type="submit" class="col-4" v-else>
                          <v-icon small class="mr-1">fas fa-edit</v-icon> แก้ไข
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
      ledgers: [],
      disburseuser: {},
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
      updateCompanyDialog: false,
      updateCompanyValidate: null,
      companies: []
    }
  },

  async mounted() {
    let loginuser = JSON.parse(sessionStorage.getItem('loginuser'))
    this.user = JSON.parse(JSON.stringify(loginuser.user))
    if(this.disburse) {
      await this.getDisburselist(this.disburse.disburseID)
      await this.getDisburselistQty(this.disburse.disburseID)
      await this.getLedger()
      if(this.disburse.userID>0) {
        await this.getDisburseUser(this.disburse.userID)
      }
    }
  },

  beforeDestroy() {
    this.$emit('getUpdateStatus', {'status': true})
  },

  methods: {
    async getDisburseUser(userID) {
      let result = await this.$axios.$get('user.php', {
        params: {
          token: this.$store.state.jwtToken,
          userID: userID
        }
      })

      if(result.message == 'Success') {
        this.disburseuser = JSON.parse(JSON.stringify(result.user))
      }
    },

    async getLedger() {
      let result = await this.$axios.$get('ledger.php', {
        params: {
          token: this.$store.state.jwtToken,
          fn: 'All'
        }
      })

      if(result.message == 'Success') {
        this.ledgers = JSON.parse(JSON.stringify(result.ledger))
      }
    },

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
        this.disburseSum = this.disburselists.reduce((prev, curr)=> parseFloat(prev) + parseFloat(curr.disburselistSumPrice), 0);
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

    async getCompany() {
        let result = await this.$axios.$get('company.php', {
        params: {
          token: this.$store.state.jwtToken,
          fn: 'All'
        }
      })
      if(result.message == 'Success') {
        this.companies = JSON.parse(JSON.stringify(result.company))
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
      let lineMsg = ''
      if(this.departmentSys == 'Parcel') {
        lineMsg = 'งานพัสดุ'
        disburse.disburseParcDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
        if(disburse.disburseParcCheck=='ถูกต้อง') {
          disburse.disburseParcHead = this.user.departmentHead
          disburse.parcUserID = this.user.userID
          await this.sendLineGroup('มีรายการขอซื้อขอจ้าง รหัส DB-'+parseInt(this.disburse.disburseID)+' ('+this.qtyFormat(this.disburse.disburseMoney)+' บาท) ส่งมาให้ > งานวางแผนฯ > ตรวจสอบความถูกต้อง')
          await this.sendLindDepartSys('Plan', this.disburse.disburseID)
        }
      } else if(this.departmentSys == 'Plan') {
        lineMsg = 'งานวางแผนฯ'
        disburse.disbursePlanDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
        if(disburse.disbursePlanCheck=='ถูกต้อง') {
          disburse.disbursePlanHead = this.user.departmentHead
          disburse.planUserID = this.user.userID
          await this.sendLineGroup('มีรายการขอซื้อขอจ้าง รหัส DB-'+parseInt(this.disburse.disburseID)+' ('+this.qtyFormat(this.disburse.disburseMoney)+' บาท) ส่งมาให้ > งานบัญชี > ตรวจสอบความถูกต้อง')
          await this.sendLindDepartSys('Account', this.disburse.disburseID)
        }
      }
      if(this.departmentSys == 'Account') {
        lineMsg = 'งานการบัญชี'
        disburse.disburseAccoDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
        if(disburse.disburseAccoCheck=='ถูกต้อง') {
          disburse.disburseAccoHead = this.user.departmentHead
          disburse.accoUserID = this.user.userID
          await this.sendLineGroup('มีรายการขอซื้อขอจ้าง รหัส DB-'+parseInt(this.disburse.disburseID)+' ('+this.qtyFormat(this.disburse.disburseMoney)+' บาท) ส่งมาให้ > งานการเงิน > ตรวจสอบความถูกต้อง')
          await this.sendLindDepartSys('Finance', this.disburse.disburseID)
        }
      }
      if(this.departmentSys == 'Finance') {
        lineMsg = 'งานการเงิน'
        disburse.disburseFinaDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
        if(disburse.disburseFinaCheck=='ถูกต้อง') {
          disburse.finaUserID = this.user.userID
          disburse.disburseFinaHead = this.user.departmentHead
        }
      }

      if(disburse.disburseParcCheck=='ไม่ถูกต้อง' || disburse.disbursePlanCheck=='ไม่ถูกต้อง' || disburse.disburseAccoCheck=='ไม่ถูกต้อง' || disburse.disburseFinaCheck=='ไม่ถูกต้อง') {
        disburse.disburseStatus = 'ไม่ถูกต้อง'
        await this.sendLineGroup('ผลตรวจสอบรายการขอซื้อขอจ้าง รหัส DB-'+parseInt(this.disburse.disburseID)+' ('+this.qtyFormat(this.disburse.disburseMoney)+' บาท) : ไม่ถูกต้อง > ส่งกลับไปแก้ไข')
        lineMsg = 'ผลตรวจสอบรายการขอซื้อขอจ้าง รหัส DB-'+parseInt(this.disburse.disburseID)+' ('+this.qtyFormat(this.disburse.disburseMoney)+' บาท) : ไม่ถูกต้อง > โปรดแก้ไขและยืนยันคำขออีกครั้ง'
      } else if(disburse.disburseParcCheck=='ถูกต้อง' && disburse.disbursePlanCheck=='ถูกต้อง' && disburse.disburseAccoCheck=='ถูกต้อง' && disburse.disburseFinaCheck=='ถูกต้อง') {
        disburse.disburseStatus = 'รอฝ่ายเห็นชอบ'
        await this.sendLineGroup('มีรายการขอซื้อขอจ้าง รหัส DB-'+parseInt(this.disburse.disburseID)+' ('+this.qtyFormat(this.disburse.disburseMoney)+' บาท) ส่งมาให้ > รองฝ่าย'+(disburse.pjpartyID? disburse.pjpartyName: disburse.partyName)+' > ให้ความเห็นชอบ')
        lineMsg = 'ผลตรวจสอบรายการขอซื้อขอจ้าง รหัส DB-'+parseInt(this.disburse.disburseID)+' ('+this.qtyFormat(this.disburse.disburseMoney)+' บาท) : ถูกต้อง > รอให้รองฝ่าย'+(disburse.pjpartyID? disburse.pjpartyName: disburse.partyName)+'ให้ความเห็นชอบ'
        this.sendLindParty(disburse.pjpartyID? disburse.pjpartyID: disburse.partyID, disburse.disburseID)
      }
      let result = await this.updateDisburse(disburse)

      if(result) {
        Swal.fire({
          title: 'เรียบร้อย',
          text: 'บันทึกข้อมูลเป็นที่เรียบร้อยแล้ว',
          icon: 'success'
        }).then(async ()=>{
          if(disburse.disburseStatus == 'ไม่ถูกต้อง' || disburse.disburseStatus == 'รอฝ่ายเห็นชอบ') {
            if(this.disburseuser.userLineToken) {
            await this.$axios.$post('sendline.php', {
              token: this.disburseuser.userLineToken,
              message: lineMsg+'\n'+window.location.origin
            })
          }
          
        }
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

    showUpdateCompanyDialog(disburse) {
      this.updateData = JSON.parse(JSON.stringify(disburse))
      this.getCompany()
      this.updateCompanyDialog = true
    },

    async updateDisburseCompany() {
      this.updateProgress = true
      let disburseUpdate = await this.$axios.$post('disburse.update.php', {
        token: this.$store.state.jwtToken,
        disburseID: this.updateData.disburseID,
        companyID: this.updateData.companyID,
        disburseAuditHead: this.updateData.disburseAuditHead,
        disburseAuditHeadPos: this.updateData.disburseAuditHeadPos,
        disburseAuditComm: this.updateData.disburseAuditComm,
        disburseAuditCommPos: this.updateData.disburseAuditCommPos,
        disburseAuditSecr: this.updateData.disburseAuditSecr,
        disburseAuditSecrPos: this.updateData.disburseAuditSecrPos
      })

      if(disburseUpdate.message == 'Success') {
        Swal.fire({
          title: 'เรียบร้อย',
          text: 'แก้ไขข้อมูลเป็นที่เรียบร้อยแล้ว',
          icon: 'success'
        }).then(()=>{
          this.disburse.companyID = this.updateData.companyID
          this.disburse.companyName = this.companies.filter(company => company.companyID==this.updateData.companyID)[0].companyName || ''
          this.disburse.disburseAuditHead = this.updateData.disburseAuditHead
          this.disburse.disburseAuditHeadPos = this.updateData.disburseAuditHeadPos
          this.disburse.disburseAuditComm = this.updateData.disburseAuditComm
          this.disburse.disburseAuditHeadPos = this.updateData.disburseAuditHeadPos
          this.disburse.disburseAuditSecr = this.updateData.disburseAuditSecr
          this.disburse.disburseAuditHeadPos = this.updateData.disburseAuditHeadPos
          this.updateProgress = false
          this.updateCompanyDialog = false
        })
      } else {
        Swal.fire({
          title: 'เรียบร้อย',
          text: 'แก้ไขข้อมูลเป็นที่เรียบร้อยแล้ว',
          icon: 'success'
        }).then(()=>{
          this.updateProgress = false
          this.updateCompanyDialog = false
        })
      }
    },

    async sendLindDepartSys(departmentSys, disburseID) {
      await this.$axios.$get('department.php', {
        params: {
          token: this.$store.state.jwtToken,
          departmentSys: departmentSys
        }
      }).then(result=> {
        if(result.message=='Success') {
          result.department.forEach(async department => {
            await this.$axios.$get('user.php', {
              params: {
                token: this.$store.state.jwtToken,
                departmentID: department.departmentID
              }
            }).then(result2=>{
              if(result2.message == 'Success') {
                result2.user.forEach(async user=>{
                  if(user.userLineToken) {
                    await this.$axios.$post('sendline.php', {
                      token: user.userLineToken,
                      message: 'มีรายการขอซื้อขอจ้าง รหัส DB-'+parseInt(disburseID)+' ('+this.qtyFormat(this.disburse.disburseMoney)+' บาท) ส่งมาตรวจสอบความถูกต้อง\n'+window.location.origin
                    })
                  }
                })
              }
            })
          })
        }
      })
    },

    async sendLindParty(partyID, disburseID) {
      await this.$axios.$get('user.php', {
        params: {
          token: this.$store.state.jwtToken,
          partyID: partyID
        }
      }).then(result=>{
        if(result.message == 'Success') {
          result.user.forEach(async user=>{
            if(user.userLineToken) {
              await this.$axios.$post('sendline.php', {
                token: user.userLineToken,
                message: 'มีรายการขอซื้อขอจ้าง รหัส DB-'+parseInt(disburseID)+' ('+this.qtyFormat(this.disburse.disburseMoney)+' บาท) ส่งมาตรวจสอบและให้ความเห็นชอบ\n'+window.location.origin
              })
            }
          })
        }
      })
    },

    async sendLineGroup(msg){
      if(this.$store.state.lineGroupToken) {
        await this.$axios.$post('sendline.php', {
          token: this.$store.state.lineGroupToken,
          message: msg+'\n'+window.location.origin
        })
      }
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
      if(qty%1) {
        return numeral(qty).format('0,0.00')
      } else {
        return numeral(qty).format('0,0')
      }
    },

  },

  watch: {
    async disburse() {
      await this.getDisburselist(this.disburse.disburseID)
      await this.getDisburselistQty(this.disburse.disburseID)
      await this.getLedger()
      if(this.disburse.userID>0) {
        await this.getDisburseUser(this.disburse.userID)
      }
      this.insertData = {}
    }
  }
}
</script>
