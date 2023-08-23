<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ใบโอนจัดสรรงบประมาณ ประจำปีงบประมาณ พ.ศ.{{ parseInt(this.budgetslipYear)+543 }}</b>
          </v-card-title>
          <!-- <v-card-subtitle class="ptcBg white--text" v-if="budgetplanID">
            <b>หมวดงบประมาณรายรับ : {{ budgetplan.budgetFullname }}</b>
          </v-card-subtitle> -->
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
              <template v-slot:item.index="{ item }">
                <div class="text-no-wrap">{{  budgetslip.indexOf(item)+1 }}</div>
              </template>
              <template v-slot:item.budgetslipNo="{ item }">
                <div class="text-no-wrap">{{ item.budgetslipNo }}</div>
              </template>
              <template v-slot:item.budgetplanDes="{ item }">
                <div class="py-2">
                  <!-- <div class="body-2">{{ item.budgettypeName }} : {{ item.budgetName }}</div> -->
                  <div>{{ item.budgetplanDes }}</div>
                </div>
              </template>
              <template v-slot:item.budgetslipMoney="{ item }">
                <div class="text-no-wrap">{{ moneyFormat(item.budgetslipMoney) }}</div>
              </template>
              <template v-slot:item.budgetslipDate="{ item }">
                <div class="text-no-wrap">{{ thaiDate(item.budgetslipDate) }}</div>
              </template>
              <template v-slot:item.budgetslipNo="{ item }">
                <div>
                  <v-btn small color="primary" rounded outlined :href="item.budgetslipFile" target="_blank" v-if="item.budgetslipFile">
                    <v-icon small class="mr-1">fas fa-file-lines</v-icon> {{ item.budgetslipNo }}
                  </v-btn>
                </div>
              </template>
            </v-data-table>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

  </div>
</template>

<script>
import numeral from 'numeral'
export default {
  components: {
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
        // {
        //   text: 'เลขที่ใบโอน',
        //   align: 'center',
        //   sortable: false,
        //   value: 'budgetslipNo',
        // },
        { text: '#', value: 'index', align: 'center', class: 'text-center' },
        { text: 'รายการงบประมาณ', value: 'budgetplanDes', align: 'left', class: 'text-center' },
        { text: 'หมวดงบประมาณ', value: 'budgettypeName', align: 'left', class: 'text-center' },
        { text: '', value: 'budgetName', align: 'left', class: 'text-center' },
        { text: 'จำนวน (บาท)', value: 'budgetslipMoney', align: 'right', class: 'text-center' },
        { text: 'วันที่', value: 'budgetslipDate', align: 'center', class: 'text-center' },
        // { text: '', value: 'actions', align: 'center' },
        {
          text: 'เลขที่ใบโอน',
          align: 'center',
          sortable: false,
          value: 'budgetslipNo',
        },
      ],
      search: '',
      budgetplan: {},
      budgetslipLoading: true,
      budgetslipOrg: [],
      budgetslip: [],
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
        }
      })

      if(result.message === 'Success') {
        this.budgetslipOrg = JSON.parse(JSON.stringify(result.budgetslip))
        this.budgetslip = this.budgetslipOrg.filter(budgetslip => budgetslip.budgettypePublic == 1)
      }
      this.budgetslipLoading = false
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
