<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="2">
          <v-card-title class="pb-5 ptcBg white--text">
            <b>โครงการ ประจำปีงบประมาณ พ.ศ. {{ parseInt(projectYear)+543 }}</b>
            <v-spacer></v-spacer>
            <v-btn icon color="primary" class="mr-md-3"  :href="'/print/projecttableReport/?year='+projectYear" target="_blank" v-if="userType=='Admin'||userType=='Director'">
              <v-icon>fas fa-print</v-icon>
            </v-btn>
          </v-card-title>
          <v-card-subtitle  class="pt-1 blue-grey lighten-5">
            <!-- <b>จำนวนทั้งสิ้น {{ projectSum.projectQty }} โครงการ งบประมาณ {{ moneyFormat(projectSum.pjbudgetMoney) }} บาท</b> -->
            <v-row class="mt-1">
              <!-- <v-col cols="12" md="4">
                <v-card elevation="1" color="primary">
                  <v-card-subtitle class="elevation-1 white--text">กำลังเสนอโครงการ</v-card-subtitle>
                  <v-card-text class="py-2 text-right primary lighten-3 black--text">
                    {{projectSum.projectWaitApproveQty }} โครงการ<br>
                    {{ moneyFormat(parseInt(projectSum.pjbudgetWaitApproveMoney)) }} บาท
                  </v-card-text>
                </v-card>
              </v-col> -->
              <!-- <v-col cols="12" md="4">
                <v-card elevation="1" color="purple darken-1">
                  <v-card-subtitle class="elevation-1 white--text">อยู่ในขั้นตอนอนุมัติโครงการ</v-card-subtitle>
                  <v-card-text class="py-2 text-right purple lighten-3 black--text">
                    {{ parseInt(projectSum.projectDepApproveQty)+parseInt(projectSum.projectParApproveQty) }} โครงการ<br>
                    {{ moneyFormat(parseInt(projectSum.pjbudgetDepApproveMoney) + parseInt(projectSum.pjbudgetParApproveMoney)) }} บาท
                  </v-card-text>
                </v-card>
              </v-col> -->
              <!-- <v-col cols="12" md="3">
                <v-card elevation="1" color="primary">
                  <v-card-subtitle class="elevation-1 white--text">เสนอโครงการทั้งสิ้น</v-card-subtitle>
                  <v-card-text class="py-2 text-right primary lighten-3 black--text">
                    {{ parseInt(projectSum.projectQty) }} โครงการ<br>
                    {{ moneyFormat(projectSum.pjbudgetMoney) }} บาท
                  </v-card-text>
                </v-card>
                <v-card elevation="1" color="purple" class="mt-2">
                  <v-card-subtitle class="elevation-1 white--text">อยู่ในขั้นตอนอนุมัติโครงการ</v-card-subtitle>
                  <v-card-text class="py-2 text-right purple lighten-3 black--text">
                    {{ parseInt(projectSum.projectQty)-parseInt(projectSum.projectHinAndApproveQty) }} โครงการ<br>
                    {{ moneyFormat(parseFloat(projectSum.pjbudgetMoney) - parseFloat(projectSum.pjbudgetHintAndApproveMoney)) }} บาท
                  </v-card-text>
                </v-card>
              </v-col> -->
              <!-- <v-col cols="12" md="9"> -->
              <v-col cols="12">
                <v-card elevation="1" color="primary">
                  <v-card-subtitle class="elevation-1 white--text">โครงการทั้งหมด</v-card-subtitle>
                  <v-card-text class="py-2 text-right primary lighten-4 black--text">
                    {{ projectSum.projectHinAndApproveQty }} โครงการ<br>
                    {{ moneyFormat(projectSum.pjbudgetHintAndApproveMoney) }} บาท
                  </v-card-text>
                  <v-row no-gutters class="pa-2 light-green lighten-3">
                    <v-col cols="12" md="4">
                      <v-card elevation="1" color="red darken-2">
                        <v-card-subtitle class="elevation-1 white--text">ยังไม่ได้ดำเนินการ</v-card-subtitle>
                        <v-card-text class="py-2 text-right red lighten-4 black--text">
                          {{ parseInt(projectSum.projectHinAndApproveQty)-(parseInt(projectSum.projectInProgressQty)+parseInt(projectSum.projectDoneProgressQty)) }} โครงการ<br>
                          {{ moneyFormat(projectSum.pjbudgetHintAndNoneProgressMoney) }} บาท
                        </v-card-text>
                      </v-card>
                    </v-col>
                    <v-col cols="12" md="4">
                      <v-card elevation="1" color="yellow darken-3">
                        <v-card-subtitle class="elevation-1 white--text">อยู่ระหว่างดำเนินการ</v-card-subtitle>
                        <v-card-text class="py-2 text-right yellow lighten-4 black--text">
                          {{ projectSum.projectInProgressQty }} โครงการ<br>
                          {{ moneyFormat(projectSum.disburseInProgressMoney) }} บาท
                        </v-card-text>
                      </v-card>
                    </v-col>
                    <v-col cols="12" md="4">
                      <v-card elevation="1" color="success darken-2">
                        <v-card-subtitle class="elevation-1 white--text">ดำเนินการเสร็จสิ้น</v-card-subtitle>
                        <v-card-text class="py-2 text-right light-green lighten-4 black--text">
                          {{ projectSum.projectDoneProgressQty }} โครงการ<br>
                          {{ moneyFormat(projectSum.disburseDoneProgressMoney) }} บาท
                        </v-card-text>
                      </v-card>
                    </v-col>
                  </v-row>
                </v-card>
              </v-col>
              <!-- <v-col cols="12" md="4">
                <v-card elevation="1" color="red darken-2">
                  <v-card-subtitle class="elevation-1 white--text">ยังไม่ได้ดำเนินการ</v-card-subtitle>
                  <v-card-text class="py-2 text-right red lighten-3 black--text">
                    {{projectSum.projectNoneProgressQty }} โครงการ<br>
                    {{ moneyFormat(parseInt(projectSum.pjbudgetNoneProgressMoney)) }} บาท
                  </v-card-text>
                </v-card>
              </v-col>
              <v-col cols="12" md="4">
                <v-card elevation="1" color="yellow darken-2">
                  <v-card-subtitle class="elevation-1 white--text">อยู่ระหว่างดำเนินการ</v-card-subtitle>
                  <v-card-text class="py-2 text-right yellow lighten-3 black--text">
                    {{ projectSum.projectInProgressQty }} โครงการ<br>
                    {{ moneyFormat(projectSum.disburseInProgressMoney) }} บาท
                  </v-card-text>
                </v-card>
              </v-col>
              <v-col cols="12" md="4">
                <v-card elevation="1" color="success">
                  <v-card-subtitle class="elevation-1 white--text">ดำเนินการแล้ว</v-card-subtitle>
                  <v-card-text class="py-2 text-right success lighten-3 black--text">
                    {{ projectSum.projectDoneProgressQty }} โครงการ<br>
                    {{ moneyFormat(projectSum.disburseDoneProgressMoney) }} บาท
                  </v-card-text>
                </v-card>
              </v-col> -->
            </v-row>
          </v-card-subtitle>
          <v-divider></v-divider>
          <!-- <v-card-text>
            <v-data-table
              :headers="headers"
              :items="projects_tb"
              :search="search"
              :items-per-page="-1"
              :loading="projectsLoading"
              hide-default-footer
              class="mt-2"
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <v-select
                      v-model="orgstrategicID"
                      label="ยุทธศาสตร์"
                      :items="orgstrategics"
                      item-text="orgstrategicFullname"
                      item-value="orgstrategicID"
                      outlined
                      dense
                      @change="filterProjects"
                    ></v-select>
                  </v-col>
                  <v-col cols="12" md="6">
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

              <template v-slot:item.departmentName="{ item }">
                <v-icon x-small color="deep-purple" class="mr-1">fas fa-circle</v-icon>{{ item.departmentName }}
              </template>

              <template v-slot:item.pjbudgetMoney="{ item }">
                <div class="text-no-wrap text-right">
                  {{ moneyFormat(parseInt(item.pjbudgetMoney)) }}
              </div>
              </template>

              <template v-slot:item.projectStatus="{ item }">
                <v-chip x-small color="success" v-if="item.projectStatus=='อนุมัติ'">
                  <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.projectStatus }}
                </v-chip>
                <v-chip x-small color="success" v-else-if="item.projectPlanStatus=='อนุมัติหลักการ'">
                  <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> อนุมัติ
                  <v-icon x-small class="ml-1">fas fa-check-circle</v-icon>
                </v-chip>
                <v-chip color="lime" x-small v-else-if="item.projectStatus=='ฝ่ายเห็นชอบ'">
                  <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.projectStatus }}
                  <v-icon x-small class="ml-1" v-if="item.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon>
                </v-chip>
                <v-chip color="deep-purple" x-small dark v-else-if="item.projectStatus=='แผนก/งานเห็นชอบ'">
                  <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.projectStatus }}
                  <v-icon x-small class="ml-1" v-if="item.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon>
                </v-chip>
                <v-chip color="red" x-small dark v-else-if="item.projectStatus=='ไม่อนุมัติ' || item.projectStatus=='แผนก/งานไม่เห็นชอบ' || item.projectStatus=='ฝ่ายไม่เห็นชอบ'">
                  <v-icon x-small class="mr-1">fas fa-exclamation</v-icon> {{ item.projectStatus }}
                  <v-icon x-small class="ml-1" v-if="item.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon>
                </v-chip>
                <v-chip color="info" x-small dark v-else>
                  <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.projectStatus }}
                  <v-icon x-small class="ml-1" v-if="item.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon>
                </v-chip>
              </template>
              <template v-slot:item.projectProgress="{ item }">
                <v-chip x-small color="success" v-if="item.projectProgress=='ดำเนินการเสร็จสิ้น'">
                  <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.projectProgress }}
                </v-chip>
                <v-chip color="red" x-small dark v-else-if="item.projectProgress=='ยังไม่ได้ดำเนินการ'">
                  <v-icon x-small class="mr-1">fas fa-exclamation</v-icon> {{ item.projectProgress }}
                </v-chip>
                <v-chip color="yellow" x-small v-else>
                  <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.projectProgress }}
                </v-chip>
              </template>
              <template v-slot:item.projectReport="{ item }">
                <v-btn color="success" text small dark v-if="item.projectProgress=='ดำเนินการเสร็จสิ้น'">
                  <v-chip x-small color="red darken-1" v-if="item.projectReport=='ไม่รายงาน'">
                    <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> ยังได้ไม่รายงาน
                  </v-chip>
                  <v-chip x-small color="warning" v-else-if="item.projectReport=='ไม่ครบถ้วน' || item.imageQty<4">
                    <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> อยู่ระหว่างรายงาน
                  </v-chip>
                  <v-chip x-small color="success" v-else-if="item.projectReport=='ครบถ้วน'">
                    <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> ครบถ้วน
                  </v-chip>
                </v-btn>
              </template>
              <template v-slot:item.pjbudgetMoney="{ item }">
                <div class="text-right text-no-wrap">
                  <span v-if="parseFloat(item.pjbudgetMoney) > parseFloat(item.disburseMoney)">
                    {{ moneyFormat(item.pjbudgetMoney) }}
                  </span>
                  <span v-else>
                    {{ moneyFormat(item.disburseMoney) }}
                  </span>
                  <div class="caption blue-grey lighten-5" v-if="parseFloat(item.disburseMoney)>0">
                    <span class="px-1">ใช้ดำเนินการแล้ว<br> {{ moneyFormat(parseFloat(item.disburseMoney)) }}</span>
                    <v-progress-linear
                      :value="parseFloat(item.disburseMoney)/parseFloat(item.pjbudgetMoney)*100"
                      background-color="green lighten-3"
                      color="red lighten-2"
                      height="8"
                      v-if="parseFloat(item.pjbudgetMoney) > parseFloat(item.disburseMoney)"
                    >
                    </v-progress-linear>
                    <v-progress-linear
                      :value="100"
                      background-color="green lighten-3"
                      color="red lighten-2"
                      height="8"
                      v-else
                    >
                    </v-progress-linear>
                  </div>
                </div>
              </template>
              <template v-slot:item.actions="{ item }">
                <div  class="text-no-wrap">
                  <v-btn color="info darken-2" icon small @click="showUpdateStatusDialog(item)">
                    <v-icon small class="mr-1">fas fa-file-alt</v-icon>
                  </v-btn>
                </div>
              </template>
            </v-data-table>
          </v-card-text> -->
        </v-card>
      </v-col>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="updateStatusDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row no-gutters>
            <v-col class="col-11 col-md-10 mx-auto mt-5">
              <v-card>
                <v-card-actions class="blue-grey lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateStatusDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="ptcBg white--text">
                  <span class="fontBold">รายละเอียดโครงการ ปีงบประมาณ พ.ศ.{{ parseInt(this.projectYear)+543 }}</span>
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
                        <h3 class="mb-2 fontBold">ยุทธศาสตร์สถานศึกษา</h3>
                        ยุทธศาสตร์ที่ {{ projectData.orgstrategicNum }} {{ projectData.orgstrategicName }}
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ฝ่าย</h3>
                        <span class="ml-3 fontPrompt">{{ projectData.partyName }}</span>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">แผนก/งาน</h3>
                        <span class="ml-3 fontPrompt">{{ projectData.departmentName }}</span>

                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ชื่อโครงการ</h3>
                        <span class="ml-3 fontPrompt">{{ projectData.projectName }}</span>
                      </v-col>
                      <v-col cols="12" v-if="projectData.projectProgress!='ดำเนินการเสร็จสิ้น'">
                        <h3 class="mb-2 fontBold">งบประมาณ</h3>
                        <span class="ml-3 fontPrompt">{{ moneyFormat(projectData.pjbudgetMoney) }} บาท</span>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">วัตถุประสงค์</h3>
                        <pre class="ml-3 fontPrompt">{{ projectData.projectObjective }}</pre>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">เป้าหมาย</h3>
                        <div class="ml-3">
                          <h4 class="fontBold">เชิงปริมาณ</h4>
                          <pre class="fontPrompt">{{ projectData.projectQuantityGoal }}</pre>
                          <h4 class="fontBold">เชิงคุณภาพ</h4>
                          <pre class="fontPrompt">{{ projectData.projectQualityGoal }}</pre>
                        </div>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ตัวชี้วัดความสำเร็จโครงการ</h3>
                        <b  class="ml-3 fontBold">เชิงปริมาณ</b>
                        <pre class="ml-3 fontPrompt">{{ projectData.projectQuantityKpi }}</pre>
                        <b  class="ml-3 fontBold">เชิงคุณภาพ</b>
                        <pre class="ml-3 fontPrompt">{{ projectData.projectQuantityKpi }}</pre>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ประโยชน์ที่คาดว่าจะได้รับ</h3>
                        <pre class="ml-3 fontPrompt">{{ projectData.projectBenefit }}</pre>
                      </v-col>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold">การอนุมัติ</h3>
                        <v-chip x-small color="success" v-if="projectData.projectStatus=='อนุมัติ'">
                          <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ projectData.projectStatus }}
                        </v-chip>
                        <v-chip x-small color="success" v-else-if="projectData.projectPlanStatus=='อนุมัติหลักการ'">
                          <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> อนุมัติ
                          <v-icon x-small class="ml-1">fas fa-check-circle</v-icon>
                        </v-chip>
                        <v-chip color="lime" x-small v-else-if="projectData.projectStatus=='ฝ่ายเห็นชอบ'">
                          <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ projectData.projectStatus }}
                          <v-icon x-small class="ml-1" v-if="projectData.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon>
                        </v-chip>
                        <v-chip color="deep-purple" x-small dark v-else-if="projectData.projectStatus=='แผนก/งานเห็นชอบ'">
                          <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ projectData.projectStatus }}
                          <v-icon x-small class="ml-1" v-if="projectData.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon>
                        </v-chip>
                        <v-chip color="red" x-small dark v-else-if="projectData.projectStatus=='ไม่อนุมัติ' || projectData.projectStatus=='แผนก/งานไม่เห็นชอบ' || projectData.projectStatus=='ฝ่ายไม่เห็นชอบ'">
                          <v-icon x-small class="mr-1">fas fa-exclamation</v-icon> {{ projectData.projectStatus }}
                          <v-icon x-small class="ml-1" v-if="projectData.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon>
                        </v-chip>
                        <v-chip color="info" x-small dark v-else>
                          <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ projectData.projectStatus }}
                          <v-icon x-small class="ml-1" v-if="projectData.projectPlanStatus=='อนุมัติหลักการ'">fas fa-check-circle</v-icon>
                        </v-chip>
                      </v-col>
                      <v-col cols="12" md="4">
                        <h3 class="mb-2 fontBold">การดำเนินกิจกรรม</h3>
                        <v-chip x-small color="success" v-if="projectData.projectProgress=='ดำเนินการเสร็จสิ้น'">
                          <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ projectData.projectProgress }}
                        </v-chip>
                        <v-chip color="red" x-small dark v-else-if="projectData.projectProgress=='ยังไม่ได้ดำเนินการ'">
                          <v-icon x-small class="mr-1">fas fa-exclamation</v-icon> {{ projectData.projectProgress }}
                        </v-chip>
                        <v-chip color="yellow" x-small v-else>
                          <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ projectData.projectProgress }}
                        </v-chip>
                      </v-col>
                      <v-col cols="12" md="4" v-if="projectData.projectProgress=='ดำเนินการเสร็จสิ้น'">
                        <h3 class="mb-2 fontBold">การรายงานผล</h3>
                        <v-chip x-small color="red darken-1" v-if="projectData.projectReport=='ไม่รายงาน'">
                          <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> ไม่รายงาน
                        </v-chip>
                        <v-chip x-small color="warning" v-else-if="projectData.projectReport=='ไม่ครบถ้วน' || projectData.imageQty<4">
                          <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> เข้ารายงาน <v-icon x-small>fas fa-search-plus</v-icon>
                        </v-chip>
                        <v-chip x-small color="success" v-else-if="projectData.projectReport=='ครบถ้วน'">
                          <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> ครบถ้วน <v-icon>fas fa-file-search</v-icon>
                        </v-chip>
                      </v-col>
                    </v-row>
                  </v-card-text>
                </v-form>
              </v-card>
            </v-col>
            <v-col class="col-11 col-md-10 mx-auto mb-5" v-if="projectData.projectProgress=='ดำเนินการเสร็จสิ้น'">
              <v-card>
                <v-card-title class="ptcBg white--text">
                  <span class="fontBold">ผลการดำเนินโครงการ</span>
                  <!-- <v-spacer></v-spacer> -->
                  <!-- <v-btn fab x-small color="white" class="mr-2" @click="showUpdateReportDialog(projectData)" v-if="userType=='Department' || userType=='Personal'">
                    <v-icon small color="warning">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn fab x-small color="white" class="mr-2" :to="'/print/pjsummaryReport/?id='+projectData.projectID" target="_blank">
                    <v-icon small color="primary">fas fa-print</v-icon>
                  </v-btn> -->
                </v-card-title>
                <v-divider class="green"></v-divider>
                  <v-card-text>
                    <v-row dense>
                      <v-col cols="12" v-if="projectData.projectProgress=='ดำเนินการเสร็จสิ้น'">
                        <h3 class="mb-2 fontBold">งบประมาณ</h3>
                        <span class="ml-3 fontPrompt">{{ moneyFormat(projectData.disburseMoney) }} บาท</span>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ผลการดำเนินงาน/กิจกรรม</h3>
                        <b  class="ml-3 fontBold">เชิงปริมาณ</b>
                        <pre class="ml-3 fontPrompt">{{ projectData.pjsummaryQtyResult }}</pre>
                        <b  class="ml-3 fontBold">เชิงคุณภาพ</b>
                        <pre class="ml-3 fontPrompt">{{ projectData.pjsummaryQlyResult }}</pre>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ปัญหาอุปสรรค</h3>
                        <pre class="ml-3 fontPrompt">{{ projectData.pjsummaryProblem }}</pre>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ข้อเสนอแนะ</h3>
                        <pre class="ml-3 fontPrompt">{{ projectData.pjsummarySuggestion }}</pre>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ภาพการดำเนินโครงการ</h3>
                        <v-row v-if="imageNames.length > 0">
                          <v-col cols="6" md="3" v-for="imageName in imageNames" :key="imageName.key">
                            <v-img
                              :src="imagePath+imageName"
                              @click="showImageDialog(imageName)"
                            >
                            </v-img>
                          </v-col>
                        </v-row>
                      </v-col>
                    </v-row>
                  </v-card-text>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="imageDialog"
        :scrollable="false"
      >
        <v-row>
          <v-col cols="12" class="text-right">
            <v-btn icon color="black" @click="imageDialog = false">
              <v-icon>fas fa-times</v-icon>
            </v-btn>
          </v-col>
          <v-col cols="12" class="pa-5 text-center">
            <img :src="imagePath+imageShowName" max-width="800" max-height="500" class="mx-auto" />
          </v-col>
        </v-row>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
