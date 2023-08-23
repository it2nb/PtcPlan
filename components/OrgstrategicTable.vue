<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ยุทธศาสตร์สถานศึกษา</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="orgstrategics"
              :search="search"
              :items-per-page="-1"
              :loading="orgstrategicsLoading"
              hide-default-footer
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <!-- <v-select
                      v-model="orgstrategicID"
                      label="ยุทธศาสตร์"
                      :items="orgstrategics"
                      item-text="orgstrategicFullname"
                      item-value="orgstrategicID"
                      outlined
                      @change="filterProjects"
                    ></v-select> -->
                    <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || userType=='Plan'">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มยุทธศาสตร์
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

              <template v-slot:item.orgstrategicID="{ item }">
                <div  class="text-no-wrap">OSC-{{ parseInt(item.orgstrategicID) }}</div>
              </template>
              <template v-slot:item.orgstrategicYear="{ item }">
                {{ parseInt(item.orgstrategicYear)+543 }}
              </template>
              <template v-slot:item.orgstrategicEnable="{ item }">
                <v-chip color="success" v-if="item.orgstrategicEnable==1">
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
                <OrgstartegicInsertVue :orgstrategic="orgstrategicData" @getInsertStatus="insertOrgstrategic"/>
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
                <OrgstrategicUpdateVue :orgstrategic="orgstrategicData" @getUpdateStatus="updateOrgstrategic"/>
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
                <OrgstrategicDeleteVue :orgstrategic="orgstrategicData" @getDeleteStatus="deleteOrgstrategic"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
import OrgstartegicInsertVue from './OrgstrategicInsert'
import OrgstrategicUpdateVue from './OrgstrategicUpdate.vue'
import OrgstrategicDeleteVue from './OrgstrategicDelete.vue'
export default {
  components: {
    OrgstartegicInsertVue,
    OrgstrategicUpdateVue,
    OrgstrategicDeleteVue,
  },

  props: {
    // orgstrategics: {
    //   type: Array,
    //   default: () => []
    // }
    userType: {
      type: String,
      default: null,
    },
    personalIDcard: {
      type: String,
      default: null
    },
    orgstrategicYear: {
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
          value: 'orgstrategicID',
        },
        { text: 'ยุทธศาสตร์ที่', value: 'orgstrategicNum', align: 'center' },
        { text: 'ชื่อยุทธศาสตร์', value: 'orgstrategicName', align: 'left', class: 'text-center' },
        { text: 'ปีงบประมาณ พ.ศ.', value: 'orgstrategicYear', align: 'center', class: 'text-center' },
        { text: 'สถานะ', value: 'orgstrategicEnable', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      orgstrategicsLoading: true,
      orgstrategics: [],
      orgstrategicData: {},
      insertDialog: false,
      insertProgress: false,
      orgstrategicInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      orgstrategicUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      orgstrategicDeleteValidate: null,
    }
  },

  async mounted() {
    await this.getOrgstrategics()
  },

  methods: {
    async getOrgstrategics() {
      this.orgstrategicsLoading = true
      let result = await this.$axios.$get('orgstrategic.php', {
        params: {
          token: this.$store.state.jwtToken,
          orgstrategicYear: this.orgstrategicYear
        }
      })

      if(result.message === 'Success') {
        this.orgstrategics = JSON.parse(JSON.stringify(result.orgstrategic))
      }
      this.orgstrategicsLoading = false
    },

    showInsertDialog() {
      this.orgstrategicData = {
        token: this.$store.state.jwtToken,
        orgstrategicYear: this.orgstrategicYear,
        orgstrategicEnable: 1
      }
      this.insertDialog = true
    },

    async insertOrgstrategic(res) {
      if(res.status) {
        await this.getOrgstrategics()
        this.$emit('getorgstrategicStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(orgstrategic) {
      this.orgstrategicData = orgstrategic
      this.orgstrategicData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updateOrgstrategic(res) {
      if(res.status) {
        await this.getOrgstrategics()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(orgstrategic) {
      this.orgstrategicData = orgstrategic
      this.orgstrategicData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteOrgstrategic(res) {
      if(res.status) {
        await this.getOrgstrategics()
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },
  },

watch: {
  async orgstrategicYear() {
    await this.getOrgstrategics()
  },

  async personalIDcard() {
    await this.getOrgstrategics()
  }
}
}
</script>
