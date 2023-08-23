<template>
  <div v-if="userID" class="mt-2">
    <UserDepAdminInfoVue :userID="userID"/>
  </div>
</template>

<script>
import UserDepAdminInfoVue from '~/components/UserDepAdminInfo.vue';
export default {
  layout: 'finance_layout',
  components: {
    UserDepAdminInfoVue,
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
