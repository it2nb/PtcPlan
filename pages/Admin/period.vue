<template>
  <div>
    <!-- <v-row dense>
      <v-col cols="12" class="pt-5 px-5 green lighten-5">
        <div class="col-12 col-md-2 ml-auto pa-0">
          <v-select
            v-model="periodYear"
            label="ปีงบประมาณ พ.ศ."
            :items="periodYears"
            item-text="periodYearBd"
            item-value="periodYear"
            outlined
            dense
          ></v-select>
        </div>
      </v-col>
    </v-row> -->
    <div v-if="personalIDcard" class="mt-2">
        <PeriodTable :personalIDcard="personalIDcard" :insertBt="insertBt" :updateBt="updateBt" :deleteBt="deleteBt" userType="Admin" />
    </div>
  </div>
</template>

<script>
export default {
  layout: 'admin_layout',

  data() {
    return {
      periods: [],
      personalIDcard: null,
      insertBt: 1,
      updateBt: 1,
      deleteBt: 1,
    }
  },

  async mounted() {
    let loginuser = JSON.parse(sessionStorage.getItem("loginuser"))
    this.personalIDcard = loginuser.user.personalIDcard
  },

  methods: {

  },
}
</script>
