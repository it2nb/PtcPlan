<template>
  <div>
    <div v-if="personalIDcard" class="mt-2">
        <UserTable :insertBt="insertBt" :updateBt="updateBt" :deleteBt="deleteBt" userType="Department" />
    </div>
  </div>
</template>

<script>
import UserTable from '~/components/UserTable';
export default {
  layout: 'department_layout',

  components: {
    UserTable
  },

  data() {
    return {
      personalIDcard: null,
      user: {},
      insertBt: 1,
      updateBt: 1,
      deleteBt: 1,
    }
  },

  async mounted() {
    let loginuser = JSON.parse(sessionStorage.getItem("loginuser"))
    this.user = loginuser.user
    console.log(this.user)
    this.personalIDcard = loginuser.user.personalIDcard
  },

  methods: {

  },

watch: {

}

}
</script>