var numeral = require('numeral')
import Swal from 'sweetalert2'
export default {
  components: {

  },

  props: {
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
      type: Number,
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
          value: 'projectID',
        },
        { text: 'ชื่อโครงการ', value: 'projectName', align: 'left', class: 'text-center' },
        { text: 'ยุทธศาสตร์', value: 'orgstrategicName', align: 'left', class: 'text-center' },
        { text: 'ผู้รับผิดชอบโครงการ', value: 'departmentName', align: 'left', class: 'text-center' },
        // { text: 'ผู้รับผิดชอบ', value: '' },
        { text: 'การอนุมัติ', value: 'projectStatus', align: 'center' },
        { text: 'การดำเนินกิจกรรม', value: 'projectProgress', align: 'center' },
        { text: 'การรายงานผล', value: 'projectReport', align: 'center' },
        { text: 'งบประมาณ', value: 'pjbudgetMoney', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      parties: [],
      party: {},
      budgetInsertBt: 0,
      departments: [],
      department: {},
      orgstrategics: [],
      orgstrategies: [],
      projects: [],
      projects_tb: [],
      projectSum: {},
      projectsLoading: true,
      search: '',
      projectData: {},
      projectStatus: null,
      insertDialog: false,
      insertProgress: false,
      projectInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      projectUpdateValidate: null,

      updateStatusDialog: false,
      updateStatusProgress: false,
      projectUpdateStatusValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      projectDeleteValidate: null,

      activityBudgetDialog: false,
      activityBudgetTab: 0,

      projectSummaryReportDialog: false,
      imageNames: [],
      imagePath: null,

      imageDialog: false,
      imageShowName: null,

    }
  },

  async mounted() {
    await this.getParties()
    await this.getOrgstrategic()
    await this.getProjects()
    await this.filterProjects()
  },

  methods: {
    async getParties() {
      let result = await this.$axios.$get('party.php', {
        params: {
          token: this.$store.state.jwtToken,
        }
      })

      if(result.message === 'Success') {
        this.parties = result.party
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
        this.orgstrategics.unshift({
          orgstrategicID: null,
          orgstrategicFullname: 'ทุกยุทธศาสตร์'
        })
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

    async getProjects() {
      this.projectsLoading = true
      let params = {
        token: this.$store.state.jwtToken,
          personalIDcard: this.personalIDcard,
          partyID: this.partyID,
          departmentID: this.departmentID,
          orgstrategicID: this.orgstrategicID,
          orgstrategyID: this.orgstrategyID,
          projectYear: this.projectYear
      }
      if(this.userType == 'Admin') {
        delete params.personalIDcard
      } else if(this.userType == 'Director') {
        delete params.personalIDcard
        delete params.partyID
      }

      let result = await this.$axios.$get('project.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.projects = JSON.parse(JSON.stringify(result.project))
      }

      if(this.userType == 'Admin' || this.userType == 'Director') {
        params.fn = 'getSummaryByYear'
      } else if(this.userType == 'Party') {
        params.fn = 'getSummaryByPartyYear'
      } else if(this.userType == 'Department') {
        params.fn = 'getSummaryByDepartmentYear'
      } else if(this.userType == 'Public') {
        params.fn = 'getSummaryByYear'
      }

      let sum = await this.$axios.$get('project.php', {
        params: params
      })
      if(sum.message == 'Success') {
        this.projectSum = JSON.parse(JSON.stringify(sum.project))
      }

      this.projectsLoading = false
    },

    filterProjects() {
      if(this.orgstrategicID > 0) {
        this.projects_tb = this.projects.filter((project)=> {
          return project.orgstrategicID == this.orgstrategicID
        })
      } else {
        this.projects_tb = JSON.parse(JSON.stringify(this.projects))
      }
    },

    async showInsertDialog() {
      this.projectData = {}
      this.departments = []
      this.orgstrategies = []
      this.projectData.projectStatus = 'เสนอโครงการ'
      this.projectData.projectProgress = 'ยังไม่ได้ดำเนินการ'
      this.insertDialog = true
    },

    async insertProject() {
      await this.$refs.projectInsertForm.validate()
      if(this.projectInsertValidate) {
        this.insertProgress = true
        this.projectData.token = this.$store.state.jwtToken
        this.projectData.projectYear = this.projectYear
        this.projectData.personalIDcard = this.personalIDcard

        let result = await this.$axios.$post('project.insert.php', this.projectData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            await this.getProjects()
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
      this.departments = []
      await this.getDepartments(this.projectData.partyID)
      this.orgstrategies = []
      await this.getOrgstrategy(this.projectData.orgstrategicID)
      this.updateDialog = true
    },

    async showUpdateStatusDialog(project) {
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
      this.projectStatus = project.projectStatus
      this.departments = []
      await this.getDepartments(this.projectData.partyID)
      this.orgstrategies = []
      await this.getOrgstrategy(this.projectData.orgstrategicID)
      this.updateStatusDialog = true
    },

    showImageDialog(image) {
      this.imageShowName = image
      this.imageDialog = true
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
            await this.getProjects()
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
            await this.getProjects()
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

    async showDeleteDialog(project) {
      this.projectData = JSON.parse(JSON.stringify(project))
      this.departments = []
      await this.getDepartments(this.projectData.partyID)
      this.orgstrategies = []
      await this.getOrgstrategy(this.projectData.orgstrategicID)
      this.deleteDialog = true
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
            await this.getProjects()
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

    async showActivityBudgetDialog(project) {
      this.projectData = JSON.parse(JSON.stringify(project))
      this.budgetInsertBt = 1
      this.activityBudgetDialog = true
    },

    async getBudgetStatus(res) {
      await this.getProjects()
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    },

  },

  watch: {
    async projectYear() {
      await this.getProjects()
      await this.filterProjects()
    },

    async personalIDcard() {
      await this.getProjects()
      await this.filterProjects()
    }
  }
}
</script>
