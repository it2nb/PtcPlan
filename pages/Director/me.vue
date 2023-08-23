<template>
  <div v-if="userID" class="mt-2">
    <UserPartyInfoVue :userID="userID"/>
  </div>
</template>

<script>
import UserPartyInfoVue from '~/components/UserPartyInfo.vue';
export default {
  layout: 'director_layout',
  components: {
    UserPartyInfoVue,
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
