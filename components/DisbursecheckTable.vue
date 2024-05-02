<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>ตรวจสอบรายการจัดซื้อ/เบิกเงิน ประจำปีงบประมาณ พ.ศ.{{ parseInt(disburseYear)+543 }}</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-tabs
              v-model="tab"
              grow
              slider-color="orange darken-3"
              background-color="green lighten-5"
            >
              <v-tab>
                <b class="primary--text">รอตรวจสอบ({{ CheckDisburses.length }})</b>
              </v-tab>
              <v-tab>
                <b class="primary--text">ถูกต้อง({{ CorrectDisburses.length }})</b>
              </v-tab>
              <v-tab>
                <b class="success--text">ไม่ถูกต้อง({{ WrongDisburses.length }})</b>
              </v-tab>
              <v-tab>
                <b class="grey--text text--darken-2">ทั้งหมด({{ disburses.length }})</b>
              </v-tab>
            </v-tabs>
            <v-tabs-items
              v-model="tab"
            >
            <v-tab-item class="py-5">
                <!-- รอตรวจสอบ -->
                <v-data-table
                  :headers="headers"
                  :items="CheckDisburses"
                  :search="Reqsearch"
                  :items-per-page="50"
                  :loading="disbursesLoading"
                  :footer-props="{
                    showFirstLastPage: true,
                  }"
                >
                  <template v-slot:top>
                    <v-row>
                      <v-col cols="12" md="6" class="text-center">
                        <h3 class="mb-2 fontBold text-center">รายการที่ขอซื้อ {{ CheckDisburses.length }} รายการ {{ moneyFormat(budgetSum.disburseReqMoney) }} บาท</h3>
                        <v-btn icon color="primary" :to="'/print/disbursetableReport/?year='+disburseYear+'&disp=plan'" target="_blank" v-if="departmentSys=='Admin'||departmentSys=='Director'||departmentSys=='Plan'||departmentSys=='Finance'" class="ml-2">
                          <v-icon>fas fa-print</v-icon>
                        </v-btn>
                      </v-col>
                      <v-col cols="12" md="6">
                        <v-text-field
                          v-model="Plansearch"
                          append-icon="mdi-magnify"
                          label="ค้นหา"
                          hide-details
                          outlined
                          dense
                        ></v-text-field>
                      </v-col>
                    </v-row>
                  </template>

                  <template v-slot:item.disburseID="{ item }">
                    <div  class="text-no-wrap">DB-{{ parseInt(item.disburseID) }}</div>
                  </template>
                  <template v-slot:item.disburseYear="{ item }">
                    {{ parseInt(item.disburseYear)+543 }}
                  </template>
                  <template v-slot:item.disburseMoney="{ item }">
                    <span class="error--text text--darken-2" v-if="item.disburseStatus=='ยกเลิก'">{{ moneyFormat(item.disburseMoney) }}</span>
                    <span class="success--text text--darken-3 font-weight-bold" v-else-if="item.disburseStatus=='เบิกจ่ายแล้ว'">{{ moneyFormat(item.disburseFinMoney) }}</span>
                    <span class="primary--text text--darken-2" v-else-if="(item.disburseParcCheck=='ถูกต้อง'&&item.disburseAccoCheck=='ถูกต้อง'&&item.disbursePlanCheck=='ถูกต้อง'&&item.disburseFinaCheck=='ถูกต้อง') || item.disburseStatus=='ตัดแผนแล้ว'">{{ moneyFormat(item.disburseMoney) }}</span>
                    <span v-else>{{ moneyFormat(item.disburseMoney) }}</span>
                  </template>
                  <template v-slot:item.disburseDate="{ item }">
                    {{ thaiDateBf(item.disburseDate) }}
                  </template>
                  <template v-slot:item.disburseFinDate="{ item }">
                    {{ thaiDateBf(item.disburseFinDate) }}
                  </template>
                  <template v-slot:item.disburseParcCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseParcCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseParcCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disbursePlanCheck="{ item }">
                    <v-icon small color="success" v-if="item.disbursePlanCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disbursePlanCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disburseAccoCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseAccoCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseAccoCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disburseFinaCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseFinaCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseFinaCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.actions="{ item }">
                    <div>
                      <v-chip color="grey darken-3" outlined x-small v-if="item.disburseStatus=='ขอซื้อ'">
                        <v-icon x-small class="mr-1">fas fa-pen</v-icon> ขอซื้อ
                      </v-chip>
                      <v-chip color="yellow" x-small v-if="item.disburseStatus=='ตรวจสอบรายการ'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> รอตรวจสอบ
                      </v-chip>
                      <v-chip color="red darken-2 white--text" x-small v-if="item.disburseStatus=='ไม่ถูกต้อง'">
                        <v-icon x-small class="mr-1">fas fa-times</v-icon> ไม่ถูกต้อง
                      </v-chip>
                      <v-chip color="primary" x-small v-if="item.disburseStatus=='รอยืนยันจัดซื้อ'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> รอยืนยันจัดซื้อ
                      </v-chip>
                      <v-chip color="success darken-3" outlined x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" outlined x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" outlined x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </div>
                    <div  class="text-no-wrap">
                      <v-btn color="green darken-2" icon  small @click="showDisburselistListDialog(item)">
                        <v-icon small class="mr-1">fas fa-list</v-icon>
                      </v-btn>
                    </div>
                  </template>
                  <template slot="body.append">
                    <tr>
                      <td colspan="3" class="fontBold text-center">รวม</td>
                      <td class="fontBold text-right">{{ moneyFormat(budgetSum.disburseReqMoney) }}</td>
                      <!-- <td class="fontBold text-right">{{ moneyFormat(budgetSum.budgetrealMoney) }} บาท</td> -->
                      <td></td>
                    </tr>
                  </template>
                </v-data-table>
              </v-tab-item>
              <v-tab-item class="py-5">
                <!-- ถูกต้อง -->
                <v-data-table
                  :headers="headers"
                  :items="CorrectDisburses"
                  :search="Plansearch"
                  :items-per-page="50"
                  :loading="disbursesLoading"
                  :footer-props="{
                    showFirstLastPage: true,
                  }"
                >
                  <template v-slot:top>
                    <v-row>
                      <v-col cols="12" md="6" class="text-center">
                        <h3 class="mb-2 fontBold text-center">ตรวจสอบถูกต้องแล้ว {{ CorrectDisburses.length }} รายการ {{ moneyFormat(budgetSum.disbursePlanMoney) }} บาท</h3>
                        <v-btn icon color="primary" :to="'/print/disbursetableReport/?year='+disburseYear+'&disp=plan'" target="_blank" v-if="departmentSys=='Admin'||departmentSys=='Director'||departmentSys=='Plan'||departmentSys=='Finance'" class="ml-2">
                          <v-icon>fas fa-print</v-icon>
                        </v-btn>
                      </v-col>
                      <v-col cols="12" md="6">
                        <v-text-field
                          v-model="Plansearch"
                          append-icon="mdi-magnify"
                          label="ค้นหา"
                          hide-details
                          outlined
                          dense
                        ></v-text-field>
                      </v-col>
                    </v-row>
                  </template>

                  <template v-slot:item.disburseID="{ item }">
                    <div  class="text-no-wrap">DB-{{ parseInt(item.disburseID) }}</div>
                  </template>
                  <template v-slot:item.disburseYear="{ item }">
                    {{ parseInt(item.disburseYear)+543 }}
                  </template>
                  <template v-slot:item.disburseMoney="{ item }">
                    <span class="error--text text--darken-2" v-if="item.disburseStatus=='ยกเลิก'">{{ moneyFormat(item.disburseMoney) }}</span>
                    <span class="success--text text--darken-3 font-weight-bold" v-else-if="item.disburseStatus=='เบิกจ่ายแล้ว'">{{ moneyFormat(item.disburseFinMoney) }}</span>
                    <span class="primary--text text--darken-2" v-else-if="(item.disburseParcCheck=='ถูกต้อง'&&item.disburseAccoCheck=='ถูกต้อง'&&item.disbursePlanCheck=='ถูกต้อง'&&item.disburseFinaCheck=='ถูกต้อง') || item.disburseStatus=='ตัดแผนแล้ว'">{{ moneyFormat(item.disburseMoney) }}</span>
                    <span v-else>{{ moneyFormat(item.disburseMoney) }}</span>
                  </template>
                  <template v-slot:item.disburseDate="{ item }">
                    {{ thaiDateBf(item.disburseDate) }}
                  </template>
                  <template v-slot:item.disburseFinDate="{ item }">
                    {{ thaiDateBf(item.disburseFinDate) }}
                  </template>
                  <template v-slot:item.disburseParcCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseParcCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseParcCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disbursePlanCheck="{ item }">
                    <v-icon small color="success" v-if="item.disbursePlanCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disbursePlanCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disburseAccoCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseAccoCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseAccoCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disburseFinaCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseFinaCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseFinaCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.actions="{ item }">
                    <div>
                      <v-chip color="grey darken-3" outlined x-small v-if="item.disburseStatus=='ขอซื้อ'">
                        <v-icon x-small class="mr-1">fas fa-pen</v-icon> ขอซื้อ
                      </v-chip>
                      <v-chip color="yellow" x-small v-if="item.disburseStatus=='ตรวจสอบรายการ'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> รอตรวจสอบ
                      </v-chip>
                      <v-chip color="red darken-2 white--text" x-small v-if="item.disburseStatus=='ไม่ถูกต้อง'">
                        <v-icon x-small class="mr-1">fas fa-times</v-icon> ไม่ถูกต้อง
                      </v-chip>
                      <v-chip color="primary" x-small v-if="item.disburseStatus=='รอยืนยันจัดซื้อ'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> รอยืนยันจัดซื้อ
                      </v-chip>
                      <v-chip color="success darken-3" outlined x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" outlined x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" outlined x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </div>
                    <div  class="text-no-wrap">
                      <v-btn color="green darken-2" icon  small @click="showDisburselistListDialog(item)">
                        <v-icon small class="mr-1">fas fa-list</v-icon>
                      </v-btn>
                    </div>
                  </template>
                  <template slot="body.append">
                    <tr>
                      <td colspan="3" class="fontBold text-center">รวม</td>
                      <td class="fontBold text-right">{{ moneyFormat(budgetSum.disbursePlanMoney) }}</td>
                      <!-- <td class="fontBold text-right">{{ moneyFormat(budgetSum.budgetrealMoney) }} บาท</td> -->
                      <td></td>
                    </tr>
                  </template>
                </v-data-table>
              </v-tab-item>
              <v-tab-item class="py-5">
                <!-- ไม่ถูกต้อง -->
                <v-data-table
                  :headers="headers"
                  :items="WrongDisburses"
                  :search="Completesearch"
                  :items-per-page="50"
                  :loading="disbursesLoading"
                  :footer-props="{
                    showFirstLastPage: true,
                  }"
                >
                  <template v-slot:top>
                    <v-row>
                      <v-col cols="12" md="6" class="text-center">
                        <h3 class="mb-2 fontBold text-center">รายการที่เบิกจ่ายแล้ว {{ WrongDisburses.length }} รายการ {{ moneyFormat(budgetSum.disburseCompleteMoney) }} บาท</h3>
                        <v-btn icon color="primary" :to="'/print/disbursetableReport/?year='+disburseYear+'&disp=complete'" target="_blank" v-if="departmentSys=='Admin'||departmentSys=='Director'||departmentSys=='Plan'||departmentSys=='Finance'" class="ml-2">
                          <v-icon>fas fa-print</v-icon>
                        </v-btn>
                      </v-col>
                      <v-col cols="12" md="6">
                        <v-text-field
                          v-model="Completesearch"
                          append-icon="mdi-magnify"
                          label="ค้นหา"
                          hide-details
                          outlined
                          dense
                        ></v-text-field>
                      </v-col>
                    </v-row>
                  </template>

                  <template v-slot:item.disburseID="{ item }">
                    <div  class="text-no-wrap">DB-{{ parseInt(item.disburseID) }}</div>
                  </template>
                  <template v-slot:item.disburseYear="{ item }">
                    {{ parseInt(item.disburseYear)+543 }}
                  </template>
                  <template v-slot:item.disburseMoney="{ item }">
                    <span class="error--text text--darken-2" v-if="item.disburseStatus=='ยกเลิก'">{{ moneyFormat(item.disburseMoney) }}</span>
                    <span class="success--text text--darken-3 font-weight-bold" v-else-if="item.disburseStatus=='เบิกจ่ายแล้ว'">{{ moneyFormat(item.disburseFinMoney) }}</span>
                    <span class="primary--text text--darken-2" v-else-if="(item.disburseParcCheck=='ถูกต้อง'&&item.disburseAccoCheck=='ถูกต้อง'&&item.disbursePlanCheck=='ถูกต้อง'&&item.disburseFinaCheck=='ถูกต้อง') || item.disburseStatus=='ตัดแผนแล้ว'">{{ moneyFormat(item.disburseMoney) }}</span>
                    <span v-else>{{ moneyFormat(item.disburseMoney) }}</span>
                  </template>
                  <template v-slot:item.disburseDate="{ item }">
                    {{ thaiDateBf(item.disburseDate) }}
                  </template>
                  <template v-slot:item.disburseFinDate="{ item }">
                    {{ thaiDateBf(item.disburseFinDate) }}
                  </template>
                  <template v-slot:item.disburseParcCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseParcCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseParcCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disbursePlanCheck="{ item }">
                    <v-icon small color="success" v-if="item.disbursePlanCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disbursePlanCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disburseAccoCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseAccoCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseAccoCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disburseFinaCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseFinaCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseFinaCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.actions="{ item }">
                    <div>
                      <v-chip color="grey darken-3" outlined x-small v-if="item.disburseStatus=='ขอซื้อ'">
                        <v-icon x-small class="mr-1">fas fa-pen</v-icon> ขอซื้อ
                      </v-chip>
                      <v-chip color="yellow" x-small v-if="item.disburseStatus=='ตรวจสอบรายการ'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> รอตรวจสอบ
                      </v-chip>
                      <v-chip color="red darken-2 white--text" x-small v-if="item.disburseStatus=='ไม่ถูกต้อง'">
                        <v-icon x-small class="mr-1">fas fa-times</v-icon> ไม่ถูกต้อง
                      </v-chip>
                      <v-chip color="primary" x-small v-if="item.disburseStatus=='รอยืนยันจัดซื้อ'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> รอยืนยันจัดซื้อ
                      </v-chip>
                      <v-chip color="success darken-3" outlined x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" outlined x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" outlined x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </div>
                    <div  class="text-no-wrap">
                      <v-btn color="green darken-2" icon  small @click="showDisburselistListDialog(item)">
                        <v-icon small class="mr-1">fas fa-list</v-icon>
                      </v-btn>
                    </div>
                  </template>
                  <template slot="body.append">
                    <tr>
                      <td colspan="3" class="fontBold text-center">รวม</td>
                      <td class="fontBold text-right">{{ moneyFormat(budgetSum.disburseCompleteMoney) }}</td>
                      <td></td>
                    </tr>
                  </template>
                </v-data-table>
              </v-tab-item>
              <v-tab-item class="py-5">
                <!-- ทั้งหมด -->
                <v-data-table
                  :headers="headers"
                  :items="disburses"
                  :search="search"
                  :items-per-page="50"
                  :loading="disbursesLoading"
                  :footer-props="{
                    showFirstLastPage: true,
                  }"
                >
                  <template v-slot:top>
                    <v-row>
                      <v-col cols="12" md="6" class="text-center">
                        <h3 class="mb-2 fontBold text-center">รายการทั้งหมด {{ budgetSum.disburseQty }} รายการ {{ moneyFormat(budgetSum.disburseMoney) }} บาท</h3>
                        <v-btn icon color="primary" :to="'/print/disbursetableReport/?year='+disburseYear+'&disp=all'" target="_blank" v-if="departmentSys=='Admin'||departmentSys=='Director'||departmentSys=='Plan'||departmentSys=='Finance'" class="ml-2">
                          <v-icon>fas fa-print</v-icon>
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

                  <template v-slot:item.disburseID="{ item }">
                    <div  class="text-no-wrap">DB-{{ parseInt(item.disburseID) }}</div>
                  </template>
                  <template v-slot:item.disburseYear="{ item }">
                    {{ parseInt(item.disburseYear)+543 }}
                  </template>
                  <template v-slot:item.disburseMoney="{ item }">
                    <span class="error--text text--darken-2" v-if="item.disburseStatus=='ยกเลิก'">{{ moneyFormat(item.disburseMoney) }}</span>
                    <span class="success--text text--darken-3 font-weight-bold" v-else-if="item.disburseStatus=='เบิกจ่ายแล้ว'">{{ moneyFormat(item.disburseFinMoney) }}</span>
                    <span class="primary--text text--darken-2" v-else-if="(item.disburseParcCheck=='ถูกต้อง'&&item.disburseAccoCheck=='ถูกต้อง'&&item.disbursePlanCheck=='ถูกต้อง'&&item.disburseFinaCheck=='ถูกต้อง') || item.disburseStatus=='ตัดแผนแล้ว'">{{ moneyFormat(item.disburseMoney) }}</span>
                    <span v-else>{{ moneyFormat(item.disburseMoney) }}</span>
                  </template>
                  <template v-slot:item.disburseDate="{ item }">
                    {{ thaiDateBf(item.disburseDate) }}
                  </template>
                  <template v-slot:item.disburseFinDate="{ item }">
                    {{ thaiDateBf(item.disburseFinDate) }}
                  </template>
                  <template v-slot:item.disburseParcCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseParcCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseParcCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disbursePlanCheck="{ item }">
                    <v-icon small color="success" v-if="item.disbursePlanCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disbursePlanCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disburseAccoCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseAccoCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseAccoCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.disburseFinaCheck="{ item }">
                    <v-icon small color="success" v-if="item.disburseFinaCheck=='ถูกต้อง'">fas fa-check-circle</v-icon>
                    <v-icon small color="error"  v-if="item.disburseFinaCheck=='ไม่ถูกต้อง'">fas fa-times-circle</v-icon>
                  </template>
                  <template v-slot:item.actions="{ item }">
                    <div>
                      <v-chip color="grey darken-3" outlined x-small v-if="item.disburseStatus=='ขอซื้อ'">
                        <v-icon x-small class="mr-1">fas fa-pen</v-icon> ขอซื้อ
                      </v-chip>
                      <v-chip color="yellow" x-small v-if="item.disburseStatus=='ตรวจสอบรายการ'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> รอตรวจสอบ
                      </v-chip>
                      <v-chip color="red darken-2 white--text" x-small v-if="item.disburseStatus=='ไม่ถูกต้อง'">
                        <v-icon x-small class="mr-1">fas fa-times</v-icon> ไม่ถูกต้อง
                      </v-chip>
                      <v-chip color="primary" x-small v-if="item.disburseStatus=='รอยืนยันจัดซื้อ'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> รอยืนยันจัดซื้อ
                      </v-chip>
                      <v-chip color="success darken-3" outlined x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" outlined x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" outlined x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </div>
                    <div  class="text-no-wrap">
                      <v-btn color="green darken-2" icon  small @click="showDisburselistListDialog(item)">
                        <v-icon small class="mr-1">fas fa-list</v-icon>
                      </v-btn>
                    </div>
                  </template>
                  <template slot="body.append">
                    <tr>
                      <td colspan="3" class="fontBold text-center">รวม</td>
                      <td class="fontBold text-right">{{ moneyFormat(budgetSum.disburseMoney) }}</td>
                      <td></td>
                    </tr>
                  </template>
                </v-data-table>
              </v-tab-item>
            </v-tabs-items>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="updateStatusDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateStatusDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <DisburseUpdateStatusVue :disburse="disburseData" :departmentSys="departmentSys" @getUpdateStatus="updateDisburse"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="disburselistListDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="disburselistListDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <DisburselistListCheckVue :disburse="JSON.parse(JSON.stringify(disburseData))" :departmentSys="departmentSys" @getUpdateStatus="getDisburses" v-if="disburselistListDialog"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
