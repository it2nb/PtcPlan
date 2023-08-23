<template>
  <div v-if="userID" class="mt-2">
    <UserAdminInfoVue :userID="userID"/>
  </div>
</template>

<script>
import UserAdminInfoVue from '~/components/UserAdminInfo.vue';
export default {
  layout: 'admin_layout',
  components: {
    UserAdminInfoVue,
  },

  data() {
    return {
      userID: null
    }
  },

  async mounted() {
    let loginuser = JSON.parse(sessionStorage.getItem("loginuser"))
    this.userID = loginuser.user.userID
  }
}
</script>
