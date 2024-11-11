<template>
  <div v-if="userID" class="mt-2">
    <UserDepAdminInfoVue :userID="userID"/>
  </div>
</template>

<script>
import UserDepAdminInfoVue from '~/components/UserDepAdminInfo.vue';
export default {
  layout: 'plan_layout',
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
  },

  methods: {
    async sendLineNotify() {
      let result  = await this.$axios.post('https://notify-api.line.me/api/notify', {message:'Test'}, {
        headers: {
          Authorization: 'Bearer eW5bdWePAvZK6hOlsh1e2YJxvFfwwOSpjddt6Y4Fv7C'
        }
      })

      // let result = await this.$axios.$post('sendline.php', {
      //   token: 'eW5bdWePAvZK6hOlsh1e2YJxvFfwwOSpjddt6Y4Fv7C',
      //   message: 'Test \nทดสอบ'
      // })
    }
  }
}
</script>
