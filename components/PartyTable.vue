<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ฝ่ายงาน</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="parties"
              :search="search"
              :items-per-page="-1"
              :loading="partiesLoading"
              hide-default-footer
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || userType=='Plan'">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มฝ่าย
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

              <template v-slot:item.partyID="{ item }">
                <div  class="text-no-wrap">DPM-{{ parseInt(item.partyID) }}</div>
              </template>
              <template v-slot:item.partyEnable="{ item }">
                <v-chip color="success" v-if="item.partyEnable==1">
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
                <PartyInsert :party="partyData" @getInsertStatus="insertParty"/>
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
                <PartyUpdate :party="partyData" @getUpdateStatus="updateParty"/>
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
                <PartyDelete :party="partyData" @getDeleteStatus="deleteParty"/>
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
    partyYear: {
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
          value: 'partyID',
        },
        { text: 'ชื่อฝ่าย', value: 'partyName', align: 'left', class: 'text-center' },
        { text: 'หัวหน้าฝ่าย', value: 'partyHeadFullname', align: 'left', class: 'text-left' },
        { text: 'รักษาการหัวหน้าฝ่าย', value: 'partyReheadFullname', align: 'left', class: 'text-left' },
        { text: 'สถานะ', value: 'partyEnable', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      partiesLoading: true,
      parties: [],
      partyData: {},
      insertDialog: false,
      insertProgress: false,
      partyInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      partyUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      partyDeleteValidate: null,
    }
  },

  async mounted() {
    await this.getParties()
  },

  methods: {
    async getParties() {
      this.partiesLoading = true
      let result = await this.$axios.$get('party.php', {
        params: {
          token: this.$store.state.jwtToken
        }
      })

      if(result.message === 'Success') {
        this.parties = JSON.parse(JSON.stringify(result.party))
      }
      this.partiesLoading = false
    },

    showInsertDialog() {
      this.partyData = {
        token: this.$store.state.jwtToken,
        partyYear: this.partyYear,
        partyEnable: 1
      }
      this.insertDialog = true
    },

    async insertParty(res) {
      if(res.status) {
        await this.getParties()
        this.$emit('getpartyStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(party) {
      this.partyData = party
      this.partyData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updateParty(res) {
      if(res.status) {
        await this.getParties()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(party) {
      this.partyData = party
      this.partyData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteParty(res) {
      if(res.status) {
        await this.getParties()
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },
  },

watch: {
  async partyYear() {
    await this.getParties()
  },

  async personalIDcard() {
    await this.getParties()
  }
}
}
</script>
