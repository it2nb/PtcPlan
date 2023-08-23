<template>
  <div>
    <div v-if="personalIDcard" class="mt-2">
        <UserTable :insertBt="insertBt" :updateBt="updateBt" :deleteBt="deleteBt" userType="Admin" />
    </div>
  </div>
</template>

<script>
import UserTable from '~/components/UserTable';
export default {
  layout: 'admin_layout',

  components: {
    UserTable
  },

  data() {
    return {
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

watch: {

}

}
</script>