import DisburseInsertVue from './DisburseInsert.vue'
import DisburseDepInsertVue from './DisburseDepInsert.vue'
import DisburseUpdateVue from './DisburseUpdate.vue'
import DisburseDepUpdateVue from './DisburseDepUpdate.vue'
import DisburseDeleteVue from './DisburseDelete.vue'
import DisburseUpdateStatusVue from './DisburseUpdateStatus.vue'
import DisburselistListCheckVue from './DisburselistListCheck.vue'
import numeral from 'numeral'
export default {
  components: {
    DisburseInsertVue,
    DisburseDepInsertVue,
    DisburseDepInsertVue,
    DisburseUpdateVue,
    DisburseDepUpdateVue,
    DisburseDeleteVue,
    DisburseUpdateStatusVue,
    DisburselistListCheckVue,
  },

  props: {
    departmentSys: {
      type: String,
      default: null,
    },
    userID: {
      type: String,
      default : null
    },
    personalIDcard: {
      type: String,
      default: null
    },
    departmentID: {
      type: String,
      default: null
    },
    disburseYear: {
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
          value: 'disburseID',
        },
        { text: 'รายการ', value: 'disburseDes', align: 'left', class: 'text-center' },
        { text: 'หมวดค่าใช้จ่าย : ค่าใช้จ่าย/โครงการ', value: 'disburseName', align: 'left', class: 'text-center' },
        // { text: 'หมวดค่าใช้จ่าย', value: 'expenseName', align: 'left', class: 'text-center' },
        { text: 'จำนวนเงิน(บาท)', value: 'disburseMoney', align: 'right', class: 'text-center' },
        { text: 'วันที่', value: 'disburseDate', align: 'center', class: 'text-center' },
        { text: 'หมวดงบประมาณรายรับ', value: 'budgetplanFullname', align: 'left', class: 'text-center' },
        { text: 'แผนก/งาน', value: 'departmentName', align: 'left', class: 'text-center' },
        { text: 'พัสดุตรวจสอบ', value: 'disburseParcCheck', align: 'center', class: 'text-center' },
        { text: 'แผนตรวจสอบ', value: 'disbursePlanCheck', align: 'center', class: 'text-center' },
        { text: 'บัญชีตรวจสอบ', value: 'disburseAccoCheck', align: 'center', class: 'text-center' },
        { text: 'การเงินตรวจสอบ', value: 'disburseFinaCheck', align: 'center', class: 'text-center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      Reqheaders: [
        {
          text: '#',
          align: 'center',
          sortable: false,
          value: 'disburseID',
        },
        { text: 'รายการ', value: 'disburseDes', align: 'left', class: 'text-center' },
        { text: 'หมวดค่าใช้จ่าย : ค่าใช้จ่าย/โครงการ', value: 'disburseName', align: 'left', class: 'text-center' },
        { text: 'จำนวนเงิน(บาท)', value: 'disburseMoney', align: 'right', class: 'text-center' },
        { text: 'วันที่ตัด', value: 'disburseDate', align: 'center', class: 'text-center' },
        { text: 'หมวดงบประมาณรายรับ', value: 'budgetplanFullname', align: 'left', class: 'text-center' },
        { text: 'แผนก/งาน', value: 'departmentName', align: 'left', class: 'text-center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      Planheaders: [
        {
          text: '#',
          align: 'center',
          sortable: false,
          value: 'disburseID',
        },
        { text: 'รายการ', value: 'disburseDes', align: 'left', class: 'text-center' },
        { text: 'หมวดค่าใช้จ่าย : ค่าใช้จ่าย/โครงการ', value: 'disburseName', align: 'left', class: 'text-center' },
        // { text: 'หมวดค่าใช้จ่าย', value: 'expenseName', align: 'left', class: 'text-center' },
        { text: 'ตัดแผน(บาท)', value: 'disburseMoney', align: 'right', class: 'text-center' },
        { text: 'วันที่ตัด', value: 'disburseDate', align: 'center', class: 'text-center' },
        { text: 'หมวดงบประมาณรายรับ', value: 'budgetplanFullname', align: 'left', class: 'text-center' },
        { text: 'แผนก/งาน', value: 'departmentName', align: 'left', class: 'text-center' },
        { text: '', value: 'disburseStatus', align: 'center', class: 'text-center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      Completeheaders: [
        {
          text: '#',
          align: 'center',
          sortable: false,
          value: 'disburseID',
        },
        { text: 'รายการ', value: 'disburseDes', align: 'left', class: 'text-center' },
        { text: 'หมวดค่าใช้จ่าย : ค่าใช้จ่าย/โครงการ', value: 'disburseName', align: 'left', class: 'text-center' },
        // { text: 'หมวดค่าใช้จ่าย', value: 'expenseName', align: 'left', class: 'text-center' },
        { text: 'เบิกจ่าย(บาท)', value: 'disburseFinMoney', align: 'right', class: 'text-center' },
        { text: 'วันที่เบิก', value: 'disburseFinDate', align: 'center', class: 'text-center' },
        { text: 'หมวดงบประมาณรายรับ', value: 'budgetplanFullname', align: 'left', class: 'text-center' },
        { text: 'แผนก/งาน', value: 'departmentName', align: 'left', class: 'text-center' },
        { text: '', value: 'disburseStatus', align: 'center', class: 'text-center' },
        // { text: '', value: 'actions', align: 'center' },
      ],
      Cancelheaders: [
        {
          text: '#',
          align: 'center',
          sortable: false,
          value: 'disburseID',
        },
        { text: 'รายการ', value: 'disburseDes', align: 'left', class: 'text-center' },
        { text: 'หมวดค่าใช้จ่าย : ค่าใช้จ่าย/โครงการ', value: 'disburseName', align: 'left', class: 'text-center' },
        // { text: 'หมวดค่าใช้จ่าย', value: 'expenseName', align: 'left', class: 'text-center' },
        { text: 'จำนวนเงิน', value: 'disburseMoney', align: 'right', class: 'text-center' },
        { text: 'หมวดงบประมาณรายรับ', value: 'budgetplanFullname', align: 'left', class: 'text-center' },
        { text: 'แผนก/งาน', value: 'departmentName', align: 'left', class: 'text-center' },
        { text: 'วันที่', value: 'disburseDate', align: 'center', class: 'text-center' },
        // { text: 'สถานะ', value: 'disburseStatus', align: 'center', class: 'text-center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      Reqsearch: '',
      Plansearch: '',
      Completesearch: '',
      Cancelsearch: '',
      tab: 0,
      disbursesLoading: true,
      disburses: [],
      CheckDisburses: [],
      CorrectDisburses: [],
      WrongDisburses: [],
      CancelDisburses: [],
      budgetSum: {},
      disburseData: {},
      insertDialog: false,
      insertProgress: false,
      disburseInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      disburseUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      disburseDeleteValidate: null,

      updateStatusDialog: false,
      updateStatusProgress: false,
      disburseUpdateStatusValidate: null,

      disburselistListDialog: false,
    }
  },

  async mounted() {
    await this.getDisburses()
  },

  methods: {
    async getDisburses() {
      this.disbursesLoading = true
      let params = {}
      if(this.departmentSys=='Parcel' || this.departmentSys=='Plan' || this.departmentSys=='Account' || this.departmentSys=='Finance') {
        params = {
          token: this.$store.state.jwtToken,
          disburseYear: this.disburseYear
        }
      }
      let result = await this.$axios.$get('disburse.php', {params})
      if(result.message === 'Success') {
        this.disburses = JSON.parse(JSON.stringify(result.disburse))
        if(this.disburses) {
          if(this.departmentSys == 'Parcel') {
            this.CheckDisburses = this.disburses.filter(disburse => (disburse.disburseParcCheck === '' ||disburse.disburseParcCheck === null) && disburse.disburseStatus=='ตรวจสอบรายการ')
          } else if(this.departmentSys == 'Plan') {
            this.CheckDisburses = this.disburses.filter(disburse => (disburse.disbursePlanCheck === '' || disburse.disbursePlanCheck === null) && disburse.disburseStatus=='ตรวจสอบรายการ' && disburse.disburseParcCheck == 'ถูกต้อง')
          } else if(this.departmentSys == 'Account') {
            this.CheckDisburses = this.disburses.filter(disburse => (disburse.disburseAccoCheck === '' || disburse.disburseAccoCheck === null) && disburse.disburseStatus=='ตรวจสอบรายการ' && disburse.disbursePlanCheck == 'ถูกต้อง')
          } else if(this.departmentSys == 'Finance') {
            this.CheckDisburses = this.disburses.filter(disburse => (disburse.disburseFinaCheck === '' || disburse.disburseFinaCheck === null) && disburse.disburseStatus=='ตรวจสอบรายการ' && disburse.disburseAccoCheck == 'ถูกต้อง')
          }
          this.CorrectDisburses = this.disburses.filter(disburse => (disburse.disburseParcCheck === 'ถูกต้อง' && disburse.disbursePlanCheck === 'ถูกต้อง' && disburse.disburseAccoCheck === 'ถูกต้อง' && disburse.disburseFinaCheck === 'ถูกต้อง'))
          this.WrongDisburses = this.disburses.filter(disburse => (disburse.disburseParcCheck === 'ไม่ถูกต้อง' || disburse.disbursePlanCheck === 'ไม่ถูกต้อง' || disburse.disburseAccoCheck === 'ไม่ถูกต้อง' || disburse.disburseFinaCheck === 'ไม่ถูกต้อง'))
        }
      }
      // params = {
      //   token: this.$store.state.jwtToken,
      //   disburseYear: this.disburseYear,
      //   fn: 'getSummaryByYear'
      // }
      params.fn = 'getSummaryByYear'
      let result2 = await this.$axios.$get('disburse.php', {params})
      if(result2.message === 'Success') {
        this.budgetSum = JSON.parse(JSON.stringify(result2.disburse))
      }
      this.disbursesLoading = false
    },

    showInsertDialog() {
      if(this.departmentSys=='Department') {
        this.disburseData = {
          token: this.$store.state.jwtToken,
          disburseYear: this.disburseYear,
          userID: this.userID,
          personalIDcardCreate: this.personalIDcard,
          departmentID: this.departmentID,
          disburseStatus: 'ขอซื้อ'
        }
      } else {
        let disburseStatus = ''
        if(this.departmentSys=='Plan') {
          disburseStatus = 'ตัดแผนแล้ว'
        } else if(this.departmentSys=='Finance') {
          disburseStatus = 'เบิกจ่ายแล้ว'
        }
        this.disburseData = {
          token: this.$store.state.jwtToken,
          disburseYear: this.disburseYear,
          personalIDcardCreate: this.personalIDcard,
          disburseStatus: disburseStatus,
        }
      }

      this.insertDialog = true
    },

    async insertDisburse(res) {
      if(res.status) {
        await this.getDisburses()
        this.$emit('getTableStatus', {'status': true})
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(disburse) {
      this.disburseData = disburse
      this.disburseData.token = this.$store.state.jwtToken
      this.disburseData.personalIDcardEdit = this.personalIDcard,
      this.updateDialog = true
    },

    async updateDisburse(res) {
      if(res.status) {
        await this.getDisburses()
        this.$emit('getTableStatus', {'status': true})
        this.updateDialog = false
        this.updateStatusDialog = false
      } else {
        this.updateDialog = false
        this.updateStatusDialog = false
      }
    },

    showDeleteDialog(disburse) {
      this.disburseData = disburse
      this.disburseData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deleteDisburse(res) {
      if(res.status) {
        await this.getDisburses()
        this.$emit('getTableStatus', {'status': true})
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },

    showUpdateStatusDialog(disburse) {
      this.disburseData = disburse
      this.disburseData.token = this.$store.state.jwtToken
      this.updateStatusDialog = true
    },

    showDisburselistListDialog(disburse) {
      this.disburseData = disburse
      this.disburseData.token = this.$store.state.jwtToken
      this.disburselistListDialog = true
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
          month: 'long',
          day: 'numeric',
        })
      }
      return result
    },

    thaiDateBf(inDate) {
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
  async disburseYear() {
    await this.getDisburses()
  },

  async personalIDcard() {
    await this.getDisburses()
  }
}
}
</script>
