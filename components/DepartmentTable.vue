<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>แผนก/งาน</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="departments"
              :search="search"
              :items-per-page="-1"
              :loading="departmentsLoading"
              hide-default-footer
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || userType=='Plan'">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มแผนก/งาน
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

              <template v-slot:item.departmentID="{ item }">
                <div  class="text-no-wrap">DPM-{{ parseInt(item.departmentID) }}</div>
              </template>
              <template v-slot:item.departmentSys="{ item }">
                <v-chip color="primary" v-if="item.departmentSys=='Parcel'">
                    งานพัสดุ
                </v-chip>
                <v-chip color="primary" v-else-if="item.departmentSys=='Plan'">
                    งานวางแผน
                </v-chip>
                <v-chip color="primary" v-else-if="item.departmentSys=='Account'">
                    งานบัญชี
                </v-chip>
                <v-chip color="primary" v-else-if="item.departmentSys=='Finance'">
                    งานการเงิน
                </v-chip>
              </template>
              <template v-slot:item.departmentEnable="{ item }">
                <v-chip color="success" v-if="item.departmentEnable==1">
                  <v-icon class="mr-1">fas fa-check-circle</v-icon> ใช้งาน
                </v-chip>
                <v-chip color="red" small dark v-else>
                  <v-icon small class="mr-1">fas fa-exclamation</v-icon> ไม่ใช้งาน
                </v-chip>
              </template>
              <template v-slot:item.actions="{ item }">
                <div  class="text-no-wrap">
                  <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="updateBt || userType=='Admin' || userType=='Plan'">
                    <v-icon small class="mr-1">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="deleteBt || userType=='Admin' || userType=='Plan'">
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
                <DepartmentInsert :department="departmentData" @getInsertStatus="insertDepartment"/>
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
                <DepartmentUpdate :department="departmentData" @getUpdateStatus="updateDepartment"/>
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
                <DepartmentDelete :department="departmentData" @getDeleteStatus="deleteDepartment"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
export default {

  props: {
    userType: {
      type: String,
      default: null,
    },
    personalIDcard: {
      type: String,
      default: null
    },
    departmentYear: {
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
          value: 'departmentID',
        },
        { text: 'ชื่อแผนก/งาน', value: 'departmentName', align: 'left', class: 'text-center' },
        { text: 'สิทธิ์ของระบบ', value: 'departmentSys', align: 'center' },
        { text: 'สถานะ', value: 'departmentEnable', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      departmentsLoading: true,
      departments: [],
      departmentData: {},
      insertDialog: false,
      insertProgress: false,
      departmentInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      departmentUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      departmentDeleteValidate: null,
    }
  },

  async mounted() {
    await this.getDepartments()
  },

  methods: {
    async getDepartments() {
      this.departmentsLoading = true
      let result = await this.$axios.$get('department.php', {
        params: {
          token: this.$store.state.jwtToken
        }
      })

      if(result.message === 'Success') {
        this.departments = JSON.parse(JSON.stringify(result.department))
      }
      this.departmentsLoading = false
    },

    showInsertDialog() {
      this.departmentData = {
        token: this.$store.state.jwtToken,
        departmentYear: this.departmentYear,
        departmentEnable: 1
      }
      this.insertDialog = true
    },

    async insertDepartment(res) {
      if(res.status) {
        await this.getDepartments()
        this.$emit('getdepartmentStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(department) {
      this.departmentData = department
      this.departmentData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updateDepartment(res) {
      if(res.status) {
        await this.getDepartments()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(department) {
      this.departmentData = department
      this.departmentData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteDepartment(res) {
      if(res.status) {
        await this.getDepartments()
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },
  },

watch: {
  async departmentYear() {
    await this.getDepartments()
  },

  async personalIDcard() {
    await this.getDepartments()
  }
}
}
</script>
