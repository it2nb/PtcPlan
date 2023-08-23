<template>
  <div class="container">
    <v-row justify="center">
      <v-col cols="12">
        <v-card elevation="1">
          <v-card-title class="ptcBg white--text">
            <b>กิจกรรมโครงการ</b>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <div>
              <v-list>
                  <v-list-item  v-if="!readOnly">
                    <v-list-item-content>
                      <v-list-item-title>
                        <v-btn color="success" text @click="showInsertDialog">
                          <v-icon small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มกิจกรรมหลัก
                        </v-btn>
                      </v-list-item-title>
                    </v-list-item-content>
                  </v-list-item>
                <template v-for="pjactivity in pjactivities">
                  <v-list-item :key="pjactivity.key">
                    <v-list-item-content>
                      <v-list-item-title class="pa-3 blue-grey lighten-5">
                        <div>
                          กิจกรรมหลักที่ {{ pjactivity.pjactivityNum }} {{ pjactivity.pjactivityName }}
                        </div>
                        <div class="text-right" v-if="!readOnly">
                          <v-btn color="warning" icon  small @click="showUpdateDialog(pjactivity)">
                            <v-icon small class="mr-1">fas fa-edit</v-icon>
                          </v-btn>
                          <v-btn color="red darken-2" icon  small @click="showDeleteDialog(pjactivity)" v-if="parseFloat(pjactivity.disburseMoney)<=0">
                            <v-icon small class="mr-1">fas fa-trash</v-icon>
                          </v-btn>
                          <v-btn color="success" text small @click="showInsertSubDialog(pjactivity)">
                            <v-icon x-small class="mr-1">fas fa-plus-circle</v-icon> เพิ่มกิจกรรมย่อย
                          </v-btn>
                        </div>
                      </v-list-item-title>
                      <v-list-item-subtitle class="ml-5 pa-3" v-for="pjsubactivity in pjactivity.pjsubactivity" :key="pjsubactivity.key">
                        <v-row>
                          <v-col cols="12" md="6">
                            กิจกรรมย่อยที่ {{ pjactivity.pjactivityNum }}.{{ pjsubactivity.pjsubactivityNum }} {{ pjsubactivity.pjsubactivityName }}
                          </v-col>
                          <v-col cols="6" md="3" class="text-no-wrap">
                            {{ thaiDate(pjsubactivity.pjsubactivityStart) }} - {{ thaiDate(pjsubactivity.pjsubactivityEnd) }}
                          </v-col>
                          <v-col cols="6" md="3" class="text-no-wrap text-right" v-if="!readOnly">
                            <v-btn color="warning" icon  small @click="showUpdateSubDialog(pjsubactivity)" >
                              <v-icon small class="mr-1">fas fa-edit</v-icon>
                            </v-btn>
                            <v-btn color="red darken-2" icon  small @click="showDeleteSubDialog(pjsubactivity)" v-if="parseFloat(pjsubactivity.disburseMoney)<=0">
                              <v-icon small class="mr-1">fas fa-trash</v-icon>
                            </v-btn>
                          </v-col>
                        </v-row>
                      </v-list-item-subtitle>
                    </v-list-item-content>
                  </v-list-item>
                  <v-divider :key="pjactivity.key"></v-divider>
                </template>
              </v-list>
            </div>
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
                <PjactivityInsertVue :pjactivity="pjactivityData" @getInsertStatus="insertPjactivity"/>
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
                <PjactivityUpdateVue :pjactivity="pjactivityData" @getUpdateStatus="updatePjactivity"/>
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
                <PjactivityDeleteVue :pjactivity="pjactivityData" @getDeleteStatus="deletePjactivity"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <!-- Subactivity-->

    <v-row justify="center">
      <v-dialog
        v-model="insertSubDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="light-green lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="insertSubDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <PjsubactivityInsertVue :pjsubactivity="pjsubactivityData" @getInsertStatus="insertPjsubactivity"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="updateSubDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="amber lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="updateSubDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <PjsubactivityUpdateVue :pjsubactivity="pjsubactivityData" @getUpdateStatus="updatePjsubactivity"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="deleteSubDialog"
        persistent
        fullscreen
      >
        <v-card color="rgba(0,0,0, .5)">
          <v-row>
            <v-col class="col-11 col-md-10 mx-auto my-5">
              <v-card>
                <v-card-actions class="red lighten-4">
                  <v-spacer></v-spacer>
                  <v-btn icon color="black" @click="deleteSubDialog = false">
                    <v-icon>fas fa-times</v-icon>
                  </v-btn>
                </v-card-actions>
                <PjsubactivityDeleteVue :pjsubactivity="pjsubactivityData" @getDeleteStatus="deletePjsubactivity"/>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>
    </v-row>

  </div>
</template>

