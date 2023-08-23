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
    budgettypeID: {
      type: String,
      default: null
    },
    budgettypeName: {
      type: String,
      default: null
    }
  },

  data() {
    return {
      budgets: [],
      showChart: false,
      seriesAll: [],
      chartOptionsAll: {
        chart: {
          toolbar: {
            show: true
          },
        },
        title: {
          text: 'การเบิกจ่ายงบประมาณประจำปี',
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
    await this.getBudgettype()
  },

  methods: {
    async getBudgettype() {
      this.chartOptionsAll.title.text = 'การเบิกจ่ายงบประมาณประจำปีงบประมาณ พ.ศ.'+(parseInt(this.periodYear)+543)+' ('+this.budgettypeName+')'
      let params = {
        token: this.$store.state.jwtToken,
        budgettypeID: this.budgettypeID,
        budgetslipYear: this.periodYear,
        fn: 'getSlipDisburse'
      }
      let result = await this.$axios.$get('budget.php', {params})

      if(result.message=="Success") {
        this.budgets = JSON.parse(JSON.stringify(result.budget))
        let indata = {
          name: 'ได้รับจัดสรร',
          color: '#B0BEC5',
          group: 'budget',
          data: []
        }
        let betweendata = {
          name: 'อยู่ระหว่างจัดซื้อ',
          color: '#9FA8DA',
          group: 'expand',
          data: []
        }
        let outdata = {
          name: 'เบิกจ่าย',
          color: '#80CBC4',
          group: 'expand',
          data: []
        }
        let categories = []
        let osm = this.budgets.map( budget => {
          let budgetin = parseFloat(budget.budgetslipMoney) || 0
          let budgetbetween = parseFloat(budget.disbursePlanMoney) || 0
          let budgetout = parseFloat(budget.disburseCompleteMoney) || 0
          categories.push(budget.budgetplanDes)
          indata.data.push(budgetin)
          betweendata.data.push(budgetbetween)
          outdata.data.push(budgetout)
          // data.push(
          //   {
          //     x: budget.budgetName,
          //     y: budgetout,
          //     goals: [
          //       {
          //         name: 'ได้รับจัดสรร',
          //         value: budgetin,
          //         strokeHeight: 5,
          //         strokeColor: '#2E7D32'
          //       }
          //     ]
          //   }
          // )
        })
        await Promise.all(osm)
        this.chartOptionsAll.xaxis.categories = categories
        this.seriesAll = [indata, betweendata, outdata]
        this.showChart = true
      }
    },
  },

  watch: {
    async periodYear() {
      await this.getBudgettype()
    }
  }
}
</script>
