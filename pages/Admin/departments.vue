<template>
  <div>
    <div v-if="personalIDcard" class="mt-2">
        <DepartmentTable :personalIDcard="personalIDcard" :insertBt="insertBt" :updateBt="updateBt" :deleteBt="deleteBt" userType="Admin" />
    </div>
  </div>
</template>

<script>
import OrgstrategicTable from '~/components/OrgstrategicTable';
export default {
  layout: 'admin_layout',

  components: {
    OrgstrategicTable
  },

  data() {
    return {
      orgstrategics: [],
      personalIDcard: null,
      orgstrategicYear: null,
      insertBt: 1,
      updateBt: 1,
      deleteBt: 1,
      periodYears: []
    }
  },

  async mounted() {
    let loginuser = JSON.parse(sessionStorage.getItem("loginuser"))
    this.personalIDcard = loginuser.user.personalIDcard
  },

  methods: {
    
  },

watch: {
  
}

}
</script>
