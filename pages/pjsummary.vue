<template>
  <v-container>
    <v-row justify="center" class="mt-3">
      <v-col cols="12">
        <h3 class="fontBold">รายงานผลการดำเนินโครงการ ประจำปีงบประมาณ พ.ศ. 2565</h3>
      </v-col>
      <v-col cols="12">
        <v-data-table
          :headers="headers"
          :items="projects_tb"
          :search="search"
          :items-per-page="-1"
        >
          <template v-slot:top>
            <v-row>
              <v-col cols="12" md="6">
                <v-autocomplete
                  v-model="orgstrategicID"
                  label="ยุทธศาสตร์"
                  :items="orgstrategics"
                  item-text="orgstrategicFullname"
                  item-value="orgstrategicID"
                  outlined
                  @change="filterProjects"
                ></v-autocomplete>
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field
                  v-model="search"
                  append-icon="mdi-magnify"
                  label="ค้นหา"
                  hide-details
                  outlined
                ></v-text-field>
              </v-col>
            </v-row>
          </template>

          <template v-slot:item.pjsummaryStatus="{ item }">
            <v-chip color="success" v-if="item.pjsummaryStatus==item.pjsummaryStatusAll && item.imageQty>=4">
              <v-icon class="mr-1">fas fa-check-circle</v-icon> รายงานเรียบร้อย
            </v-chip>
            <v-chip color="warning" small v-else-if="item.pjsummaryStatus>0">
              <v-icon small class="mr-1">fas fa-exclamation-circle</v-icon> รายงานยังไม่เรียบร้อย
            </v-chip>
            <v-chip color="red" small dark v-else>
              <v-icon small class="mr-1">fas fa-exclamation</v-icon> ยังไม่ได้รายงาน
            </v-chip>
          </template>
          <template v-slot:item.actions="{ item }">
            <div  class="text-no-wrap">
              <v-btn color="warning" icon  small @click="showUpdateDialog(item)" v-if="item.pjsummaryStatus>0">
                <v-icon small class="mr-1">fas fa-edit</v-icon>
              </v-btn>
              <v-btn color="success" text small dark @click="showInsertDialog(item)" v-else>
                <v-icon small class="mr-1">fas fa-plus-circle</v-icon> รายงาน
              </v-btn>
              <v-btn color="info" icon  small @click="showInfoDialog(item)" v-if="item.pjsummaryStatus>0">
                <v-icon small class="mr-1">fas fa-search</v-icon>
              </v-btn>
              <v-btn color="primary" icon  small :to="'print/pjsummaryReport/?id='+item.projectID" target="_blank" v-if="item.pjsummaryStatus==item.pjsummaryStatusAll && item.imageQty>=4">
                <v-icon small class="mr-1">fas fa-print</v-icon>
              </v-btn>
            </div>
          </template>
        </v-data-table>
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
                <v-card-title class="light-green lighten-2">
                  <span class="fontBold">บันทึกข้อมูลรายงานผลดำเนินโครงการ</span>
                </v-card-title>
                <v-card-subtitle class="light-green lighten-2">
                  <h3 class="mt-2 black--text">{{ project.projectName }}</h3>
                </v-card-subtitle>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="pjsummaryInsertValidate"
                  ref="pjsummaryInsertForm"
                  lazy-validation
                  @submit.prevent="insertPjsummary"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ฝ่าย</h3>
                        <v-autocomplete
                          v-model="project.partyID"
                          :items="parties"
                          item-text="partyName"
                          item-value="partyID"
                          label="ฝ่าย"
                          outlined
                          :rules="[
                            () => !!project.partyID || 'กรุณากรอกข้อมูล'
                          ]"
                          @change="getDepartments(project.partyID)"
                        ></v-autocomplete>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">แผนก/งาน</h3>
                        <v-autocomplete
                          v-model="project.departmentID"
                          :items="departments"
                          item-text="departmentName"
                          item-value="departmentID"
                          label="แผนก/งาน"
                          outlined
                          :rules="[
                            () => !!project.departmentID || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-autocomplete>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">1. หลักการและเหตุผล</h3>
                        <v-textarea
                          v-model="project.projectPrinciple"
                          label="หลักการและเหตุผล"
                          outlined
                          :rules="[
                            () => !!project.projectPrinciple || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">2. วัตถุประสงค์</h3>
                        <v-textarea
                          v-model="project.projectObjective"
                          label="วัตถุประสงค์"
                          outlined
                          :rules="[
                            () => !!project.projectObjective || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">3. งบประมาณ</h3>
                        <v-text-field
                          v-model="project.pjbudgetMoney"
                          label="งบประมาณ (บาท)"
                          outlined
                          :rules="[
                            () => !!project.pjbudgetMoney || 'กรุณากรอกข้อมูล',
                            () => (!!moneyFormat(project.pjbudgetMoney) || moneyFormat(project.pjbudgetMoney)==0) || 'กรุณากรอกข้อมูลเป็นตัวเลข'
                          ]"
                          class="col-12 col-md-5"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">4. ผลการดำเนินงาน/กิจกรรม</h3>
                        <v-textarea
                          v-model="project.pjsummaryQtyResult"
                          label="เชิงปริมาณ"
                          outlined
                          :rules="[
                            () => !!project.pjsummaryQtyResult || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                        <v-textarea
                          v-model="project.pjsummaryQlyResult"
                          label="เชิงคุณภาพ"
                          outlined
                          :rules="[
                            () => !!project.pjsummaryQlyResult || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                        <v-textarea
                          v-model="project.pjsummaryImpact"
                          label="ผลกระทบ"
                          outlined
                          :rules="[
                            () => !!project.pjsummaryImpact || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">5. ปัญหาอุปสรรค</h3>
                        <v-textarea
                          v-model="project.pjsummaryProblem"
                          label="ปัญหาอุปสรรค"
                          outlined
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">6. ข้อเสนอแนะ</h3>
                        <v-textarea
                          v-model="project.pjsummarySuggestion"
                          label="ข้อเสนอแนะ"
                          outlined
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">7. ภาพการดำเนินโครงการ (ไม่เกิน 4 ภาพ)</h3>
                        <v-file-input
                          v-model="imageInsertNames"
                          ref="projectImages"
                          small-chips
                          show-size
                          counter
                          multiple
                          accept="image/jpeg"
                          label="ไฟล์รูปภาพ"
                          :rules="[
                            ()=> imageInsertNames.length<=4 || 'เพิ่มรูปภาพได้ไม่เกิน 4 ภาพ'
                          ]"
                          @change="productImagesChanged"
                        ></v-file-input>
                        <v-row v-if="imageInsertNames.length > 0">
                          <v-col class="col-3 col-md-1" v-for="imageName in imageInsertNames" :key="imageName.key">
                            <v-img
                              :src="getImageUrl(imageName)"
                            >
                              <template v-slot:placeholder>
                                <v-row
                                    class="fill-height ma-0 "
                                    justify="center"
                                >
                                  <v-icon large>fas fa-images</v-icon>
                                </v-row>
                              </template>
                            </v-img>
                          </v-col>
                        </v-row>
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions>
                    <div class="col-12 text-center">
                      <v-btn
                        @click="insertDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="insertProgress"
                      ></v-progress-circular>
                      <v-btn
                        type="submit"
                        color="success darken-1"
                        large
                        v-else
                      >
                        บันทึก
                      </v-btn>
                    </div>
                  </v-card-actions>
                </v-form>
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
                <v-card-title class="amber lighten-2">
                  <span class="fontBold black--text">แก้ไขข้อมูลรายงานผลดำเนินโครงการ</span>
                </v-card-title>
                <v-card-subtitle class="amber lighten-2">
                  <h3 class="mt-2 black--text">{{ project.projectName }}</h3>
                </v-card-subtitle>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="pjsummaryUpdateValidate"
                  ref="pjsummaryUpdateForm"
                  lazy-validation
                  @submit.prevent="updatePjsummary"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">ฝ่าย</h3>
                        <v-autocomplete
                          v-model="project.partyID"
                          :items="parties"
                          item-text="partyName"
                          item-value="partyID"
                          label="ฝ่าย"
                          outlined
                          :rules="[
                            () => !!project.partyID || 'กรุณากรอกข้อมูล'
                          ]"
                          @change="getDepartments(project.partyID)"
                        ></v-autocomplete>
                      </v-col>
                      <v-col cols="12" md="6">
                        <h3 class="mb-2 fontBold">แผนก/งาน</h3>
                        <v-autocomplete
                          v-model="project.departmentID"
                          :items="departments"
                          item-text="departmentName"
                          item-value="departmentID"
                          label="แผนก/งาน"
                          outlined
                          :rules="[
                            () => !!project.departmentID || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-autocomplete>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">1. หลักการและเหตุผล</h3>
                        <v-textarea
                          v-model="project.projectPrinciple"
                          label="หลักการและเหตุผล"
                          outlined
                          :rules="[
                            () => !!project.projectPrinciple || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">2. วัตถุประสงค์</h3>
                        <v-textarea
                          v-model="project.projectObjective"
                          label="วัตถุประสงค์"
                          outlined
                          :rules="[
                            () => !!project.projectObjective || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">3. งบประมาณ</h3>
                        <v-text-field
                          v-model="project.pjbudgetMoney"
                          label="งบประมาณ (บาท)"
                          outlined
                          :rules="[
                            () => !!project.pjbudgetMoney || 'กรุณากรอกข้อมูล',
                            () => (!!moneyFormat(project.pjbudgetMoney) || moneyFormat(project.pjbudgetMoney)==0) || 'กรุณากรอกข้อมูลเป็นตัวเลข'
                          ]"
                          class="col-12 col-md-5"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">4. ผลการดำเนินงาน/กิจกรรม</h3>
                        <v-textarea
                          v-model="project.pjsummaryQtyResult"
                          label="เชิงปริมาณ"
                          outlined
                          :rules="[
                            () => !!project.pjsummaryQtyResult || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                        <v-textarea
                          v-model="project.pjsummaryQlyResult"
                          label="เชิงคุณภาพ"
                          outlined
                          :rules="[
                            () => !!project.pjsummaryQlyResult || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                        <v-textarea
                          v-model="project.pjsummaryImpact"
                          label="ผลกระทบ"
                          outlined
                          :rules="[
                            () => !!project.pjsummaryImpact || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">5. ปัญหาอุปสรรค</h3>
                        <v-textarea
                          v-model="project.pjsummaryProblem"
                          label="ปัญหาอุปสรรค"
                          outlined
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">6. ข้อเสนอแนะ</h3>
                        <v-textarea
                          v-model="project.pjsummarySuggestion"
                          label="ข้อเสนอแนะ"
                          outlined
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">7. ภาพการดำเนินโครงการ (ไม่เกิน 4 ภาพ)</h3>
                        <v-file-input
                          v-model="imageUpdateNames"
                          ref="projectImages"
                          small-chips
                          show-size
                          counter
                          multiple
                          accept="image/jpeg"
                          label="ไฟล์รูปภาพ"
                          :rules="[
                            ()=> (imageUpdateNames.length+imageNames.length)<=4 || 'เพิ่มรูปภาพได้ไม่เกิน 4 ภาพ'
                          ]"
                          @change="productImagesChanged"
                        ></v-file-input>
                        <v-row v-if="imageUpdateNames.length > 0">
                          <v-col class="col-3 col-md-1" v-for="imageName in imageUpdateNames" :key="imageName.key">
                            <v-img
                              :src="getImageUrl(imageName)"
                            >
                              <template v-slot:placeholder>
                                <v-row
                                    class="fill-height ma-0 "
                                    justify="center"
                                >
                                  <v-icon large>fas fa-images</v-icon>
                                </v-row>
                              </template>
                            </v-img>
                          </v-col>
                        </v-row>
                        <v-row v-if="imageNames.length > 0">
                          <v-col class="col-3 col-md-1" v-for="imageName in imageNames" :key="imageName.key">
                            <v-img
                              :src="imagePath+imageName"
                              class="align-end text-right"
                              gradient="to bottom, rgba(255,255,255,.1), rgba(255,255,255,.5)"
                            >
                              <v-btn icon small color="red darken-2" @click="showDeleteImageDialog(imageName)">
                                <v-icon small>fas fa-trash</v-icon>
                              </v-btn>
                            </v-img>
                          </v-col>
                        </v-row>
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions>
                    <div class="col-12 text-center">
                      <v-btn
                        @click="updateDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="updateProgress"
                      ></v-progress-circular>
                      <v-btn
                        type="submit"
                        color="amber darken-1"
                        large
                        v-else
                      >
                        แก้ไข
                      </v-btn>
                    </div>
                  </v-card-actions>
                </v-form>
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
                <v-card-title class="red lighten-2">
                  <span class="fontBold black--text">ลบภาพการดำเนินโครงการ</span>
                </v-card-title>
                <v-card-subtitle class="red lighten-2">
                  <h3 class="mt-2 black--text">{{ project.projectName }}</h3>
                </v-card-subtitle>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="pjsummaryDeleteValidate"
                  ref="pjsummaryDeleteForm"
                  lazy-validation
                  @submit.prevent="deletePjsummary"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">ภาพการดำเนินโครงการ</h3>
                        <v-row v-if="imageDeleteName.length > 0">
                          <v-col class="col-12 col-md-6 mx-auto">
                            <v-img
                              :src="imagePath+imageDeleteName"
                            >
                            </v-img>
                          </v-col>
                        </v-row>
                      </v-col>
                    </v-row>
                  </v-card-text>
                  <v-divider class="green lighten-2"></v-divider>
                  <v-card-actions>
                    <div class="col-12 text-center">
                      <v-btn
                        @click="deleteDialog = false"
                        outlined
                      >
                        ยกเลิก
                      </v-btn>
                      <v-progress-circular
                        indeterminate
                        color="success"
                        v-if="deleteProgress"
                      ></v-progress-circular>
                      <v-btn
                        type="submit"
                        color="red darken-1"
                        large
                        dark
                        v-else
                      >
                        ลบ
                      </v-btn>
                    </div>
                  </v-card-actions>
                </v-form>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="infoDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="grey lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="infoDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <v-card-title class="grey lighten-2">
                  <span class="fontBold black--text">ข้อมูลการรายงานผลการดำเนินโครงการ</span>
                  <v-spacer></v-spacer>
                  <v-btn icon color="primary" :to="'print/pjsummaryReport/?id='+project.projectID" target="_blank" v-if="project.pjsummaryStatus==project.pjsummaryStatusAll && project.imageQty>=4">
                  <v-icon>fas fa-print</v-icon>
                  </v-btn>
                </v-card-title>
                <v-divider class="green"></v-divider>
                  <PjsummaryInfo :project="project" :imageNames="imageNames" :imagePath="imagePath" class="my-3 mx-5" />
                <v-divider class="green lighten-2"></v-divider>
                <v-card-actions>
                  <div class="col-12 text-center">
                    <v-btn
                      @click="infoDialog = false"
                      outlined
                    >
                      ปิด
                    </v-btn>
                  </div>
                </v-card-actions>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>
  </v-container>
