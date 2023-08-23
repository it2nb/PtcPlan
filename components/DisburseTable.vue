<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>จัดซื้อ/เบิกเงิน ประจำปีงบประมาณ พ.ศ.{{ parseInt(disburseYear)+543 }}</b>
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
                <b class="grey--text text--darken-2">ทั้งหมด</b>
              </v-tab>
              <v-tab>
                <b class="primary--text">ตัดแผนแล้ว</b>
              </v-tab>
              <v-tab>
                <b class="success--text">เบิกจ่ายแล้ว</b>
              </v-tab>
              <v-tab class="red--text text--darken-3">
                <b>ยกเลิก</b>
              </v-tab>
            </v-tabs>
            <v-tabs-items
              v-model="tab"
            >
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
                        <v-btn color="success" text @click="showInsertDialog" v-if="userType=='Admin' || userType=='Plan' || userType=='Finance'">
                          <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มรายการจัดซื้อ/เบิกเงิน
                        </v-btn>
                        <v-btn icon color="primary" :to="'/print/disbursetableReport/?year='+disburseYear+'&disp=all'" target="_blank" v-if="userType=='Admin'||userType=='Director'||userType=='Plan'||userType=='Finance'" class="ml-2">
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
                    {{ moneyFormat(item.disburseMoney) }}
                  </template>
                  <template v-slot:item.disburseDate="{ item }">
                    {{ thaiDateBf(item.disburseDate) }}
                  </template>
                  <template v-slot:item.disburseStatus="{ item }">
                    <v-btn text small  @click="showUpdateStatusDialog(item)" v-if="userType=='Finance' || (userType=='Plan' && item.disburseStatus!='เบิกจ่ายแล้ว')">
                      <v-chip color="success" x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </v-btn>
                    <div v-else>
                      <v-chip color="success" x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </div>
                  </template>
                  <template v-slot:item.actions="{ item }">
                    <div  class="text-no-wrap">
                      <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="(updateBt || userType=='Admin' || userType=='Plan') && item.disburseStatus!='เบิกจ่ายแล้ว'">
                        <v-icon small class="mr-1">fas fa-edit</v-icon>
                      </v-btn>
                      <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="(deleteBt || userType=='Admin' || userType=='Plan') && item.disburseStatus!='เบิกจ่ายแล้ว'">
                        <v-icon small class="mr-1">fas fa-trash</v-icon>
                      </v-btn>
                    </div>
                  </template>
                  <template slot="body.append">
                    <tr>
                      <td colspan="3" class="fontBold text-center">รวม</td>
                      <td class="fontBold text-right">{{ moneyFormat(budgetSum.disburseMoney) }}</td>
                      <!-- <td class="fontBold text-right">{{ moneyFormat(budgetSum.budgetrealMoney) }} บาท</td> -->
                      <td></td>
                    </tr>
                  </template>
                </v-data-table>
              </v-tab-item>
              <v-tab-item class="py-5">
                <!-- ตัดแผนแล้ว -->
                <v-data-table
                  :headers="headers"
                  :items="PlanDisburses"
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
                        <h3 class="mb-2 fontBold text-center">รายการที่ตัดแผนแล้ว {{ budgetSum.disbursePlanQty }} รายการ {{ moneyFormat(budgetSum.disbursePlanMoney) }} บาท</h3>
                        <v-btn icon color="primary" :to="'/print/disbursetableReport/?year='+disburseYear+'&disp=plan'" target="_blank" v-if="userType=='Admin'||userType=='Director'||userType=='Plan'||userType=='Finance'" class="ml-2">
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
                    {{ moneyFormat(item.disburseMoney) }}
                  </template>
                  <template v-slot:item.disburseDate="{ item }">
                    {{ thaiDateBf(item.disburseDate) }}
                  </template>
                  <template v-slot:item.disburseStatus="{ item }">
                    <v-btn text small  @click="showUpdateStatusDialog(item)" v-if="userType=='Finance' || (userType=='Plan' && item.disburseStatus!='เบิกจ่ายแล้ว')">
                      <v-chip color="success" x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </v-btn>
                    <div v-else>
                      <v-chip color="success" x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </div>
                  </template>
                  <template v-slot:item.actions="{ item }">
                    <div  class="text-no-wrap">
                      <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="(updateBt || userType=='Admin' || userType=='Plan') && item.disburseStatus!='เบิกจ่ายแล้ว'">
                        <v-icon small class="mr-1">fas fa-edit</v-icon>
                      </v-btn>
                      <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="(deleteBt || userType=='Admin' || userType=='Plan') && item.disburseStatus!='เบิกจ่ายแล้ว'">
                        <v-icon small class="mr-1">fas fa-trash</v-icon>
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
                <!-- เบิกจ่ายแล้ว -->
                <v-data-table
                  :headers="headers"
                  :items="CompleteDisburses"
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
                        <h3 class="mb-2 fontBold text-center">รายการที่เบิกจ่ายแล้ว {{ budgetSum.disburseCompleteQty }} รายการ {{ moneyFormat(budgetSum.disburseCompleteMoney) }} บาท</h3>
                        <v-btn icon color="primary" :to="'/print/disbursetableReport/?year='+disburseYear+'&disp=complete'" target="_blank" v-if="userType=='Admin'||userType=='Director'||userType=='Plan'||userType=='Finance'" class="ml-2">
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
                    {{ moneyFormat(item.disburseMoney) }}
                  </template>
                  <template v-slot:item.disburseDate="{ item }">
                    {{ thaiDateBf(item.disburseDate) }}
                  </template>
                  <template v-slot:item.disburseStatus="{ item }">
                    <v-btn text small  @click="showUpdateStatusDialog(item)" v-if="userType=='Finance' || (userType=='Plan' && item.disburseStatus!='เบิกจ่ายแล้ว')">
                      <v-chip color="success" x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </v-btn>
                    <div v-else>
                      <v-chip color="success" x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </div>
                  </template>
                  <template v-slot:item.actions="{ item }">
                    <div  class="text-no-wrap">
                      <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="(updateBt || userType=='Admin' || userType=='Plan') && item.disburseStatus!='เบิกจ่ายแล้ว'">
                        <v-icon small class="mr-1">fas fa-edit</v-icon>
                      </v-btn>
                      <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="(deleteBt || userType=='Admin' || userType=='Plan') && item.disburseStatus!='เบิกจ่ายแล้ว'">
                        <v-icon small class="mr-1">fas fa-trash</v-icon>
                      </v-btn>
                    </div>
                  </template>
                  <template slot="body.append">
                    <tr>
                      <td colspan="3" class="fontBold text-center">รวม</td>
                      <td class="fontBold text-right">{{ moneyFormat(budgetSum.disburseCompleteMoney) }}</td>
                      <!-- <td class="fontBold text-right">{{ moneyFormat(budgetSum.budgetrealMoney) }} บาท</td> -->
                      <td></td>
                    </tr>
                  </template>
                </v-data-table>
              </v-tab-item>
              <v-tab-item class="py-5">
                <!-- ยกเลิก -->
                <v-data-table
                  :headers="headers"
                  :items="CancelDisburses"
                  :search="Cancelsearch"
                  :items-per-page="50"
                  :loading="disbursesLoading"
                  :footer-props="{
                    showFirstLastPage: true,
                  }"
                >
                  <template v-slot:top>
                    <v-row>
                      <v-col cols="12" md="6" class="text-center">
                        <h3 class="mb-2 fontBold text-center">รายการที่ยกเลิก {{ budgetSum.disburseCancelQty }} รายการ {{ moneyFormat(budgetSum.disburseCancelMoney) }} บาท</h3>
                        <v-btn icon color="primary" :to="'/print/disbursetableReport/?year='+disburseYear+'&disp=cancel'" target="_blank" v-if="userType=='Admin'||userType=='Director'||userType=='Plan'||userType=='Finance'" class="ml-2">
                          <v-icon>fas fa-print</v-icon>
                        </v-btn>
                      </v-col>
                      <v-col cols="12" md="6">
                        <v-text-field
                          v-model="Cancelsearch"
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
                    {{ moneyFormat(item.disburseMoney) }}
                  </template>
                  <template v-slot:item.disburseDate="{ item }">
                    {{ thaiDateBf(item.disburseDate) }}
                  </template>
                  <template v-slot:item.disburseStatus="{ item }">
                    <v-btn text small  @click="showUpdateStatusDialog(item)" v-if="userType=='Finance' || (userType=='Plan' && item.disburseStatus!='เบิกจ่ายแล้ว')">
                      <v-chip color="success" x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </v-btn>
                    <div v-else>
                      <v-chip color="success" x-small v-if="item.disburseStatus=='เบิกจ่ายแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-check-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="primary" x-small dark v-else-if="item.disburseStatus=='ตัดแผนแล้ว'">
                        <v-icon x-small class="mr-1">fas fa-clock</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                      <v-chip color="red darken-2" x-small dark v-else-if="item.disburseStatus=='ยกเลิก'">
                        <v-icon x-small class="mr-1">fas fa-times-circle</v-icon> {{ item.disburseStatus }}
                      </v-chip>
                    </div>
                  </template>
                  <template v-slot:item.actions="{ item }">
                    <div  class="text-no-wrap">
                      <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="(updateBt || userType=='Admin' || userType=='Plan') && item.disburseStatus!='เบิกจ่ายแล้ว'">
                        <v-icon small class="mr-1">fas fa-edit</v-icon>
                      </v-btn>
                      <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)" v-if="(deleteBt || userType=='Admin' || userType=='Plan') && item.disburseStatus!='เบิกจ่ายแล้ว'">
                        <v-icon small class="mr-1">fas fa-trash</v-icon>
                      </v-btn>
                    </div>
                  </template>
                  <template slot="body.append">
                    <tr>
                      <td colspan="3" class="fontBold text-center">รวม</td>
                      <td class="fontBold text-right">{{ moneyFormat(budgetSum.disburseCancelMoney) }}</td>
                      <!-- <td class="fontBold text-right">{{ moneyFormat(budgetSum.budgetrealMoney) }} บาท</td> -->
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
                <DisburseInsertVue :disburse="disburseData" @getInsertStatus="insertDisburse"/>
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
                <DisburseUpdateVue :disburse="disburseData" @getUpdateStatus="updateDisburse"/>
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
                <DisburseDeleteVue :disburse="disburseData" @getDeleteStatus="deleteDisburse"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
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
                <DisburseUpdateStatusVue :disburse="disburseData" :userType="userType" @getUpdateStatus="updateDisburse"/>
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
import DisburseUpdateVue from './DisburseUpdate.vue'
import DisburseDeleteVue from './DisburseDelete.vue'
import DisburseUpdateStatusVue from './DisburseUpdateStatus.vue'
import numeral from 'numeral'
export default {
  components: {
    DisburseInsertVue,
    DisburseUpdateVue,
    DisburseDeleteVue,
    DisburseUpdateStatusVue,
  },

  props: {
    // disburses: {
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
        // { text: 'ปีงบประมาณ พ.ศ.', value: 'disburseYear', align: 'center', class: 'text-center' },
        { text: 'รายการ', value: 'disburseDes', align: 'left', class: 'text-center' },
        { text: 'ค่าใช้จ่าย/โครงการ', value: 'disburseName', align: 'left', class: 'text-center' },
        // { text: 'โครงการ', value: 'projectName', align: 'left', class: 'text-center' },
        // { text: 'ค่าใช้จ่าย', value: 'expenseplanDes', align: 'left', class: 'text-center' },
        { text: 'หมวดค่าใช้จ่าย', value: 'expenseName', align: 'left', class: 'text-center' },
        { text: 'จำนวนเงิน', value: 'disburseMoney', align: 'right', class: 'text-center' },
        { text: 'หมวดงบประมาณรายรับ', value: 'budgetplanFullname', align: 'left', class: 'text-center' },
        { text: 'แผนก/งาน', value: 'departmentName', align: 'left', class: 'text-center' },
        // { text: 'เจ้าของรายการ', value: 'disburseReqName', align: 'left', class: 'text-center' },
        { text: 'วันที่', value: 'disburseDate', align: 'center', class: 'text-center' },
        { text: 'สถานะ', value: 'disburseStatus', align: 'center', class: 'text-center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      Plansearch: '',
      Completesearch: '',
      Cancelsearch: '',
      tab: 0,
      disbursesLoading: true,
      disburses: [],
      PlanDisburses: [],
      CompleteDisburses: [],
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
    }
  },

  async mounted() {
    await this.getDisburses()
  },

  methods: {
    async getDisburses() {
      this.disbursesLoading = true
      let params = {}
      if(this.userType=='Admin' || this.userType=='Director' || this.userType=='Party' || this.userType=='Plan' || this.userType=='Finance') {
        params = {
          token: this.$store.state.jwtToken,
          disburseYear: this.disburseYear
        }
      } else if(this.userType=='Department') {
        params = {
          token: this.$store.state.jwtToken,
          disburseYear: this.disburseYear,
          departmentID: this.departmentID
        }
      }
      let result = await this.$axios.$get('disburse.php', {params})
      if(result.message === 'Success') {
        this.disburses = JSON.parse(JSON.stringify(result.disburse))
        if(this.disburses) {
          this.PlanDisburses = this.disburses.filter(disburse => disburse.disburseStatus === 'ตัดแผนแล้ว')
          this.CompleteDisburses = this.disburses.filter(disburse => disburse.disburseStatus === 'เบิกจ่ายแล้ว')
          this.CancelDisburses = this.disburses.filter(disburse => disburse.disburseStatus === 'ยกเลิก')
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
      let disburseStatus = ''
      if(this.userType=='Plan') {
        disburseStatus = 'ตัดแผนแล้ว'
      } else if(this.userType=='Finance') {
        disburseStatus = 'เบิกจ่ายแล้ว'
      }
      this.disburseData = {
        token: this.$store.state.jwtToken,
        disburseYear: this.disburseYear,
        personalIDcardCreate: this.personalIDcard,
        disburseStatus: disburseStatus,
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
