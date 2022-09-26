<template>
  <div style="background: linear-gradient(310deg, rgba(250,174,93,1) 0%, rgba(250,174,93,1) 5%, rgba(255,255,255,1) 10%);">
    <h3 class="mx-md-5 px-md-5 fontBold blue--text text--darken-4">{{title}}</h3>
  </div>
</template>

<script>
export default {
  name: 'DefaultLayout',
  data () {
    return {
      user: {},
      title: this.$store.state.appTitle,
    }
  }
}
</script>
