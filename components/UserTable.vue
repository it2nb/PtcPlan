<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ข้อมูลผู้ใช้ระบบ</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="users"
              :search="search"
              :items-per-page="50"
              :loading="usersLoading"
              :footer-props="{
                showFirstLastPage: true,
              }"
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <!-- <v-select
                      v-model="userID"
                      label="ผู้ใช้ระบบ"
                      :items="users"
                      item-text="userFullname"
                      item-value="userID"
                      outlined
                      @change="filterProjects"
                    ></v-select> -->
                    <v-btn color="success" text @click="showInsertDialog" v-if="insertBt">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มผู้ใช้ระบบ
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

              <template v-slot:item.userID="{ item }">
                <div  class="text-no-wrap">UID-{{ parseInt(item.userID) }}</div>
              </template>
              <template v-slot:item.departmentName="{ item }">
                <span v-if="item.userStatus=='Department'">{{ item.departmentName }}</span>
              </template>
              <template v-slot:item.partyName="{ item }">
                <span v-if="item.userStatus=='Party' || item.userStatus=='Director'">{{ item.partyName }}</span>
              </template>
              <template v-slot:item.userEnable="{ item }">
                <v-chip color="success" v-if="item.userEnable=='Enable'">
                  <v-icon class="mr-1">fas fa-check-circle</v-icon> ใช้งาน
                </v-chip>
                <v-chip color="red" small dark v-else>
                  <v-icon small class="mr-1">fas fa-exclamation</v-icon> ไม่ใช้งาน
                </v-chip>
              </template>
              <template v-slot:item.actions="{ item }">
                <div  class="text-no-wrap" v-if="item.userID!=user.userID">
                  <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="updateBt">
                    <v-icon small class="mr-1">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="deleteBt">
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
                <UserInsertVue :user="userData" :userType="userType" @getInsertStatus="insertUser"/>
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
                <UserUpdateVue :user="userData" :userType="userType" @getUpdateStatus="updateUser"/>
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
                <UserDeleteVue :user="userData" :userType="userType" @getDeleteStatus="deleteUser"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
import UserInsertVue from './UserInsert.vue'
import UserUpdateVue from './UserUpdate.vue'
import UserDeleteVue from './UserDelete.vue'
export default {
  components: {
    UserInsertVue,
    UserUpdateVue,
    UserDeleteVue,
  },

  props: {
    // users: {
    //   type: Array,
    //   default: () => []
    // }
    userType: {
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
          value: 'userID',
        },
        { text: 'ชื่อผู้ใช้', value: 'userName', align: 'left', class: 'text-center' },
        { text: 'ชื่อผู้ใช้', value: 'userFullname', align: 'left', class: 'text-center' },
        { text: 'ประเภท', value: 'userStatus', align: 'left', class: 'text-center' },
        { text: 'แผนก/งาน', value: 'departmentName', align: 'left', class: 'text-center' },
        { text: 'ฝ่าย', value: 'partyName', align: 'left', class: 'text-center' },
        { text: 'คำอธิบาย', value: 'userDes', align: 'left', class: 'text-center' },
        { text: 'อนุญาตใช้งาน', value: 'userEnable', align: 'center', class: 'text-center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      usersLoading: true,
      users: [],
      user: {},
      userData: {},
      insertDialog: false,
      insertProgress: false,
      userInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      userUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      userDeleteValidate: null,
    }
  },

  async mounted() {
    this.user = JSON.parse(sessionStorage.getItem("loginuser"))?.user
    await this.getUsers()
  },

  methods: {
    async getUsers() {
      this.usersLoading = true
      let params = {}
      if(this.userType=='Admin') {
        params = {
          token: this.$store.state.jwtToken,
          fn: 'All'
        }
      } else if(this.userType=='Department') {
        params = {
          token: this.$store.state.jwtToken,
          departmentID: this.user.departmentID
        }
      }
      let result = await this.$axios.$get('user.php', {
        params: params
      })

      if(result.message === 'Success') {
        this.users = JSON.parse(JSON.stringify(result.user))
      }
      this.usersLoading = false
    },

    showInsertDialog() {
      if(this.userType=='Admin') {
        this.userData = {
          token: this.$store.state.jwtToken,
          userEnable: 1
        }
      } else if(this.userType=='Department') {
        this.userData = {
          token: this.$store.state.jwtToken,
          userEnable: 1,
          userStatus: 'Department',
          departmentID: this.user.departmentID,
        }
      }
      this.insertDialog = true
    },

    async insertUser(res) {
      if(res.status) {
        await this.getUsers()
        this.$emit('getuserStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(user) {
      this.userData = user
      this.userData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updateUser(res) {
      if(res.status) {
        await this.getUsers()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(user) {
      this.userData = user
      this.userData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteUser(res) {
      if(res.status) {
        await this.getUsers()
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },
  },

watch: {

}
}
</script>
