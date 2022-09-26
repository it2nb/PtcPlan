<template>
  <v-app>
    <v-navigation-drawer
      v-model="drawer"
      clipped
      fixed
      app
    >
      <v-list class="pt-0">
        <v-list-item class="px-1" style="background: linear-gradient(135deg, rgba(73,194,241,1) 0%, rgba(233,249,255,1) 31%, rgba(181,240,252,1) 100%);">
          <v-list-item-content>
            <v-row class="pa-0 col-12 align-center">
              <v-col cols="9" class="text-right">
                <div class="fontBold">
                  {{ user.userName }}
                </div>
                <div class="mt-1">
                  <v-btn
                    x-small
                    text
                    outlined
                    color="red darken-3"
                    @click="logout"
                  >
                    <v-icon x-small class="mr-1">fas fa-sign-out-alt</v-icon>ออกจากระบบ
                  </v-btn>
                </div>
              </v-col>
              <v-col cols="3" class="text-center">
                <v-avatar
                  color="primary"
                  size="48"
                >
                  <v-icon color="grey lighten-2">
                    fas fa-cog
                  </v-icon>

                </v-avatar>
              </v-col>
            </v-row>

          </v-list-item-content>
        </v-list-item>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          :to="item.to"
          router
          exact
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title v-text="item.title" />
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar
      clipped-left
      clipped-right
      fixed
      app
      class="elevation-1 white"
      style="background: linear-gradient(0deg, rgba(252,151,34,1) 0%, rgba(252,151,34,1) 8%, rgba(255,255,255,1) 12%);"
    >
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <v-toolbar-title class="col-12">
        <Headerapp />
      </v-toolbar-title>
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
  name: 'AdminLayout',

  components: {
    Headerapp
  },

  data () {
    return {
      user: {},
      drawer: true,
      title: this.$store.state.appTitle,
      items: [
        {
          icon: 'fas fa-dot-circle ',
          title: 'ยุทธศาสตร์สถานศึกษา',
          to: '/Admin/orgstrategic',
        },
        {
          icon: 'fas fa-dot-circle',
          title: 'โครงการ',
          to: '/Admin/project'
        },
        {
          icon: 'fas fa-dot-circle',
          title: 'แผนกงาน',
          to: '/Admin/department'
        },
        {
          icon: 'fas fa-dot-circle ',
          title: 'นโยบายที่เกี่ยวข้อง',
          to: '/Admin/strategic',
        },
      ],
    }
  },

  mounted() {
    let loginUser = JSON.parse(sessionStorage.getItem("loginuser")) || {type: ''}
    if(loginUser.type == 'Admin') {
      this.user = loginUser.user
    } else {
      this.$router.replace('/')
    }
  },

  methods: {
    logout() {
      sessionStorage.clear()
      this.$router.replace('/')
    }
  }
}
</script>
