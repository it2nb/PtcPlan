<template>
    <div>
      <div class="printPage">
        <div class="mb-2 font16 text-right">{{ project.projectCode }}</div>
        <div class="font18 text-center"><span class="font18 fontBold">ชื่อโครงการ: </span>{{ project.projectName }}</div>
        <div class="font16 text-center"><span class="font16 fontBold">ผู้รับผิดชอบโครงการ: </span> {{ project.departmentName }} ({{project.departmentSignName}})</div>
        <div class="font16 text-center"><span class="font16 fontBold">ระยะเวลาดำเนินการ: </span>ปีงบประมาณ พ.ศ. {{ parseInt(project.projectYear)+543 }} ({{ thaiDate(projectPeriod.pjsubactivityStart) }} - {{ thaiDate(projectPeriod.pjsubactivityEnd) }})</div>
        <div class="mt-5 font16 fontBold">1. ความสอดคล้องกับนโยบาย</div>
        <div>
          <div class="pa-1 font16 fontBold grey lighten-3">
            ยุทธศาสตร์สถานศึกษา
          </div>
          <div class="ml-3" v-for="orgstrategic in orgstrategics" :key="orgstrategic.key">
            <div class="font16">
              <v-icon small class="mr-1" color="black" v-if="orgstrategic.orgstrategicID==project.orgstrategicID">far fa-check-square</v-icon>
              <v-icon small class="mr-1" color="black" v-else>far fa-square</v-icon>
              ยุทธศาสตร์ที่ {{ orgstrategic.orgstrategicNum }} {{ orgstrategic.orgstrategicName }}
            </div>
          </div>
        </div>
        <div v-for="pjpolicy in pjpolicies" :key="pjpolicy.key">
          <div class="pa-1 font16 fontBold grey lighten-3" v-if="pjpolicy.strategic.length <= 0">
            <v-icon small class="mr-1" color="black" v-if="pjpolicy.policyChk=='1'">far fa-check-square</v-icon>
            <v-icon small class="mr-1" color="black" v-else>far fa-square</v-icon>
            {{ pjpolicy.policyName }}
          </div>
          <div class="pa-1 font16 fontBold grey lighten-3" v-else>
            {{ pjpolicy.policyName }}
          </div>
          <div class="ml-3" v-for="strategic in pjpolicy.strategic" :key="strategic.key">
            <div class="font16" v-if="strategic.strategy.length <= 0">
              <v-icon small class="mr-1" color="black" v-if="strategic.strategicChk=='1'">far fa-check-square</v-icon>
              <v-icon small class="mr-1" color="black" v-else>far fa-square</v-icon>
              {{ strategic.strategicName }}
            </div>
            <div class="font16" v-else>
              {{ strategic.strategicName }}
            </div>
            <div class="ml-3 font16" v-for="strategy in strategic.strategy" :key="strategy.key">
              <v-icon small class="mr-1" color="black" v-if="strategy.strategyChk=='1'">far fa-check-square</v-icon>
              <v-icon small class="mr-1" color="black" v-else>far fa-square</v-icon>
              {{ strategy.strategyName }}
            </div>
          </div>
        </div>
        <div class="mt-2 font16 fontBold">2. หลักการและเหตุผล</div>
        <pre class="ml-4 font16">{{ project.projectPrinciple }}</pre>
        <div class="mt-2 font16 fontBold">3. วัตถุประสงค์ของโครงการ</div>
        <pre class="ml-4 font16">{{ project.projectObjective }}</pre>
        <div class="mt-2 font16 fontBold">4. เป้าหมาย</div>
        <div class="ml-4">
          <div>
            <u class="font16">เชิงปริมาณ</u>
            <pre class="font16">{{ project.projectQuantityGoal }}</pre>
          </div>
          <div>
            <u class="font16">เชิงคุณภาพ</u>
            <pre class="font16">{{ project.projectQualityGoal }}</pre>
          </div>
        </div>
        <div class="mt-2 font16 fontBold">5. กิจกรรม/วิธีดำเนินงาน พร้อมแสดงผังขั้นตอนการดำเนินงาน(PDCA)</div>
        <div>
          <table width="100%" style="border: solid 1px black; border-spacing: 0;">
            <thead>
              <tr>
                <th width="40%" rowspan="2" class="font16 fontBold" style="border: solid 1px black; padding: 3px">กิจกรรมหลัก/กิจกรรมย่อย</th>
                <th colspan="3" class="font16 fontBold" style="border: solid 1px black; padding: 3px">{{ parseInt(project.projectYear)+542 }}</th>
                <th colspan="9" class="font16 fontBold" style="border: solid 1px black; padding: 3px">{{ parseInt(project.projectYear)+543 }}</th>
              </tr>
              <tr>
                <th width="5%" class="font16 fontBold" style="border: solid 1px black; padding: 3px" v-for="n in 12" :key="n">{{ months_th_short[(n+9)%12] }}</th>
              </tr>
            </thead>
            <tbody>
              <template v-for="pjactivity in pjactivities">
                <tr :key="pjactivity.key">
                  <td class="font16 fontBold" style="border: solid 1px black; padding: 3px">
                    กิจกรรมหลักที่ {{ pjactivity.pjactivityNum }} {{ pjactivity.pjactivityName }}
                  </td>
                  <td class="font16" style="border: solid 1px black; padding: 3px" v-for="n in 12" :key="n"></td>
                </tr>
                <template v-for="pjsubactivity in pjactivity.pjsubactivity">
                  <tr :key="pjsubactivity.key">
                    <td class="pl-3 font16" style="border: solid 1px black; padding: 3px">
                      กิจกรรมย่อยที่  {{ pjactivity.pjactivityNum }}.{{ pjsubactivity.pjsubactivityNum }} {{ pjsubactivity.pjsubactivityName }}
                    </td>
                    <td class="font16 text-center" style="border: solid 1px black; padding: 3px" v-for="n in 12" :key="n">
                      <v-icon small v-if="checkActPeriod((n+9)%12, pjsubactivity.pjsubactivityStart, pjsubactivity.pjsubactivityEnd)">fas fa-check</v-icon>
                    </td>
                  </tr>
                </template>
              </template>
  
            </tbody>
          </table>
        </div>
        <div class="mt-2 font16 fontBold">6. งบประมาณในการดำเนินโครงการ</div>
        <div>
          <table width="100%" style="border: solid 1px black; border-spacing: 0;">
            <thead>
              <tr>
                <th width="40%" rowspan="2" class="font16 fontBold" style="border: solid 1px black; padding: 3px">รายการ</th>
                <th :colspan="budgets.length" class="font16 fontBold" style="border: solid 1px black; padding: 3px">จำนวนเงิน</th>
                <th width="10%" rowspan="2" class="font16 fontBold" style="border: solid 1px black; padding: 3px">หมายเหตุ</th>
              </tr>
              <tr>
                <th class="font16 fontBold" style="border: solid 1px black; padding: 3px" v-for="budget in budgets" :key="budget.key">
                  {{ budget.budgettypeName}} <br> {{ budget.budgetplanDes }}
                </th>
              </tr>
            </thead>
            <tbody v-for="pjactivity in pjbudgets" :key="pjactivity.key">
              <tr>
                <td style="border: solid 1px black; padding: 3px;"><u class="font16 fontBold">กิจกรรมหลักที่ {{ pjactivity.pjactivityNum }} {{ pjactivity.pjactivityName }}</u></td>
                <td class="font16 text-right" style="border: solid 1px black; padding: 3px"  v-for="budget in budgets" :key="budget.key"></td>
                <td class="font16" style="border: solid 1px black; padding: 3px"></td>
              </tr>
              <template v-for="pjsubactivity in pjactivity.pjsubactivity">
                <tr :key="pjsubactivity.key">
                  <td class="pl-2 font16 fontBold" style="border: solid 1px black; padding: 3px">กิจกรรมย่อยที่  {{ pjactivity.pjactivityNum }}.{{ pjsubactivity.pjsubactivityNum }} {{ pjsubactivity.pjsubactivityName }}</td>
                  <td class="font16 text-right" style="border: solid 1px black; padding: 3px"  v-for="budget in budgets" :key="budget.key"></td>
                  <td class="font16" style="border: solid 1px black; padding: 3px"></td>
                </tr>
                <template v-for="expense in pjsubactivity.expense">
                  <tr :key="expense.key">
                    <td class="pl-3" style="border: solid 1px black; padding: 3px"><u class="font16">{{ expense.expenseName }}</u></td>
                    <td class="font16 text-right" style="border: solid 1px black; padding: 3px"  v-for="budget in budgets" :key="budget.key"></td>
                    <td class="font16" style="border: solid 1px black; padding: 3px"></td>
                  </tr>
                  <template v-for="pjbudget in expense.pjbudget">
                    <tr :key="pjbudget.key">
                      <td class="pl-5 font16" style="border: solid 1px black; padding: 3px">
                        - {{ pjbudget.pjbudgetName }}
                        <div class="ml-2">
                          <pre class="font14">{{ pjbudget.pjbudgetComment }}</pre>
                        </div>
                      </td>
                      <td class="font16 text-right" style="border: solid 1px black; padding: 3px"  v-for="budget in budgets" :key="budget.key">
                        <span v-if="pjbudget.budgetplanID==budget.budgetplanID">{{ moneyFormat(parseFloat(pjbudget.pjbudgetQty)*parseFloat(pjbudget.pjbudgetMoney)) }}</span>
                      </td>
                      <td class="font16" style="border: solid 1px black; padding: 3px"></td>
                    </tr>
                  </template>
                </template>
              <template>
  
              </template>
            </template>
            </tbody>
            <tbody>
              <tr>
                <td rowspan="2" class="font16 fontBold text-center" style="border: solid 1px black; padding: 3px">รวม</td>
                <td class="font16 fontBold text-right" style="border: solid 1px black; padding: 3px" v-for="budget in budgets" :key="budget.key">
                  {{ moneyFormat(budget.pjbudgetTotal) }}
                </td>
                <td class="font16 fontBold" style="border: solid 1px black; padding: 3px"></td>
              </tr>
              <tr>
                <td :colspan="budgets.length" class="font16 fontBold text-center" style="border: solid 1px black; padding: 3px">
                  {{ moneyFormat(totalBudget) }}
                </td>
                <td class="font16 fontBold" style="border: solid 1px black; padding: 3px"></td>
              </tr>
            </tbody>
          </table>
          <div class="font16 text-right">หมายเหตุ สามารถถัวเฉลี่ยได้ทุกรายการ</div>
        </div>
        <div class="mt-2 font16 fontBold">7. แผนตัวชี้วัดความสำเร็จโครงการ (KPI)</div>
        <div class="ml-4">
          <div>
            <u class="font16">เชิงปริมาณ</u>
            <pre class="font16">{{ project.projectQuantityKpi }}</pre>
          </div>
          <div>
            <u class="font16">เชิงคุณภาพ</u>
            <pre class="font16">{{ project.projectQualityKpi }}</pre>
          </div>
        </div>
        <div class="mt-2 font16 fontBold">8. ประโยชน์ที่คาดว่าจะได้รับ</div>
        <pre class="ml-4 font16">{{ project.projectBenefit }}</pre>
      </div>
  
      <div class="printPage" v-if="project.projectStatus=='อนุมัติ'">
        <div class="mb-2 font16 text-right">{{ project.projectCode }}</div>
        <div class="font18 text-center"><span class="font18 fontBold">ใบอนุมัติโครงการ ประจำปีงบประมาณ พ.ศ.{{parseInt(project.projectYear)+543}}</span></div>
        <div class="font16 text-center"><span class="font16 fontBold">ชื่อโครงการ: </span>{{ project.projectName }}</div>
        <div class="font16 text-center"><span class="font16 fontBold">ผู้รับผิดชอบโครงการ: </span>{{ project.departmentName }}</div>
        <div class="font16 text-center">
          <span class="font16 fontBold">ระยะเวลาดำเนินการ: </span>{{ thaiDate(projectPeriod.pjsubactivityStart) }} - {{ thaiDate(projectPeriod.pjsubactivityEnd) }}
          <span class="font16 fontBold">งบประมาณ: </span> {{ moneyFormat(totalBudget) }} บาท
        </div>
        <div class="mt-2 ml-6 font16 fontBold">วัตถุประสงค์ของโครงการ</div>
        <pre class="ml-10 font16">{{ project.projectObjective }}</pre>
        <div class="mt-2 ml-6 font16 fontBold">เป้าหมายของโครงการ</div>
        <div class="ml-10">
          <div>
            <u class="font16">เชิงปริมาณ</u>
            <pre class="font16">{{ project.projectQuantityGoal }}</pre>
          </div>
          <div>
            <u class="font16">เชิงคุณภาพ</u>
            <pre class="font16">{{ project.projectQualityGoal }}</pre>
          </div>
        </div>
        <!-- <div class="mt-10 font16 text-center">
          ผู้เสนอโครงการ <img :src="personalSignature" width="150" v-if="personalSignature" /><span v-else>...........................................................</span><br>({{ project.personalPrefix+project.personalName+" "+project.personalSer }})
        </div> -->
        <div class="mt-10 font16 text-center">
          ผู้เสนอโครงการ <img :src="departmentSignature+'?t='+new Date()" style="max-width: 150px; max-height: 40px;" v-if="departmentSignature" />
          <span v-else>................................................</span><br>
          <span class="font16" v-if="project.departmentSignName">({{ project.departmentSignName }})</span>
          <span class="font16" v-else-if="project.departmentHeadFullname">({{ project.departmentHeadFullname }})</span>
          <span class="font16" v-else>(&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;)</span><br>
          หัวหน้า{{project.departmentName}}
        </div>
        <div class="mt-10 font16 text-center">
          ผู้เห็นชอบโครงการ <img :src="partySignature+'?t='+new Date()" style="max-width: 150px; max-height: 40px;" v-if="partySignature" />
          <span v-else>................................................</span><br>
          <span class="font16" v-if="project.partySignName">({{ project.partySignName }})</span>
          <span class="font16" v-else-if="project.partyHeadFullname">({{ project.partyHeadFullname }})</span>
          <span class="font16" v-else>(&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;)</span><br>
          รองผู้อำนวยการฝ่าย{{project.partyName}}
        </div>
        <div class="mt-10 font16 text-center">
          ผู้อนุมัติโครงการ <img :src="directorSignature+'?t='+new Date()" style="max-width: 150px; max-height: 40px;" v-if="directorSignature" />
          <span v-else>................................................</span><br>
          <span class="font16" v-if="project.directorSignName">({{ project.directorSignName }})</span>
          <span class="font16" v-else-if="bossparty.partyHeadFullname">({{ bossparty.partyHeadFullname }})</span>
          <span class="font16" v-else>(&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;)</span><br>
          ผู้อำนวยการวิทยาลัยเทคนิคแพร่
        </div>
      </div>
    </div>
  </template>
  <script>
  var numeral = require('numeral')
  export default {
    layout: 'print_layout',
    props: {
        pid: {
            type: String,
            default: null,
        }
    },

    data() {
      return {
        bossparty: {},
        projectID: null,
        project: {},
        projectPeriod: {},
        orgstrategics: [],
        pjpolicies: [],
        totalBudget: 0,
        budgets: [],
        pjbudgets: [],
        pjactivities: [],
        personalSignature: null,
        departmentSignature: null,
        partySignature: null,
        directorSignature: null,
        months_th_short: ["ธ.ค." ,"ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."]
      }
    },
  
    async mounted() {
      this.projectID = this.pid
      await this.getBossParty()
      await this.getProject()
      await this.getProjectPeriod()
      await this.getOrgstrategic()
      await this.getPjpolicy()
      await this.getPjactivity()
      await this.getBudgets()
      await this.getPjbudget()
    },
  
    methods: {
      async getBossParty() {
        let params = {
          token: this.$store.state.jwtToken,
          partyName: 'อำนวยการ'
        }
        let result = await this.$axios.$get('party.php', {params})
        if(result.message == 'Success') {
          this.bossparty = JSON.parse(JSON.stringify(result.party))
        }
      },
  
      async getProject() {
        let params = {
          token: this.$store.state.jwtToken,
          projectID: this.projectID
        }
        let result = await this.$axios.$get('project.php', {params})
        if(result.message == 'Success') {
          this.project = JSON.parse(JSON.stringify(result.project))
          await this.getPersonalSignature(this.project.personalIDcard)
          if(this.project.departmentSign) {
            await this.getDepartmentSignature(this.project.departmentSign)
          }
          if(this.project.partySign) {
            await this.getPartySignature(this.project.partySign)
          }
          if(this.project.directorSign) {
            await this.getDirectorSignature(this.project.directorSign)
          }
        }
  
      },
  
      async getProjectPeriod() {
        let params = {
          token: this.$store.state.jwtToken,
          projectID: this.projectID,
          fn: 'projectPeriod'
        }
        let result = await this.$axios.$get('pjsubactivity.php', {params})
        if(result.message == 'Success') {
          this.projectPeriod = JSON.parse(JSON.stringify(result.pjsubactivity))
        }
      },
  
      async getOrgstrategic() {
        let params = {
          token: this.$store.state.jwtToken,
          orgstrategicYear: this.project.projectYear,
        }
        let result = await this.$axios.$get('orgstrategic.php', {params})
        if(result.message == 'Success') {
          this.orgstrategics = JSON.parse(JSON.stringify(result.orgstrategic))
        }
        //console.log(this.orgstrategics)
      },
  
      async getPjpolicy() {
        let params = {
          token: this.$store.state.jwtToken,
          projectID: this.projectID,
          pjpolicyYear: this.project.projectYear,
          fn: 'All'
        }
        let result = await this.$axios.$get('pjpolicy.php', {params})
        if(result.message == 'Success') {
          this.pjpolicies = JSON.parse(JSON.stringify(result.policy))
        }
      },
  
      async getPjactivity() {
        let params = {
          token: this.$store.state.jwtToken,
          projectID: this.projectID
        }
        let result = await this.$axios.$get('pjactivity.php', {params})
        if(result.message == 'Success') {
          this.pjactivities = JSON.parse(JSON.stringify(result.pjactivity))
        }
      },
  
      async getBudgets() {
        let params = {
          token: this.$store.state.jwtToken,
          projectID: this.projectID,
          fn: 'getBudget'
        }
        let result = await this.$axios.$get('pjbudget.php', {params})
        if(result.message == 'Success') {
          this.budgets = JSON.parse(JSON.stringify(result.pjbudget))
          this.totalBudget = 0
          let bgs = this.budgets.map(budget=>{
            this.totalBudget += parseFloat(budget.pjbudgetTotal)
          })
          await Promise.all(bgs)
        }
      },
  
      async getPjbudget() {
        let params = {
          token: this.$store.state.jwtToken,
          projectID: this.projectID,
          fn: 'Group'
        }
        let result = await this.$axios.$get('pjbudget.php', {params})
        if(result.message == 'Success') {
          this.pjbudgets = JSON.parse(JSON.stringify(result.pjbudget))
        }
      },
  
      async getPersonalSignature(personalIDcard) {
        let result = await this.$axios.$get('signature.image.php', {
            params: {
              token: this.$store.state.jwtToken,
              signatureType: 'Personal',
              signatureID: personalIDcard,
              function: 'signatureImageGet'
            }
          })
  
          if(result.message == 'Success') {
            this.personalSignature = result.signatureImagePath+JSON.parse(JSON.stringify(result.signatureImages))[0]
          }
      },
  
      async getDepartmentSignature(userID) {
        let result = await this.$axios.$get('signature.image.php', {
            params: {
              token: this.$store.state.jwtToken,
              signatureType: 'Department',
              signatureID: userID,
              function: 'signatureImageGet'
            }
          })
  
          if(result.message == 'Success') {
            this.departmentSignature = result.signatureImagePath+JSON.parse(JSON.stringify(result.signatureImages))[0]
          }
      },
  
      async getPartySignature(userID) {
        let result = await this.$axios.$get('signature.image.php', {
            params: {
              token: this.$store.state.jwtToken,
              signatureType: 'Party',
              signatureID: userID,
              function: 'signatureImageGet'
            }
          })
  
          if(result.message == 'Success') {
            this.partySignature = result.signatureImagePath+JSON.parse(JSON.stringify(result.signatureImages))[0]
          }
      },
  
      async getDirectorSignature(userID) {
        let result = await this.$axios.$get('signature.image.php', {
            params: {
              token: this.$store.state.jwtToken,
              signatureType: 'Party',
              signatureID: userID,
              function: 'signatureImageGet'
            }
          })
  
          if(result.message == 'Success') {
            this.directorSignature = result.signatureImagePath+JSON.parse(JSON.stringify(result.signatureImages))[0]
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
      },
  
      thaiMonthShort(inDate) {
        let result = ''
        if(inDate) {
          let thdate = new Date(inDate)
          result = thdate.toLocaleDateString('th-TH', {
            month: 'short',
          })
        }
        return result
      },
  
      checkActPeriod(month, startDate, endDate) {
        let result = false
        if(month == 0) {
          month = 12
        }
        let start = new Date(startDate)
        let end = new Date(endDate)
        if(start.getFullYear() < end.getFullYear()) {
          if((month>=(start.getMonth()+1) && month<=12) || month<=(end.getMonth()+1)) {
            result = true
          }
        } else {
          if(month>=(start.getMonth()+1) && (month<=end.getMonth()+1)) {
            result = true
          }
        }
        return result
      },
  
      moneyFormat(money) {
        return numeral(money).format('0,0.00')
      }
  
    }
  }
  </script>
  
  <style scoped>
    @page {
      size: A4;
    }
  </style>
  