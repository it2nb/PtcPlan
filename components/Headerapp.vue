<template>
  <v-app-bar
    clipped-left
    clipped-right
    fixed
    app
    height="60"
    class="elevation-2"
    style="background-color: #A90D1A"
  >
    <v-app-bar-nav-icon @click.stop="drawerChange" class="white--text" />
    <v-toolbar-title class="col-12">
      <div>
        <img src="/logo.jpg" width="60" align="middle" />
        <span class="ml-2 fontBold white--text">{{title}} {{subTitle}}</span>
      </div>
    </v-toolbar-title>
  </v-app-bar>

</template>

<script>
export default {
  name: 'DefaultLayout',
  props: {
    drawer: {
      type: Boolean,
      default: 1,
    }
  },

  data () {
    return {
      user: {},
      title: this.$store.state.appTitle,
      subTitle: this.$store.state.appSubTitle,
      hdrawer: this.drawer
    }
  },

  methods: {
    drawerChange() {
      this.$emit('getDrawer', {'drawer': !this.hdrawer})
    }
  },

  watch: {
    drawer() {
      this.hdrawer = this.drawer
    }
  }
}
</script>
