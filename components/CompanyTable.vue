<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ข้อมูลร้านค้า</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="companys"
              :search="search"
              :items-per-page="50"
              :loading="companysLoading"
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || departmentSys=='Parcel'">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มร้านค้า
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

              <template v-slot:item.companyID="{ item }">
                <div  class="text-no-wrap">CPN-{{ parseInt(item.companyID) }}</div>
              </template>
              <template v-slot:item.companyEnable="{ item }">
                <v-chip color="success" v-if="item.companyEnable==1">
                  <v-icon class="mr-1">fas fa-check-circle</v-icon> ใช้งาน
                </v-chip>
                <v-chip color="red" small dark v-else>
                  <v-icon small class="mr-1">fas fa-exclamation</v-icon> ไม่ใช้งาน
                </v-chip>
              </template>
              <template v-slot:item.actions="{ item }">
                <div  class="text-no-wrap">
                  <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="updateBt || userType=='Admin' || departmentSys=='Parcel'">
                    <v-icon small class="mr-1">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="deleteBt || userType=='Admin' || departmentSys=='Parcel'">
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
                <CompanyInsert :company="companyData" @getInsertStatus="insertCompany"/>
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
                <CompanyUpdate :company="companyData" @getUpdateStatus="updateCompany"/>
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
                <CompanyDelete :company="companyData" @getDeleteStatus="deleteCompany"/>
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
    departmentSys: {
      type: String,
      default: null,
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
          value: 'companyID',
        },
        { text: 'ชื่อร้านค้า', value: 'companyName', align: 'left' },
        { text: 'ชื่อเจ้าของ/ผู้จัดการ', value: 'companyOwner', align: 'left'},
        { text: 'ที่อยู่', value: 'companyAddress', align: 'left'},
        { text: 'เบอร์โทรศัพท์', value: 'companyPhone', align: 'left'},
        { text: 'สถานะ', value: 'companyEnable', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      companysLoading: true,
      companys: [],
      companyData: {},
      insertDialog: false,
      insertProgress: false,
      companyInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      companyUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      companyDeleteValidate: null,
    }
  },

  async mounted() {
    await this.getCompanys()
  },

  methods: {
    async getCompanys() {
      this.companysLoading = true
      let result = await this.$axios.$get('company.php', {
        params: {
          token: this.$store.state.jwtToken,
          fn: 'All'
        }
      })
      if(result.message === 'Success') {
        this.companys = JSON.parse(JSON.stringify(result.company))
      }
      this.companysLoading = false
    },

    showInsertDialog() {
      this.companyData = {
        token: this.$store.state.jwtToken,
        companyYear: this.companyYear,
        companyEnable: 1
      }
      this.insertDialog = true
    },

    async insertCompany(res) {
      if(res.status) {
        await this.getCompanys()
        this.$emit('getcompanyStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(company) {
      this.companyData = company
      this.companyData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updateCompany(res) {
      if(res.status) {
        await this.getCompanys()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(company) {
      this.companyData = company
      this.companyData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteCompany(res) {
      if(res.status) {
        await this.getCompanys()
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },
  },

watch: {
  async companyYear() {
    await this.getCompanys()
  },

  async personalIDcard() {
    await this.getCompanys()
  }
}
}
</script>
