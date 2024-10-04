<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>เอกสารเผยแพร่ ประเภท {{ documenttype.documenttypeTitle }}</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
                :items="documents"
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
                <template v-slot:item.documentTitle="{item}">
                    {{ item.documentTitle }}
                    <v-btn 
                        icon 
                        smalll 
                        :href="documentPath+item.documentLink+'?t='+new Date().getTime()" 
                        target="_blank" 
                        color="primary"
                        v-if="item.documentLink"
                    >
                        <v-icon small>fas fa-link</v-icon>
                    </v-btn>
                </template>
                <template v-slot:item.index="{item}">
                    {{ documents.indexOf(item)+1 }}
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
                <DocumentInsert :userID="userID" :documenttypeID="documenttypeID" @getStatus="insertData" v-if="insertDialog"/>
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
                <DocumentUpdate :document="document" @getStatus="updateData" v-if="updateDialog"/>
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
                <DocumentDelete :document="document" @getStatus="deleteData" v-if="deleteDialog"/>
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
    userID: {
      type: String,
      default: null,
    },
    documenttypeID: {
      type: String,
      default: null
    }
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
          value: 'documentTitle',
          text: 'รายการ',
          sortable: true,
        },
        // {
        //   value: 'documenttypeTitle',
        //   text: 'ประเภท',
        //   sortable: true,
        // },
        {
          value: 'documentYearBd',
          text: 'ปีงบประมาณ พ.ศ.',
          sortable: true,
          align: 'center',
          class: 'text-center',
        },
        {
          value: 'documentDateTime',
          text: 'แก้ไขล่าสุด',
          sortable: true,
          align: 'center',
          class: 'text-center',
        },
        ,
        {
          value: 'actions',
          text: '',
        },
      ],
      documenttype: {},
      documents: [],
      document: {},
      documentPath: null,
      loadData: false,
      
      insertDialog: false,
      insertProgress: false,

      updateDialog: false,
      updateProgress: false,

      deleteDialog: false,
      deleteProgress: false,
    }
  },

  async mounted() {
    await this.getDocumenttype()
    await this.getDocumentPath()
    await this.getDocuments()
  },

  methods: {
    async getDocumenttype() {
      this.loadData = true
      let result = await this.$axios.$get('documenttype.php', {
        params: {
          token: this.$store.state.jwtToken,
          documenttypeID: this.documenttypeID
        }
      })

      if(result.message == 'Success') {
        this.documenttype = JSON.parse(JSON.stringify(result.documenttype))
      }
      this.loadData = false
    },

    async getDocumentPath() {
        let result = await this.$axios.$get('document.doc.php', {
            params: {
                token: this.$store.state.jwtToken,
                function: 'documentPath'
            }
        })
        if(result.message == 'Success') {
            this.documentPath = result.documentPath
        }
    },

    async getDocuments() {
      this.loadData = true
      let params = {
        token: this.$store.state.jwtToken,
      }
      if(this.documenttypeID) {
        params.documenttypeID = this.documenttypeID
      } else {
        params.fn = 'All'
      }

      let result = await this.$axios.$get('document.php', {params})
      
      if(result.message == 'Success') {
        this.documents = JSON.parse(JSON.stringify(result.document))
      }
      this.loadData = false
    },

    async getCover(document) {
      let result = await this.$axios.$get('document.image.php', {
        params: {
          token: this.$store.state.jwtToken,
          documentID: document.documentID,
          function: 'documentImageGet'
        }
      })
       if(result.message == 'Success') {
        document.documentCoverPath = result.documentImagePath
        document.documentCover = result.documentImages[0]
       }
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
        await this.getDocuments()
        this.$emit('getStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    async showUpdate(document) {
      this.document = JSON.parse(JSON.stringify(document))
      this.document.token = this.$store.state.jwtToken
      this.document.userID = this.userID
      await this.getCover(this.document)
      this.updateDialog = true
    },

    async updateData(res) {
      if(res.status) {
        await this.getDocuments()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDelete(document) {
      this.document = JSON.parse(JSON.stringify(document))
      this.document.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteData(res) {
      if(res.status) {
        await this.getDocuments()
        this.$emit('getStatus', {'status': true})
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },
  },
}
</script>