<script>
import PjactivityInsertVue from './PjactivityInsert.vue'
import PjactivityUpdateVue from './PjactivityUpdate.vue'
import PjactivityDeleteVue from './PjactivityDelete.vue'
import PjsubactivityInsertVue from './PjsubactivityInsert.vue'
import PjsubactivityUpdateVue from './PjsubactivityUpdate.vue'
import PjsubactivityDeleteVue from './PjsubactivityDelete.vue'
export default {
  components: {
    PjactivityInsertVue,
    PjactivityUpdateVue,
    PjactivityDeleteVue,
    PjsubactivityInsertVue,
    PjsubactivityUpdateVue,
    PjsubactivityDeleteVue,
  },

  props: {
    projectID: {
      type: String,
      default: null
    },
    periodYear: {
      type: Number,
      default: null
    },
    readOnly: {
      type: Boolean,
      default: false,
    }
  },

  data() {
    return {
      pjactivities: [],

      pjactivityData: {},

      insertDialog: false,
      insertProgress: false,
      insertValidate: null,

      updateDialog: false,
      updateProgress: false,
      updateValidate: null,

      deleteDialog: false,
      deleteProgress: false,
      deleteValidate: null,

      pjsubactivityData: {},

      insertSubDialog: false,
      insertSubProgress: false,
      insertSubValidate: null,

      updateSubDialog: false,
      updateSubProgress: false,
      updateSubValidate: null,

      deleteSubDialog: false,
      deleteSubProgress: false,
      deleteSubValidate: null,
    }
  },

  async mounted() {
    if(this.projectID) {
      await this.getPjactivity()
    }
  },

  methods: {
    async getPjactivity() {
      let params = {
        token: this.$store.state.jwtToken,
        projectID: this.projectID
      }
      let result = await this.$axios.$get('pjactivity.php', {
        params: params
      })

      if(result.message == 'Success') {
        this.pjactivities = JSON.parse(JSON.stringify(result.pjactivity))
      }
    },

    showInsertDialog() {
      this.pjactivityData = {
        token: this.$store.state.jwtToken,
        projectID: this.projectID
      }
      this.insertDialog = true
    },

    async insertPjactivity(res) {
      if(res.status) {
        await this.getPjactivity()
        this.insertDialog = false
      } else {
        this.insertDialog = false
      }
    },

    showUpdateDialog(pjactivity) {
      this.pjactivityData = pjactivity
      this.pjactivityData.token = this.$store.state.jwtToken
      this.updateDialog = true
    },

    async updatePjactivity(res) {
      if(res.status) {
        await this.getPjactivity()
        this.updateDialog = false
      } else {
        this.updateDialog = false
      }
    },

    showDeleteDialog(pjactivity) {
      this.pjactivityData = pjactivity
      this.pjactivityData.token = this.$store.state.jwtToken
      this.deleteDialog = true
    },

    async deletePjactivity(res) {
      if(res.status) {
        await this.getPjactivity()
        this.deleteDialog = false
      } else {
        this.deleteDialog = false
      }
    },

    showInsertSubDialog(pjactivity) {
      this.pjsubactivityData = {
        token: this.$store.state.jwtToken,
        pjactivityNum: pjactivity.pjactivityNum,
        pjactivityName: pjactivity.pjactivityName,
        pjactivityID: pjactivity.pjactivityID,
        projectID: this.projectID
      }
      this.insertSubDialog = true
    },

    async insertPjsubactivity(res) {
      if(res.status) {
        await this.getPjactivity()
        this.insertSubDialog = false
      } else {
        this.insertSubDialog = false
      }
    },

    showUpdateSubDialog(pjsubactivity) {
      this.pjsubactivityData = pjsubactivity
      this.pjsubactivityData.token = this.$store.state.jwtToken
      this.pjsubactivityData.pjactivityNum = pjsubactivity.pjactivityNum
      this.pjsubactivityData.pjactivityName = pjsubactivity.pjactivityName

      this.updateSubDialog = true
    },

    async updatePjsubactivity(res) {
      if(res.status) {
        this.getPjactivity()
        this.updateSubDialog = false
      } else {
        this.updateSubDialog = false
      }
    },

    showDeleteSubDialog(pjsubactivity) {
      this.pjsubactivityData = pjsubactivity
      this.pjsubactivityData.token = this.$store.state.jwtToken
      this.pjsubactivityData.pjactivityNum = pjsubactivity.pjactivityNum
      this.pjsubactivityData.pjactivityName = pjsubactivity.pjactivityName
      this.deleteSubDialog = true
    },

    async deletePjsubactivity(res) {
      if(res.status) {
        await this.getPjactivity()
        this.deleteSubDialog = false
      } else {
        this.deleteSubDialog = false
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

  },

  watch: {
    async projectID() {
      await this.getPjactivity()
    }
  }
}
</script>
