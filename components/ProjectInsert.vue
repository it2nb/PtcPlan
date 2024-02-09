<template>
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
                        :rules="[
                          () => !!projectData.departmentID || 'กรุณากรอกข้อมูล'
                        ]"
                      ></v-autocomplete>
                    </v-col>
                    <v-col cols="12">
                      <h3 class="mb-2 fontBold">ยุทธศาสตร์สถานศึกษา</h3>
                      <v-autocomplete
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
                      ></v-autocomplete>
                    </v-col>
                    <v-col cols="12">
                      <h3 class="mb-2 fontBold">กลยุทธ์สถานศึกษา</h3>
                      <v-autocomplete
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
                      ></v-autocomplete>
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
</template>

<script>
import Swal from 'sweetalert2'
export default {
  props: {
    project: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      parties: [],
      departments: [],
      orgstrategics: [],
      orgstrategies: [],
      projectData: {},
      projectYear: null,
      insertDialog: false,
      insertProgress: false,
      projectInsertValidate: null,
    }
  },

  async mounted() {
    this.projectData = JSON.parse(JSON.stringify(this.project))
    this.projectYear = this.projectData.projectYear
    await this.getParties()
    await this.getOrgstrategic()
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
            this.emit('getInsertStatus', true)
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.emit('getInsertStatus', false)
          })
        }
      }
    },

  },

  watch: {
    async project() {
      this.projectData = JSON.parse(JSON.stringify(this.project))
      this.projectYear = this.projectData.projectYear
    }
  }
}
</script>
