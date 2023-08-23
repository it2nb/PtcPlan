<template>
  <div v-if="userID" class="mt-5">
    <UserDepartmentInfoVue :userID="userID"/>
  </div>
</template>

<script>
import UserDepartmentInfoVue from '~/components/UserDepartmentInfo.vue';
export default {
  layout: 'department_layout',
  components: {
    UserDepartmentInfoVue,
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
