<template>
  <div>
      <v-row dense>
        <v-col cols="12" md="4" v-for="orgstrategic in orgstrategics" :key="orgstrategic.key">
          <h6><b>ยุทธศาสตร์ที่ {{ orgstrategic.orgstrategicNum }}</b> {{ orgstrategic.orgstrategicName }}</h6>
        </v-col>
      </v-row>
      <apexchart type="radar" height="450" :options="chartOptions" :series="series" class="mt-2" v-if="showChart"></apexchart>
  </div>
</template>
<script>
import numeral from 'numeral'
export default {
  props: {
    periodYear: {
      type: Number,
      default: null
    }
  },

  data() {
    return {
      orgstrategics: [],
      showChart: false,
      series: [{
          name: 'โครงการทั้งหมด',
          data: [],
        }, {
          name: 'โครงการที่ดำเนินการ',
          data: [],
        }],
      chartOptions: {
        chart: {
          type: 'radar',
        },
        dataLabels: {
          enabled: true
        },
        plotOptions: {
          radar: {
            size: 160,
            polygons: {
              // strokeColors: '#e9e9e9',
              fill: {
                colors: ['#f8f8f8', '#fff']
              }
            }
          }
        },
        title: {
          text: 'การดำเนินโครงการแยกตามยุทธศาสตร์',
          align: 'center',
        },
        colors: ['#B71C1C', '#00695C'],
        markers: {
          size: 4,
          colors: ['#fff'],
          strokeColor: '#FF4560',
          strokeWidth: 2,
        },
        tooltip: {
          y: {
            formatter: function(val) {
              return val + ' โครงการ'
            }
          }
        },
        xaxis: {
          categories: [],
        },
        yaxis: {
          tickAmount: 7,
          labels: {
            formatter: function(val, i) {
              if (i % 2 === 0) {
                return numeral(Math.floor(val)).format('0,0.00')
              } else {
                return ''
              }
            }
          }
        }
      },
    }
  },

  async mounted() {
    await this.getOrgstrategic()
  },

  methods: {
    async getOrgstrategic() {
      let params = {
        token: this.$store.state.jwtToken,
        orgstrategicYear: this.periodYear,
        fn: 'SummaryProgress'
      }
      let result = await this.$axios.$get('orgstrategic.php', {params})
      if(result.message=="Success") {
        this.orgstrategics = JSON.parse(JSON.stringify(result.orgstrategic))
        let osm = this.orgstrategics.map( orgstrategic => {
          this.chartOptions.xaxis.categories.push('ยุทธศาสตร์ที่ '+orgstrategic.orgstrategicNum)
          let projectQty = parseInt(orgstrategic.projectQty) || 0
          let doProgress = parseInt(orgstrategic.doProgress) || 0
          let doneProgress = parseInt(orgstrategic.doneProgress) || 0
          this.series[0].data.push(projectQty)
          this.series[1].data.push(doProgress+doneProgress)
        })
        Promise.all(osm)
        this.showChart = true
      }
    },
  },

  watch: {
    async periodYear() {
      this.orgstrategics = []
      this.series = [{
        name: 'โครงการทั้งหมด',
        data: [],
      }, {
        name: 'โครงการที่ดำเนินการ',
        data: [],
      }]
      await this.getOrgstrategic()
    }
  }
}
</script>
