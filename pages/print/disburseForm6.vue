<template>
  <div style="line-height: 1.8">
    <div class="printPage3x2" v-if="disburse.disburseSubtype=='ซื้อ'">
      <v-row no-gutters class="mb-2">
        <v-col cols="12" align-self="end" class="text-center font19 font-weight-bold">
            ใบสั่งซื้อ
        </v-col>
        <v-col cols="6" class="mt-5 font17">
            ผู้ขาย {{ company.companyName }}<br>
            ที่อยู่ {{ company.companyAddress }}<br>
            โทรศัพท์ {{ company.companyPhone }}<br>
            เลขประจำตัวผู้เสียภาษี {{ company.companyTaxID }}<br>
            เลขที่บัญชีเงินฝากธนาคาร {{ company.companyBankNo }}<br>
            ชื่อบัญชี {{ company.companyBankOwner }}<br>
            ธนาคาร {{ company.companyBankName }}
        </v-col>
        <v-col cols="6" class="mt-5 font17" v-if="state">
            ใบสั่งซื้อเลขที่ &nbsp; {{ disburse.orderNo }}<br>
            วันที่ &nbsp; {{  thaiDate(disburse.recDate) }} <br>
            ส่วนราชการ {{ state.appSubTitle }}<br>
            ที่อยู่ ถ.เหมืองหิต ต.ในเวียง อ.เมืองแพร่ จ.แพร่ <br>
            โทรศัพท์  054-511142,054-511530
        </v-col>
        <v-col cols="12" class="mt-3 font17" v-if="state">
            &emsp;&emsp;&emsp;&emsp;&emsp;ตามที่ {{ company.companyName }} ได้เสนอราคา ไว้ต่อ {{ state.appSubTitle }} ซึ่งได้รับราคาและตกลงซื้อ ตามรายการดังต่อไปนี้
        </v-col>
        <v-col cols="12" class="mt-3 font17">
          <table width="100%" class="tableNormal">
            <thead>
              <tr>
                <th class="font17 font-weight-bold">
                   ลำดับ
                </th>
                <th class="font17 font-weight-bold">
                  รายการ
                </th>
                <th class="font17 font-weight-bold">
                  จำนวน
                </th>
                <th class="font17 font-weight-bold">
                  หน่วย
                </th>
                <th class="font17 font-weight-bold">
                  ราคาต่อหน่วย<br>(บาท)
                </th>
                <th class="font17 font-weight-bold">
                  รวมเงิน
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="disburselist, index in disburselists" :key="disburselist.key">
                <td class="font17 text-center">{{index+1}}</td>
                <td class="font17">
                  {{ disburselist.disburselistName }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistQty }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistUnit }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
              </tr>
              <tr v-for="disburselist, index in disburselistdis" :key="disburselist.key">
                <td class="font17 text-center"></td>
                <td class="font17">
                  - {{ disburselist.disburselistName }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistQty }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistUnit }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
              </tr>
              <tr>
                <td colspan="3" rowspan="3" class="font17 font-weight-bold text-center">{{ thaiBaht(disburse.disburseMoney) }}</td>
                <td colspan="2" class="font17 font-weight-bold">รวมเป็นเงิน</td>
                <td class="font17 text-right font-weight-bold">{{ moneyFormat(disburse.disburseMoney*100/107) }}</td>
              </tr>
              <tr>
                <td colspan="2" class="font17 font-weight-bold">ภาษีมูลค่าเพิ่ม</td>
                <td class="font17 text-right font-weight-bold">{{ moneyFormat(disburse.disburseMoney-(disburse.disburseMoney*100/107)) }}</td>
              </tr>
              <tr>
                <td colspan="2" class="font17 font-weight-bold">รวมเป็นเงินทั้งสิ้น</td>
                <td class="font17 text-right font-weight-bold">{{ moneyFormat(disburse.disburseMoney) }}</td>
              </tr>
            </tbody>
          </table>
        </v-col>
        <v-col cols="12" class="mt-3 font17">
            การซื้อ อยู่ภายใต้เงื่อนไขต่อไปนี้<br>
            1.  กำหนดส่งมอบภายใน {{ disburse.orderSendDay }} วันทำการ นับจากวันที่ผู้ขายได้รับใบสั่งซื้อ<br>
            2.  ครบกำหนดส่งมอบวันที่ {{ thaiDate(disburse.orderSendDate) }}<br>
            3.  สถานที่ส่งมอบ  วิทยาลัยเทคนิคแพร่ ถนนเหมืองหิต<br>
            4.  ระยะเวลารับประกัน  -<br>
            5.  สงวนสิทธ์ค่าปรับกรณีส่งมอบเกินกำหนด โดยคิดค่าปรับเป็นรายวันในอัตราร้อยละ 0.20 ของราคาสิ่งของที่ยังไม่ได้รับมอบ<br>
            6.  ส่วนราชการสงวนสิทธิ์ที่จะไม่รับมอบถ้าปรากฏว่าสินค้านั้นมีลักษณะไม่ตรงตามรายการที่ระบุไว้ในใบสั่งซื้อ กรณีนี้ผู้ขายจะต้องดำเนินการเปลี่ยนใหม่ให้ถูกต้องตามใบสั่งซื้อทุกประการ<br>
            7.  การประเมินผลการปฏิบัติงานของผู้ประกอบการ หน่วยงานของรัฐสามารถนำผลการปฏิบัติงานแล้วเสร็จตามสัญญาหรือข้อตกลงของคู่สัญญาเพื่อนำมาประเมินผลการปฏิบัติงานของผู้ประกอบการ<br>
            <u class="mt-2 font17">หมายเหตุ :</u><br>
            1. การติดอากรแสตมป์ให้เป็นไปตามประมวลกฎหมายรัษฎากร หากต้องการให้ใบสั่งซื้อมีผลตามกฎหมาย<br>
            2. ใบสั่งซื้อนี้ ซื้อ<span class="font17" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span><span class="font17" v-if="disburse.disburseType=='ค่าใช้จ่าย'"> {{ subDepartment(disburse.departmentName) }}</span><span class="font17" v-if="disburse.disburseType=='โครงการ'"> {{ disburse.projectName }} {{ subDepartment(disburse.pjdepartmentName) }}</span> จำนวน {{ disburselists.length }} รายการ โดยวิธีเฉพาะเจาะจง
        </v-col>
        <v-col cols="8" class="mt-10 ml-auto font17 text-center">
          <div class="mt-3 font17">ลงชื่อ........................................ผู้สั่งซื้อ</div>
          ({{ directorName }})<br>
          ผู้อำนวยการวิทยาลัยเทคนิคแพร่<br>
          วันที่ {{ disburse.recDate? thaiDate(disburse.recDate) : '.........../.........................../................' }}
        </v-col>
        <v-col cols="8" class="mt-5 ml-auto font17 text-center">
          <div class="mt-3 font17">ลงชื่อ........................................ผู้รับใบสั่งซื้อ</div>
          ({{ company.companyOwner }})<br>
          ผู้จัดการ<br>
          วันที่ {{ disburse.recDate? thaiDate(disburse.recDate) : '.........../.........................../................' }}
        </v-col>
      </v-row>
    </div>

    <div class="printPage3x2" v-if="disburse.disburseSubtype=='จ้าง'">
      <v-row no-gutters class="mb-2">
        <v-col cols="12" align-self="end" class="text-center font19 font-weight-bold">
            ใบสั่งจ้าง
        </v-col>
        <v-col cols="6" class="mt-5 font17">
            ผู้รับจ้าง {{ company.companyName }}<br>
            ที่อยู่ {{ company.companyAddress }}<br>
            โทรศัพท์ {{ company.companyPhone }}<br>
            เลขประจำตัวผู้เสียภาษี {{ company.companyTaxID }}<br>
            เลขที่บัญชีเงินฝากธนาคาร {{ company.companyBankNo }}<br>
            ชื่อบัญชี {{ company.companyBankOwner }}<br>
            ธนาคาร {{ company.companyBankName }}
        </v-col>
        <v-col cols="6" class="mt-5 font17" v-if="state">
            ใบสั่งจ้างเลขที่ &nbsp; {{ disburse.orderNo }}<br>
            วันที่ &nbsp; {{  thaiDate(disburse.recDate) }} <br>
            ส่วนราชการ {{ state.appSubTitle }}<br>
            ที่อยู่ ถ.เหมืองหิต ต.ในเวียง อ.เมืองแพร่ จ.แพร่ <br>
            โทรศัพท์  054-511142,054-511530
        </v-col>
        <v-col cols="12" class="mt-3 font17" v-if="state">
            &emsp;&emsp;&emsp;&emsp;&emsp;ตามที่ {{ company.companyName }} ได้เสนอราคา ไว้ต่อ {{ state.appSubTitle }} ซึ่งได้รับราคาและตกลงจ้าง ตามรายการดังต่อไปนี้
        </v-col>
        <v-col cols="12" class="mt-3 font17">
          <table width="100%" class="tableNormal">
            <thead>
              <tr>
                <th class="font17 font-weight-bold">
                   ลำดับ
                </th>
                <th class="font17 font-weight-bold">
                  รายการ
                </th>
                <th class="font17 font-weight-bold">
                  จำนวน
                </th>
                <th class="font17 font-weight-bold">
                  หน่วย
                </th>
                <th class="font17 font-weight-bold">
                  ราคาต่อหน่วย<br>(บาท)
                </th>
                <th class="font17 font-weight-bold">
                  รวมเงิน
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="disburselist, index in disburselists" :key="disburselist.key">
                <td class="font17 text-center">{{index+1}}</td>
                <td class="font17">
                  {{ disburselist.disburselistName }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistQty }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistUnit }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
              </tr>
              <tr v-for="disburselist, index in disburselistdis" :key="disburselist.key">
                <td class="font17 text-center"></td>
                <td class="font17">
                  - {{ disburselist.disburselistName }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistQty }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistUnit }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
              </tr>
              <tr>
                <td colspan="3" rowspan="3" class="font17 font-weight-bold text-center">{{ thaiBaht(disburse.disburseMoney) }}</td>
                <td colspan="2" class="font17 font-weight-bold">รวมเป็นเงิน</td>
                <td class="font17 text-right font-weight-bold">{{ moneyFormat(disburse.disburseMoney-(disburse.disburseMoney*0.07)) }}</td>
              </tr>
              <tr>
                <td colspan="2" class="font17 font-weight-bold">ภาษีมูลค่าเพิ่ม</td>
                <td class="font17 text-right font-weight-bold">{{ moneyFormat(disburse.disburseMoney*0.07) }}</td>
              </tr>
              <tr>
                <td colspan="2" class="font17 font-weight-bold">รวมเป็นเงินทั้งสิ้น</td>
                <td class="font17 text-right font-weight-bold">{{ moneyFormat(disburse.disburseMoney) }}</td>
              </tr>
            </tbody>
          </table>
        </v-col>
        <v-col cols="12" class="mt-3 font17">
            การจ้าง อยู่ภายใต้เงื่อนไขต่อไปนี้<br>
            1.  กำหนดส่งมอบภายใน {{ disburse.orderSendDay }} วันทำการ นับจากวันที่ผู้รับจ้างได้รับใบสั่งจ้าง<br>
            2.  ครบกำหนดส่งมอบวันที่ {{ thaiDate(disburse.orderSendDate) }}<br>
            3.  สถานที่ส่งมอบ  วิทยาลัยเทคนิคแพร่ ถนนเหมืองหิต<br>
            4.  ระยะเวลารับประกัน  -<br>
            5.  สงวนสิทธ์ค่าปรับกรณีส่งมอบเกินกำหนด โดยคิดค่าปรับเป็นรายวันในอัตราร้อยละ 0.1 ของราคาสิ่งของที่ยังไม่ได้รับมอบแต่จะต้องไม่ต่ำกว่ากันวันละ 100.00 บาท<br>
            6.   ส่วนราชการสงวนสิทธิ์ที่จะไม่รับมอบถ้าปรากฏว่าสินค้านั้นมีลักษณะไม่ตรงตามรายการที่ระบุไว้ในใบสั่งจ้าง กรณีนี้ผู้รับจ้างจะต้องดำเนินการเปลี่ยนใหม่ให้ถูกต้องตามใบสั่งจ้างทุกประการ<br>
            7.  กรณีงานจ้าง ผู้จ้างจะต้องไม่เอางานทั้งหมดหรือแต่บางส่วนแห่งสัญญานี้ไปจ้างช่วงอีกทอดหนึ่ง เว้นแต่การจ้างช่วงงาน แต่บางส่วนที่ได้รับอนุญาตเป็นหนังสือจากผู้ว่าจ้างแล้ว การที่ผู้ว่าจ้างได้อนุญาตให้จ้างช่วงงานแต่บางส่วนดังกล่าวนั้น ไม่เป็นเหตุให้ผู้รับจ้างหลุดพ้นจากความได้รับผิดหรือพันธะหน้าที่ตามสัญญานี้ และผู้รับจ้างจะยังคงต้องรับผิดในความผิด และความประมาทเลินเล่อของผู้รับจ้าง หรืองของตัวแทนหรือลูกจ้างของผู้รับจ้างช่วงนั้นทุกประการ กรณีผู้รับจ้างไปจ้างช่วงงาน แต่บางส่วนโดยฝ่าฝืนความในวรรคหนึ่ง ผู้รับจ้างต้องชำระค่าปรับให้แก่ผู้ว่าจ้างเป็นจำนวนเงินในอัตราร้อยละ 10 (สิบ) ของวงเงินของงานที่จ้างช่วงตามสัญญา ทั้งนี้ ไม่ตัดสิทธิผู้ว่าจ้างในการบอกเลิกสัญญา<br>
            8.  การประเมินผลการปฏิบัติงานของผู้ประกอบการ หน่วยงานของรัฐสามารถนำผลการปฏิบัติงานแล้วเสร็จตามสัญญา หรือข้อตกลงของคู่สัญญาเพื่อนำมาประเมินผลการปฏิบัติงานของผู้ประกอบการ<br>
            <u class="mt-2 font17">หมายเหตุ :</u><br>
            1. การติดอากรแสตมป์ให้เป็นไปตามประมวลกฎหมายรัษฎากร หากต้องการให้ใบสั่งจ้างมีผลตามกฎหมาย<br>
            2. ใบสั่งจ้างนี้ จ้าง<span class="font17" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span><span class="font17" v-if="disburse.disburseType=='ค่าใช้จ่าย'"> {{ subDepartment(disburse.departmentName) }}</span><span class="font17" v-if="disburse.disburseType=='โครงการ'"> {{ disburse.projectName }} {{ subDepartment(disburse.pjdepartmentName) }}</span> จำนวน {{ disburselists.length }} รายการ โดยวิธีเฉพาะเจาะจง
        </v-col>
        <v-col cols="8" class="mt-10 ml-auto font17 text-center">
          <div class="mt-3 font17">ลงชื่อ........................................ผู้สั่งจ้่าง</div>
          ({{ directorName }})<br>
          ผู้อำนวยการวิทยาลัยเทคนิคแพร่<br>
          วันที่ {{ disburse.recDate? thaiDate(disburse.recDate) : '.........../.........................../................' }}
        </v-col>
        <v-col cols="8" class="mt-5 ml-auto font17 text-center">
          <div class="mt-3 font17">ลงชื่อ........................................ผู้รับใบสั่งจ้าง</div>
          ({{ company.companyOwner }})<br>
          ผู้จัดการ<br>
          วันที่ {{ disburse.recDate? thaiDate(disburse.recDate) : '.........../.........................../................' }}
        </v-col>
      </v-row>
    </div>

    <div class="printPage3x2" v-if="disburse.disburseSubtype=='เช่า'">
      <v-row no-gutters class="mb-2">
        <v-col cols="12" align-self="end" class="text-center font19 font-weight-bold">
          ใบสั่งเช่า
        </v-col>
        <v-col cols="6" class="mt-5 font17">
            ผู้รับเช่า {{ company.companyName }}<br>
            ที่อยู่ {{ company.companyAddress }}<br>
            โทรศัพท์ {{ company.companyPhone }}<br>
            เลขประจำตัวผู้เสียภาษี {{ company.companyTaxID }}<br>
            เลขที่บัญชีเงินฝากธนาคาร {{ company.companyBankNo }}<br>
            ชื่อบัญชี {{ company.companyBankOwner }}<br>
            ธนาคาร {{ company.companyBankName }}
        </v-col>
        <v-col cols="6" class="mt-5 font17" v-if="state">
            ใบสั่งเช่าเลขที่ &nbsp; {{ disburse.orderNo }}<br>
            วันที่  &nbsp; {{  thaiDate(disburse.recDate) }}<br>
            ส่วนราชการ {{ state.appSubTitle }}<br>
            ที่อยู่ ถ.เหมืองหิต ต.ในเวียง อ.เมืองแพร่ จ.แพร่ <br>
            โทรศัพท์  054-511142,054-511530
        </v-col>
        <v-col cols="12" class="mt-3 font17" v-if="state">
            &emsp;&emsp;&emsp;&emsp;&emsp;ตามที่ {{ company.companyName }} ได้เสนอราคา ไว้ต่อ {{ state.appSubTitle }} ซึ่งได้รับราคาและตกลงเช่า ตามรายการดังต่อไปนี้
        </v-col>
        <v-col cols="12" class="mt-3 font17">
          <table width="100%" class="tableNormal">
            <thead>
              <tr>
                <th class="font17 font-weight-bold">
                   ลำดับ
                </th>
                <th class="font17 font-weight-bold">
                  รายการ
                </th>
                <th class="font17 font-weight-bold">
                  จำนวน
                </th>
                <th class="font17 font-weight-bold">
                  หน่วย
                </th>
                <th class="font17 font-weight-bold">
                  ราคาต่อหน่วย<br>(บาท)
                </th>
                <th class="font17 font-weight-bold">
                  รวมเงิน
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="disburselist, index in disburselists" :key="disburselist.key">
                <td class="font17 text-center">{{index+1}}</td>
                <td class="font17">
                  {{ disburselist.disburselistName }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistQty }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistUnit }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
              </tr>
              <tr v-for="disburselist, index in disburselistdis" :key="disburselist.key">
                <td class="font17 text-center"></td>
                <td class="font17">
                  - {{ disburselist.disburselistName }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistQty }}
                </td>
                <td class="font17 text-center">
                    {{ disburselist.disburselistUnit }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistPrice) }}
                </td>
                <td class="font17 text-right  text-no-wrap">
                  {{ moneyFormat(disburselist.disburselistQty*disburselist.disburselistPrice) }}
                </td>
              </tr>
              <tr>
                <td colspan="3" rowspan="3" class="font17 font-weight-bold text-center">{{ thaiBaht(disburse.disburseMoney) }}</td>
                <td colspan="2" class="font17 font-weight-bold">รวมเป็นเงิน</td>
                <td class="font17 text-right font-weight-bold">{{ moneyFormat(disburse.disburseMoney-(disburse.disburseMoney*0.07)) }}</td>
              </tr>
              <tr>
                <td colspan="2" class="font17 font-weight-bold">ภาษีมูลค่าเพิ่ม</td>
                <td class="font17 text-right font-weight-bold">{{ moneyFormat(disburse.disburseMoney*0.07) }}</td>
              </tr>
              <tr>
                <td colspan="2" class="font17 font-weight-bold">รวมเป็นเงินทั้งสิ้น</td>
                <td class="font17 text-right font-weight-bold">{{ moneyFormat(disburse.disburseMoney) }}</td>
              </tr>
            </tbody>
          </table>
        </v-col>
        <v-col cols="12" class="mt-3 font17">
            การเช่า อยู่ภายใต้เงื่อนไขต่อไปนี้<br>
            1.  กำหนดส่งมอบภายใน {{ disburse.orderSendDay }} วันทำการ นับจากวันที่ผู้รับเช่าได้รับใบสั่งเช่า<br>
            2.  ครบกำหนดส่งมอบวันที่ {{ thaiDate(disburse.orderSendDate) }}<br>
            3.  สถานที่ส่งมอบ  วิทยาลัยเทคนิคแพร่ ถนนเหมืองหิต<br>
            4.  ระยะเวลารับประกัน  -<br>
            5.  สงวนสิทธ์ค่าปรับกรณีส่งมอบเกินกำหนด โดยคิดค่าปรับเป็นรายวันในอัตราร้อยละ 0.10 ของราคางานเช่าแต่ต้องไม่ต่ำกว่าวันละ 100.00 บาท<br>
            6.   ส่วนราชการสงวนสิทธิ์ที่จะไม่รับมอบถ้าปรากฏว่าสินค้านั้นมีลักษณะไม่ตรงตามรายการที่ระบุไว้ในใบสั่งเช่า กรณีนี้ผู้รับเช่าจะต้องดำเนินการเปลี่ยนใหม่ให้ถูกต้องตามใบสั่งเช่าทุกประการ<br>
            <u class="mt-2 font17">หมายเหตุ :</u><br>
            1. การติดอากรแสตมป์ให้เป็นไปตามประมวลกฎหมายรัษฎากร หากต้องการให้ใบสั่งเช่ามีผลตามกฎหมาย<br>
            2. ใบสั่งเช่านี้ เช่า<span class="font17" v-if="disburse.disburseSubtype=='ซื้อ'">{{ disburse.disburseType=='โครงการ'? disburse.expenseName.replace('ค่า', '') : disburse.expenseplanDes.replace('ค่า', '') }}</span><span class="font17" v-if="disburse.disburseType=='ค่าใช้จ่าย'"> {{ subDepartment(disburse.departmentName) }}</span><span class="font17" v-if="disburse.disburseType=='โครงการ'"> {{ disburse.projectName }} {{ subDepartment(disburse.pjdepartmentName) }}</span> จำนวน {{ disburselists.length }} รายการ โดยวิธีเฉพาะเจาะจง
        </v-col>
        <v-col cols="8" class="mt-10 ml-auto font17 text-center">
          <div class="mt-3 font17">ลงชื่อ........................................ผู้สั่งเช่า</div>
          ({{ directorName }})<br>
          ผู้อำนวยการวิทยาลัยเทคนิคแพร่<br>
          วันที่ {{ disburse.recDate? thaiDate(disburse.recDate) : '.........../.........................../................' }}
        </v-col>
        <v-col cols="8" class="mt-5 ml-auto font17 text-center">
          <div class="mt-3 font17">ลงชื่อ........................................ผู้รับใบสั่งเช่า</div>
          ({{ company.companyOwner }})<br>
          ผู้จัดการ<br>
          วันที่ {{ disburse.recDate? thaiDate(disburse.recDate) : '.........../.........................../................' }}
        </v-col>
      </v-row>
    </div>
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
        parcelName: null,
        financeName: null,
        dedirectorName: null,
        directorName: null,
        disburse: {},
        company: {},
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
    await this.getName()
    await this.getCompany()
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

    async getName() {
      let token = this.$store.state.jwtToken
      await this.$axios.$get('party.php', {
        params: {
          token: token,
          partyName: 'อำนวยการ'
        }
      }).then(result=> {
        if(result.message == 'Success') {
          this.directorName = result.party.partyHead
        }
      })

      await this.$axios.$get('party.php', {
        params: {
          token: token,
          partyName: 'บริหารทรัพยากร'
        }
      }).then(result=> {
        if(result.message == 'Success') {
          this.dedirectorName = result.party.partyHead
        }
      })

      await this.$axios.$get('department.php', {
        params: {
          token: token,
          departmentSys: 'Parcel'
        }
      }).then(result=> {
        if(result.message == 'Success') {
          if(result.department.length>0){
            this.parcelName = result.department[0].departmentHead
          }
        }
      })

      await this.$axios.$get('department.php', {
        params: {
          token: token,
          departmentSys: 'Finance'
        }
      }).then(result=> {
        if(result.message == 'Success') {
          if(result.department.length>0){
            this.financeName = result.department[0].departmentHead
          }
        }
      })
    },

    async getCompany(){
        await this.$axios.$get('company.php', {
        params: {
          token: this.$store.state.jwtToken,
          companyID: this.disburse.companyID
        }
      }).then(result=> {
        if(result.message == 'Success') {
            this.company = result.company
        }
      })
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

    addDays(inDate, days) {
        let result = ''
        if(inDate) {
            let thdate = new Date(inDate)
            thdate.setDate(thdate.getDate() + days)
            result = thdate.toLocaleDateString('th-TH', {
          year: 'numeric',
          month: 'long',
          day: 'numeric',
        })
        }
        return result;
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
