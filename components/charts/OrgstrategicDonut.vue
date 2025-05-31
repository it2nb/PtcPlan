<template>
  <div>
      <v-row v-if="showChart">
        <!-- <v-col cols="12" md="4" class="mx-auto">
          <v-select
            v-model="subperiod"
            :items="subperiods"
            label="ไตรมาตรที่"
            outlined
            hide-details
            dense
          ></v-select>
        </v-col> -->
        <v-col cols="12">
          <apexchart type="donut" height="400" :options="chartOptionsAll" :series="seriesAll" class="mt-2"></apexchart>
        </v-col>
        <v-col cols="12" md="3" v-for="orgstrategic in orgstrategics" :key="orgstrategic.key">
          <apexchart type="donut" height="400" :options="chartOptions[parseInt(orgstrategic.orgstrategicID)]" :series="series[parseInt(orgstrategic.orgstrategicID)]" class="mt-2"></apexchart>
        </v-col>
      </v-row>
  </div>
</template>
<script>
var numeral = require('numeral')
export default {
  props: {
    periodYear: {
      type: Number,
      default: null
    },
    periodSec: {
      type: Number,
      default: null
    }
  },

  data() {
    return {
      orgstrategics: [],
      showChart: false,
      seriesAll: [],
      subperiod: null,
      subperiods: [
        {
          value: 1,
          text: 'ไตรมาตร 1',
          startDate: (parseInt(this.periodYear)-1)+'-10-01',
          endDate: (parseInt(this.periodYear)-1)+'-12-31'
        },
        {
          value: 2,
          text: 'ไตรมาตร 2',
          startDate: this.periodYear+'-01-01',
          endDate: this.periodYear+'-03-31'
        },
        {
          value: 3,
          text: 'ไตรมาตร 3',
          startDate: this.periodYear+'-04-01',
          endDate: this.periodYear+'-06-30'
        },{
          value: 4,
          text: 'ไตรมาตร 4',
          startDate: this.periodYear+'-07-01',
          endDate: this.periodYear+'-09-30'
        }
      ],
      chartOptionsAll: {
        chart: {
          toolbar: {
            show: true
          }
        },
        title: {
          text: 'รวมทุกยุทธศาสตร์',
          align: 'center'
        },
        labels: ['ยังไม่ได้ดำเนินการ', 'อยู่ระหว่างดำเนินการ', 'ดำเนินการเสร็จสิ้น'],
        colors: ['#EF9A9A', '#FBC02D', '#00695C'],
        legend: {
          position: 'bottom'
        },
        plotOptions: {
          pie: {
            donut: {
              size: '60%',
              labels: {
                show: true,
                value: {
                  show: true,
                  fontSize: '14',
                  formatter: function (val) {
                    return numeral(val).format('0,0')+' โครงการ'
                  }
                },
                total: {
                  show: true,
                  showAlways: true,
                  label: 'โครงการทั้งหมด'
                }
              }
            }
          }
        },
        tooltip: {
          y: {
            formatter: function (val) {
              return val+' โครงการ'
            }
          }
        },
      },
      series: [],
      chartOptions: [],
    }
  },

  async mounted() {
    if(this.periodSec>=1 && this.periodSec<=4) {
      this.subperiod = parseInt(this.periodSec)
    } else {
      let period = this.subperiods.filter(period => new Date().getTime()>=new Date(period.startDate+' 00:00:01').getTime())
      if(period.length>0) {
        this.subperiod = period.length
      }
    }
    await this.getOrgstrategic()
  },

  methods: {
    async getOrgstrategic() {
      let period = this.subperiods.filter(period => period.value==this.subperiod)
      let params = {
        token: this.$store.state.jwtToken,
        orgstrategicYear: this.periodYear,
        orgstrategicStart: (parseInt(this.periodYear)-1)+'-10-01',
        orgstrategicEnd: period[0]?.endDate,
        fn: 'SummaryProgress'
      }
      let result = await this.$axios.$get('orgstrategic.php', {params})

      if(result.message=="Success") {
        if(result.orgstrategic.length > 0) {
          this.orgstrategics = JSON.parse(JSON.stringify(result.orgstrategic))
          let noProgressAll = 0
          let doProgressAll = 0
          let doneProgressAll = 0
          let osm = this.orgstrategics.map( orgstrategic => {
            let noProgress = parseInt(orgstrategic.noProgress) || 0
            let doProgress = parseInt(orgstrategic.doProgress) || 0
            let doneProgress = parseInt(orgstrategic.doneProgress) || 0
            this.series[parseInt(orgstrategic.orgstrategicID)] = [noProgress, doProgress, doneProgress]
            noProgressAll += noProgress
            doProgressAll += doProgress
            doneProgressAll += doneProgress

            this.chartOptions[parseInt(orgstrategic.orgstrategicID)] = {
              chart: {
                toolbar: {
                  show: true
                }
              },
              title: {
                text: 'ยุทธศาสตร์ที่ '+orgstrategic.orgstrategicNum,
                align: 'center'
              },
              labels: ['ยังไม่ได้ดำเนินการ', 'อยู่ระหว่างดำเนินการ', 'ดำเนินการเสร็จสิ้น'],
              colors: ['#EF9A9A', '#FBC02D', '#00695C'],
              legend: {
                position: 'bottom'
              },
              plotOptions: {
                pie: {
                  donut: {
                    size: '60%',
                    labels: {
                      show: true,
                      value: {
                        show: true,
                        fontSize: '14',
                        formatter: function (val) {
                          return numeral(val).format('0,0')+' โครงการ'
                        }
                      },
                      total: {
                        show: true,
                        showAlways: true,
                        label: 'โครงการทั้งหมด'
                      }
                    }
                  }
                }
              },
              tooltip: {
                y: {
                  formatter: function (val) {
                    return val+' โครงการ'
                  }
                }
              },
            }
          })
          await Promise.all(osm)
          this.seriesAll = [noProgressAll, doProgressAll, doneProgressAll]
          this.showChart = true
        }
      }
    },
  },

  watch: {
    async periodYear() {
      this.showChart = false
      this.subperiods = [
        {
          value: 1,
          text: 'ไตรมาตร 1',
          startDate: (parseInt(this.periodYear)-1)+'-10-01',
          endDate: (parseInt(this.periodYear)-1)+'-12-31'
        },
        {
          value: 2,
          text: 'ไตรมาตร 2',
          startDate: this.periodYear+'-01-01',
          endDate: this.periodYear+'-03-31'
        },
        {
          value: 3,
          text: 'ไตรมาตร 3',
          startDate: this.periodYear+'-04-01',
          endDate: this.periodYear+'-06-30'
        },{
          value: 4,
          text: 'ไตรมาตร 4',
          startDate: this.periodYear+'-07-01',
          endDate: this.periodYear+'-09-30'
        }
      ]
      let period = this.subperiods.filter(period => new Date().getTime()>=new Date(period.startDate+' 00:00:01').getTime())
      if(period.length>0) {
        this.subperiod = period.length
      } else {
        this.subperiod = 1
      }
      await this.getOrgstrategic()
    },
    async subperiod() {
      this.showChart = false
      await this.getOrgstrategic()
    },
  }
}
</script>
