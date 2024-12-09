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
        <v-col cols="8" align-self="end" class="text-center font25 font-weight-bold">
            บันทึกข้อความ
        </v-col>
        <v-col cols="12" class="font17" v-if="disburse.disburseType=='ค่าใช้จ่าย'">
            ส่วนราชการ &emsp; {{ subDepartment(disburse.departmentName) }} ฝ่าย{{ disburse.partyName}} วิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="font17" v-if="disburse.disburseType=='โครงการ'">
            ส่วนราชการ &emsp; {{ subDepartment(disburse.pjdepartmentName) }} ฝ่าย{{ disburse.pjpartyName}} วิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="6" class="font17">
            ที่&emsp;&emsp;&emsp;&emsp;&emsp;/{{ parseInt(formDate[0])+543 }}
        </v-col>
        <v-col cols="6" class="font17">
            วันที่ {{  thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="12" class="font17">
          เรื่อง ขออนุญาตดำเนินการและขออนุมัติค่าใช้จ่าย
        </v-col>
        <v-col cols="12" class="pt-1 font17">
          เรียน ผู้อำนวยการวิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="pt-1 font17">
          <table>
            <tr>
              <td class="font17" valign="top">สิ่งที่ส่งมาด้วย</td>
              <td class="pl-3 font17">
                1. แบบโครงการและประมาณการค่าใช้จ่าย<br>
                2. แบบตรวจสอบรายการคำขอจัดซื้อจัดจ้าง รหัส DB-{{ parseInt(disburseID) }}
              </td>
            </tr>
          </table>
        </v-col>
        <v-col cols="12" class="pt-1 font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;ด้วย{{ subDepartment(disburse.departmentName) }} มีความประสงค์จะจัด{{disburse.disburseSubtype}}<span class="font17" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span> เพื่อ{{ disburse.disburseDes }} {{ disburse.disburseType=='โครงการ'? 'ตาม'+disburse.projectName : '' }} จำนวน {{ disburselists.length }} รายการ โดยมีค่าใช้จ่ายเป็นเงินจำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท  ({{ thaiBaht(disburse.disburseMoney) }})
        </v-col>
        <v-col cols="12" class="pt-1 font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;ดังนั้น เพื่อให้การดำเนินงานเป็นไปด้วยความเรียบร้อย จึงขออนุญาตดำเนินการและขออนุมัติงบประมาณเป็นเงินจำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท  ({{ thaiBaht(disburse.disburseMoney) }}) เพื่อใช้จ่ายตามแบบโครงการและประมาณการค่าใช้จ่ายที่แนบท้าย
        </v-col>
        <v-col cols="12" class="pt-1 font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;จึงเรียนมาเพื่อโปรด<br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;1. ทราบ <br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;2. พิจารณาอนุญาตดำเนินการ <br>
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;3. อนุมัติค่าใช้จ่ายตามโครงการ 
        </v-col>
        <v-col cols="12" class="mt-10">
          <v-row no-gutters v-if="disburse.disburseType=='ค่าใช้จ่าย'">
            <v-col align-self="start" class="text-center font17">
              <!-- <img :src="departmentSignature" width="100" v-if="departmentSignature && (project.departmentSignName==disburse.departmentHead)" /><br> -->
              <img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="disburseSign" /><br>
              ({{ disburse.disburseReqName }})<br>
              หัวหน้า{{ disburse.departmentName }}
            </v-col>
            <v-col align-self="start" class="text-center font17">
              <img :src="disbursePartySign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="disbursePartySign" /><br>
              ({{ disburse.partyHead }})<br>
              รองผู้อำนวยการฝ่าย{{ disburse.partyName }}
            </v-col>
          </v-row>
          <v-row no-gutters v-if="disburse.disburseType=='โครงการ'">
            <v-col align-self="start" class="text-center font17" v-if="disburse.departmentID!=disburse.pjdepartmentID">
              <!-- <img :src="departmentSignature" width="100" v-if="departmentSignature && (project.departmentSignName==disburse.departmentHead)" /><br> -->
              <img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="disburseSign" /><br>
              ({{ disburse.disburseReqName }})<br>
              ผู้ขอจัดซื้อ
            </v-col>
            <v-col align-self="start" class="text-center font17" v-if="disburse.departmentID!=disburse.pjdepartmentID">
              <img :src="pjdepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="pjdepartmentSign" /><br>
              ({{ disburse.pjdepartmentHead }})<br>
              หัวหน้า{{ disburse.pjdepartmentName }}<br>ผู้รับผิดชอบโครงการ
            </v-col>
            <v-col align-self="start" class="text-center font17" v-else>
              <img :src="pjdepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="pjdepartmentSign&&disburse.departmentSign==disburse.userID" /><img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-else-if="disburseSign" /><br>
              ({{ disburse.disburseReqName }})<br>
              หัวหน้า{{ disburse.pjdepartmentName }}
            </v-col>
            <v-col align-self="start" class="text-center font17">
              <img :src="disbursePartySign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="disbursePartySign" /><br>
              ({{ disburse.disburseParReqName? disburse.disburseParReqName : disburse.pjpartyHead }})<br>
              รองผู้อำนวยการฝ่าย{{ disburse.pjpartyName }}
            </v-col>
          </v-row>
        </v-col>
        </v-row>
      </div>
      <div class="printPage3x2">
        <v-row no-gutters class="mb-2">
        <v-col cols="12" align-self="end" class="text-center font19 font-weight-bold">
          แบบตรวจสอบรายการคำขอจัดซื้อจัดจ้าง <br>รหัส DB-{{ parseInt(disburseID) }}
        </v-col>
        <v-col cols="12" class="font17 text-center" v-if="disburse.disburseType=='ค่าใช้จ่าย'">
            {{ subDepartment(disburse.departmentName) }} ฝ่าย{{ disburse.partyName}} วิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="font17 text-center" v-if="disburse.disburseType=='โครงการ'">
            {{ subDepartment(disburse.pjdepartmentName) }} ฝ่าย{{ disburse.pjpartyName}} วิทยาลัยเทคนิคแพร่
        </v-col>
        <v-col cols="12" class="mt-1 font17 text-center">
          จัด{{disburse.disburseSubtype}}<span class="font17" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span> เพื่อ{{ disburse.disburseDes }} {{ disburse.disburseType=='โครงการ'? 'ตาม'+disburse.projectName : '' }} เป็นเงินจำนวน {{ moneyFormat(disburse.disburseMoney) }} บาท  ({{ thaiBaht(disburse.disburseMoney) }})
        </v-col>
        <v-col cols="12" class="mt-3 font17">
          1. งานพัสดุตรวจสอบรายการวัสดุ/ครุภัณฑ์<br/>
          &emsp;&emsp;<v-icon small v-if="disburse.disburseParcCheck=='ถูกต้อง'">far fa-square-check</v-icon><v-icon small v-else>far fa-square</v-icon> ถูกต้อง <span class="font17" v-if="disburse.disburseParcCheck=='ถูกต้อง'">{{ moneyFormat(disburse.disburseMoney) }} บาท</span><br>
          &emsp;&emsp;<v-icon small v-if="disburse.disburseParcCheck=='ไม่ถูกต้อง'">far fa-square-check</v-icon><v-icon small v-else>far fa-square</v-icon> ไม่ถูกต้อง
          <v-row no-gutters class="mt-2">
            <v-col cols="12" class="font17 text-center">
              ลงชื่อ <img :src="parcSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="parcSign && disburse.disburseParcCheck=='ถูกต้อง'" />
              <span class="font-17" v-else>..............................................................</span>
            </v-col>
            <v-col cols="12" class="font17 text-center">
              ({{ disburse.disburseParcHead? disburse.disburseParcHead : '..............................................................' }})
            </v-col>
            <v-col cols="12" class="font17 text-center">
              วันที่ {{ disburse.disburseParcDate? ((new Date(disburse.disburseParcDate).getDay()==0)? thaiDate(minusDate(disburse.disburseParcDate, 2)) : ((new Date(disburse.disburseParcDate).getDay()==6)? thaiDate(minusDate(disburse.disburseParcDate, 1)) : thaiDate(disburse.disburseParcDate))) : '.........../.........................../................' }}
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="12" class="mt-2 font17">
          2. ความเห็นหัวหน้างานวางแผนและงบประมาณ<br/>
          &emsp;เห็นควรใช้งบ:  {{ disburse.budgettypeName }} {{ String(disburse.budgetplanDes).length <65 ? disburse.budgetplanDes : String(disburse.budgetplanDes).substring(0, 65)+'...ฯ' }}<br>
            &emsp;โครงการ: {{ disburse.disburseType=='โครงการ'? disburse.projectName : disburse.expenseplanDes }}
          <v-row no-gutters class="mt-2">
            <v-col cols="12" class="font17 text-center">

              ลงชื่อ <img :src="planSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="planSign && disburse.disbursePlanCheck=='ถูกต้อง'" />
              <span class="font-17" v-else>..............................................................</span>
            </v-col>
            <v-col cols="12" class="font17 text-center">
              ({{ disburse.disbursePlanHead? disburse.disbursePlanHead  : '..............................................................' }})
            </v-col>
            <v-col cols="12" class="font17 text-center">
              วันที่ {{ disburse.disbursePlanDate? ((new Date(disburse.disbursePlanDate).getDay()==0)? thaiDate(minusDate(disburse.disbursePlanDate, 2)) : ((new Date(disburse.disbursePlanDate).getDay()==6)? thaiDate(minusDate(disburse.disbursePlanDate, 1)) : thaiDate(disburse.disbursePlanDate))) : '.........../.........................../................' }}
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="12" class="mt-2 font17">
          3. ความเห็นหัวหน้างานบัญชี<br/>
          &emsp;&emsp;เห็นควรอนุญาตดำเนินการ <span>GL-{{ disburse.ledgerID }}</span><br>
          <v-row no-gutters class="mt-2">
            <v-col cols="12" class="font17 text-center">
              ลงชื่อ <img :src="accoSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="accoSign && disburse.disburseAccoCheck=='ถูกต้อง'" />
              <span class="font-17" v-else>..............................................................</span>
            </v-col>
            <v-col cols="12" class="font17 text-center">
              ({{ disburse.disburseAccoHead? disburse.disburseAccoHead  : '..............................................................' }})
            </v-col>
            <v-col cols="12" class="font17 text-center">
              วันที่ {{ disburse.disburseAccoDate? ((new Date(disburse.disburseAccoDate).getDay()==0)? thaiDate(minusDate(disburse.disburseAccoDate, 2)) : ((new Date(disburse.disburseAccoDate).getDay()==6)? thaiDate(minusDate(disburse.disburseAccoDate, 1)) : thaiDate(disburse.disburseAccoDate))) : '.........../.........................../................' }}
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="12" class="mt-2 font17">
          4. ความเห็นหัวหน้างานการเงิน<br/>
          &emsp;&emsp;เห็นควรอนุญาตดำเนินการ<br>
          <v-row no-gutters class="mt-2">
            <v-col cols="12" class="font17 text-center">
              ลงชื่อ <img :src="finaSign+'?t='+new Date()" style="max-width: 100px; max-height: 30px;" v-if="finaSign && disburse.disburseFinaCheck=='ถูกต้อง'" />
              <span class="font-17" v-else>..............................................................</span>
            </v-col>
            <v-col cols="12" class="font17 text-center">
              ({{ disburse.disburseFinaHead? disburse.disburseFinaHead  : '..............................................................' }})
            </v-col>
            <v-col cols="12" class="font17 text-center">
              วันที่ {{ disburse.disburseFinaDate? ((new Date(disburse.disburseFinaDate).getDay()==0)? thaiDate(minusDate(disburse.disburseFinaDate, 2)) : ((new Date(disburse.disburseFinaDate).getDay()==6)? thaiDate(minusDate(disburse.disburseFinaDate, 1)) : thaiDate(disburse.disburseFinaDate))) : '.........../.........................../................' }}
            </v-col>
          </v-row>
        </v-col>
        <!-- <v-col cols="12" class="mt-3">
          <table width="100%" class="tableNormal">
            <tr>
              <td width="40%" class="font17" valign="top">
                1. งานพัสดุตรวจสอบรายการวัสดุ/ครุภัณฑ์<br/>
                &emsp;&emsp;<v-icon small v-if="disburse.disburseParcCheck=='ถูกต้อง'">far fa-square-check</v-icon><v-icon small v-else>far fa-square</v-icon> ถูกต้อง <span class="font17" v-if="disburse.disburseParcCheck=='ถูกต้อง'">{{ moneyFormat(disburse.disburseMoney) }} บาท</span><br>
                &emsp;&emsp;<v-icon small v-if="disburse.disburseParcCheck=='ไม่ถูกต้อง'">far fa-square-check</v-icon><v-icon small v-else>far fa-square</v-icon> ไม่ถูกต้อง
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font17 text-center">
                    ลงชื่อ <img :src="parcSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="parcSign && disburse.disburseParcCheck=='ถูกต้อง'" />
                    <span class="font-17" v-else>...............................</span>
                  </v-col>
                  <v-col cols="12" class="font17 text-center">
                    ({{ disburse.disburseParcHead? disburse.disburseParcHead : '...............................' }})
                  </v-col>
                </v-row>
              </td>
              <td class="font17" valign="top">
                2. ความเห็นหัวหน้างานวางแผนและงบประมาณ<br/>
                &emsp;เห็นควรใช้งบ:  {{ disburse.budgettypeName }} {{ String(disburse.budgetplanDes).length <65 ? disburse.budgetplanDes : String(disburse.budgetplanDes).substring(0, 65)+'...ฯ' }}<br>
                  &emsp;โครงการ: {{ disburse.disburseType=='โครงการ'? disburse.projectName : disburse.expenseplanDes }}
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font17 text-center">

                    ลงชื่อ <img :src="planSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="planSign && disburse.disbursePlanCheck=='ถูกต้อง'" />
                    <span class="font-17" v-else>...............................</span>
                  </v-col>
                  <v-col cols="12" class="font17 text-center">
                    ({{ disburse.disbursePlanHead? disburse.disbursePlanHead  : '...............................' }})
                  </v-col>
                </v-row>
              </td>
            </tr>
            <tr>
              <td class="font17" valign="top">
                3. ความเห็นหัวหน้างานการเงิน<br/>
                &emsp;&emsp;เห็นควรอนุญาตดำเนินการ<br>
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font17 text-center">
                    ลงชื่อ <img :src="finaSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="finaSign && disburse.disburseFinaCheck=='ถูกต้อง'" />
                    <span class="font-17" v-else>...............................</span>
                  </v-col>
                  <v-col cols="12" class="font17 text-center">
                    ({{ disburse.disburseFinaHead? disburse.disburseFinaHead  : '...............................' }})
                  </v-col>
                </v-row>
              </td>
              <td class="font17" valign="top">
                4. ความเห็นหัวหน้างานบัญชี<br/>
                &emsp;&emsp;เห็นควรอนุญาตดำเนินการ <span>GL-{{ disburse.ledgerID }}</span><br>
                <v-row no-gutters class="mt-1">
                  <v-col cols="12" class="font17 text-center">
                    ลงชื่อ <img :src="accoSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="accoSign && disburse.disburseAccoCheck=='ถูกต้อง'" />
                    <span class="font-17" v-else>...............................</span>
                  </v-col>
                  <v-col cols="12" class="font17 text-center">
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
        <v-col cols="12" class="font17 font-weight-bold text-center">
          แบบโครงการและประมาณการค่าใช้จ่าย
        </v-col>
        <v-col cols="12" class="mb-2 font17 font-weight-bold text-center">
          โครงการ
        </v-col>
        <v-col cols="4" class="font17" v-if="state">
          สถานศึกษา {{ state.appSubTitle }}
        </v-col>
        <v-col cols="4" class="font17" v-if="disburse.disburseType=='ค่าใช้จ่าย'">
          ฝ่าย {{ disburse.partyName }}
        </v-col>
        <v-col cols="4" class="font17" v-if="disburse.disburseType=='ค่าใช้จ่าย'">
          {{ subDepartment(disburse.departmentName) }}
        </v-col>
        <v-col cols="4" class="font17" v-if="disburse.disburseType=='โครงการ'">
          ฝ่าย {{ disburse.pjpartyName }}
        </v-col>
        <v-col cols="4" class="font17" v-if="disburse.disburseType=='โครงการ'">
          {{ subDepartment(disburse.pjdepartmentName) }}
        </v-col>
        <v-col cols="12" class="font17 mb-2">
          ภาคเรียนที่ {{ (parseInt(String(disburse.disburseDate).split('-')[1])>=5&&parseInt(String(disburse.disburseDate).split('-')[1])<=10)? '1':'2'}} &emsp;ปีการศึกษา {{ (parseInt(String(disburse.disburseDate).split('-')[1])>=5&&parseInt(String(disburse.disburseDate).split('-')[1])<=10)? parseInt(disburse.disburseYear)+543:parseInt(disburse.disburseYear)+542}}&emsp;ชื่อโครงการ {{ disburse.disburseType=='โครงการ'? disburse.projectName : disburse.expenseplanDes }} จำนวน {{ disburselists.length }} รายการ 
        </v-col>
        <v-col cols="4" class="font17">
          &emsp;&emsp;&emsp;&emsp;&emsp;ลักษณะโครงการ
        </v-col>
        <v-col cols="8" class="font17">
          <v-icon small>far fa-square</v-icon> ตามโครงการพัฒนาสถานศึกษา<br>
          <v-icon small>far fa-square</v-icon> อื่นๆ
        </v-col>
        <v-col cols="12" class="mb-3 font17 text-center">
          วันที่เริ่มต้น {{ thaiDate(disburse.disburseStart) }}&emsp;&emsp;วันที่สิ้นสุด {{ thaiDate(disburse.disburseEnd) }}
        </v-col>
        <v-col cols="5" class="font17">
          ประมาณการค่าใช้จ่ายดังนี้
          <v-row no-gutters>
            <v-col  class="font17">
              - {{ disburse.expenseName }}
            </v-col>
            <v-col class="font17 text-right pr-3">
              {{ moneyFormat(disburse.disburseMoney) }} บาท
            </v-col>
          </v-row>
          <v-row no-gutters>
            <v-col  class="font17">
              &emsp;&emsp;รวม
            </v-col>
            <v-col class="font17 text-right pr-3">
              {{ moneyFormat(disburse.disburseMoney) }} บาท
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="7" class="font17">
          <table width="100%" class="tableNormal">
            <tr>
              <td class="font17 text-center">
                ผลิตผลที่คาดว่าจะได้
              </td>
            </tr>
            <tr>
              <td class="font17 px-3"><pre class="font17">{{ disburse.disburseProduct }}</pre></td>
            </tr>
          </table>
        </v-col>
        <v-col cols="6" class="font17 text-center mt-5" v-if="disburse.disburseType=='ค่าใช้จ่าย'">
          <img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disburseSign" />
          <span class="font17" v-else>........................................</span><br>
          ({{ disburse.departmentHead }}) <br>
          หัวหน้า{{ disburse.departmentName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="6" class="font17 text-center mt-5" v-if="disburse.disburseType=='ค่าใช้จ่าย'">
          <img :src="disbursePartySign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disbursePartySign" />
          <span class="font17" v-else>........................................</span><br>
          ({{ disburse.disburseParReqName? disburse.disburseParReqName : disburse.pjpartyHead }}) <br>
          รองผู้อำนวยการฝ่าย{{ disburse.partyName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="4" class="font17 text-center mt-5" v-if="disburse.disburseType=='โครงการ' && disburse.departmentID!=disburse.pjdepartmentID">
          <img :src="disburseSign+'?t='+new Date()"style="max-width: 100px; max-height: 25px;" v-if="disburseSign" />
          <span class="font17" v-else>........................................</span><br>
          ({{ disburse.departmentHead }}) <br>
          ผู้ขอจัดซื้อ<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="4" class="font17 text-center mt-5" v-if="disburse.disburseType=='โครงการ' && disburse.departmentID!=disburse.pjdepartmentID">
          <img :src="pjdepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="pjdepartmentSign" />
          <span class="font17" v-else>........................................</span><br>
          ({{ disburse.pjdepartmentHead }}) <br>
          หัวหน้า{{ disburse.pjdepartmentName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="6" class="font17 text-center mt-5" v-else-if="disburse.disburseType=='โครงการ'">
          <img :src="pjdepartmentSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="pjdepartmentSign&&disburse.departmentSign==disburse.userID" /><img :src="disburseSign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-else-if="disburseSign" />
          <span class="font17" v-else>........................................</span><br>
         ({{ disburse.disburseReqName }}) <br>
          หัวหน้า{{ disburse.pjdepartmentName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="4" class="font17 text-center mt-5" v-if="disburse.disburseType=='โครงการ' && disburse.departmentID!=disburse.pjdepartmentID">
          <img :src="disbursePartySign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disbursePartySign" />
          <span class="font17" v-else>........................................</span><br>
          ({{ disburse.pjpartyHead }}) <br>
          รองผู้อำนวยการฝ่าย{{ disburse.pjpartyName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="6" class="font17 text-center mt-5" v-else-if="disburse.disburseType=='โครงการ'">
          <img :src="disbursePartySign+'?t='+new Date()" style="max-width: 100px; max-height: 25px;" v-if="disbursePartySign" />
          <span class="font17" v-else>........................................</span><br>
          ({{ disburse.pjpartyHead }}) <br>
          รองผู้อำนวยการฝ่าย{{ disburse.pjpartyName }}<br>
          วันที่ {{ thaiDate(disburse.disburseDate) }}
        </v-col>
        <v-col cols="12" class="mt-3 font17">
          <table width="100%" class="tableNormal">
            <thead>
              <tr>
              </tr>
              <tr>
                <th colspan="7" class="font17 text-center font-weight-bold">
                  <div class="text-right font16">รหัสคำขอจัดซื้อ DB-{{ parseInt(disburseID) }}</div>
                  ประมาณการค่าใช้จ่าย  (ค่าใช้สอย / ค่าตอบแทน / ค่าวัสดุ)
                </th>
              </tr>
              <tr>
                <th class="font17 font-weight-bold">
                  ลำดับ
                </th>
                <th class="font17 font-weight-bold">
                  รายการ
                </th>
                <th colspan="2" class="font17 font-weight-bold">
                  จำนวน<br>หน่วย
                </th>
                <th class="font17 font-weight-bold">
                  ราคาต่อหน่วย
                </th>
                <th class="font17 font-weight-bold">
                  รวมเงิน
                </th>
                <th class="font17 font-weight-bold">
                  หมายเหตุ
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="font17 text-center">1</td>
                <td class="font17">{{ disburse.expenseName }}</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
              </tr>
              <tr v-for="disburselist, index in disburselists" :key="disburselist.key">
                <td></td>
                <td class="font17">
                  1.{{index+1}} {{ disburselist.disburselistName }}
                </td>
                <td class="font17 text-right text-no-wrap">
                  {{ qtyFormat(disburselist.disburselistQty) }}
                </td>
                <td class="font17 pl-2">
                  {{ disburselist.disburselistUnit }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
                <td class="font17">
                  {{ disburselist.disburselistDes }}
                  <v-icon small color="error" v-if="disburselist.disburselistStatus=='ไม่ถูกต้อง'">fas fa-times</v-icon>
                  {{ disburselist.disburselistStatus=='ไม่ถูกต้อง' ? disburselist.disburselistCommment : '' }}
                </td>
              </tr>
              <tr v-for="disburselist, index in disburselistdis" :key="disburselist.key">
                <td></td>
                <td class="font17">
                  {{ disburselist.disburselistName }}
                </td>
                <td class="font17 text-right text-no-wrap">
                  {{ qtyFormat(disburselist.disburselistQty) }}
                </td>
                <td class="font17 pl-2">
                  {{ disburselist.disburselistUnit }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
                <td class="font17">
                  {{ disburselist.disburselistDes }}
                  <v-icon small color="error" v-if="disburselist.disburselistStatus=='ไม่ถูกต้อง'">fas fa-times</v-icon>
                  {{ disburselist.disburselistStatus=='ไม่ถูกต้อง' ? disburselist.disburselistCommment : '' }}
                </td>
              </tr>
              <tr v-if="disburse.disburseExcludeVat==1">
                <td colspan="5" class="font17 text-right">ภาษีมูลค่าเพิ่ม 7%</td>
                <td class="font17 text-right">{{ moneyFormat(disburse.disburseMoney-(disburse.disburseMoney*100/107)) }}</td>
              </tr>
              <tr>
                <td colspan="5" class="font17 text-right font-weight-bold">รวมเงิน</td>
                <td class="font17 text-right font-weight-bold">{{ moneyFormat(disburse.disburseMoney) }}</td>
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
              this.disbursePartySign = await this.getPartySignature(this.disburse.partyUserID)
            }
            if(this.disburse.userID) {
              this.disburseSign = await this.getDepartmentSignature(this.disburse.userID)
            }
            if(this.disburse.departmentSign) {
              this.pjdepartmentSign = await this.getDepartmentSignature(this.disburse.departmentSign)
            }
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
