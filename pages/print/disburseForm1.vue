<template>
  <div style="line-height: 1.8">
    <div class="printPage3x2">
      <v-row no-gutters class="mb-2">
        <v-col cols="2">
            <img
                src="/krut.jpg"
                class="krut"
            />
        </v-col>
        <v-col cols="8" align-self="end" class="text-center font24 font-weight-bold">
            บันทึกข้อความ
        </v-col>
        <v-col cols="12" class="font16" v-if="disburse.disburseType=='ค่าใช้จ่าย'">
            ส่วนราชการ &emsp; {{ subDepartment(disburse.departmentName) }} ฝ่าย{{ disburse.partyName}} วิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="font16" v-if="disburse.disburseType=='โครงการ'">
            ส่วนราชการ &emsp; {{ subDepartment(disburse.pjdepartmentName) }} ฝ่าย{{ disburse.pjpartyName}} วิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="6" class="font16">
            ที่&emsp;&emsp;&emsp;&emsp;&emsp;/{{ parseInt(formDate[0])+543 }}
        </v-col>
        <v-col cols="6" class="font16">
            วันที่ {{  thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="12" class="font16">
          เรื่อง ขออนุญาตดำเนินการและขออนุมัติค่าใช้จ่าย
        </v-col>
        <v-col cols="12" class="pt-1 font16">
          เรียน ผู้อำนวยการวิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="pt-1 font16">
          <table>
            <tr>
              <td class="font16" valign="top">สิ่งที่ส่งมาด้วย</td>
              <td class="pl-3 font16">
                1. แบบโครงการและประมาณการค่าใช้จ่าย<br>
                2. แบบตรวจสอบรายการคำขอจัดซื้อจัดจ้าง รหัส DB-{{ parseInt(disburseID) }}
              </td>
            </tr>
          </table>
        </v-col>
        <v-col cols="12" class="pt-1 font16">
          &emsp;&emsp;&emsp;&emsp;&emsp;ด้วย{{ subDepartment(disburse.departmentName) }} มีความประสงค์จะจัด{{disburse.disburseSubtype}}<span class="font16" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span> เพื่อ{{ disburse.disburseDes }} {{ disburse.disburseType=='โครงการ'? 'ตาม'+disburse.projectName+'  กิจกรรมที่ '+disburse.pjactivityNum+'.'+disburse.pjsubactivityNum+' '+disburse.pjsubactivityName : '' }} จำนวน {{ disburselists.length }} รายการ โดยมีค่าใช้จ่ายเป็นเงินจำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท  ({{ thaiBaht(disburse.disburseMoney) }})
        </v-col>
        <v-col cols="12" class="pt-1 font16">
          &emsp;&emsp;&emsp;&emsp;&emsp;ดังนั้น เพื่อให้การดำเนินงานเป็นไปด้วยความเรียบร้อย จึงขออนุญาตดำเนินการและขออนุมัติงบประมาณเป็นเงินจำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท  ({{ thaiBaht(disburse.disburseMoney) }}) เพื่อใช้จ่ายตามแบบโครงการและประมาณการค่าใช้จ่ายที่แนบท้าย
        </v-col>
        <v-col cols="12" class="pt-1 font16">
          &emsp;&emsp;&emsp;&emsp;&emsp;จึงเรียนมาเพื่อโปรด<br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;1. ทราบ <br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;2. พิจารณาอนุญาตดำเนินการ <br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;3. อนุมัติค่าใช้จ่ายตามโครงการ 
        </v-col>
        <v-col cols="12" class="mt-10">
          <v-row v-if="disburse.disburseType=='ค่าใช้จ่าย'">
            <v-col cols="8" align-self="start" class="ml-auto text-center font16" v-if="disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID">
              <!-- <img :src="departmentSignature" width="100" v-if="departmentSignature && (project.departmentSignName==disburse.departmentHead)" /><br> -->
              <img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="disburseSign" /><br>
              ({{ disburse.disburseReqName }})<br>
              ผู้ขอจัดซื้อ
            </v-col>
            <v-col cols="8" align-self="start" class="ml-auto text-center font16">
              <!-- <img :src="departmentSignature" width="100" v-if="departmentSignature && (project.departmentSignName==disburse.departmentHead)" /><br> -->
              <img :src="disburseDepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="disburseDepartmentSign" /><br>
              ({{ disburse.disburseDepReqName? disburse.disburseDepReqName : (disburse.userID==disburse.departmentHeadUserID? disburse.disburseReqName : disburse.departmentHeadFullname) }})<br>
              {{ disburse.departmentUserExpos }}<br v-if="disburse.departmentUserExpos">
              หัวหน้า{{ disburse.departmentName }}
            </v-col>
            <v-col cols="8" align-self="start" class="ml-auto text-center font16">
              <img :src="disbursePartySign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="disbursePartySign && disburse.partyUserID>0" /><br>
              ({{ disburse.disburseParReqName? disburse.disburseParReqName : disburse.partyHeadFullname }})<br>
              {{ disburse.partyUserExpos }}<br v-if="disburse.partyUserExpos">
              รองผู้อำนวยการฝ่าย{{ disburse.partyName }}
            </v-col>
          </v-row>
          <v-row v-if="disburse.disburseType=='โครงการ'">
            <v-col cols="8" align-self="start" class="ml-auto text-center font16" v-if="disburse.departmentID!=disburse.pjdepartmentID || (disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID)">
              <!-- <img :src="departmentSignature" width="100" v-if="departmentSignature && (project.departmentSignName==disburse.departmentHead)" /><br> -->
              <img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="disburseSign" /><br>
              ({{ disburse.disburseReqName }})<br>
              ผู้ขอจัดซื้อ
            </v-col>
            <v-col cols="8" align-self="start" class="ml-auto text-center font16" v-if="disburse.departmentID!=disburse.pjdepartmentID">
              <img :src="disburseDepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="disburseDepartmentSign" /><br>
              ({{ disburse.disburseDepReqName? disburse.disburseDepReqName : disburse.pjdepartmentHead }})<br>
              {{ disburse.departmentUserExpos }}<br v-if="disburse.departmentUserExpos">
              หัวหน้า{{ disburse.pjdepartmentName }}<br>ผู้รับผิดชอบโครงการ
            </v-col>
            <v-col cols="8" align-self="start" class="ml-auto text-center font16" v-else>
              <img :src="disburseDepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="disburseDepartmentSign" />
              <!-- <img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-else-if="disburseSign" /> -->
              <br>
              ({{ disburse.disburseDepReqName? disburse.disburseDepReqName : disburse.departmentHeadFullname }})<br>
              {{ disburse.departmentUserExpos }}<br v-if="disburse.departmentUserExpos">
              หัวหน้า{{ disburse.pjdepartmentName }}
            </v-col>
            <v-col cols="8" align-self="start" class="ml-auto text-center font16">
              <img :src="disbursePartySign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="disbursePartySign && disburse.partyUserID>0" /><br>
              ({{ disburse.disburseParReqName? disburse.disburseParReqName : disburse.pjpartyHead }})<br>
              {{ disburse.partyUserExpos }}<br v-if="disburse.partyUserExpos">
              รองผู้อำนวยการฝ่าย{{ disburse.pjpartyName }}
            </v-col>
          </v-row>
        </v-col>
        </v-row>
      </div>
      <div class="printPage3x2">
        <v-row no-gutters class="mb-2">
        <v-col cols="12" align-self="end" class="text-center font18 font-weight-bold">
          แบบตรวจสอบรายการคำขอจัดซื้อจัดจ้าง <br>รหัส DB-{{ parseInt(disburseID) }}
        </v-col>
        <v-col cols="12" class="font16 text-center" v-if="disburse.disburseType=='ค่าใช้จ่าย'">
            {{ subDepartment(disburse.departmentName) }} ฝ่าย{{ disburse.partyName}} วิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="font16 text-center" v-if="disburse.disburseType=='โครงการ'">
            {{ subDepartment(disburse.pjdepartmentName) }} ฝ่าย{{ disburse.pjpartyName}} วิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="mt-1 font16 text-center">
          จัด{{disburse.disburseSubtype}}<span class="font16" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span> เพื่อ{{ disburse.disburseDes }} {{ disburse.disburseType=='โครงการ'? 'ตาม'+disburse.projectName : '' }} เป็นเงินจำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท  ({{ thaiBaht(disburse.disburseMoney) }})
        </v-col>
        <v-col cols="12" class="mt-3 font16">
          1. งานพัสดุตรวจสอบรายการวัสดุ/ครุภัณฑ์<br/>
          &emsp;&emsp;<v-icon small v-if="disburse.disburseParcCheck=='ถูกต้อง'">far fa-square-check</v-icon><v-icon small v-else>far fa-square</v-icon> ถูกต้อง <span class="font16" v-if="disburse.disburseParcCheck=='ถูกต้อง'">{{ moneyFormat(disburse.disburseMoney) }} บาท</span><br>
          &emsp;&emsp;<v-icon small v-if="disburse.disburseParcCheck=='ไม่ถูกต้อง'">far fa-square-check</v-icon><v-icon small v-else>far fa-square</v-icon> ไม่ถูกต้อง
          <v-row no-gutters class="mt-2">
            <v-col cols="12" class="font16 text-center">
              ลงชื่อ <img :src="parcSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="parcSign && disburse.disburseParcCheck=='ถูกต้อง'" />
              <span class="font-17" v-else>..............................................................</span>
            </v-col>
            <v-col cols="12" class="font16 text-center">
              ({{ disburse.disburseParcHead? disburse.disburseParcHead : '..............................................................' }})
            </v-col>
            <v-col cols="12" class="font16 text-center">
              วันที่ {{ disburse.disburseParcDate? ((new Date(disburse.disburseParcDate).getDay()==0)? thaiDate(minusDate(disburse.disburseParcDate, 2)) : ((new Date(disburse.disburseParcDate).getDay()==6)? thaiDate(minusDate(disburse.disburseParcDate, 1)) : thaiDate(disburse.disburseParcDate))) : '.........../.........................../................' }}
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="12" class="mt-2 font16">
          2. ความเห็นหัวหน้างานวางแผนและงบประมาณ<br/>
          &emsp;เห็นควรใช้งบ:  {{ disburse.budgettypeName }} {{ String(disburse.budgetplanDes).length <65 ? disburse.budgetplanDes : String(disburse.budgetplanDes).substring(0, 65)+'...ฯ' }}<br>
            &emsp;โครงการ: {{ disburse.disburseType=='โครงการ'? disburse.projectName : disburse.expenseplanDes }}
          <v-row no-gutters class="mt-2">
            <v-col cols="12" class="font16 text-center">

              ลงชื่อ <img :src="planSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="planSign && disburse.disbursePlanCheck=='ถูกต้อง'" />
              <span class="font-17" v-else>..............................................................</span>
            </v-col>
            <v-col cols="12" class="font16 text-center">
              ({{ disburse.disbursePlanHead? disburse.disbursePlanHead  : '..............................................................' }})
            </v-col>
            <v-col cols="12" class="font16 text-center">
              วันที่ {{ disburse.disbursePlanDate? ((new Date(disburse.disbursePlanDate).getDay()==0)? thaiDate(minusDate(disburse.disbursePlanDate, 2)) : ((new Date(disburse.disbursePlanDate).getDay()==6)? thaiDate(minusDate(disburse.disbursePlanDate, 1)) : thaiDate(disburse.disbursePlanDate))) : '.........../.........................../................' }}
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="12" class="mt-2 font16">
          3. ความเห็นหัวหน้างานบัญชี<br/>
          &emsp;&emsp;เห็นควรอนุญาตดำเนินการ <span>GL-{{ disburse.ledgerID }}</span><br>
          <v-row no-gutters class="mt-2">
            <v-col cols="12" class="font16 text-center">
              ลงชื่อ <img :src="accoSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="accoSign && disburse.disburseAccoCheck=='ถูกต้อง'" />
              <span class="font-17" v-else>..............................................................</span>
            </v-col>
            <v-col cols="12" class="font16 text-center">
              ({{ disburse.disburseAccoHead? disburse.disburseAccoHead  : '..............................................................' }})
            </v-col>
            <v-col cols="12" class="font16 text-center">
              วันที่ {{ disburse.disburseAccoDate? ((new Date(disburse.disburseAccoDate).getDay()==0)? thaiDate(minusDate(disburse.disburseAccoDate, 2)) : ((new Date(disburse.disburseAccoDate).getDay()==6)? thaiDate(minusDate(disburse.disburseAccoDate, 1)) : thaiDate(disburse.disburseAccoDate))) : '.........../.........................../................' }}
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="12" class="mt-2 font16">
          4. ความเห็นหัวหน้างานการเงิน<br/>
          &emsp;&emsp;เห็นควรอนุญาตดำเนินการ<br>
          <v-row no-gutters class="mt-2">
            <v-col cols="12" class="font16 text-center">
              ลงชื่อ <img :src="finaSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="finaSign && disburse.disburseFinaCheck=='ถูกต้อง'" />
              <span class="font-17" v-else>..............................................................</span>
            </v-col>
            <v-col cols="12" class="font16 text-center">
              ({{ disburse.disburseFinaHead? disburse.disburseFinaHead  : '..............................................................' }})
            </v-col>
            <v-col cols="12" class="font16 text-center">
              วันที่ {{ disburse.disburseFinaDate? ((new Date(disburse.disburseFinaDate).getDay()==0)? thaiDate(minusDate(disburse.disburseFinaDate, 2)) : ((new Date(disburse.disburseFinaDate).getDay()==6)? thaiDate(minusDate(disburse.disburseFinaDate, 1)) : thaiDate(disburse.disburseFinaDate))) : '.........../.........................../................' }}
            </v-col>
          </v-row>
        </v-col>
        <!-- <v-col cols="12" class="mt-3">
          <table width="100%" class="tableNormal">
            <tr>
              <td width="40%" class="font16" valign="top">
                1. งานพัสดุตรวจสอบรายการวัสดุ/ครุภัณฑ์<br/>
                &emsp;&emsp;<v-icon small v-if="disburse.disburseParcCheck=='ถูกต้อง'">far fa-square-check</v-icon><v-icon small v-else>far fa-square</v-icon> ถูกต้อง <span class="font16" v-if="disburse.disburseParcCheck=='ถูกต้อง'">{{ moneyFormat(disburse.disburseMoney) }} บาท</span><br>
                &emsp;&emsp;<v-icon small v-if="disburse.disburseParcCheck=='ไม่ถูกต้อง'">far fa-square-check</v-icon><v-icon small v-else>far fa-square</v-icon> ไม่ถูกต้อง
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font16 text-center">
                    ลงชื่อ <img :src="parcSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="parcSign && disburse.disburseParcCheck=='ถูกต้อง'" />
                    <span class="font-17" v-else>...............................</span>
                  </v-col>
                  <v-col cols="12" class="font16 text-center">
                    ({{ disburse.disburseParcHead? disburse.disburseParcHead : '...............................' }})
                  </v-col>
                </v-row>
              </td>
              <td class="font16" valign="top">
                2. ความเห็นหัวหน้างานวางแผนและงบประมาณ<br/>
                &emsp;เห็นควรใช้งบ:  {{ disburse.budgettypeName }} {{ String(disburse.budgetplanDes).length <65 ? disburse.budgetplanDes : String(disburse.budgetplanDes).substring(0, 65)+'...ฯ' }}<br>
                  &emsp;โครงการ: {{ disburse.disburseType=='โครงการ'? disburse.projectName : disburse.expenseplanDes }}
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font16 text-center">

                    ลงชื่อ <img :src="planSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="planSign && disburse.disbursePlanCheck=='ถูกต้อง'" />
                    <span class="font-17" v-else>...............................</span>
                  </v-col>
                  <v-col cols="12" class="font16 text-center">
                    ({{ disburse.disbursePlanHead? disburse.disbursePlanHead  : '...............................' }})
                  </v-col>
                </v-row>
              </td>
            </tr>
            <tr>
              <td class="font16" valign="top">
                3. ความเห็นหัวหน้างานการเงิน<br/>
                &emsp;&emsp;เห็นควรอนุญาตดำเนินการ<br>
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font16 text-center">
                    ลงชื่อ <img :src="finaSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="finaSign && disburse.disburseFinaCheck=='ถูกต้อง'" />
                    <span class="font-17" v-else>...............................</span>
                  </v-col>
                  <v-col cols="12" class="font16 text-center">
                    ({{ disburse.disburseFinaHead? disburse.disburseFinaHead  : '...............................' }})
                  </v-col>
                </v-row>
              </td>
              <td class="font16" valign="top">
                4. ความเห็นหัวหน้างานบัญชี<br/>
                &emsp;&emsp;เห็นควรอนุญาตดำเนินการ <span>GL-{{ disburse.ledgerID }}</span><br>
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font16 text-center">
                    ลงชื่อ <img :src="accoSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="accoSign && disburse.disburseAccoCheck=='ถูกต้อง'" />
                    <span class="font-17" v-else>...............................</span>
                  </v-col>
                  <v-col cols="12" class="font16 text-center">
                    ({{ disburse.disburseAccoHead? disburse.disburseAccoHead  : '...............................' }})
                  </v-col>
                </v-row>
              </td>
            </tr>
          </table>
        </v-col> -->
      </v-row>
    </div>
    <div class="printPage3x2">
      <v-row no-gutters class="mb-2">
        <v-col cols="12" class="font16 text-right">
          เอกสารจัดซื้อจัดจ้าง เลขที่ ...............................
        </v-col>
        <v-col cols="12" class="mt-3 font16 font-weight-bold text-center" v-if="state">
          {{ state.appSubTitle }}
        </v-col>
        <v-col cols="12" class="mb-2 font16 font-weight-bold text-center">
          บัญชีประมาณการของอนุญาตจัดซื้อ/จัดจ้าง ปี {{ parseInt(disburse.disburseYear)+543 }}
        </v-col>
        <v-col cols="12" class="font16 text-center">
          ด้วยเงิน (&nbsp;&nbsp;) อุดหนุน &emsp; (&nbsp;&nbsp;) งบประมาณ &emsp; (&nbsp;&nbsp;) รายได้ &emsp; (&nbsp;&nbsp;) อื่นๆ................................
        </v-col>
        <v-col cols="12" class="mt-5 font16 text-center">
          หมวด........................................................................................................
        </v-col>
        <v-col cols="12" class="font16">
          <div class="text-right font16">รหัสคำขอจัดซื้อ DB-{{ parseInt(disburseID) }}</div>
          <table width="100%" class="tableNormal">
            <thead>
              <tr>
                <th class="font16 font-weight-bold">
                  ที่
                </th>
                <th class="font16 font-weight-bold">
                  รายการ
                </th>
                <th colspan="2" class="font16 font-weight-bold">
                  จำนวน
                </th>
                <th class="font16 font-weight-bold">
                  ราคาต่อหน่วย
                </th>
                <th class="font16 font-weight-bold">
                  จำนวนเงิน
                </th>
                <th class="font16 font-weight-bold">
                  หมายเหตุ
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="disburselist, index in disburselists" :key="disburselist.key">
                <td class="px-1 text-center" valign="toptop">{{index+1}}</td>
                <td class="font16" valign="top">
                  {{ disburselist.disburselistName }}
                  <pre class="ml-2 font16">{{ disburselist.disburselistDetail }}</pre>
                </td>
                <td class="pl-2 font16 text-right text-no-wrap" valign="top">
                  {{ qtyFormat(disburselist.disburselistQty) }}
                </td>
                <td class="font16 pl-2" valign="top">
                  {{ disburselist.disburselistUnit }}
                </td>
                <td class="font16 text-right  text-no-wrap" valign="top">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font16 text-right  text-no-wrap" valign="top">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
                <td class="font16" valign="top">
                  {{ disburselist.disburselistDes }}
                  <v-icon small color="error" v-if="disburselist.disburselistStatus=='ไม่ถูกต้อง'">fas fa-times</v-icon>
                  {{ disburselist.disburselistStatus=='ไม่ถูกต้อง' ? disburselist.disburselistCommment : '' }}
                </td>
              </tr>
              <tr v-for="disburselist, index in disburselistdis" :key="disburselist.key">
                <td></td>
                <td class="font16" valign="top">
                  {{ disburselist.disburselistName }}
                  <pre class="ml-2 font16">{{ disburselist.disburselistDetail }}</pre>
                </td>
                <td class="font16 text-right text-no-wrap" valign="top">
                  {{ qtyFormat(disburselist.disburselistQty) }}
                </td>
                <td class="font16 pl-2" valign="top">
                  {{ disburselist.disburselistUnit }}
                </td>
                <td class="pl-2 font16 text-right  text-no-wrap" valign="top">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="pl-2 font16 text-right  text-no-wrap" valign="top">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
                <td class="font16" valign="top">
                  {{ disburselist.disburselistDes }}
                  <v-icon small color="error" v-if="disburselist.disburselistStatus=='ไม่ถูกต้อง'">fas fa-times</v-icon>
                  {{ disburselist.disburselistStatus=='ไม่ถูกต้อง' ? disburselist.disburselistCommment : '' }}
                </td>
              </tr>
              <tr v-if="disburse.disburseExcludeVat==1">
                <td colspan="5" class="font16 text-right" valign="top">ภาษีมูลค่าเพิ่ม 7%</td>
                <td class="font16 text-right" valign="top">{{ moneyFormat(disburse.disburseMoney-(disburse.disburseMoney*100/107)) }}</td>
              </tr>
              <tr>
                <td colspan="5" class="font16 text-center font-weight-bold" valign="top">รวมเป็นเงินทั้งสิ้น</td>
                <td class="font16 text-right font-weight-bold" valign="top">{{ moneyFormat(disburse.disburseMoney) }}</td>
                <td></td>
              </tr>
            </tbody>
          </table>
        </v-col>
        <v-col cols="6" class="mt-2 font16 ml-auto">
          ตัวอักษร {{ thaiBaht(disburse.disburseMoney) }}
        </v-col>
        <v-col cols="12"></v-col>
        <v-col cols="6" class="font16 text-center mt-10 ml-auto" v-if="disburse.disburseType=='ค่าใช้จ่าย' && disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID">
          <img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disburseSign" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseReqName }}) <br>
          ผู้ประมาณราคา
        </v-col>
        <v-col cols="6" class="font16 text-center mt-10 ml-auto" v-else-if="disburse.disburseType=='ค่าใช้จ่าย' && disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID">
          <img :src="disburseDepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disburseDepartmentSign" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseDepReqName? disburse.disburseDepReqName : disburse.departmentHeadFullname }}) <br>
          {{ disburse.departmentUserExpos }}<br v-if="disburse.departmentUserExpos">
          ผู้ประมาณราคา
        </v-col>
        <v-col cols="6" class="font16 text-center mt-10 ml-auto" v-else-if="disburse.disburseType=='ค่าใช้จ่าย'">
          <img :src="disburseDepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disburseDepartmentSign" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseDepReqName? disburse.disburseDepReqName : disburse.departmentHeadFullname }}) <br>
          {{ disburse.departmentUserExpos }}<br v-if="disburse.departmentUserExpos">
          ผู้ประมาณราคา
        </v-col>
        <v-col cols="4" class="font16 text-center mt-10 ml-auto" v-if="disburse.disburseType=='โครงการ' && (disburse.departmentID!=disburse.pjdepartmentID || (disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID))">
          <img :src="disburseSign+'?t='+new Date()"style="max-width: 100px; max-height: 25px;" v-if="disburseSign" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseReqName }}) <br>
          ผู้ประมาณราคา
        </v-col>
        <v-col cols="4" class="font16 text-center mt-10 ml-auto" v-else-if="disburse.disburseType=='โครงการ' && (disburse.departmentID!=disburse.pjdepartmentID || (disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID))">
          <img :src="disburseDepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disburseDepartmentSign" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseDepReqName? disburse.disburseDepReqName : disburse.pjdepartmentHead }}) <br>
          {{ disburse.departmentUserExpos }}<br v-if="disburse.departmentUserExpos">
         ผู้ประมาณราคา
        </v-col>
        <v-col cols="6" class="font16 text-center mt-10 ml-auto" v-else-if="disburse.disburseType=='โครงการ'">
          <img :src="disburseDepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disburseDepartmentSign" />
          <!-- <img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-else-if="disburseSign" /> -->
          <span class="font16" v-else>........................................</span><br>
         ({{ disburse.disburseDepReqName? disburse.disburseDepReqName : disburse.departmentHeadFullname }}) <br>
         {{ disburse.departmentUserExpos }}<br v-if="disburse.departmentUserExpos">
          ผู้ประมาณราคา
        </v-col>
      </v-row>
    </div>
    <div class="printPage3x2">
      <v-row no-gutters class="mb-2">
        <v-col cols="12" class="font16 text-right">
          สผ.1
        </v-col>
        <v-col cols="12" class="font16 font-weight-bold text-center">
          แบบโครงการและประมาณการค่าใช้จ่าย
        </v-col>
        <v-col cols="12" class="mb-2 font16 font-weight-bold text-center">
          โครงการ
        </v-col>
        <v-col cols="4" class="font16" v-if="state">
          สถานศึกษา {{ state.appSubTitle }}
        </v-col>
        <v-col cols="4" class="font16" v-if="disburse.disburseType=='ค่าใช้จ่าย'">
          ฝ่าย {{ disburse.partyName }}
        </v-col>
        <v-col cols="4" class="font16" v-if="disburse.disburseType=='ค่าใช้จ่าย'">
          {{ subDepartment(disburse.departmentName) }}
        </v-col>
        <v-col cols="4" class="font16" v-if="disburse.disburseType=='โครงการ'">
          ฝ่าย {{ disburse.pjpartyName }}
        </v-col>
        <v-col cols="4" class="font16" v-if="disburse.disburseType=='โครงการ'">
          {{ subDepartment(disburse.pjdepartmentName) }}
        </v-col>
        <v-col cols="12" class="font16 mb-2">
          ภาคเรียนที่ 
          <span v-if="disburse.disburseEduTerm">{{ disburse.disburseEduTerm }}</span>
          <span v-else>{{ (parseInt(String(disburse.disburseDate).split('-')[1])>=5&&parseInt(String(disburse.disburseDate).split('-')[1])<=10)? '1':'2'}} </span>
          &emsp;ปีการศึกษา 
          <span v-if="disburse.disburseEduYear">{{ disburse.disburseEduYear }}</span>
          <span v-else>{{ (parseInt(String(disburse.disburseDate).split('-')[1])>=5&&parseInt(String(disburse.disburseDate).split('-')[1])<=10)? parseInt(disburse.disburseYear)+543:parseInt(disburse.disburseYear)+542}}</span>
          &emsp;ชื่อโครงการ {{ disburse.disburseType=='โครงการ'? disburse.projectName : disburse.expenseplanDes }} <!--จำนวน {{ disburselists.length }} รายการ -->
        </v-col>
        <v-col cols="4" class="font16">
          &emsp;&emsp;&emsp;&emsp;&emsp;ลักษณะโครงการ
        </v-col>
        <v-col cols="8" class="font16">
          <v-icon small>far fa-square</v-icon> ตามโครงการพัฒนาสถานศึกษา<br>
          <v-icon small>far fa-square</v-icon> อื่นๆ
        </v-col>
        <v-col cols="12" class="mb-3 font16 text-center">
          วันที่เริ่มต้น {{ thaiDate(disburse.disburseStart) }}&emsp;&emsp;วันที่สิ้นสุด {{ thaiDate(disburse.disburseEnd) }}
        </v-col>
        <v-col cols="5" class="font16">
          ประมาณการค่าใช้จ่ายดังนี้
          <v-row no-gutters>
            <v-col  class="font16">
              - {{ disburse.expenseName }}
            </v-col>
            <v-col class="font16 text-right pr-3">
              {{ moneyFormat(disburse.disburseMoney) }} บาท
            </v-col>
          </v-row>
          <v-row no-gutters>
            <v-col  class="font16">
              &emsp;&emsp;รวม
            </v-col>
            <v-col class="font16 text-right pr-3">
              {{ moneyFormat(disburse.disburseMoney) }} บาท
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="7" class="font16">
          <table width="100%" class="tableNormal">
            <tr>
              <td class="font16 text-center">
                ผลิตผลที่คาดว่าจะได้
              </td>
            </tr>
            <tr>
              <td class="font16 px-3"><pre class="font16">{{ disburse.disburseProduct }}</pre></td>
            </tr>
          </table>
        </v-col>
        <v-col cols="4" class="font16 text-center mt-5" v-if="disburse.disburseType=='ค่าใช้จ่าย' && disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID">
          <img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disburseSign" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseReqName }}) <br>
          ผู้ขอจัดซื้อ<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="4" class="font16 text-center mt-5" v-if="disburse.disburseType=='ค่าใช้จ่าย' && disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID">
          <img :src="disburseDepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disburseDepartmentSign" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseDepReqName? disburse.disburseDepReqName : disburse.departmentHeadFullname }}) <br>
          {{ disburse.departmentUserExpos }}<br v-if="disburse.departmentUserExpos">
          หัวหน้า{{ disburse.departmentName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="6" class="font16 text-center mt-5" v-else-if="disburse.disburseType=='ค่าใช้จ่าย'">
          <img :src="disburseDepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disburseDepartmentSign" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseDepReqName? disburse.disburseDepReqName : disburse.departmentHeadFullname }}) <br>
          {{ disburse.departmentUserExpos }}<br v-if="disburse.departmentUserExpos">
          หัวหน้า{{ disburse.departmentName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="4" class="font16 text-center mt-5" v-if="disburse.disburseType=='ค่าใช้จ่าย' && disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID">
          <img :src="disbursePartySign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disbursePartySign && disburse.partyUserID>0" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseParReqName? disburse.disburseParReqName : disburse.partyHeadFullname }}) <br>
          {{ disburse.partyUserExpos }}<br v-if="disburse.partyUserExpos">
          รองผู้อำนวยการฝ่าย{{ disburse.partyName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="6" class="font16 text-center mt-5" v-else-if="disburse.disburseType=='ค่าใช้จ่าย'">
          <img :src="disbursePartySign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disbursePartySign && disburse.partyUserID>0" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseParReqName? disburse.disburseParReqName : disburse.partyHeadFullname }}) <br>
          {{ disburse.partyUserExpos }}<br v-if="disburse.partyUserExpos">
          รองผู้อำนวยการฝ่าย{{ disburse.partyName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="4" class="font16 text-center mt-5" v-if="disburse.disburseType=='โครงการ' && (disburse.departmentID!=disburse.pjdepartmentID || (disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID))">
          <img :src="disburseSign+'?t='+new Date()"style="max-width: 100px; max-height: 25px;" v-if="disburseSign" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseReqName }}) <br>
          ผู้ขอจัดซื้อ<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="4" class="font16 text-center mt-5" v-if="disburse.disburseType=='โครงการ' && (disburse.departmentID!=disburse.pjdepartmentID || (disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID))">
          <img :src="disburseDepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disburseDepartmentSign" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseDepReqName? disburse.disburseDepReqName : disburse.pjdepartmentHead }}) <br>
          {{ disburse.departmentUserExpos }}<br v-if="disburse.departmentUserExpos">
          หัวหน้า{{ disburse.pjdepartmentName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="6" class="font16 text-center mt-5" v-else-if="disburse.disburseType=='โครงการ'">
          <img :src="disburseDepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disburseDepartmentSign" />
          <!-- <img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-else-if="disburseSign" /> -->
          <span class="font16" v-else>........................................</span><br>
         ({{ disburse.disburseDepReqName? disburse.disburseDepReqName : disburse.departmentHeadFullname }}) <br>
         {{ disburse.departmentUserExpos }}<br v-if="disburse.departmentUserExpos">
          หัวหน้า{{ disburse.pjdepartmentName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="4" class="font16 text-center mt-5" v-if="disburse.disburseType=='โครงการ' && (disburse.departmentID!=disburse.pjdepartmentID || (disburse.userID!=disburse.departmentHeadUserID && disburse.userID!=disburse.departmentUserID))">
          <img :src="disbursePartySign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disbursePartySign && disburse.partyUserID>0" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseParReqName? disburse.disburseParReqName : disburse.pjpartyHead }}) <br>
          {{ disburse.partyUserExpos }}<br v-if="disburse.partyUserExpos">
          รองผู้อำนวยการฝ่าย{{ disburse.pjpartyName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="6" class="font16 text-center mt-5" v-else-if="disburse.disburseType=='โครงการ'">
          <img :src="disbursePartySign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disbursePartySign && disburse.partyUserID>0" />
          <span class="font16" v-else>........................................</span><br>
          ({{ disburse.disburseParReqName? disburse.disburseParReqName : disburse.pjpartyHead }}) <br>
          {{ disburse.partyUserExpos }}<br v-if="disburse.partyUserExpos">
          รองผู้อำนวยการฝ่าย{{ disburse.pjpartyName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="12" class="mt-3 font16">
          <table width="100%" class="tableNormal">
            <thead>
              <tr>
                <th colspan="7" class="font16 text-center font-weight-bold">
                  <div class="text-right font16">รหัสคำขอจัดซื้อ DB-{{ parseInt(disburseID) }}</div>
                  ประมาณการค่าใช้จ่าย  (ค่าใช้สอย / ค่าตอบแทน / ค่าวัสดุ)
                </th>
              </tr>
              <tr>
                <th class="font16 font-weight-bold">
                  ลำดับ
                </th>
                <th class="font16 font-weight-bold">
                  รายการ
                </th>
                <th colspan="2" class="font16 font-weight-bold">
                  จำนวน<br>หน่วย
                </th>
                <th class="font16 font-weight-bold">
                  ราคาต่อหน่วย
                </th>
                <th class="font16 font-weight-bold">
                  รวมเงิน
                </th>
                <th class="font16 font-weight-bold">
                  หมายเหตุ
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="font16 text-center" valign="top">1</td>
                <td class="font16" valign="top">{{ disburse.expenseName }}</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
              </tr>
              <tr v-for="disburselist, index in disburselists" :key="disburselist.key">
                <td></td>
                <td class="font16" valign="top">
                  1.{{index+1}} {{ disburselist.disburselistName }}
                  <pre class="ml-2 font16">{{ disburselist.disburselistDetail }}</pre>
                </td>
                <td class="pl-2 font16 text-right text-no-wrap" valign="top">
                  {{ qtyFormat(disburselist.disburselistQty) }}
                </td>
                <td class="font16 pl-2" valign="top">
                  {{ disburselist.disburselistUnit }}
                </td>
                <td class="pl-2 font16 text-right  text-no-wrap" valign="top">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="pl-2 font16 text-right  text-no-wrap" valign="top">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
                <td class="font16" valign="top">
                  {{ disburselist.disburselistDes }}
                  <v-icon small color="error" v-if="disburselist.disburselistStatus=='ไม่ถูกต้อง'">fas fa-times</v-icon>
                  {{ disburselist.disburselistStatus=='ไม่ถูกต้อง' ? disburselist.disburselistCommment : '' }}
                </td>
              </tr>
              <tr v-for="disburselist, index in disburselistdis" :key="disburselist.key">
                <td></td>
                <td class="font16" valign="top">
                  {{ disburselist.disburselistName }}
                  <pre class="ml-2 font16">{{ disburselist.disburselistDetail }}</pre>
                </td>
                <td class="font16 text-right text-no-wrap" valign="top">
                  {{ qtyFormat(disburselist.disburselistQty) }}
                </td>
                <td class="font16 pl-2" valign="top">
                  {{ disburselist.disburselistUnit }}
                </td>
                <td class="font16 text-right  text-no-wrap" valign="top">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font16 text-right  text-no-wrap" valign="top">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
                <td class="font16" valign="top">
                  {{ disburselist.disburselistDes }}
                  <v-icon small color="error" v-if="disburselist.disburselistStatus=='ไม่ถูกต้อง'">fas fa-times</v-icon>
                  {{ disburselist.disburselistStatus=='ไม่ถูกต้อง' ? disburselist.disburselistCommment : '' }}
                </td>
              </tr>
              <tr v-if="disburse.disburseExcludeVat==1">
                <td colspan="5" class="font16 text-right" valign="top">ภาษีมูลค่าเพิ่ม 7%</td>
                <td class="font16 text-right" valign="top">{{ moneyFormat(disburse.disburseMoney-(disburse.disburseMoney*100/107)) }}</td>
              </tr>
              <tr>
                <td colspan="5" class="font16 text-right font-weight-bold" valign="top">รวมเงิน</td>
                <td class="font16 text-right font-weight-bold" valign="top">{{ moneyFormat(disburse.disburseMoney) }}</td>
                <td></td>
              </tr>
            </tbody>
          </table>
        </v-col>
      </v-row>
    </div>
    <ProjectPrint :pid="disburse.projectID" v-if="disburse.projectID"/>
  </div>
</template>
<script>
var numeral = require('numeral')
const { bahttext } = require('bahttext')
export default {
  layout: 'print_layout',
  data() {
    return {
        state: null,
        disburseID: null,
        disburse: {},
        disburseSign: null,
        disburseDepartmentSign: null,
        disbursePartySign: null,
        pjdepartmentSign: null,
        pjpartySign: null,
        parcSign: null,
        planSign: null,
        accoSign: null,
        finaSign: null,
        disburselistall: [],
        disburselists: [],
        disburselistdis: [],
        formDate: []
    }
  },

  async mounted() {
    this.disburseID = this.$route.query.id
    this.state = this.$store.state
    await this.getDisburse()
  },

  methods: {
    async getDisburse() {
        let disburseQuery = await this.$axios.$get('disburse.php', {
            params: {
                token: this.$store.state.jwtToken,
                disburseID: this.disburseID
            }
        })

        if(disburseQuery.message == 'Success') {
            this.disburse = JSON.parse(JSON.stringify(disburseQuery.disburse))
            if(this.disburse.partyUserID) {
              let partyUserQuery = await this.$axios.$get('user.php', {
                  params: {
                      token: this.$store.state.jwtToken,
                      userID: this.disburse.partyUserID
                  }
              }).then(async result=>{
                if(result.message=='Success') {
                  let partyUser = JSON.parse(JSON.stringify(result.user))
                  if(partyUser.userStatus=='Party') {
                    this.disbursePartySign = await this.getPartySignature(this.disburse.partyUserID)
                  } else {
                    this.disbursePartySign = await this.getDepartmentSignature(this.disburse.partyUserID)
                  }
                }
              })
              // if(this.disburse.partyUserExpos=='รักษาราชการแทน') {
              //   this.disbursePartySign = await this.getDepartmentSignature(this.disburse.partyUserID)
              // } else {
              //   this.disbursePartySign = await this.getPartySignature(this.disburse.partyUserID)
              // }
            }
            if(this.disburse.userID) {
              this.disburseSign = await this.getDepartmentSignature(this.disburse.userID)
            }
            if(this.disburse.departmentUserID) {
              this.disburseDepartmentSign = await this.getDepartmentSignature(this.disburse.departmentUserID)
            }
            // if(this.disburse.departmentSign) {
            //   this.pjdepartmentSign = await this.getDepartmentSignature(this.disburse.departmentSign)
            // }
            if(this.disburse.parcUserID) {
              this.parcSign = await this.getDepartmentSignature(this.disburse.parcUserID)
            }
            if(this.disburse.planUserID) {
              this.planSign = await this.getDepartmentSignature(this.disburse.planUserID)
            }
            if(this.disburse.accoUserID) {
              this.accoSign = await this.getDepartmentSignature(this.disburse.accoUserID)
            }
            if(this.disburse.finaUserID) {
              this.finaSign = await this.getDepartmentSignature(this.disburse.finaUserID)
            }
            this.formDate = this.disburse.disburseDate.split('-')

            let disburselistQuery = await this.$axios.$get('disburselist.php', {
              params: {
                token: this.$store.state.jwtToken,
                disburseID: this.disburseID
              }
            })

            if(disburselistQuery.message == 'Success') {
              this.disburselistall = JSON.parse(JSON.stringify(disburselistQuery.disburselist))
              this.disburselists = this.disburselistall.filter(disburselist => disburselist.disburselistPrice>=0)
              this.disburselistdis = this.disburselistall.filter(disburselist => disburselist.disburselistPrice<0)
            }
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
          return result.signatureImagePath+JSON.parse(JSON.stringify(result.signatureImages))[0]
        } else {
          return null
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
          return result.signatureImagePath+JSON.parse(JSON.stringify(result.signatureImages))[0]
        } else {
          return null
        }
    },

    minusDate(inDate, days) {
      let newDate = new Date(inDate);
      newDate.setDate(newDate.getDate() - days);
      return newDate;
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

    subDepartment(departmentName) {
      if(departmentName) {
        let subd = departmentName.substring(departmentName.indexOf("(") + 1, departmentName.lastIndexOf(")"))
        if(subd){
          return subd
        } else {
          return departmentName
        }
      }
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    },

    qtyFormat(qty){
      if(qty%1) {
        return numeral(qty).format('0,0.00')
      } else {
        return numeral(qty).format('0,0')
      }
    },

    thaiBaht(money) {
      return bahttext(money)
    }

  }
}
</script>

<style scoped>
  
  @page {
    size: A4;
  }
</style>
