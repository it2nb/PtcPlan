<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="light-blue lighten-5">
            <b>โครงการ</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="projects"
              :search="search"
              :items-per-page="-1"
              :loading="projectsLoading"
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <!-- <v-select
                      v-model="projectID"
                      label="ยุทธศาสตร์"
                      :items="projects"
                      item-text="projectFullname"
                      item-value="projectID"
                      outlined
                      @change="filterProjects"
                    ></v-select> -->
                    <v-btn color="success" text @click="showInsertDialog">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มโครงการ
                    </v-btn>
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

              <template v-slot:item.projectStatus="{ item }">
                <v-chip color="success" v-if="item.projectStatus=='อนุมัติ'">
                  <v-icon class="mr-1">fas fa-check-circle</v-icon> อนุมัติ
                </v-chip>
                <v-chip color="red" small dark v-else-if="item.projectStatus=='ไม่อนุมัติ'">
                  <v-icon small class="mr-1">fas fa-exclamation</v-icon> {{ item.projectStatus }}
                </v-chip>
                <v-chip color="info" small dark v-else>
                  <v-icon small class="mr-1">fas fa-clock</v-icon> {{ item.projectStatus }}
                </v-chip>
              </template>
              <template v-slot:item.actions="{ item }">
                <div  class="text-no-wrap" v-if="item.projectStatus!='อนุมัติ'">
                  <v-btn color="warning" icon  small @click="showUpdateDialog(item)">
                    <v-icon small class="mr-1">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)">
                    <v-icon small class="mr-1">fas fa-trash</v-icon>
                  </v-btn>
                </div>
              </template>
            </v-data-table>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

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
                        <v-select
                          v-model="projectData.partyID"
                          :items="parties"
                          item-text="partyName"
                          item-value="partyID"
                          label="ฝ่าย"
                          outlined
                          :rules="[
                            () => !!projectData.partyID || 'กรุณากรอกข้อมูล'
                          ]"
                          @change="partyChange"
                        ></v-select>
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
                      <v-col cols="12">
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
                      </v-col>
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
                          label="ที่มาและความสำคัญ"
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
  </div>
</template>

<script>
import Swal from 'sweetalert2'
export default {
  props: {
    personalIDcard: {
      type: String,
      default: null
    },
    partyID: {
      type: Number,
      default: null
    },
    departmentID: {
      type: Number,
      default: null
    },
    orgstrategicID: {
      type: Number,
      default: null
    },
    orgstrategyID: {
      type: Number,
      default: null
    },
    projectYear: {
      type: String,
      default: null
    }
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
        { text: 'รหัสโครงการ', value: 'projectNum', align: 'center' },
        { text: 'ชื่อโครงการ', value: 'projectName', align: 'left', class: 'text-center' },
        // { text: 'ผู้รับผิดชอบ', value: '' },
        { text: 'สถานะ', value: 'projectStatus', align: 'center' },
        { text: 'กำหนดรายละเอียด', value: 'projectDetail', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      parties: [],
      departments: [],
      orgstrategics: [],
      orgstrategies: [],
      projects: [],
      projectsLoading: true,
      search: '',
      projectData: {},
      insertDialog: false,
      insertProgress: false,
      projectInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      projectUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      projectDeleteValidate: null,
    }
  },

  async mounted() {
    await this.getProjects()
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

    async getOrgstrategic() {
      let params = {
        token: this.$store.state.jwtToken,
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
      let result = await this.$axios.$get('project.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.projects = JSON.parse(JSON.stringify(result.project))
      }
      this.projectsLoading = false
    },

    async showInsertDialog() {
      this.parties = []
      this.departments = []
      await this.getParties()
      this.orgstrategics = []
      this.orgstrategies = []
      await this.getOrgstrategic()
      this.insertDialog = true
    },

    async insertProject() {
      await this.$refs.projectInsertForm.validate()
      if(this.projectInsertValidate) {
        this.insertProgress = true
        this.projectData.token = this.$store.state.jwtToken
        this.projectData.projectYear = this.projectYear
        this.projectData.projectStatus = 'เสนอโครงการ'
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

    async showUpdateDialog() {
      this.parties = []
      this.departments = []
      await this.getParties()
      await this.getDepartments()
      this.orgstrategics = []
      this.orgstrategies = []
      await this.getOrgstrategic()
      this.updateDialog = true
    },

    showDeleteDialog() {
      this.deleteDialog = true
    }
  },

  watch: {
    async projectYear() {
      await this.getProjects()
    },

    async personalIDcard() {
      await this.getProjects()
    }
  }
}
</script>
