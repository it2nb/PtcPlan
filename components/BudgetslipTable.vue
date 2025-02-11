<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ใบโอนจัดสรรงบประมาณ ประจำปีงบประมาณ พ.ศ.{{ parseInt(this.budgetslipYear)+543 }}</b>
          </v-card-title>
          <v-card-subtitle class="ptcBg white--text" v-if="budgetplanID">
            <b>หมวดงบประมาณรายรับ : {{ budgetplan.budgetFullname }}</b>
          </v-card-subtitle>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="budgetslip"
              :search="search"
              :items-per-page="-1"
              :loading="budgetslipLoading"
              hide-default-footer
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <!-- <v-select
                      v-model="budgetslipID"
                      label="งบประมาณที่ได้รับจัดสรร"
                      :items="budgetslip"
                      item-text="budgetslipFullname"
                      item-value="budgetslipID"
                      outlined
                      @change="filterProjects"
                    ></v-select> -->
                    <v-btn color="success" text @click="showInsertDialog" v-if="insertBt || userType=='Admin' || userType=='Plan' || userType=='Finance'">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มงบประมาณที่ได้รับจัดสรร
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

              <!-- <template v-slot:item.budgetslipID="{ item }">
                <div  class="text-no-wrap">OSC-{{ parseInt(item.budgetslipID) }}</div>
              </template> -->
              <template v-slot:item.budgetslipNo="{ item }">
                <div class="text-no-wrap">{{ item.budgetslipNo }}</div>
              </template>
              <template v-slot:item.budgetplanDes="{ item }">
                <div class="py-2">
                  <div class="body-2">{{ item.budgettypeName }} : {{ item.budgetName }}</div>
                  <div>{{ item.budgetplanDes }}</div>
                </div>
              </template>
              <template v-slot:item.budgetslipMoney="{ item }">
                <div class="text-no-wrap">{{ moneyFormat(item.budgetslipMoney) }}</div>
              </template>
              <template v-slot:item.budgetslipDate="{ item }">
                <div class="text-no-wrap">{{ thaiDate(item.budgetslipDate) }}</div>
              </template>
              <template v-slot:item.actions="{ item }">
                <div  class="text-no-wrap">
                  <v-btn icon small color="primary" :href="item.budgetslipFile" target="_blank" v-if="item.budgetslipFile">
                    <v-icon small>fas fa-file-lines</v-icon>
                  </v-btn>
                  <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="updateBt || userType=='Admin' || userType=='Plan' || userType=='Finance'">
                    <v-icon small class="mr-1">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="deleteBt || userType=='Admin' || userType=='Plan' || userType=='Finance'">
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
                <BudgetslipInsertVue :budgetslip="budgetslipData" @getInsertStatus="insertBudgetslip"/>
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
                <BudgetslipUpdateVue :budgetslip="budgetslipData" @getUpdateStatus="updateBudgetslip"/>
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
                <BudgetslipDeleteVue :budgetslip="budgetslipData" @getDeleteStatus="deleteBudgetslip"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
import BudgetslipInsertVue from './BudgetslipInsert'
import BudgetslipUpdateVue from './BudgetslipUpdate.vue'
import BudgetslipDeleteVue from './BudgetslipDelete.vue'
import numeral from 'numeral'
export default {
  components: {
    BudgetslipInsertVue,
    BudgetslipUpdateVue,
    BudgetslipDeleteVue,
  },

  props: {
    // budgetslip: {
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
    budgetslipYear: {
      type: String,
      default: null
    },
    budgetplanID: {
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
          text: 'เลขที่ใบโอน',
          align: 'center',
          sortable: false,
          value: 'budgetslipNo',
        },
        { text: 'หมวดงบประมาณรายรับ', value: 'budgetplanDes', align: 'left', class: 'text-center' },
        { text: 'จำนวนเงิน', value: 'budgetslipMoney', align: 'right', class: 'text-center' },
        { text: 'วันที่', value: 'budgetslipDate', align: 'center', class: 'text-center' },
        { text: 'หมายเหตุ', value: 'budgetslipDetail', align: 'left', class: 'text-center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      budgetplan: {},
      budgetslipLoading: true,
      budgetslip: [],
      budgetslipData: {},
      insertDialog: false,
      insertProgress: false,
      budgetslipInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      budgetslipUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      budgetslipDeleteValidate: null,
    }
  },

  async mounted() {
    if(this.budgetplanID) {
      await this.getBudgetplan()
    }
    await this.getBudgetslips()
  },

  methods: {
    async getBudgetplan() {
      let result = await this.$axios.$get('budgetplan.php', {
        params: {
          token: this.$store.state.jwtToken,
          budgetplanID: this.budgetplanID
        }
      })

      if(result.message === 'Success') {
        this.budgetplan = JSON.parse(JSON.stringify(result.budgetplan))
      }
    },

    async getBudgetslips() {
      this.budgetslipLoading = true
      let result = await this.$axios.$get('budgetslip.php', {
        params: {
          token: this.$store.state.jwtToken,
          budgetslipYear: this.budgetslipYear,
          budgetplanID: this.budgetplanID,
        }
      })

      if(result.message === 'Success') {
        this.budgetslip = JSON.parse(JSON.stringify(result.budgetslip))
        this.budgetslip = this.budgetslip.filter(budgetslip => budgetslip.budgettypePublic == 1)
      }
      this.budgetslipLoading = false
    },

    showInsertDialog() {
      this.budgetslipData = {
        token: this.$store.state.jwtToken,
        budgetslipYear: this.budgetslipYear,
        budgetplanID: this.budgetplanID
      }
      this.insertDialog = true
    },

    async insertBudgetslip(res) {
      if(res.status) {
        await this.getBudgetslips()
        this.$emit('getTableStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(budgetslip) {
      this.budgetslipData = budgetslip
      this.budgetslipData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updateBudgetslip(res) {
      if(res.status) {
        await this.getBudgetslips()
        this.$emit('getTableStatus', {'status': true})
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(budgetslip) {
      this.budgetslipData = budgetslip
      this.budgetslipData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteBudgetslip(res) {
      if(res.status) {
        await this.getBudgetslips()
        this.$emit('getTableStatus', {'status': true})
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    },

    thaiDate(inDate) {
      let result = ''
      if(inDate) {
        let thdate = new Date(inDate)
        result = thdate.toLocaleDateString('th-TH', {
          year: 'numeric',
          month: 'short',
          day: 'numeric',
        })
      }
      return result
    }
  },

watch: {
  async budgetslipYear() {
    if(this.budgetplanID) {
      await this.getBudgetplan()
    }
    await this.getBudgetslips()
  },

  async budgetplanID() {
    if(this.budgetplanID) {
      await this.getBudgetplan()
    }
    await this.getBudgetslips()
  }
}
}
</script>
