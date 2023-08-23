<template>
  <div>
      <v-row v-if="showChart">
        <v-col cols="12">
          <apexchart type="bar" height="400" :options="chartOptionsAll" :series="seriesAll" class="mt-2"></apexchart>
        </v-col>
        <!-- <v-col cols="12" md="4" v-for="orgstrategic in orgstrategics" :key="orgstrategic.key">
          <apexchart type="donut" height="400" :options="chartOptions[parseInt(orgstrategic.orgstrategicID)]" :series="series[parseInt(orgstrategic.orgstrategicID)]" class="mt-2"></apexchart>
        </v-col> -->
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
    departmentID: {
      type: String,
      default: null
    },
    expenseplanDes: {
      type: String,
      default: null
    }
  },

  data() {
    return {
      disburses: [],
      showChart: false,
      seriesAll: [],
      chartOptionsAll: {
        chart: {
          toolbar: {
            show: true
          }
        },
        title: {
          text: 'การจัดซื้อวัสดุการศึกษาประจำปี',
          align: 'center'
        },
        dataLabels: {
          enabled: true,
          offsetY: 8,
          dropShadow: {
            enabled: false,
            top: 1,
            left: 1,
            blur: 1,
            color: '#fff',
            opacity: 0.45
          },
          style: {
            fontWeight: 'bold',
            colors: ['#000']
          },
          formatter: function (val) {
            return numeral(val).format('0,0')
          }
        },
        stroke: {
          show: true,
          width: 2,
          colors: ['transparent']
        },
        fill: {
          opacity: 0.8
        },
        xaxis: {
          categories: [],
        },
        yaxis: {
          labels: {
            formatter: function (val) {
              return numeral(val).format('0,0')
            }
          }
        },
        plotOptions: {
          bar: {
            columnWidth: '60%',
            dataLabels: {
              position: 'bottom',
              orientation: 'vertical',
            },
          }
        },
        tooltip: {
          y: {
            formatter: function (val) {
              return numeral(val).format('0,0')+' บาท'
            }
          }
        },
        responsive: [{
            breakpoint: 1000,
            options: {
              dataLabels: {
                offsetY: 0,
                offsetX: 2,
              },
              plotOptions: {
                bar: {
                  horizontal: true,
                  dataLabels: {
                    orientation: 'horizontal',
                  },
                }
              },
              yaxis: {
                labels: {
                  show: true,
                  maxWidth: 80,
                }
              },
              xaxis: {
                labels: {
                  show: false
                }
              },
            },
        }],
      },
    }
  },

  async mounted() {
    await this.getDisburse()
  },

  methods: {
    async getDisburse() {
      this.chartOptionsAll.title.text = 'การจัดซื้อ'+this.expenseplanDes+' ประจำปีงบประมาณ พ.ศ.'+(parseInt(this.periodYear)+543)
      let params = {
        token: this.$store.state.jwtToken,
        disburseYear: this.periodYear,
        expenseplanDes: 'วัสดุการศึกษา',
        fn: 'getSummaryByExpenseplanDepartmentYear'
      }
      let result = await this.$axios.$get('disburse.php', {params})

      if(result.message=="Success") {
        this.disburses = JSON.parse(JSON.stringify(result.disburse))
        let outdata = {
          name: 'จัดซื้อ',
          color: '#EF9A9A',
          data: []
        }
        let categories = []
        if(this.disburses) {
          let osm = this.disburses.map( disburse => {
            let disburseMoney = parseFloat(disburse.disburseMoney) || 0
            categories.push(disburse.departmentName)
            outdata.data.push(disburseMoney)
          })
          await Promise.all(osm)
          this.chartOptionsAll.xaxis.categories = categories
          this.seriesAll = [outdata]
        }
        this.showChart = true
      }
    },
  },

  watch: {
    async periodYear() {
      await this.getDisburse()
    }
  }
}
</script>
