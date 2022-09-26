<template>
  <v-app>
    <v-app-bar
      clipped-left
      clipped-right
      fixed
      app
      class="elevation-1 white"

    >
      <v-toolbar-title class="pa-0 col-12 text-center">
        <h3 class="mx-md-5 px-md-5 fontBold blue--text text--darken-4">{{title}}</h3>
      </v-toolbar-title>
      <template v-slot:extension>
        <div class="my-5 col-12 text-center pa-1">
          <v-btn text color="orange darken-2" to="/">หน้าหลัก</v-btn>
          <v-btn text color="orange darken-2" to="/pjsummary">รายงานผล</v-btn>
          <v-btn text color="orange  darken-2" to="/login">เข้าสู่ระบบ</v-btn>
        </div>
      </template>
    </v-app-bar>
    <v-main>
      <v-container>
        <Nuxt />
      </v-container>
    </v-main>
    <v-footer
      absolute
      app
    >
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<script>
import Headerapp from '~/components/Headerapp'
export default {
  name: 'DefaultLayout',

  components: {
    Headerapp
  },

  data () {
    return {
      title: this.$store.state.appTitle
    }
  }
}
</script>
