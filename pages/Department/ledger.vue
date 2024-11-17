<template>
  <div>
    <v-row dense>
      <v-col cols="12" class="pt-5 px-5 green lighten-5">
        <div class="col-12 col-md-2 ml-auto pa-0">

        </div>
      </v-col>
    </v-row>
    <div v-if="userStatus || departmentSys" class="mt-2">
        <LedgerTable :userType="userStatus" :departmentSys="departmentSys"/>
    </div>
  </div>
</template>

<script>
export default {
  layout: 'department_layout',

  data() {
    return {
      departmentID: null,
      userID: null,
      userStatus: null,
      departmentSys: null,
      disburses: [],
      personalIDcard: null,
      disburseYear: null,
      insertBt: 1,
      updateBt: 1,
      deleteBt: 1,
      periodYears: []
    }
  },

  async mounted() {
    let loginuser = JSON.parse(sessionStorage.getItem("loginuser"))
    this.departmentID = loginuser.user.departmentID
    this.userID = loginuser.user.userID
    this.userStatus = loginuser.user.userStatus
    this.departmentSys = loginuser.user.departmentSys
  },

  methods: {

  },

watch: {

}

}
</script>
