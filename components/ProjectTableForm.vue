<template>
  <div>
    <v-data-table
      :headers="headers"
      :items="projectDatas"
      :search="search"
      :items-per-page="-1"
      :loading="projectsLoading"
      hide-default-footer
    >
      <template v-slot:top>
        <v-row>
          <v-col cols="12" class="text-center fontBold">
            ทั้งหมดจำนวน {{ projectDatas.length }} โครงการ งบประมาณ
            <span v-if="projectDatas.length>0">
              <span class="fontBold" v-if="projectDatas[0].projectStatus=='เสนอโครงการ'">{{ moneyFormat(projectSum.pjbudgetWaitApproveMoney) }} </span>
              <span class="fontBold" v-else-if="status=='ฝ่ายเห็นชอบ'">{{ moneyFormat(projectSum.pjbudgetParApproveMoney) }} </span>
              <span class="fontBold" v-else-if="status=='อนุมัติ'">{{ moneyFormat(projectSum.pjbudgetApproveMoney) }} </span>
              <span class="fontBold" v-else>{{ moneyFormat(projectSum.pjbudgetMoney) }} </span>
            </span>
            <span class="fontBold" v-else>
              0
            </span>
            บาท
          </v-col>
          <v-col cols="12" md="4" v-if="insertBt">
            <v-btn color="success" text @click="showInsertDialog">
              <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มโครงการ
            </v-btn>
          </v-col>
          <v-col cols="12" md="4">
            <v-autocomplete
              v-model="strategicID"
              label="ยุทธศาสตร์"
              :items="strategics"
              item-text="orgstrategicName"
              item-value="orgstrategicID"
              hide-details
              outlined
              dense
              @change="getProjects"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field
              v-model="search"
              append-icon="mdi-magnify"
              label="ค้นหา"
              hide-details
              outlined
              dense
            ></v-text-field>
          </v-col>
        </v-row>
      </template>

      <template v-slot:item.projectID="{ item }">
        <div class="text-no-wrap text-left">
          <div  class="text-no-wrap">PJ-{{ parseInt(item.projectID) }}</div>
        </div>
      </template>

      <template v-slot:item.projectCode="{ item }">
        <div class="text-no-wrap text-left">
          <div  class="text-no-wrap">{{ item.projectCode }}</div>
        </div>
      </template>

      <template v-slot:item.projectNamePresenter="{ item }">
        <div class="py-2">
          <v-icon small color="red darken-4" v-if="item.projectType=='ในแผน'">fas fa-school</v-icon>
          <v-icon small color="brown" v-else-if="item.projectType=='เข้าแผน'">fas fa-user</v-icon>
          <v-icon small color="orange" v-else-if="item.projectType=='เพิ่มเติม'">fas fa-add</v-icon>
          <span class="font-weight-bold">{{ item.projectName }}</span><br>
          <span class="pl-2 text-no-wrap text--secondary">{{ item.departmentName }}</span><br>
          <span class="pl-2 text-no-wrap text--secondary">ฝ่าย{{ item.partyName }}</span><br>
        </div>
      </template>

      <template v-slot:item.departmentName="{ item }">
        <!-- <span class="text-no-wrap" v-if="userType!='Public'"><v-icon x-small color="primary" class="mr-1">fas fa-circle</v-icon>{{ item.personalName }} {{ item.personalSer }}<br></span> -->
        <span class="text-no-wrap text--primary"><v-icon x-small color="primary" class="mr-1">fas fa-circle</v-icon>{{ item.departmentName }}</span><br>
        <!-- <span class="text-no-wrap text--secondary">ฝ่าย{{ item.partyName }}</span> -->
      </template>

      <template v-slot:item.pjbudgetMoney="{ item }">
        <div class="text-no-wrap text-right">
          {{ moneyFormat(parseFloat(item.pjbudgetMoney)) }}
          <div class="caption" v-if="parseFloat(item.disburseMoney)>0">
            <span class="px-1 success lighten-4" v-if="parseFloat(item.disburseMoney)<=parseFloat(item.pjbudgetMoney)">{{ moneyFormat(parseFloat(item.disburseMoney)) }}</span>
            <span class="px-1 red lighten-4" v-else>{{ moneyFormat(parseFloat(item.disburseMoney)) }}</span>
          </div>
      </div>
      </template>

      <template v-slot:item.projectStatus="{ item }">
        <v-btn
          x-small
          text
          rounded
          @click="showUpdateStatusDialog(item)"
        >
          <v-chip x-small color="success" class="py-3" v-if="item.projectStatus=='อนุมัติ'">
            <v-icon small class="mr-1">fas fa-check-circle</v-icon> {{ item.projectStatus }}
          </v-chip>
          <v-chip color="lime" x-small class="py-3" v-else-if="item.projectStatus=='ฝ่ายเห็นชอบ'">
            <v-icon small class="mr-1">fas fa-clock</v-icon> {{ item.projectStatus }}
            <!-- <v-icon x-small class="ml-1" v-if="item.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon> -->
          </v-chip>
          <!-- <v-chip color="deep-purple" x-small dark v-else-if="item.projectStatus=='แผนก/งานเห็นชอบ'">
            <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.projectStatus }}
            <v-icon x-small class="ml-1" v-if="item.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon>
          </v-chip> -->
          <v-chip color="red" x-small dark class="py-3" v-else-if="item.projectStatus=='ไม่อนุมัติ' ||  item.projectStatus=='ฝ่ายไม่เห็นชอบ' ||  item.projectStatus=='ไม่ผ่าน'">
            <v-icon small class="mr-1">fas fa-exclamation</v-icon> {{ item.projectStatus }}
            <!-- <v-icon x-small class="ml-1" v-if="item.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon> -->
          </v-chip>
          <v-chip color="info" x-small dark class="py-3" v-else>
            <v-icon small class="mr-1">fas fa-clock</v-icon> {{ item.projectStatus }}
            <!-- <v-icon x-small class="ml-1" v-if="item.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon> -->
          </v-chip>
        </v-btn>
      </template>
      <template v-slot:item.projectProgress="{ item }">
        <v-btn
          x-small
          text
          rounded
          @click="showUpdateProgressDialog(item)"
          v-if="item.projectStatus=='อนุมัติ'"
        >
          <v-chip x-small color="success" class="py-3" v-if="item.projectProgress=='ดำเนินการเสร็จสิ้น'">
            <v-icon small class="mr-1">fas fa-check-circle</v-icon> {{ item.projectProgress }}
          </v-chip>
          <v-chip color="red" x-small dark class="py-3" v-else-if="item.projectProgress=='ยังไม่ได้ดำเนินการ'">
            <v-icon small class="mr-1">fas fa-exclamation</v-icon> {{ item.projectProgress }}
          </v-chip>
          <v-chip color="yellow" x-small class="py-3" v-else>
            <v-icon small class="mr-1">fas fa-clock</v-icon> {{ item.projectProgress }}
          </v-chip>
        </v-btn>
      </template>
      <template v-slot:item.projectReport="{ item }">
        <v-btn color="success" text small dark @click="showSummaryReportDialog(item)"  v-if="item.projectProgress=='ดำเนินการเสร็จสิ้น'">
          <v-chip x-small color="red darken-1" class="py-3" v-if="item.projectReport=='ไม่รายงาน'">
            <v-icon small class="mr-1">fas fa-exclamation</v-icon> ไม่รายงาน
          </v-chip>
          <v-chip x-small color="warning" class="py-3" v-else-if="item.projectReport=='ไม่ครบถ้วน' || item.imageQty<4">
            <v-icon small class="mr-1">fas fa-clock</v-icon> เข้ารายงาน
          </v-chip>
          <v-chip x-small color="success" class="py-3" v-else-if="item.projectReport=='ครบถ้วน'">
            <v-icon small class="mr-1">fas fa-check-circle</v-icon> ครบถ้วน
          </v-chip>
        </v-btn>
      </template>
      <template v-slot:item.actions="{ item }">
        <div  class="text-no-wrap">
          <!-- <v-btn icon @click="showActivityBudgetDialog(item)" v-if="((userType=='Personal' && item.projectStatus!='แผนก/งานเห็นชอบ' && item.projectStatus!='ฝ่ายเห็นชอบ' && item.projectStatus!='อนุมัติ' && updateBt) || (userType=='Department' && item.projectStatus!='ฝ่ายเห็นชอบ' && item.projectStatus!='อนุมัติ' && updateBt) || (userType=='Party' && item.projectStatus!='อนุมัติ' && updateBt) || userType=='Admin' || userType=='Plan') && item.projectProgress!='ดำเนินการเสร็จสิ้น'"> -->
          <v-btn icon @click="showActivityBudgetDialog(item)">
            <v-icon color="success">fas fa-clipboard-list</v-icon>
          </v-btn>
          <v-btn color="info darken-2" icon small :href="'/print/project/?pid='+item.projectID" target="_blank">
            <v-icon small class="mr-1">fas fa-print</v-icon>
          </v-btn>
          <br>
          <!-- <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="((userType=='Personal' && item.projectStatus!='ฝ่ายเห็นชอบ' && item.projectStatus!='อนุมัติ' && updateBt) || (userType=='Department' && item.projectStatus!='ฝ่ายเห็นชอบ' && item.projectStatus!='อนุมัติ' && updateBt) || (userType=='Party' && item.projectStatus!='อนุมัติ' && updateBt) || userType=='Admin' || userType=='Plan') && item.projectProgress!='ดำเนินการเสร็จสิ้น'">
            <v-icon small class="mr-1">fas fa-edit</v-icon>
          </v-btn>
          <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="((userType=='Personal' && item.projectStatus!='ฝ่ายเห็นชอบ' && item.projectStatus!='อนุมัติ' && parseFloat(item.disburseMoney)<=0 && deleteBt) || (userType=='Department' && item.projectStatus!='ฝ่ายเห็นชอบ' && item.projectStatus!='อนุมัติ' && deleteBt) || userType=='Admin' || userType=='Plan') && item.projectProgress=='ยังไม่ได้ดำเนินการ'">
            <v-icon small class="mr-1">fas fa-trash</v-icon>
          </v-btn> -->
          <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="((userType=='Personal' && item.projectStatus!='ฝ่ายเห็นชอบ' && item.projectStatus!='อนุมัติ' && updateBt) || (userType=='Department' && item.projectStatus!='ฝ่ายเห็นชอบ' && item.projectStatus!='อนุมัติ' && updateBt) || (userType=='Party' && item.projectStatus!='อนุมัติ' && updateBt) || userType=='Admin' || userType=='Plan') && item.projectProgress!='ดำเนินการเสร็จสิ้น'">
            <v-icon small class="mr-1">fas fa-edit</v-icon>
          </v-btn>
          <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="((userType=='Personal' && item.projectStatus!='ฝ่ายเห็นชอบ' && item.projectStatus!='อนุมัติ' && parseFloat(item.disburseMoney)<=0 && item.projectType!='ในแผน' && deleteBt) || (userType=='Department' && item.projectStatus!='ฝ่ายเห็นชอบ' && item.projectStatus!='อนุมัติ' && parseFloat(item.disburseMoney)<=0 && item.projectType!='ในแผน' && deleteBt) || userType=='Admin' || userType=='Plan') && item.projectProgress=='ยังไม่ได้ดำเนินการ'">
            <v-icon small class="mr-1">fas fa-trash</v-icon>
          </v-btn>
        </div>
      </template>
    </v-data-table>

    <v-row justify="center">
      <v-dialog
        v-model="insertDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="light-green lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="insertDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="light-green lighten-2">
                  <span class="fontBold">เพิ่มข้อมูลโครงการ ปีงบประมาณ พ.ศ.{{ parseInt(this.projectYear)+543 }}</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="projectInsertValidate"
                  ref="projectInsertForm"
                  lazy-validation
                  @submit.prevent="insertProject"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row dense>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ฝ่าย</h3>
                        <v-autocomplete
                          v-model="projectData.partyID"
                          :items="parties"
                          item-text="partyName"
                          item-value="partyID"
                          label="ฝ่าย"
                          outlined
                          :readonly="userType=='Department' || userType=='Party'"
                          :rules="[
                            () => !!projectData.partyID || 'กรุณากรอกข้อมูล'
                          ]"
                          @change="partyChange"
                        ></v-autocomplete>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">แผนก/งาน</h3>
                        <v-autocomplete
                          v-model="projectData.departmentID"
                          :items="departments"
                          item-text="departmentName"
                          item-value="departmentID"
                          label="แผนก/งาน"
                          outlined
                          :readonly="userType=='Department'"
                          :rules="[
                            () => !!projectData.departmentID || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-autocomplete>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ยุทธศาสตร์สถานศึกษา</h3>
                        <v-select
                          v-model="projectData.orgstrategicID"
                          label="ยุทธศาสตร์สถานศึกษา"
                          :items="orgstrategics"
                          item-text="orgstrategicFullname"
                          item-value="orgstrategicID"
                          outlined
                          required
                          :rules="[
                            ()=>!!projectData.orgstrategicID || 'กรุณากรอกข้อมูล'
                          ]"
                          @change="orgstrategicChange"
                        ></v-select>
                      </v-col>
                      <!-- <v-col cols="12">
                        <h3 class="mb-2 fontBold">กลยุทธ์สถานศึกษา</h3>
                        <v-select
                          v-model="projectData.orgstrategyID"
                          label="กลยุทธ์สถานศึกษา"
                          :items="orgstrategies"
                          item-text="orgstrategyFullname"
                          item-value="orgstrategyID"
                          outlined
                          required
                          :rules="[
                            ()=>!!projectData.orgstrategyID || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select>
                      </v-col> -->
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ชื่อโครงการ</h3>
                        <v-text-field
                          v-model="projectData.projectName"
                          label="ชื่อโครงการ"
                          outlined
                          :rules="[
                            () => !!projectData.projectName || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">หลักการและเหตุผล</h3>
                        <v-textarea
                          v-model="projectData.projectPrinciple"
                          label="หลักการและเหตุผล"
                          outlined
                          :rules="[
                            () => !!projectData.projectPrinciple || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">วัตถุประสงค์</h3>
                        <v-textarea
                          v-model="projectData.projectObjective"
                          label="วัตถุประสงค์"
                          outlined
                          :rules="[
                            () => !!projectData.projectObjective || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">เป้าหมาย</h3>
                        <v-textarea
                          v-model="projectData.projectQuantityGoal"
                          label="เชิงปริมาณ"
                          outlined
                          :rules="[
                            () => !!projectData.projectQuantityGoal || 'กรุณากรอกข้อมูล'
                          ]"
                          class="ml-5 pl-5"
                        ></v-textarea>
                        <v-textarea
                          v-model="projectData.projectQualityGoal"
                          label="เชิงคุณภาพ"
                          outlined
                          :rules="[
                            () => !!projectData.projectQualityGoal || 'กรุณากรอกข้อมูล'
                          ]"
                          class="ml-5 pl-5"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ตัวชี้วัดความสำเร็จโครงการ (KPI)</h3>
                        <v-textarea
                          v-model="projectData.projectQuantityKpi"
                          label="เชิงปริมาณ"
                          outlined
                          :rules="[
                            () => !!projectData.projectQuantityKpi || 'กรุณากรอกข้อมูล'
                          ]"
                          class="ml-5 pl-5"
                        ></v-textarea>
                        <v-textarea
                          v-model="projectData.projectQualityKpi"
                          label="เชิงคุณภาพ"
                          outlined
                          :rules="[
                            () => !!projectData.projectQualityKpi || 'กรุณากรอกข้อมูล'
                          ]"
                          class="ml-5 pl-5"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ประโยชน์ที่คาดว่าจะได้รับ</h3>
                        <v-textarea
                          v-model="projectData.projectBenefit"
                          label="วัตถุประสงค์"
                          outlined
                          :rules="[
                            () => !!projectData.projectBenefit || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12" md="4" v-if="userType=='Admin' || userType=='Plan'">
                        <h3 class="mb-2 fontBold">ประเภทโครงการ</h3>
                        <v-select
                          v-model="projectData.projectType"
                          :items="[
                            'ในแผน',
                            'เพิ่มเติม'
                          ]"
                          label="ประเภท"
                          outlined
                          :rules="[
                            () => !!projectData.projectType || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select>
                      </v-col>
                      <v-col cols="12" md="4" v-if="userType=='Admin' || userType=='Plan'">
                        <h3 class="mb-2 fontBold">การอนุมัติ</h3>
                        <v-select
                          v-model="projectData.projectStatus"
                          :items="[
                            {text: 'เสนอโครงการ', value: 'เสนอโครงการ'},
                            {text: 'อนุมัติ', value: 'อนุมัติ'}

                          ]"
                          label="การอนุมัติ"
                          outlined
                          :rules="[
                            () => !!projectData.projectStatus || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select>
                        <!-- <v-select
                          v-model="projectData.projectStatus"
                          :items="[
                            'เสนอโครงการ',
                            'อนุมัติ'
                          ]"
                          label="สถานะ"
                          outlined
                          :rules="[
                            () => !!projectData.projectStatus || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select> -->
                        <!-- <v-checkbox
                          v-model="projectData.projectPlanStatus"
                          label="อนุมัติหลักการ"
                          true-value="อนุมัติหลักการ"
                          :false-value="null"
                          color="success"
                        ></v-checkbox> -->
                        <!-- <v-radio-group
                          v-model="projectData.projectPlanStatus"
                          row
                        >
                          <v-radio label="เสนอโครงการ" value=""></v-radio>
                          <v-radio label="อนุมัติหลักการ" value="อนุมัติหลักการ" color="success"></v-radio>
                        </v-radio-group> -->
                      </v-col>
                      <v-col cols="12" md="4" v-if="userType=='Admin' || userType=='Plan'">
                        <h3 class="mb-2 fontBold">การดำเนินกิจกรรม</h3>
                        <v-select
                          v-model="projectData.projectProgress"
                          :items="[
                            'ยังไม่ได้ดำเนินการ',
                            'อยู่ระหว่างดำเนินการ',
                            'ดำเนินการเสร็จสิ้น'
                          ]"
                          label="ความก้าวหน้า"
                          outlined
                          :rules="[
                            () => !!projectData.projectProgress || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select>
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions>
                    <div class="col-12 text-center">
                      <v-btn
                        @click="insertDialog = false"
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
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

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
                  <span class="fontBold">แก้ไขข้อมูลโครงการ ปีงบประมาณ พ.ศ.{{ parseInt(this.projectYear)+543 }}</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="projectUpdateValidate"
                  ref="projectUpdateForm"
                  lazy-validation
                  @submit.prevent="updateProject"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row dense>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold">ฝ่าย</h3>
                        <v-autocomplete
                          v-model="projectData.partyID"
                          :items="parties"
                          item-text="partyName"
                          item-value="partyID"
                          label="ฝ่าย"
                          outlined
                          :readonly="userType=='Department' || userType=='Party'"
                          :rules="[
                            () => !!projectData.partyID || 'กรุณากรอกข้อมูล'
                          ]"
                          @change="partyChange"
                        ></v-autocomplete>
                      </v-col>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold">แผนก/งาน</h3>
                        <v-autocomplete
                          v-model="projectData.departmentID"
                          :items="departments"
                          item-text="departmentName"
                          item-value="departmentID"
                          label="แผนก/งาน"
                          outlined
                          :readonly="userType=='Department'"
                          :rules="[
                            () => !!projectData.departmentID || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-autocomplete>
                      </v-col>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold">ชื่อหัวหน้างานผู้เสนอโครงการ</h3>
                        <v-text-field
                          v-model="projectData.departmentSignName"
                          label="ชื่อหัวหน้างานผู้เสนอโครงการ"
                          outlined
                          :rules="[
                            () => (!!projectData.departmentSignName || userType=='Admin' || userType=='Plan') || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ยุทธศาสตร์สถานศึกษา</h3>
                        <v-select
                          v-model="projectData.orgstrategicID"
                          label="ยุทธศาสตร์สถานศึกษา"
                          :items="orgstrategics"
                          item-text="orgstrategicFullname"
                          item-value="orgstrategicID"
                          outlined
                          required
                          :readonly="(userType=='Department' || userType=='Party') && (projectData.projectType=='ในแผน'||projectData.projectType=='เพิ่มเติม')"
                          :rules="[
                            ()=>!!projectData.orgstrategicID || 'กรุณากรอกข้อมูล'
                          ]"
                          @change="orgstrategicChange"
                        ></v-select>
                      </v-col>
                      <!-- <v-col cols="12">
                        <h3 class="mb-2 fontBold">กลยุทธ์สถานศึกษา</h3>
                        <v-select
                          v-model="projectData.orgstrategyID"
                          label="กลยุทธ์สถานศึกษา"
                          :items="orgstrategies"
                          item-text="orgstrategyFullname"
                          item-value="orgstrategyID"
                          outlined
                          required
                          :rules="[
                            ()=>!!projectData.orgstrategyID || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select>
                      </v-col> -->
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ชื่อโครงการ</h3>
                        <v-text-field
                          v-model="projectData.projectName"
                          label="ชื่อโครงการ"
                          outlined
                          :readonly="(userType=='Department' || userType=='Party') && (projectData.projectType=='ในแผน'||projectData.projectType=='เพิ่มเติม')"
                          :rules="[
                            () => !!projectData.projectName || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">หลักการและเหตุผล</h3>
                        <v-textarea
                          v-model="projectData.projectPrinciple"
                          label="หลักการและเหตุผล"
                          outlined
                          :rules="[
                            () => !!projectData.projectPrinciple || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">วัตถุประสงค์</h3>
                        <v-textarea
                          v-model="projectData.projectObjective"
                          label="วัตถุประสงค์"
                          outlined
                          :rules="[
                            () => !!projectData.projectObjective || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">เป้าหมาย</h3>
                        <v-textarea
                          v-model="projectData.projectQuantityGoal"
                          label="เชิงปริมาณ"
                          outlined
                          :rules="[
                            () => !!projectData.projectQuantityGoal || 'กรุณากรอกข้อมูล'
                          ]"
                          class="ml-5 pl-5"
                        ></v-textarea>
                        <v-textarea
                          v-model="projectData.projectQualityGoal"
                          label="เชิงคุณภาพ"
                          outlined
                          :rules="[
                            () => !!projectData.projectQualityGoal || 'กรุณากรอกข้อมูล'
                          ]"
                          class="ml-5 pl-5"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ตัวชี้วัดความสำเร็จโครงการ (KPI)</h3>
                        <v-textarea
                          v-model="projectData.projectQuantityKpi"
                          label="เชิงปริมาณ"
                          outlined
                          :rules="[
                            () => !!projectData.projectQuantityKpi || 'กรุณากรอกข้อมูล'
                          ]"
                          class="ml-5 pl-5"
                        ></v-textarea>
                        <v-textarea
                          v-model="projectData.projectQualityKpi"
                          label="เชิงคุณภาพ"
                          outlined
                          :rules="[
                            () => !!projectData.projectQualityKpi || 'กรุณากรอกข้อมูล'
                          ]"
                          class="ml-5 pl-5"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ประโยชน์ที่คาดว่าจะได้รับ</h3>
                        <v-textarea
                          v-model="projectData.projectBenefit"
                          label="ประโยชน์ที่คาดว่าจะได้รับ"
                          outlined
                          :rules="[
                            () => !!projectData.projectBenefit || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12" md="4" v-if="userType=='Admin' || userType=='Plan'">
                        <h3 class="mb-2 fontBold">ประเภทโครงการ</h3>
                        <v-select
                          v-model="projectData.projectType"
                          :items="[
                            'ในแผน',
                            'เพิ่มเติม',
                            'เข้าแผน'
                          ]"
                          label="ประเภท"
                          outlined
                          :rules="[
                            () => !!projectData.projectType || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select>
                      </v-col>
                      <v-col cols="12" md="4" v-if="userType=='Admin' || userType=='Plan'">
                        <h3 class="mb-2 fontBold">การอนุมัติ</h3>
                        <v-select
                          v-model="projectData.projectStatus"
                          :items="[
                            {text: 'เสนอโครงการ', value: 'เสนอโครงการ'},
                            {text: 'ไม่ผ่าน', value: 'ไม่ผ่าน'},
                            {text: 'อนุมัติ', value: 'อนุมัติ'}

                          ]"
                          label="การอนุมัติ"
                          outlined
                          :rules="[
                            () => !!projectData.projectStatus || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select>
                        <!-- <v-select
                          v-model="projectData.projectStatus"
                          :items="[
                            'เสนอโครงการ',
                            'อนุมัติ'
                          ]"
                          label="สถานะ"
                          outlined
                          :rules="[
                            () => !!projectData.projectStatus || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select> -->
                        <!-- <v-checkbox
                          v-model="projectData.projectPlanStatus"
                          label="อนุมัติหลักการ"
                          true-value="อนุมัติหลักการ"
                          :false-value="null"
                          color="success"
                        ></v-checkbox> -->
                        <!-- <v-radio-group
                          v-model="projectData.projectPlanStatus"
                          row
                        >
                          <v-radio label="เสนอโครงการ" value=""></v-radio>
                          <v-radio label="อนุมัติหลักการ" value="อนุมัติหลักการ" color="success"></v-radio>
                        </v-radio-group> -->
                      </v-col>
                      <v-col cols="12" md="4" v-if="userType=='Admin' || userType=='Plan'">
                        <h3 class="mb-2 fontBold">การดำเนินกิจกรรม</h3>
                        <v-select
                          v-model="projectData.projectProgress"
                          :items="[
                            'ยังไม่ได้ดำเนินการ',
                            'อยู่ระหว่างดำเนินการ',
                            'ดำเนินการเสร็จสิ้น'
                          ]"
                          label="ความก้าวหน้า"
                          outlined
                          :rules="[
                            () => !!projectData.projectProgress || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select>
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions>
                    <div class="col-12 text-center">
                      <v-btn
                        @click="updateDialog = false"
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
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="updateStatusDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateStatusDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="amber lighten-2">
                  <span class="fontBold">แก้ไขการอนุมัติโครงการ ปีงบประมาณ พ.ศ.{{ parseInt(this.projectYear)+543 }}</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="projectUpdateStatusValidate"
                  ref="projectUpdateStatusForm"
                  lazy-validation
                  @submit.prevent="updateStatusProject"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row dense>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ชื่อโครงการ</h3>
                        {{ projectData.projectName }}
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">วัตถุประสงค์</h3>
                        <pre class="fontPrompt">{{ projectData.projectObjective }}</pre>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ยุทธศาสตร์สถานศึกษา</h3>
                        ยุทธศาสตร์ที่ {{ projectData.orgstrategicNum }} {{ projectData.orgstrategicName }}
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">กลยุทธ์สถานศึกษา</h3>
                        กลยุทธ์ที่ {{ projectData.orgstrategyNum }} {{ projectData.orgstrategyName }}
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ฝ่าย</h3>
                        {{ projectData.partyName }}
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">แผนก/งาน</h3>
                        {{ projectData.departmentName }}

                      </v-col>
                      <!-- <v-col cols="12" md="6" v-if="userType=='Admin'">
                        <h3 class="mb-2 fontBold">สถานะ</h3>
                        <v-select
                          v-model="projectData.projectStatus"
                          :items="[
                            'เสนอโครงการ',
                            'อนุมัติ'
                          ]"
                          label="สถานะ"
                          outlined
                          :rules="[
                            () => !!projectData.projectStatus || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-select>
                      </v-col> -->
                      <!-- <v-col cols="12" v-if="userType=='Department'&&(projectStatus=='เสนอโครงการ'||projectStatus=='แผนก/งานเห็นชอบ'||projectStatus=='แผนก/งานไม่เห็นชอบ')">
                        <h3 class="mb-2 fontBold">การอนุมัติ</h3>
                        <v-radio-group
                          v-model="projectData.projectStatus"
                          row
                        >
                          <v-radio label="เสนอโครงการ" value="เสนอโครงการ"></v-radio>
                          <v-radio label="แผนก/งานเห็นชอบ" value="แผนก/งานเห็นชอบ" color="deep-purple"></v-radio>
                          <v-radio label="แผนก/งานไม่เห็นชอบ" value="แผนก/งานไม่เห็นชอบ"  color="red darken-2"></v-radio>
                        </v-radio-group>
                      </v-col> -->
                      <v-col cols="12" md="6" v-if="userType=='Party'&&projectStatus!='อนุมัติ'&&projectStatus!='ไม่อนุมัติ'">
                        <h3 class="mb-2 fontBold">การอนุมัติ</h3>
                        <v-radio-group
                          v-model="projectData.projectStatus"
                          row
                        >
                          <v-radio label="เสนอโครงการ" value="เสนอโครงการ" color="primary"></v-radio>
                          <v-radio label="ฝ่ายเห็นชอบ" value="ฝ่ายเห็นชอบ" color="lime"></v-radio>
                          <v-radio label="ฝ่ายไม่เห็นชอบ" value="ฝ่ายไม่เห็นชอบ"  color="red darken-2"></v-radio>
                        </v-radio-group>
                      </v-col>
                      <v-col cols="12" md="6" v-else-if="userType=='Director'&&projectStatus!='ฝ่ายไม่เห็นชอบ'">
                        <h3 class="mb-2 fontBold">การอนุมัติ</h3>
                        <v-radio-group
                          v-model="projectData.projectStatus"
                          row
                        >
                          <v-radio label="ฝ่ายเห็นชอบ" value="ฝ่ายเห็นชอบ" color="lime"></v-radio>
                          <v-radio label="อนุมัติ" value="อนุมัติ" color="success"></v-radio>
                          <v-radio label="ไม่อนุมัติ" value="ไม่อนุมัติ"  color="red darken-2"></v-radio>
                        </v-radio-group>
                      </v-col>
                      <v-col cols="12" md="6" v-else>
                        <h3 class="mb-2 fontBold">การอนุมัติ</h3>
                        {{ projectData.projectStatus }}
                      </v-col>
                      <!-- <v-col cols="12" v-if="userType=='Admin' || userType=='Plan'">
                        <h3 class="mb-2 fontBold">การอนุมัติ</h3>
                        <v-radio-group
                          v-model="projectData.projectPlanStatus"
                          row
                        >
                          <v-radio label="รออนุมัติตามขั้นตอน" value="รออนุมัติ"></v-radio>
                          <v-radio label="อนุมัติหลักการ" value="อนุมัติหลักการ" color="success"></v-radio>
                        </v-radio-group>
                      </v-col> -->
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions v-if="userType=='Admin' || userType=='Plan' || (userType=='Director'&&projectStatus!='ฝ่ายไม่เห็นชอบ') || (userType=='Party'&&projectStatus!='อนุมัติ'&&projectStatus!='ไม่อนุมัติ')">
                    <div class="col-12 text-center">
                      <v-btn
                        @click="updateStatusDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="updateStatusProgress"
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
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="updateProgressDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateProgressDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="amber lighten-2">
                  <span class="fontBold">แก้ไขการดำเนินกิจกรรมโครงการ ปีงบประมาณ พ.ศ.{{ parseInt(this.projectYear)+543 }}</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="projectUpdateProgressValidate"
                  ref="projectUpdateProgressForm"
                  lazy-validation
                  @submit.prevent="updateProgressProject"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row dense>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ชื่อโครงการ</h3>
                        {{ projectData.projectName }}
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">วัตถุประสงค์</h3>
                        <pre class="fontPrompt">{{ projectData.projectObjective }}</pre>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ยุทธศาสตร์สถานศึกษา</h3>
                        ยุทธศาสตร์ที่ {{ projectData.orgstrategicNum }} {{ projectData.orgstrategicName }}
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">กลยุทธ์สถานศึกษา</h3>
                        กลยุทธ์ที่ {{ projectData.orgstrategyNum }} {{ projectData.orgstrategyName }}
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ฝ่าย</h3>
                        {{ projectData.partyName }}
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">แผนก/งาน</h3>
                        {{ projectData.departmentName }}

                      </v-col>
                      <v-col cols="12" v-if="userType=='Department'||userType=='Personal'">
                        <h3 class="mb-2 fontBold">การดำเนินกิจกรรม</h3>
                        <v-radio-group
                          v-model="projectData.projectProgress"
                          row
                        >
                          <v-radio label="ยังไม่ได้ดำเนินการ" value="ยังไม่ได้ดำเนินการ" color="red darken-2" v-if="parseFloat(projectData.disburseMoney)<=0"></v-radio>
                          <v-radio label="อยู่ระหว่างดำเนินการ" value="อยู่ระหว่างดำเนินการ" color="yellow darken-1"></v-radio>
                          <v-radio label="ดำเนินการเสร็จสิ้น" value="ดำเนินการเสร็จสิ้น"  color="success darken-1"></v-radio>
                        </v-radio-group>
                      </v-col>
                      <v-col cols="12" md="6" v-else>
                        <h3 class="mb-2 fontBold">การดำเนินกิจกรรม</h3>
                        {{ projectData.projectProgress }}
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions v-if="userType=='Department' || userType=='Personal'">
                    <div class="col-12 text-center">
                      <v-btn
                        @click="updateProgressDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="updateProgressProgress"
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
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="projectSummaryReportDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="success lighten-5">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="projectSummaryReportDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="success lighten-2">
                  <span class="fontBold">รายงานสรุปผลการดำเนินโครงการ ปีงบประมาณ พ.ศ.{{ parseInt(this.projectYear)+543 }}</span>
                  <v-spacer></v-spacer>
                  <v-btn fab x-small color="white" class="mr-2" @click="showUpdateReportDialog(projectData)" v-if="userType=='Department' || userType=='Personal'">
                    <v-icon small color="warning">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn fab x-small color="white" class="mr-2" :to="'/print/pjsummaryReport/?id='+projectData.projectID" target="_blank">
                    <v-icon small color="primary">fas fa-print</v-icon>
                  </v-btn>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="projectUpdateReportValidate"
                  ref="projectUpdateReportForm"
                  lazy-validation
                  @submit.prevent="updateReportProject"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row dense>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold text-center">ชื่อโครงการ</h3>
                        <h4 class="fontBold text-center">{{ projectData.projectName }}</h4>
                        <v-divider class="my-2"></v-divider>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">วัตถุประสงค์</h3>
                        <pre class="ml-3 fontPrompt">{{ projectData.projectObjective }}</pre>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">งบประมาณ</h3>
                        <span class="ml-3 fontPrompt">{{ moneyFormat(projectData.disburseMoney) }} บาท</span>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">เป้าหมาย</h3>
                        <b  class="ml-3 fontBold">เชิงปริมาณ</b>
                        <pre class="ml-3 fontPrompt">{{ projectData.projectQuantityGoal }}</pre>
                        <b  class="ml-3 fontBold">เชิงคุณภาพ</b>
                        <pre class="ml-3 fontPrompt">{{ projectData.projectQualityGoal }}</pre>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ตัวชี้วัดความสำเร็จโครงการ</h3>
                        <b  class="ml-3 fontBold">เชิงปริมาณ</b>
                        <pre class="ml-3 fontPrompt">{{ projectData.projectQuantityKpi }}</pre>
                        <b  class="ml-3 fontBold">เชิงคุณภาพ</b>
                        <pre class="ml-3 fontPrompt">{{ projectData.projectQualityKpi }}</pre>
                      </v-col>
                      <v-col cols="12">
                        <v-divider class="my-2"></v-divider>
                        <h3 class="mb-2 fontBold">ผลการดำเนินงาน/กิจกรรม</h3>
                        <b  class="ml-3 fontBold">เชิงปริมาณ</b>
                        <pre class="ml-3 fontPrompt">{{ projectData.pjsummaryQtyResult }}</pre>
                        <b  class="ml-3 fontBold">เชิงคุณภาพ</b>
                        <pre class="ml-3 fontPrompt">{{ projectData.pjsummaryQlyResult }}</pre>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ปัญหาอุปสรรค</h3>
                        <pre class="ml-3 fontPrompt">{{ projectData.pjsummaryProblem }}</pre>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ข้อเสนอแนะ</h3>
                        <pre class="ml-3 fontPrompt">{{ projectData.pjsummarySuggestion }}</pre>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ภาพการดำเนินโครงการ</h3>
                        <v-row v-if="imageNames.length > 0">
                          <v-col cols="6" md="3" v-for="imageName in imageNames" :key="imageName.key">
                            <v-img
                              :src="imagePath+imageName"
                              class="align-end text-right"
                              gradient="to bottom, rgba(255,255,255,.1), rgba(255,255,255,.5)"
                            >
                              <v-btn icon small color="red darken-2" @click="showDeleteImageDialog(imageName)" v-if="userType=='Department' || userType=='Personal'">
                                <v-icon small>fas fa-trash</v-icon>
                              </v-btn>
                            </v-img>
                          </v-col>
                        </v-row>
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
        v-model="updateReportDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-11 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateReportDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="amber lighten-2">
                  <span class="fontBold">แก้ไขการรายงานสรุปผลการดำเนินโครงการ ปีงบประมาณ พ.ศ.{{ parseInt(this.projectYear)+543 }}</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="projectUpdateReportValidate"
                  ref="projectUpdateReportForm"
                  lazy-validation
                  @submit.prevent="updateReportProject"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row dense>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold text-center">ชื่อโครงการ</h3>
                        <h4 class="fontBold text-center">{{ projectSummaryData.projectName }}</h4>
                        <v-divider class="my-2"></v-divider>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">วัตถุประสงค์</h3>
                        <pre class="fontPrompt">{{ projectSummaryData.projectObjective }}</pre>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">งบประมาณ</h3>
                        {{ moneyFormat(projectSummaryData.pjbudgetMoney) }} บาท
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">เป้าหมาย</h3>
                        <b  class="ml-3 fontBold">เชิงปริมาณ</b>
                        <pre class="ml-3 fontPrompt">{{ projectSummaryData.projectQuantityGoal }}</pre>
                        <b  class="ml-3 fontBold">เชิงคุณภาพ</b>
                        <pre class="ml-3 fontPrompt">{{ projectSummaryData.projectQualityGoal }}</pre>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ตัวชี้วัดความสำเร็จโครงการ</h3>
                        <b  class="ml-3 fontBold">เชิงปริมาณ</b>
                        <pre class="ml-3 fontPrompt">{{ projectSummaryData.projectQuantityKpi }}</pre>
                        <b  class="ml-3 fontBold">เชิงคุณภาพ</b>
                        <pre class="ml-3 fontPrompt">{{ projectSummaryData.projectQualityKpi }}</pre>
                      </v-col>
                      <v-col cols="12">
                        <v-divider class="my-2"></v-divider>
                        <h3 class="mb-2 fontBold">ผลการดำเนินงาน/กิจกรรม</h3>
                        <v-textarea
                          v-model="projectSummaryData.pjsummaryQtyResult"
                          label="เชิงปริมาณ"
                          outlined
                          :rules="[
                            () => !!projectSummaryData.pjsummaryQtyResult || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                        <v-textarea
                          v-model="projectSummaryData.pjsummaryQlyResult"
                          label="เชิงคุณภาพ"
                          outlined
                          :rules="[
                            () => !!projectSummaryData.pjsummaryQlyResult || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ปัญหาอุปสรรค</h3>
                        <v-textarea
                          v-model="projectSummaryData.pjsummaryProblem"
                          label="ปัญหาอุปสรรค"
                          outlined
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ข้อเสนอแนะ</h3>
                        <v-textarea
                          v-model="projectSummaryData.pjsummarySuggestion"
                          label="ข้อเสนอแนะ"
                          outlined
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ภาพการดำเนินโครงการ (4 - 8 ภาพ)</h3>
                        <v-file-input
                          v-model="imageInsertNames"
                          ref="projectImages"
                          small-chips
                          show-size
                          counter
                          multiple
                          accept="image/jpeg"
                          label="ไฟล์รูปภาพ"
                          :rules="[
                            ()=> (parseInt(imageInsertNames.length) + parseInt(imageNames.length))<=8 || 'เพิ่มรูปภาพได้ 4 - 8 ภาพ'
                          ]"
                          @change="productImagesChanged"
                        ></v-file-input>
                        <v-row v-if="imageInsertNames.length > 0">
                          <v-col class="col-3 col-md-1" v-for="imageName in imageInsertNames" :key="imageName.key">
                            <v-img
                              :src="getImageUrl(imageName)"
                            >
                              <template v-slot:placeholder>
                                <v-row
                                    class="fill-height ma-0 "
                                    justify="center"
                                >
                                  <v-icon large>fas fa-images</v-icon>
                                </v-row>
                              </template>
                            </v-img>
                          </v-col>
                        </v-row>
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions v-if="userType=='Department' || userType=='Personal'">
                    <div class="col-12 text-center">
                      <v-btn
                        @click="updateReportDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="updateReportProgress"
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
                  <span class="fontBold">ลบข้อมูลโครงการ ปีงบประมาณ พ.ศ.{{ parseInt(this.projectYear)+543 }}</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="projectDeleteValidate"
                  ref="projectDeleteForm"
                  lazy-validation
                  @submit.prevent="deleteProject"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row dense>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ชื่อโครงการ</h3>
                        {{ projectData.projectName }}
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">วัตถุประสงค์</h3>
                        <pre class="fontPrompt">{{ projectData.projectObjective }}</pre>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ยุทธศาสตร์สถานศึกษา</h3>
                        ยุทธศาสตร์ที่ {{ projectData.orgstrategicNum }} {{ projectData.orgstrategicName }}
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">กลยุทธ์สถานศึกษา</h3>
                        กลยุทธ์ที่ {{ projectData.orgstrategyNum }} {{ projectData.orgstrategyName }}
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ฝ่าย</h3>
                        {{ projectData.partyName }}
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">แผนก/งาน</h3>
                        {{ projectData.departmentName }}

                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions>
                    <div class="col-12 text-center">
                      <v-btn
                        @click="deleteDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="deleteProgress"
                      ></v-progress-circular>
                      <v-btn
                        type="submit"
                        color="red darken-1"
                        dark
                        large
                        v-else
                      >
                        ลบ
                      </v-btn>
                    </div>
                  </v-card-actions>
                </v-form>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="deleteImageDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-8 mx-auto my-5">
              <v-card>
                <v-card-actions class="red lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="deleteImageDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="red lighten-2">
                  <span class="fontBold black--text">ลบภาพการดำเนินโครงการ</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  @submit.prevent="deleteImage"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ภาพการดำเนินโครงการ</h3>
                        <v-row v-if="imageDeleteName">
                          <v-col class="col-12 col-md-6 mx-auto">
                            <v-img
                              :src="imagePath+imageDeleteName+'?d='+(new Date().getTime())"
                            >
                            </v-img>
                          </v-col>
                        </v-row>
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions>
                    <div class="col-12 text-center">
                      <v-btn
                        @click="deleteImageDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="deleteImageProgress"
                      ></v-progress-circular>
                      <v-btn
                        type="submit"
                        color="red darken-1"
                        large
                        dark
                        v-else
                      >
                        ลบ
                      </v-btn>
                    </div>
                  </v-card-actions>
                </v-form>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="activityBudgetDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="blue-grey lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="activityBudgetDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="blue-grey lighten-3">
                  <span class="fontBold">ข้อมูลกิจกรรมและงบประมาณโครงการ ปีงบประมาณ พ.ศ.{{ parseInt(this.projectYear)+543 }}</span>
                </v-card-title>
                <v-card-subtitle class="blue-grey lighten-3">
                  <span class="fontBold">{{ projectData.projectName }}</span>
                </v-card-subtitle>
                <v-divider class="green"></v-divider>
                <v-card-text>
                  <v-tabs
                    v-model="activityBudgetTab"
                    fixed-tabs
                    background-color="green lighten-5"
                  >
                    <v-tab>
                      นโยบายที่เกี่ยวข้อง
                    </v-tab>
                    <v-tab>
                      กิจกรรมโครงการ
                    </v-tab>
                    <v-tab>
                      งบประมาณโครงการ
                    </v-tab>
                  </v-tabs>
                  <v-tabs-items
                    v-model="activityBudgetTab"
                  >
                    <v-tab-item>
                      <PjpolicyListVue :projectID="projectData.projectID" :periodYear="projectData.projectYear" :readOnly="!(((userType=='Personal' && projectData.projectStatus!='แผนก/งานเห็นชอบ' && projectData.projectStatus!='ฝ่ายเห็นชอบ' && projectData.projectStatus!='อนุมัติ' && updateBt) || (userType=='Department' && projectData.projectStatus!='ฝ่ายเห็นชอบ' && projectData.projectStatus!='อนุมัติ' && updateBt) || (userType=='Party' && projectData.projectStatus!='อนุมัติ' && updateBt) || userType=='Admin' || userType=='Plan') && projectData.projectProgress!='ดำเนินการเสร็จสิ้น')" v-if="projectData.projectID" />
                    </v-tab-item>
                    <v-tab-item>
                      <PjactivityListVue :projectID="projectData.projectID" :readOnly="!(((userType=='Personal' && projectData.projectStatus!='แผนก/งานเห็นชอบ' && projectData.projectStatus!='ฝ่ายเห็นชอบ' && projectData.projectStatus!='อนุมัติ' && updateBt) || (userType=='Department' && projectData.projectStatus!='ฝ่ายเห็นชอบ' && projectData.projectStatus!='อนุมัติ' && updateBt) || (userType=='Party' && projectData.projectStatus!='อนุมัติ' && updateBt) || userType=='Admin' || userType=='Plan') && projectData.projectProgress!='ดำเนินการเสร็จสิ้น')" v-if="projectData.projectID" />
                    </v-tab-item>
                    <v-tab-item>
                      <PjbudgetTableVue :projectID="projectData.projectID" :insertBt="budgetInsertBt" :updateBt="1" :deleteBt="1" @getbudgetStatus="getBudgetStatus" :readOnly="!(((userType=='Personal' && projectData.projectStatus!='แผนก/งานเห็นชอบ' && projectData.projectStatus!='ฝ่ายเห็นชอบ' && projectData.projectStatus!='อนุมัติ' && updateBt) || (userType=='Department' && projectData.projectStatus!='ฝ่ายเห็นชอบ' && projectData.projectStatus!='อนุมัติ' && updateBt) || (userType=='Party' && projectData.projectStatus!='อนุมัติ' && updateBt) || userType=='Admin' || userType=='Plan') && projectData.projectProgress!='ดำเนินการเสร็จสิ้น')" v-if="projectData.projectID" />
                    </v-tab-item>
                  </v-tabs-items>
                </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
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
// import ProjectInsertVue from './ProjectInsert.vue'
import PjpolicyListVue from './PjpolicyList.vue'
import PjactivityListVue from './PjactivityList.vue'
import PjbudgetTableVue from './PjbudgetTable.vue'
import PjsummaryInfoVue from './PjsummaryInfo.vue'
export default {
  components: {
    // ProjectInsertVue,
    PjpolicyListVue,
    PjactivityListVue,
    PjbudgetTableVue,
    PjsummaryInfoVue
  },

  props: {
    projects: {
      type: Array,
      default: ()=>[]
    },
    projectSum: {
      type: Object,
      default: ()=>{}
    },
    strategics: {
      type: Array,
      default: ()=>[]
    },
    projectsLoading: {
      type: Boolean,
      default: true
    },
    userType: {
      type: String,
      default: null,
    },
    userID: {
      type: String,
      default: null,
    },
    personalIDcard: {
      type: String,
      default: null
    },
    partyID: {
      type: String,
      default: null
    },
    departmentID: {
      type: String,
      default: null
    },
    orgstrategicID: {
      type: String,
      default: null
    },
    orgstrategyID: {
      type: String,
      default: null
    },
    projectYear: {
      type: String,
      default: null
    },
    insertBt: {
      type: Number,
      default: 0
    },
    updateBt: {
      type: Number,
      default: 0
    },
    deleteBt: {
      type: Number,
      default: 0
    },
  },

  data() {
    return {
      headers: [
        {
          text: '#',
          align: 'center',
          sortable: false,
          value: 'projectCode',
        },
        { text: 'ชื่อโครงการ/ผู้รับผิดชอบ', value: 'projectNamePresenter', align: 'left', class: 'text-center' },
        // { text: 'ผู้เสนอโครงการ', value: 'departmentName', align: 'left', class: 'text-center' },
        // { text: 'ผู้รับผิดชอบ', value: '' },
        { text: 'การอนุมัติ', value: 'projectStatus', align: 'left', class: 'text-center' },
        { text: 'การดำเนินกิจกรรม', value: 'projectProgress', align: 'left', class: 'text-center' },
        { text: 'การรายงานผล', value: 'projectReport', align: 'left', class: 'text-center' },
        { text: 'งบประมาณ (แผน/ผล)', value: 'pjbudgetMoney', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      projectDatas: [],
      strategicID: "all",
      parties: [],
      party: {},
      budgetInsertBt: 0,
      departments: [],
      department: {},
      orgstrategics: [],
      orgstrategies: [],
      imageNames: [],
      imagePath: null,
      imageInsertNames: [],
      imageDeleteName: null,
      search: '',
      projectData: {},
      projectSummaryData: {},
      projectStatus: null,
      projectProgress: null,
      projectReport: null,
      insertDialog: false,
      insertProgress: false,
      projectInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      projectUpdateValidate: null,

      updateStatusDialog: false,
      updateStatusProgress: false,
      projectUpdateStatusValidate: null,

      updateProgressDialog: false,
      updateProgressProgress: false,
      projectUpdateProgressValidate: null,

      projectSummaryReportDialog: false,

      updateReportDialog: false,
      updateReportProgress: false,
      projectUpdateReportValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      projectDeleteValidate: null,

      deleteImageDialog: false,
      deleteImageProgress: false,
      projectDeleteImageValidate: null,

      activityBudgetDialog: false,
      activityBudgetTab: 0,
    }
  },

  async mounted() {
    await this.getProjects()
    await this.getParties()
  },

  methods: {
    async getProjects() {
      if(this.strategicID == "all") {
        this.projectDatas = JSON.parse(JSON.stringify(this.projects))
      } else {
        this.projectDatas = this.projects.filter(project => project.orgstrategicID==this.strategicID)
      }
    },

    async getParties() {
      let result = await this.$axios.$get('party.php', {
        params: {
          token: this.$store.state.jwtToken,
        }
      })

      if(result.message === 'Success') {
        this.parties = JSON.parse(JSON.stringify(result.party))
      }
    },

    async partyChange() {
      this.projectData.departmentID = null
      this.departments = []
      await this.getDepartments(this.projectData.partyID)
    },

    async getParty() {
      let result = await this.$axios.$get('party.php', {
        params: {
          token: this.$store.state.jwtToken,
          partyID: this.partyID
        }
      })

      if(result.message === 'Success') {
        this.party = result.party
      }
    },

    async getDepartments(partyID) {
      let result = await this.$axios.$get('department.php', {
        params: {
          token: this.$store.state.jwtToken,
          partyID: partyID
        }
      })

      if(result.message === 'Success') {
        this.departments = result.department
      }
    },

    async getDepartment() {
      let result = await this.$axios.$get('department.php', {
        params: {
          token: this.$store.state.jwtToken,
          departmentID: this.departmentID
        }
      })

      if(result.message === 'Success') {
        this.department = result.department
      }
    },

    async getOrgstrategic() {
      let params = {
        token: this.$store.state.jwtToken,
        orgstrategicYear: this.projectYear,
        orgstrategicEnable: 1
      }

      let result = await this.$axios.$get('orgstrategic.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.orgstrategics = JSON.parse(JSON.stringify(result.orgstrategic))
      }
    },

    async orgstrategicChange() {
      this.projectData.orgstrategyID = null
      this.orgstrategy = []
      await this.getOrgstrategy(this.projectData.orgstrategicID)
    },

    async getOrgstrategy(orgstrategicID) {
      let params = {
        token: this.$store.state.jwtToken,
        orgstrategicID: orgstrategicID,
        orgstrategyEnable: 1
      }
      let result = await this.$axios.$get('orgstrategy.php', {
        params: params
      })
      if(result.message == 'Success') {
        this.orgstrategies = JSON.parse(JSON.stringify(result.orgstrategy))
      }
    },

    async showInsertDialog() {
      this.projectData = {}
      this.departments = []
      this.orgstrategics = []
      this.orgstrategies = []
      await this.getOrgstrategic()

      if(this.userType=='Admin' || this.userType=='Plan') {
        this.projectData.projectType = 'ในแผน'
      } else {
        this.projectData.projectType = 'เข้าแผน'
        this.projectData.projectStatus = 'เสนอโครงการ'
        this.projectData.projectProgress = 'ยังไม่ได้ดำเนินการ'
      }

      if(this.userType=='Department') {
        if(this.projectData.departmentSignDate==null || this.projectData.departmentSignDate=='')
          this.projectData.departmentSignDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
        await this.getDepartment()
        this.projectData.partyID = this.department.partyID
        await this.getDepartments(this.projectData.partyID)
        this.projectData.departmentID = this.department.departmentID
        if(this.projectData.departmentSign==null || this.projectData.departmentSign=='')
          this.projectData.departmentSign = this.userID
        if(this.projectData.departmentSignName==null || this.projectData.departmentSignName=='')
          this.projectData.departmentSignName = this.department.departmentHead
      }
      this.insertDialog = true
    },

    async insertProject() {
      await this.$refs.projectInsertForm.validate()
      if(this.projectInsertValidate) {
        this.insertProgress = true
        this.projectData.token = this.$store.state.jwtToken
        this.projectData.projectYear = this.projectYear
        this.projectData.personalIDcard = this.personalIDcard

        if(this.userType=='Department') {
          this.projectData.departmentSignDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
          await this.getDepartment()
          this.projectData.departmentSign = this.userID
          this.projectData.departmentSignName = this.department.departmentHead
        }

        let result = await this.$axios.$post('project.insert.php', this.projectData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.$emit('getProjects')
            this.insertDialog = false
            this.insertProgress = false
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.insertProgress = false
          })
        }
      }
    },

    async showUpdateDialog(project) {
      this.projectData = JSON.parse(JSON.stringify(project))
      this.projectStatus = project.projectStatus
      if(this.userType=='Department') {
        if(this.projectData.departmentSignDate==null || this.projectData.departmentSignDate=='')
          this.projectData.departmentSignDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
        await this.getDepartment()
        if(this.projectData.departmentSign==null || this.projectData.departmentSign=='')
          this.projectData.departmentSign = this.userID
        if(this.projectData.departmentSignName==null || this.projectData.departmentSignName=='')
          this.projectData.departmentSignName = this.department.departmentHead
      }
      this.departments = []
      await this.getDepartments(this.projectData.partyID)
      this.orgstrategics = []
      await this.getOrgstrategic()
      this.orgstrategies = []
      await this.getOrgstrategy(this.projectData.orgstrategicID)
      this.updateDialog = true
    },

    async showUpdateStatusDialog(project) {
      this.projectData = JSON.parse(JSON.stringify(project))
      this.projectStatus = project.projectStatus
      this.departments = []
      await this.getDepartments(this.projectData.partyID)
      this.orgstrategics = []
      await this.getOrgstrategic()
      this.orgstrategies = []
      await this.getOrgstrategy(this.projectData.orgstrategicID)
      this.updateStatusDialog = true
    },

    async showUpdateProgressDialog(project) {
      this.projectData = JSON.parse(JSON.stringify(project))
      this.projectProgress = project.projectProgress
      this.departments = []
      await this.getDepartments(this.projectData.partyID)
      this.orgstrategics = []
      await this.getOrgstrategic()
      this.orgstrategies = []
      await this.getOrgstrategy(this.projectData.orgstrategicID)
      this.updateProgressDialog = true
    },

    async showSummaryReportDialog(project) {
      this.projectData = JSON.parse(JSON.stringify(project))
      this.imageNames = []
      this.imagePath = ''
      let result = await this.$axios.$get('project.image.php', {
        params: {
          token: this.$store.state.jwtToken,
          projectYear: this.projectData.projectYear,
          projectID: this.projectData.projectID,
          function: 'projectImageGet'
        }
      })
      if(result.message == 'Success') {
        this.imageNames = JSON.parse(JSON.stringify(result.projectImages))
        this.imagePath = result.projectImagePath
      }
      this.projectSummaryReportDialog = true
    },

    async showUpdateReportDialog(project) {
      this.projectSummaryData = JSON.parse(JSON.stringify(project))
      this.projectReport = project.projectReport
      this.imageInsertNames = []
      this.updateReportDialog = true
    },

    productImagesChanged(image) {
      if(image) {
        this.imageInsertNames = image;
      } else {
        this.imageInsertNames = [];
      }
    },

    getImageUrl(image) {
      return URL.createObjectURL(image)
    },

    async updateProject() {
      await this.$refs.projectUpdateForm.validate()
      if(this.projectUpdateValidate) {
        this.updateProgress = true
        this.projectData.token = this.$store.state.jwtToken

        let result = await this.$axios.$post('project.update.php', this.projectData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.$emit('getProjects')
            this.updateDialog = false
            this.updateProgress = false
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.updateProgress = false
          })
        }
      }
    },

    async updateStatusProject() {
      await this.$refs.projectUpdateStatusForm.validate()
      if(this.projectUpdateStatusValidate) {
        this.updateStatusProgress = true
        this.projectData.token = this.$store.state.jwtToken

        if(this.userType=='Director' || this.userType=='Admin') {
          this.projectData.directorSignDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
          if(this.projectData.projectStatus == 'อนุมัติ') {
            await this.getParty()
            this.projectData.directorSign = this.userID
            this.projectData.directorSignName = this.party.partyHead
          } else {
            this.projectData.directorSign = ''
          }
        } else if(this.userType=='Party') {
          await this.getParty()
          this.projectData.partySignDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
          if(this.projectData.projectStatus == 'ฝ่ายเห็นชอบ') {
            this.projectData.partySign = this.userID
            this.projectData.partySignName = this.party.partyHead
          } else {
            this.projectData.partySign = ''
          }
        } else if(this.userType=='Department') {
          this.projectData.departmentSignDate = new Date().toISOString().slice(0, 19).replace('T', ' ')
          if(this.projectData.projectStatus == 'แผนก/งานเห็นชอบ') {
            await this.getDepartment()
            this.projectData.departmentSign = this.userID
            this.projectData.departmentSignName = this.department.departmentHead
          } else {
            this.projectData.departmentSign = ''
          }
        } else if(this.userType=='Personal') {

        }

        let result = await this.$axios.$post('project.update.php', this.projectData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.$emit('getProjects')
            this.updateStatusDialog = false
            this.updateStatusProgress = false
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.updateStatusProgress = false
          })
        }
      }
    },

    async updateProgressProject() {
      await this.$refs.projectUpdateProgressForm.validate()
      if(this.projectUpdateProgressValidate) {
        this.updateProgressProgress = true
        this.projectData.token = this.$store.state.jwtToken

        let result = await this.$axios.$post('project.update.php', this.projectData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.$emit('getProjects')
            this.updateProgressDialog = false
            this.updateProgressProgress = false
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.updateProgressProgress = false
          })
        }
      }
    },

    async updateReportProject() {
      await this.$refs.projectUpdateReportForm.validate()
      if(this.projectUpdateReportValidate) {
        this.updateReportProgress = true
        this.projectSummaryData.token = this.$store.state.jwtToken

        if(this.imageInsertNames.length <= 8) {
          if(this.projectSummaryData.projectReport == 'ไม่รายงาน') {
            let result = await this.$axios.$post('pjsummary.insert.php', this.projectSummaryData)

            if(result.message == 'Success') {
              if(this.imageInsertNames.length > 0) {
                let result2 = this.imageInsertNames.map(async projectImage => {
                  let formData = new FormData()
                  formData.append('token', this.projectSummaryData.token)
                  formData.append('function', 'projectImageUpload')
                  formData.append('projectYear', this.projectSummaryData.projectYear)
                  formData.append('projectID', this.projectSummaryData.projectID)
                  formData.append('projectImage', projectImage)
                  await this.$axios.$post('project.image.php', formData, {
                    headers: {
                        'Content-Type': 'multipart/form-data'
                    }
                  });
                });

                await Promise.all(result2)
              }
              Swal.fire({
                title: 'สำเร็จ',
                text: result.msg,
                icon: 'success'
              })
              await this.showSummaryReportDialog(this.projectSummaryData)
              this.$emit('getProjects')
              this.imageNames = []
              this.imagePath = ''
              let result3 = await this.$axios.$get('project.image.php', {
                params: {
                  token: this.$store.state.jwtToken,
                  projectYear: this.projectSummaryData.projectYear,
                  projectID: this.projectSummaryData.projectID,
                  function: 'projectImageGet'
                }
              })
              if(result3.message == 'Success') {
                this.imageNames = JSON.parse(JSON.stringify(result3.projectImages))
                this.imagePath = result3.projectImagePath
              }
            }
          } else {
            let result = await this.$axios.$post('pjsummary.update.php', this.projectSummaryData)

            if(this.imageInsertNames.length > 0) {
              let result2 = this.imageInsertNames.map(async projectImage => {
                let formData = new FormData()
                formData.append('token', this.$store.state.jwtToken)
                formData.append('function', 'projectImageUpload')
                formData.append('projectYear', this.projectSummaryData.projectYear)
                formData.append('projectID', this.projectSummaryData.projectID)
                formData.append('projectImage', projectImage)
                await this.$axios.$post('project.image.php', formData, {
                  headers: {
                      'Content-Type': 'multipart/form-data'
                  }
                });
              });
              await Promise.all(result2)
            }
            Swal.fire({
              title: 'สำเร็จ',
              text: 'แก้ไขข้อมูลสำเร็จ',
              icon: 'success'
            })
            await this.showSummaryReportDialog(this.projectSummaryData)
            this.$emit('getProjects')
            this.imageInsertNames = []
            this.imageNames = []
            this.imagePath = ''
            let result3 = await this.$axios.$get('project.image.php', {
              params: {
                token: this.$store.state.jwtToken,
                projectYear: this.projectData.projectYear,
                projectID: this.projectData.projectID,
                function: 'projectImageGet'
              }
            })
            if(result3.message == 'Success') {
              this.imageNames = JSON.parse(JSON.stringify(result3.projectImages))
              this.imagePath = result3.projectImagePath
            }
          }
        } else {
          Swal.fire({
            title: 'ผิดพลาด',
            text: 'เพิ่มรูปภาพได้ไม่เกิน 8 ภาพ',
            icon: 'error'
          })
          this.imageInsertNames = []
        }
        this.updateReportProgress = false
        this.updateReportDialog = false
      }
    },

    async showDeleteDialog(project) {
      this.projectData = JSON.parse(JSON.stringify(project))
      this.departments = []
      await this.getDepartments(this.projectData.partyID)
      this.orgstrategies = []
      await this.getOrgstrategy(this.projectData.orgstrategicID)
      this.deleteDialog = true
    },

    showDeleteImageDialog(imageName) {
      this.imageDeleteName = imageName
      this.deleteImageDialog = true
    },

    async deleteProject() {
      await this.$refs.projectDeleteForm.validate()
      if(this.projectDeleteValidate) {
        this.deleteProgress = true
        this.projectData.token = this.$store.state.jwtToken

        let result = await this.$axios.$post('project.delete.php', this.projectData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            let params = {
              token: this.$store.state.jwtToken,
              projectID: this.projectData.projectID
            }
            await this.$axios.$post('pjactivity.delete.php', params)
            await this.$axios.$post('pjsubactivity.delete.php', params)
            await this.$axios.$post('pjsummary.delete.php', params)
            await this.$axios.$post('pjbudget.delete.php', params)
            this.$emit('getProjects')
            this.deleteDialog = false
            this.deleteProgress = false
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.deleteProgress = false
          })
        }
      }
    },

    async deleteImage() {
        if(this.imageDeleteName) {
          this.deleteImageProgress = true
          let formData = new FormData()
          formData.append('token', this.$store.state.jwtToken)
          formData.append('function', 'projectImageDelete')
          formData.append('projectImage', this.imageDeleteName)
          let result = await this.$axios.$post('project.image.php', formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
          });

          if(result.message == 'Success') {
            swal({
              title: 'สำเร็จ',
              text: result.msg,
              icon: 'success'
            })
            await this.showSummaryReportDialog(this.projectData)
            this.deleteImageProgress = false
            this.$emit('getProjects')
          } else {
            swal({
              title: 'ผิดพลาด',
              text: result.msg,
              icon: 'error'
            }).then(()=>{
              this.deleteImageProgress = false
            })
          }
        }
        this.deleteImageDialog = false
    },

    async showActivityBudgetDialog(project) {
      this.projectData = JSON.parse(JSON.stringify(project))
      this.budgetInsertBt = 1
      this.activityBudgetDialog = true
    },

    async getBudgetStatus(res) {
      this.$emit('getProjects')
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    },

  },

  computed: {
    project() {
      return this.projects.length
    }
  },

  watch: {
    async projectsLoading() {
      if(this.projectsLoading == false) {
        await this.getProjects()
      }
    },

    async projectYear() {
      this.strategicID = 'all'
      // await this.getProjects()
      await this.getParties()
    }
  //   async projectYear() {
  //     await this.getProjects()
  //   },

  //   async personalIDcard() {
  //     await this.getProjects()
  //   }
  }
}
</script>
