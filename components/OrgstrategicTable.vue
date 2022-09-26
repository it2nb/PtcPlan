<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="light-blue lighten-5">
            <b>ยุทธศาสตร์สถานศึกษา</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="orgstrategics"
              :search="search"
              :items-per-page="-1"
            >
              <template v-slot:top>
                <v-row>
                  <v-col cols="12" md="6">
                    <!-- <v-select
                      v-model="orgstrategicID"
                      label="ยุทธศาสตร์"
                      :items="orgstrategics"
                      item-text="orgstrategicFullname"
                      item-value="orgstrategicID"
                      outlined
                      @change="filterProjects"
                    ></v-select> -->
                    <v-btn color="success" text @click="showInsertDialog">
                      <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มยุทธศาสตร์
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

              <template v-slot:item.orgstrategicEnable="{ item }">
                <v-chip color="success" v-if="item.orgstrategicEnable==1">
                  <v-icon class="mr-1">fas fa-check-circle</v-icon> ใช้งาน
                </v-chip>
                <v-chip color="red" small dark v-else>
                  <v-icon small class="mr-1">fas fa-exclamation</v-icon> ไม่ใช้งาน
                </v-chip>
              </template>
              <template v-slot:item.actions="{ item }">
                <div  class="text-no-wrap">
                  <v-btn color="warning" icon  small @click="showUpdateDialog(item)">
                    <v-icon small class="mr-1">fas fa-edit</v-icon>
                  </v-btn>
                  <v-btn color="red darken-2" icon  small @click="showDeleteDialog(item)">
                    <v-icon small class="mr-1">fas fa-trash</v-icon>
                  </v-btn>
                </div>
              </template>
            </v-data-table>
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
                <v-card-title class="light-green lighten-2">
                  <span class="fontBold">บันทึกข้อมูลยุทธศาสตร์ของสถานศึกษา</span>
                </v-card-title>
                <v-divider class="green"></v-divider>
                <v-form
                  v-model="orgstrategicInsertValidate"
                  ref="orgstrategicInsertForm"
                  lazy-validation
                  @submit.prevent="insertOrgstrategic"
                  class="mt-4"
                >
                  <v-card-text>
                    <v-row>
                      <v-col cols="12" md="2">
                        <h3 class="mb-2 fontBold">ยุทธศาสตร์ที่</h3>
                        <v-text-field
                          v-model="orgstrategicInsert.orgstrategicNum"
                          label="ยุทธศาสตร์ที่"
                          outlined
                          required
                          :rules="[
                            ()=>!!orgstrategicInsert.orgstrategicNum || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" md="10">
                        <h3 class="mb-2 fontBold">ชื่อยุทธศาสตร์</h3>
                        <v-text-field
                          v-model="orgstrategicInsert.orgstrategicName"
                          label="ชื่อยุทธศาสตร์"
                          outlined
                          required
                          :rules="[
                            ()=>!!orgstrategicInsert.orgstrategicName || 'กรุณากรอกข้อมูล'
                          ]"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">คำอธิบาย</h3>
                        <v-textarea
                          v-model="orgstrategicInsert.orgstrategicDetail"
                          label="คำอธิบาย"
                          outlined
                        ></v-textarea>
                      </v-col>
                      <v-col cols="12">
                        <h3 class="mb-2 fontBold">สถานุะ</h3>
                        <v-switch
                          v-model="orgstrategicInsert.orgstrategicEnable"
                          label="สถานะ"
                          :true-value="1"
                          :false-value="0"
                          inset
                        ></v-switch>
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
  </div>
</template>

<script>
export default {
  props: {
    orgstrategics: {
      type: Array,
      default: () => []
    }
  },

  data() {
    return {
      headers: [
        {
          text: '#',
          align: 'center',
          sortable: false,
          value: 'orgstrategicID',
        },
        { text: 'ยุทธศาสตร์ที่', value: 'orgstrategicNum', align: 'center' },
        { text: 'ชื่อยุทธศาสตร์', value: 'orgstrategicName', align: 'left', class: 'text-center' },
        // { text: 'ผู้รับผิดชอบ', value: '' },
        { text: 'สถานะ', value: 'orgstrategicEnable', align: 'center' },
        { text: '', value: 'actions', align: 'center' },
      ],
      search: '',
      orgstrategicInsert: {
        orgstrategicEnable: 1
      },
      insertDialog: false,
      insertProgress: false,
      orgstrategicInsertValidate: null,

      updateDialog: false,
      updateProgress: false,
      orgstrategicUpdateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      orgstrategicDeleteValidate: null,
    }
  },

  methods: {
    showInsertDialog() {
      this.insertDialog = true
    },

    showUpdateDialog() {
      this.updateDialog = true
    },

    showDeleteDialog() {
      this.deleteDialog = true
    }
  }
}
</script>
