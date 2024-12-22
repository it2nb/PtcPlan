<template>
  <v-app>
    <v-navigation-drawer
      v-model="drawer"
      clipped
      fixed
      app
      color="grey lighten-5"
    >
      <v-list class="pt-0">
        <v-list-item class="px-1 elevation-1" style="background: linear-gradient(135deg, rgba(0,137,123,1) 0%, rgba(224,242,241,1) 31%, rgba(77,182,172,1) 100%);">
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
                  color="blue-grey darken-2"
                  size="48"
                >
                  <v-icon color="grey lighten-2">
                    fas fa-user
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
          color="teal darken-2"
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title v-text="item.title" />
          </v-list-item-content>
        </v-list-item>
        <v-list-item>
          <v-list-item-content>
            <v-divider></v-divider>
          </v-list-item-content>
        </v-list-item>
        <v-list-item
          v-for="(item) in itemsSys"
          :key="item.key"
          :to="item.to"
          router
          exact
          color="teal darken-2"
          v-if="(user.departmentSys=='Parcel' || user.departmentSys=='Plan' || user.departmentSys=='Account' || user.departmentSys=='Finance') && (user.userID==user.departmentHeadUserID || user.userID==user.departmentReheadUserID)"
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title v-text="item.title" />
          </v-list-item-content>
        </v-list-item>
        <v-list-item
          to="/Department/company"
          router
          exact
          color="teal darken-2"
          v-if="user.departmentSys=='Parcel' && (user.userID==user.departmentHeadUserID || user.userID==user.departmentReheadUserID)"
        >
          <v-list-item-action>
            <v-icon>fas fa-dot-circle</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>ร้านค้า</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item
          to="/Department/ledger"
          router
          exact
          color="teal darken-2"
          v-if="user.departmentSys=='Account' && (user.userID==user.departmentHeadUserID || user.userID==user.departmentReheadUserID)"
        >
          <v-list-item-action>
            <v-icon>fas fa-dot-circle</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>รหัสบัญชีแยกประเภท</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item
          to="/Department/users"
          router
          exact
          color="teal darken-2"
          v-if="user.userID==user.departmentHeadUserID"
        >
          <v-list-item-action>
            <v-icon>fas fa-dot-circle</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>ข้อมูลผู้ใช้</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item v-if="user.userID==user.partyReheadUserID">
          <v-list-item-content>
            <v-divider></v-divider>
          </v-list-item-content>
        </v-list-item>
        <v-list-item v-if="user.userID==user.partyReheadUserID">
          <v-list-item-subtitle>รักษาราชการแทนรองฝ่าย</v-list-item-subtitle>
        </v-list-item>
        <v-list-item
          to="/Department/partydisburse"
          router
          exact
          color="teal darken-2"
          v-if="user.userID==user.partyReheadUserID"
        >
          <v-list-item-action>
            <v-icon>fas fa-dot-circle</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>การจัดซื้อ/เบิกเงิน</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <Headerapp :drawer="drawer" @getDrawer="drawerChange" />
    <v-main>
      <v-container fluid class="mt-1 pa-0">
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
  name: 'DepartmentLayout',

  components: {
    Headerapp
  },

  data () {
    return {
      user: {},
      department: {},
      drawer: true,
      title: this.$store.state.appTitle,
      items: [
        {
          icon: 'fas fa-dot-circle ',
          title: 'ข้อมูลส่วนตัว',
          to: '/Department/',
        },
        {
          icon: 'fas fa-dot-circle',
          title: 'โครงการ',
          to: '/Department/project'
        },
        {
          icon: 'fas fa-dot-circle',
          title: 'การจัดซื้อ/เบิกเงิน',
          to: '/Department/disburse'
        },
      ],
      itemsSys: [
        {
          icon: 'fas fa-dot-circle',
          title: 'ตรวจสอบรายการจัดซื้อ',
          to: '/Department/disbursecheck'
        },
      ],
    }
  },

  async mounted() {
    let loginUser = JSON.parse(sessionStorage.getItem("loginuser")) || {type: ''}
    if(loginUser.type == 'Department') {
      this.user = loginUser.user
    } else {
      this.$router.replace('/')
    }
  },

  methods: {

    drawerChange(data) {
      this.drawer = data.drawer
    },

    logout() {
      sessionStorage.clear()
      this.$router.replace('/')
    }
  }
}
</script>
