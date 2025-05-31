<template>
  <div v-if="userID" class="mt-2">
    <DocumenttypeTable :userID="userID"/>
  </div>
</template>

<script>
export default {
  layout: 'admin_layout',

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
    }
  }
}
</script>
