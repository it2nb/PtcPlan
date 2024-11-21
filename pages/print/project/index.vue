<template>
  <div style="line-height: 1.8">
    <ProjectPrint :pid="projectID" v-if="projectID"/>
  </div>
</template>
<script>
import ProjectPrint from '~/components/ProjectPrint.vue';

var numeral = require('numeral')
export default {
  layout: 'print_layout',
  data() {
    return {
      projectID: null,
    }
  },

  async mounted() {
    this.projectID = this.$route.query.pid
  },
}
</script>

<style scoped>
  @page {
    size: A4;
  }
</style>
