<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ประเภทไฟล์เอกสารเผยแพร่</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
                :items="documenttypes"
                :headers="fields"
                :loading="loadData"
            >
                <template v-slot:top>
                    <v-toolbar
                    flat
                    >
                    <v-spacer></v-spacer>
                    <v-btn color="success" @click="insertDialog=true">
                        <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่ม
                    </v-btn>
                    </v-toolbar>
                </template>
                <template v-slot:item.index="{item}">
                    {{ documenttypes.indexOf(item)+1 }}
                </template>
                <template v-slot:item.documentQty="{item}">
                <v-btn color="info" small outlined @click="showDetail(item)">
                    {{ item.documentQty }}
                </v-btn>
                </template>
                <template v-slot:item.actions="{item}">
                <div class="text-nowrap text-right">
                    <v-btn icon color="warning" @click="showUpdate(item)">
                    <v-icon small>fas fa-edit</v-icon>
                    </v-btn>
                    <v-btn icon color="error darken-2" size="sm" @click="showDelete(item)">
                    <v-icon small>fas fa-trash</v-icon>
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
                <DocumenttypeInsert :userID="userID" @getStatus="insertData" v-if="insertDialog"/>
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
                <DocumenttypeUpdate :documenttype="documenttype" @getStatus="updateData" v-if="updateDialog"/>
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
                <DocumenttypeDelete :documenttype="documenttype" @getStatus="deleteData" v-if="deleteDialog"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="detailDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="grey lighten-2">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="detailDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <DocumentTable :userID="userID" :documenttypeID="documenttype.documenttypeID" @getStatus="documentStatus" v-if="detailDialog"/>
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
    userID: {
      type: String,
      default: null,
    },
  },

  data() {
    return {
      fields: [
        {
          value: 'index',
          text: '',
          align: 'center'
        },
        {
          value: 'documenttypeTitle',
          text: 'รายการ',
          sortable: true,
          class: 'text-center'
        },
        {
          value: 'documentQty',
          text: 'จำนวนเอกสาร',
          sortable: true,
          align: 'center',
          class: 'text-center'
        },
        {
          value: 'actions',
          text: '',
        },
      ],
      documenttypes: [],
      documenttype: {},
      loadData: false,
      insertDialog: false,
      insertProgress: false,

      updateDialog: false,
      updateProgress: false,
      orgstrategicUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      orgstrategicDeleteValidate: null,

      detailDialog: false,
    }
  },

  async mounted() {
    await this.getDocumenttypes()
  },

  methods: {
    async getDocumenttypes() {
      this.loadData = true
      let result = await this.$axios.$get('documenttype.php', {
        params: {
          token: this.$store.state.jwtToken,
          fn: 'All'
        }
      })
      if(result.message == 'Success') {
        this.documenttypes = JSON.parse(JSON.stringify(result.documenttype))
      }
      this.loadData = false
    },

    showInsertDialog() {
      this.orgstrategicData = {
        token: this.$store.state.jwtToken,
        orgstrategicYear: this.orgstrategicYear,
        orgstrategicEnable: 1
      }
      this.insertDialog = true
    },

    async insertData(res) {
      if(res.status) {
        await this.getDocumenttypes()
        this.$emit('getStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdate(documenttype) {
      this.documenttype = documenttype
      this.documenttype.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updateData(res) {
      if(res.status) {
        await this.getDocumenttypes()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDelete(documenttype) {
      this.documenttype = documenttype
      this.documenttype.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteData(res) {
      if(res.status) {
        await this.getDocumenttypes()
        this.$emit('getStatus', {'status': true})
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },

    async showDetail(documenttype) {
      this.documenttype = JSON.parse(JSON.stringify(documenttype))
      this.detailDialog = true
    },

    async documentStatus(res) {
      if(res.status) {
        await this.getDocumenttypes()
      }
    },
  },
}
</script>
