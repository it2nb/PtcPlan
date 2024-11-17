<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ข้อมูลรหัสบัญชีแยกประภท</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="ledgers"
              :search="search"
              :items-per-page="50"
              :loading="ledgersLoading"
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || departmentSys=='Account'">
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

              <template v-slot:item.ledgerID="{ item }">
                <div  class="text-no-wrap">GL-{{ parseInt(item.ledgerID) }}</div>
              </template>
              <template v-slot:item.ledgerEnable="{ item }">
                <v-chip color="success" v-if="item.ledgerEnable==1">
                  <v-icon class="mr-1">fas fa-check-circle</v-icon> ใช้งาน
                </v-chip>
                <v-chip color="red" small dark v-else>
                  <v-icon small class="mr-1">fas fa-exclamation</v-icon> ไม่ใช้งาน
                </v-chip>
              </template>
              <template v-slot:item.actions="{ item }">
                <div  class="text-no-wrap">
                  <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="updateBt || userType=='Admin' || departmentSys=='Account'">
                    <v-icon small class="mr-1">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="deleteBt || userType=='Admin' || departmentSys=='Account'">
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
                <LedgerInsert :ledger="ledgerData" @getInsertStatus="insertLedger"/>
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
                <LedgerUpdate :ledger="ledgerData" @getUpdateStatus="updateLedger"/>
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
                <LedgerDelete :ledger="ledgerData" @getDeleteStatus="deleteLedger"/>
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
          value: 'ledgerID',
        },
        { text: 'ชื่อบัญชี', value: 'ledgerName', align: 'left' },
        { text: 'เปิดใช้งาน', value: 'ledgerEnable', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      ledgersLoading: true,
      ledgers: [],
      ledgerData: {},
      insertDialog: false,
      insertProgress: false,
      ledgerInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      ledgerUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      ledgerDeleteValidate: null,
    }
  },

  async mounted() {
    await this.getLedgers()
  },

  methods: {
    async getLedgers() {
      this.ledgersLoading = true
      let result = await this.$axios.$get('ledger.php', {
        params: {
          token: this.$store.state.jwtToken,
          fn: 'All'
        }
      })
      if(result.message === 'Success') {
        this.ledgers = JSON.parse(JSON.stringify(result.ledger))
      }
      this.ledgersLoading = false
    },

    showInsertDialog() {
      this.ledgerData = {
        token: this.$store.state.jwtToken,
        ledgerYear: this.ledgerYear,
        ledgerEnable: 1
      }
      this.insertDialog = true
    },

    async insertLedger(res) {
      if(res.status) {
        await this.getLedgers()
        this.$emit('getledgerStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(ledger) {
      this.ledgerData = ledger
      this.ledgerData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updateLedger(res) {
      if(res.status) {
        await this.getLedgers()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(ledger) {
      this.ledgerData = ledger
      this.ledgerData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteLedger(res) {
      if(res.status) {
        await this.getLedgers()
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },
  },

watch: {
  async ledgerYear() {
    await this.getLedgers()
  },

  async personalIDcard() {
    await this.getLedgers()
  }
}
}
</script>
