<template>
  <v-app>
    <v-app-bar
      clipped-left
      clipped-right
      class="elevation-2"
      style="background-color: #A90D1A"
      height="190"
      max-height="240"
    >
      <v-toolbar-title class="pa-0 col-12 text-center">
        <v-img src="/logo.jpg" width="100" class="mx-auto my-1"></v-img>
        <h3 class="mx-md-5 px-md-5 fontBold white--text">{{title}}</h3>
        <h4 class="mx-md-5 px-md-5 fontBold white--text">{{subTitle}}</h4>
      </v-toolbar-title>
      <template v-slot:extension>
        <!-- <div class="my-5 col-12 text-center">
          <v-btn text color="white darken-2" to="/">หน้าหลัก</v-btn>
          <v-btn text color="white darken-2" to="/project">โครงการ</v-btn>
          <v-btn text color="white darken-2" to="/budget">งบประมาณ</v-btn>
          <v-btn text color="white  darken-2" to="/login">เข้าสู่ระบบ</v-btn>
        </div> -->
        <v-tabs dark color="orange lighten-4" centered>
          <v-tab to="/">
            หน้าหลัก
          </v-tab>
          <v-tab to="/project">
            โครงการ
          </v-tab>
          <v-tab to="/budget">
            งบประมาณ
          </v-tab>
          <v-tab to="/document">
            เอกสารเผยแพร่
          </v-tab>
          <!-- <v-tab to="/login">
            เข้าสู่ระบบ
          </v-tab> -->
        </v-tabs>
      </template>
    </v-app-bar>
    <div class="amber lighten-5 mb-1 pb-1 elevation-3" >
        <LoginBar class="col-12 col-md-8 col-xl-6 mx-auto" />
    </div>
    <v-main>
      <v-container fluid  class="mt-1 pa-0">
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
import LoginBar from '~/components/LoginBar.vue';
export default {
  name: 'DefaultLayout',

  components: {
    Headerapp,
    LoginBar
},

  data () {
    return {
      title: this.$store.state.appTitle,
      subTitle: this.$store.state.appSubTitle
    }
  }
}
</script>
