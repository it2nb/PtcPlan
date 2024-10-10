<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="2">
          <v-card-title class="pb-5 ptcBg white--text">
            <b>รายงานสถานะการดำเนินโครงการ ประจำปีงบประมาณ พ.ศ. {{ parseInt(projectYear)+543 }} (ไตรมาตร {{ subperiod }})</b>
            <v-spacer></v-spacer>
            <span class="mr-md-3 text-center caption">
              <v-btn fab small color="white" :href="'/print/projecttableStatusReport/?year='+projectYear+'&status=อนุมัติ'" target="_blank">
                <v-icon color="primary">fas fa-print</v-icon>
              </v-btn><br>
              สถานะดำเนินงาน
            </span>
            <span class="mr-md-3 text-center caption">
              <v-btn fab small color="white" :href="'/print/projecttableResultReport/?year='+projectYear" target="_blank">
                <v-icon color="primary">fas fa-print</v-icon>
              </v-btn><br>
              สรุป
            </span>
            <v-btn icon color="primary" class="mr-md-3"  :href="'/print/projecttableReport/?year='+projectYear" target="_blank" v-if="userType=='Admin'||userType=='Director'">
              <v-icon>fas fa-print</v-icon>
            </v-btn>
          </v-card-title>
          <!-- <v-card-subtitle  class="pt-1 blue-grey lighten-5">
            <v-row class="mt-1">
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
            </v-row>
          </v-card-subtitle> -->
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="projects_tb"
              :search="search"
              :items-per-page="-1"
              :loading="projectsLoading"
              hide-default-footer
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="4">
                    <v-autocomplete
                      v-model="orgstrategicID_selected"
                      label="ยุทธศาสตร์"
                      :items="orgstrategics"
                      item-text="orgstrategicFullname"
                      item-value="orgstrategicID"
                      hide-details
                      outlined
                      dense
                      @change="filterProjects"
                    ></v-autocomplete>
                  </v-col>
                  <v-col cols="12" md="4" class="mx-auto">
                    <v-select
                      v-model="subperiod"
                      :items="subperiods"
                      label="ไตรมาตรที่"
                      outlined
                      hide-details
                      dense
                    ></v-select>
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
                <span class="text-no-wrap text--primary"><v-icon x-small color="primary" class="mr-1">fas fa-circle</v-icon>{{ item.departmentName }}</span><br>
              </template>

              <template v-slot:item.pjbudgetMoney="{ item }">
                <div class="text-no-wrap text-right">
                  {{ moneyFormat(parseFloat(item.pjbudgetMoney)) }}
              </div>
              </template>
              <template v-slot:item.disburseMoney="{ item }">
                <div class="text-no-wrap text-right">
                  <div>
                    <span v-if="parseFloat(item.disburseMoney)<=parseFloat(item.pjbudgetMoney)">
                      {{ moneyFormat(parseFloat(item.disburseMoney)) }}
                    </span>
                    <span v-else>
                      {{ moneyFormat(parseFloat(item.disburseMoney)) }}
                    </span>
                    <div class="mt-1">
                      <v-progress-linear
                        :value="100-(parseFloat(parseFloat(item.disburseMoney)>parseFloat(item.pjbudgetMoney)? item.pjbudgetMoney : item.disburseMoney)/parseFloat(item.pjbudgetMoney)*100)"
                        background-color="red lighten-4"
                        color="green lighten-4"
                        height="8"
                      >
                        <!-- <template v-slot:default="{}">
                          <div class="pa-1 col-12 text-right text-no-wrap">
                            <strong>{{ moneyFormat(parseFloat(parseFloat(item.disburseMoney)>parseFloat(item.pjbudgetMoney)? item.pjbudgetMoney : item.disburseMoney)/parseFloat(item.pjbudgetMoney)*100) }}%</strong>
                          </div>
                        </template> -->
                      </v-progress-linear>
                    </div>
                  </div>
              </div>
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
                <!-- <div  class="text-no-wrap">
                  <v-btn color="info darken-2" icon small :href="'/print/project/?pid='+item.projectID" target="_blank">
                    <v-icon small class="mr-1">fas fa-print</v-icon>
                  </v-btn>
                </div> -->
              </template>
            </v-data-table>
          </v-card-text>
        </v-card>
      </v-col>
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
                <v-card-actions class="info lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateProgressDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="info lighten-2">
                  <span class="fontBold">รายละเอียดการดำเนินกิจกรรมโครงการ ปีงบประมาณ พ.ศ.{{ parseInt(this.projectYear)+543 }}</span>
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
                        <b  class="ml-3 fontBold">ผลกระทบ</b>
                        <pre class="ml-3 fontPrompt">{{ projectData.pjsummaryImpact }}</pre>
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
    projectPeriod: {
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
          value: 'projectCode',
        },
        { text: 'ชื่อโครงการ/ผู้รับผิดชอบ', value: 'projectNamePresenter', align: 'left', class: 'text-center' },
        { text: 'การดำเนินกิจกรรม', value: 'projectProgress', align: 'left', class: 'text-center' },
        { text: 'การรายงานผล', value: 'projectReport', align: 'left', class: 'text-center' },
        { text: 'งบประมาณ', value: 'pjbudgetMoney', align: 'center' },
        { text: 'เบิกจ่ายแล้ว', value: 'disburseMoney', align: 'center' },
        // { text: '', value: 'actions', align: 'center' },
      ],

      subperiod: null,
      subperiods: [
        {
          value: 1,
          text: 'ไตรมาตร 1',
          startDate: (parseInt(this.projectYear)-1)+'-10-01',
          endDate: (parseInt(this.projectYear)-1)+'-12-31'
        },
        {
          value: 2,
          text: 'ไตรมาตร 2',
          startDate: this.projectYear+'-01-01',
          endDate: this.projectYear+'-03-31'
        },
        {
          value: 3,
          text: 'ไตรมาตร 3',
          startDate: this.projectYear+'-04-01',
          endDate: this.projectYear+'-06-30'
        },{
          value: 4,
          text: 'ไตรมาตร 4',
          startDate: this.projectYear+'-07-01',
          endDate: this.projectYear+'-09-30'
        }
      ],

      parties: [],
      party: {},
      budgetInsertBt: 0,
      departments: [],
      department: {},
      orgstrategics: [],
      orgstrategies: [],
      orgstrategicID_selected: null,
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

      updateProgressDialog:false,

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
    if(this.projectPeriod>=1 && this.projectPeriod<=4) {
      this.subperiod = parseInt(this.projectPeriod)
    } else {
      let period = this.subperiods.filter(period => new Date().getTime()>=new Date(period.startDate+' 00:00:01').getTime())
      if(period.length>0) {
        this.subperiod = period.length
      }
    }
    if(this.orgstrategicID > 0) {
      this.orgstrategicID_selected = this.orgstrategicID
    }
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
      let period = this.subperiods.filter(period => period.value==this.subperiod)
      let params = {
        token: this.$store.state.jwtToken,
        projectYear: this.projectYear,
        projectStart: (parseInt(this.projectYear)-1)+'-10-01',
        projectEnd: period[0]?.endDate,
      }

      let result = await this.$axios.$get('project.php', {
        params: params
      })
      if(result.message == 'Success') {
        let projects = JSON.parse(JSON.stringify(result.project))
        if(projects){
          this.projects = projects.filter(project => project.projectStatus=='อนุมัติ')
        }
        this.filterProjects()
      }

      this.projectsLoading = false
    },

    filterProjects() {
      if(this.orgstrategicID_selected > 0) {
        this.projects_tb = this.projects.filter(project=>project.orgstrategicID == this.orgstrategicID_selected)
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
      this.subperiods = [
        {
          value: 1,
          text: 'ไตรมาตร 1',
          startDate: (parseInt(this.projectYear)-1)+'-10-01',
          endDate: (parseInt(this.projectYear)-1)+'-12-31'
        },
        {
          value: 2,
          text: 'ไตรมาตร 2',
          startDate: this.projectYear+'-01-01',
          endDate: this.projectYear+'-03-31'
        },
        {
          value: 3,
          text: 'ไตรมาตร 3',
          startDate: this.projectYear+'-04-01',
          endDate: this.projectYear+'-06-30'
        },{
          value: 4,
          text: 'ไตรมาตร 4',
          startDate: this.projectYear+'-07-01',
          endDate: this.projectYear+'-09-30'
        }
      ]
      let period = this.subperiods.filter(period => new Date().getTime()>=new Date(period.startDate+' 00:00:01').getTime())
      if(period.length>0) {
        this.subperiod = period.length
      } else {
        this.subperiod = 1
      }
      await this.getProjects()
      await this.filterProjects()
    },

    async subperiod() {
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
