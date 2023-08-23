<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ปีงบประมาณ</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="periods"
              :search="search"
              :items-per-page="-1"
              :loading="periodsLoading"
              hide-default-footer
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <!-- <v-select
                      v-model="periodID"
                      label="ยุทธศาสตร์"
                      :items="periods"
                      item-text="periodFullname"
                      item-value="periodID"
                      outlined
                      @change="filterProjects"
                    ></v-select> -->
                    <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || userType=='Plan'">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มปีงบประมาณ
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

              <template v-slot:item.periodID="{ item }">
                <div  class="text-no-wrap">{{ periods.indexOf(item)+1 }}</div>
              </template>
              <template v-slot:item.periodBegin="{ item }">
                {{ thaiDate(item.periodBegin) }}
              </template>
              <template v-slot:item.periodEnd="{ item }">
                {{ thaiDate(item.periodEnd) }}
              </template>
              <template v-slot:item.periodProject="{ item }">
                <v-chip small color="info">
                  {{ thaiDate(item.periodProjectStart) }} - {{ thaiDate(item.periodProjectEnd) }}
                </v-chip>
              </template>
              <template v-slot:item.periodEnable="{ item }">
                <v-chip color="success" v-if="item.periodEnable==1">
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
                <PeriodInsert :period="periodData" @getInsertStatus="insertPeriod"/>
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
                <PeriodUpdate :period="periodData" @getUpdateStatus="updatePeriod"/>
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
                <PeriodDelete :period="periodData" @getDeleteStatus="deletePeriod"/>
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
    // periods: {
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
    periodYear: {
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
          value: 'periodID',
        },
        { text: 'ปีงบประมาณ', value: 'periodYearBd', align: 'center' },
        { text: 'วันเริ่มปีงบประมาณ', value: 'periodBegin', align: 'left', class: 'text-center' },
        { text: 'วันสิ้นสุดปีงบประมาณ', value: 'periodEnd', align: 'center', class: 'text-center' },
        { text: 'ระยะเวลาเสนอโครงการ', value: 'periodProject', align: 'center', class: 'text-center' },
        { text: 'สถานะ', value: 'periodEnable', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      periodsLoading: true,
      periods: [],
      periodData: {},
      insertDialog: false,
      insertProgress: false,
      periodInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      periodUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      periodDeleteValidate: null,
    }
  },

  async mounted() {
    await this.getPeriods()
  },

  methods: {
    async getPeriods() {
      this.periodsLoading = true
      let result = await this.$axios.$get('period.php', {
        params: {
          token: this.$store.state.jwtToken,
          fn: 'All'
        }
      })

      if(result.message === 'Success') {
        this.periods = JSON.parse(JSON.stringify(result.period))
      }
      this.periodsLoading = false
    },

    showInsertDialog() {
      this.periodData = {
        token: this.$store.state.jwtToken,
        periodYear: this.periodYear,
        periodEnable: 1
      }
      this.insertDialog = true
    },

    async insertPeriod(res) {
      if(res.status) {
        await this.getPeriods()
        this.$emit('getperiodStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(period) {
      this.periodData = period
      this.periodData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updatePeriod(res) {
      if(res.status) {
        await this.getPeriods()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(period) {
      this.periodData = period
      this.periodData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deletePeriod(res) {
      if(res.status) {
        await this.getPeriods()
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },

    thaiDate(inDate) {
      let result = ''
      if(inDate) {
        let thdate = new Date(inDate)
        result = thdate.toLocaleDateString('th-TH', {
          year: 'numeric',
          month: 'long',
          day: 'numeric',
        })
      }
      return result
    }
  },

watch: {
  async periodYear() {
    await this.getPeriods()
  },

  async personalIDcard() {
    await this.getPeriods()
  }
}
}
</script>