</template>

<script>
import Swal from 'sweetalert2'
import PjsummaryInfo from '~/components/PjsummaryInfo';
var numeral = require('numeral');
export default {
  name: 'IndexPage',
  components: {
    PjsummaryInfo
  },
  data() {
    return {
      thdate: '',
      headers: [
        {
          text: '#',
          align: 'center',
          sortable: false,
          value: 'projectID',
        },
        { text: 'ยุทธศาสตร์ที่', value: 'orgstrategicNum', align: 'center' },
        { text: 'ชื่อโครงการ', value: 'projectName', align: 'left', class: 'text-center' },
        // { text: 'ผู้รับผิดชอบ', value: '' },
        { text: 'สถานะการรายงาน', value: 'pjsummaryStatus', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      orgstrategics: [],
      orgstrategicID: 0,
      projects: [],
      projects_tb: [],
      project: [],
      insertDialog: false,
      insertProgress: false,
      pjsummaryInsertValidate: null,
      updateDialog: false,
      updateProgress: false,
      pjsummaryUpdateValidate: null,
      deleteDialog: false,
      deleteProgress: false,
      pjsummaryDeleteValidate: null,
      infoDialog: false,

      imageInsertNames: [],
      imageUpdateNames: [],
      imageDeleteName: '',
      imageNames: [],
      imagePath: '',

      parties: [],
      departments: [],
    }
  },

  async mounted() {
    this.thdate = new Date()
    await this.getOrgstrategics()
    await this.getProjects()
    await this.getParties()
  },

  methods: {
    async getOrgstrategics() {
      let result = await this.$axios.$get('orgstrategic.php', {
        params: {
          token: this.$store.state.jwtToken,
          orgstrategicEnable: 1
        }
      })

      if(result.message === 'Success') {
        this.orgstrategics = result.orgstrategic
        this.orgstrategics.unshift({
          orgstrategicID: 0,
          orgstrategicNum: 0,
          orgstrategicFullname: 'โครงการทุกยุทธศาสตร์'
        })
      }
    },

    async getParties() {
      let result = await this.$axios.$get('party.php', {
        params: {
          token: this.$store.state.jwtToken,
        }
      })

      if(result.message === 'Success') {
        this.parties = result.party
      }
    },

    async getDepartments(partyID) {
      let result = await this.$axios.$get('department.php', {
        params: {
          token: this.$store.state.jwtToken,
          partyID: partyID
        }
      })

      if(result.message === 'Success') {
        this.departments = result.department
      }
    },

    async getProjects() {
      let result = await this.$axios.$get('project.php', {
        params: {
          token: this.$store.state.jwtToken,
          projectYear: '2022',
          fn: 'Summary'
        }
      })

      if(result.message === 'Success') {
        this.projects = result.project
        this.projects_tb = JSON.parse(JSON.stringify(this.projects))
      }
    },

    filterProjects() {
      if(this.orgstrategicID > 0) {
        this.projects_tb = this.projects.filter((project)=> {
          return project.orgstrategicID == this.orgstrategicID
        })
      } else {
        this.projects_tb = JSON.parse(JSON.stringify(this.projects))
      }
    },

    showInsertDialog(project) {
      this.project = JSON.parse(JSON.stringify(project))
      this.imageInsertNames = []
      this.insertDialog = true
    },

    async insertPjsummary() {
      await this.$refs.pjsummaryInsertForm.validate()
      if(this.pjsummaryInsertValidate) {
        this.project.token = this.$store.state.jwtToken
        let result = await this.$axios.$post('project.update.php', this.project)
        if(result.message == 'Success') {
          await this.$axios.$post('pjsummary.insert.php', this.project)
          await this.$axios.$post('pjbudget.insert.php', {
            token: this.project.token,
            pjbudgetName: 'งบประมาณ',
            pjbudgetQty: 1,
            pjbudgetUnit: 'รายการ',
            pjbudgetMoney: this.project.pjbudgetMoney,
            projectID: this.project.projectID
          })

          if(this.imageInsertNames.length > 0) {
            let result2 = this.imageInsertNames.map(async projectImage => {
              let formData = new FormData()
              formData.append('token', this.project.token)
              formData.append('function', 'projectImageUpload')
              formData.append('projectYear', this.project.projectYear)
              formData.append('projectID', this.project.projectID)
              formData.append('projectImage', projectImage)
              await this.$axios.$post('project.image.php', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
              });
            });

            await Promise.all(result2)
          }
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          })
          await this.getProjects()
        } else {
          Swal.fire({
            title: 'ผิดพลาด',
            text: result.msg,
            icon: 'error'
          })
        }
        this.insertDialog = false
      }
    },

    productImagesChanged(image) {
      if(image) {
        this.imageInsertNames = image;
      } else {
        this.imageInsertNames = [];
      }
    },

    async showUpdateDialog(project) {
      this.project = JSON.parse(JSON.stringify(project))
      this.getDepartments(this.project.partyID)
      this.imageUpdateNames = []
      this.imageNames = []
      this.imagePath = ''
      let result = await this.$axios.$get('project.image.php', {
        params: {
          token: this.project.token,
          projectYear: this.project.projectYear,
          projectID: this.project.projectID,
          function: 'projectImageGet'
        }
      })
      if(result.message == 'Success') {
        this.imageNames = JSON.parse(JSON.stringify(result.projectImages))
        this.imagePath = result.projectImagePath
      }
      this.updateDialog = true
    },

    async updatePjsummary() {
      await this.$refs.pjsummaryUpdateForm.validate()
      if(this.pjsummaryUpdateValidate) {
        this.project.token = this.$store.state.jwtToken
        let result = await this.$axios.$post('project.update.php', this.project)
        await this.$axios.$post('pjsummary.update.php', this.project)
        await this.$axios.$post('pjbudget.update.php', {
          token: this.project.token,
          pjbudgetMoney: this.project.pjbudgetMoney,
          pjbudgetID: this.project.pjbudgetID
        })

        if(this.imageUpdateNames.length > 0) {
          let result2 = this.imageUpdateNames.map(async projectImage => {
            let formData = new FormData()
            formData.append('token', this.project.token)
            formData.append('function', 'projectImageUpload')
            formData.append('projectYear', this.project.projectYear)
            formData.append('projectID', this.project.projectID)
            formData.append('projectImage', projectImage)
            await this.$axios.$post('project.image.php', formData, {
              headers: {
                  'Content-Type': 'multipart/form-data'
              }
            });
          });
          await Promise.all(result2)
        }
        Swal.fire({
          title: 'สำเร็จ',
          text: result.msg,
          icon: 'success'
        })
        await this.getProjects()
        this.updateDialog = false
      }
    },

    showDeleteImageDialog(imageName) {
      this.imageDeleteName = imageName
      this.deleteDialog = true
    },

    async deletePjsummary() {
        this.project.token = this.$store.state.jwtToken
        if(this.imageDeleteName.length > 0) {
          let formData = new FormData()
          formData.append('token', this.project.token)
          formData.append('function', 'projectImageDelete')
          formData.append('projectYear', this.project.projectYear)
          formData.append('projectID', this.project.projectID)
          formData.append('projectImage', this.imageDeleteName)
          let result = await this.$axios.$post('project.image.php', formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
          });

          if(result.message == 'Success') {
            Swal.fire({
              title: 'สำเร็จ',
              text: result.msg,
              icon: 'success'
            }).then(async ()=>{
              this.imageNames = []
              this.imagePath = ''
              let result2 = await this.$axios.$get('project.image.php', {
                params: {
                  token: this.project.token,
                  projectYear: this.project.projectYear,
                  projectID: this.project.projectID,
                  function: 'projectImageGet'
                }
              })

              if(result2.message == 'Success') {
                this.imageNames = JSON.parse(JSON.stringify(result2.projectImages))
                this.imagePath = result2.projectImagePath
              }
            })
          } else {
            Swal.fire({
              title: 'ผิดพลาด',
              text: result.msg,
              icon: 'error'
            })
          }
        }
        this.deleteDialog = false
    },

    async showInfoDialog(project) {
      this.project = JSON.parse(JSON.stringify(project))
      this.imageUpdateNames = []
      this.imageNames = []
      this.imagePath = ''
      let result = await this.$axios.$get('project.image.php', {
        params: {
          token: this.project.token,
          projectYear: this.project.projectYear,
          projectID: this.project.projectID,
          function: 'projectImageGet'
        }
      })
      if(result.message == 'Success') {
        this.imageNames = JSON.parse(JSON.stringify(result.projectImages))
        this.imagePath = result.projectImagePath
      }
      this.infoDialog = true
    },

    getImageUrl(image) {
      return URL.createObjectURL(image)
    },

    moneyFormat(money) {
      return numeral(money).value()
    }
  },
}
</script>
