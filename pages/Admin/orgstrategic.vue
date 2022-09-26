<template>
  <v-container>
    <OrgstrategicTable :orgstrategics="orgstrategics" v-if="orgstrategics.length > 0" />
  </v-container>
</template>

<script>
import OrgstrategicTable from '~/components/OrgstrategicTable';
export default {
  layout: 'admin_layout',

  components: {
    OrgstrategicTable
  },

  data() {
    return {
      orgstrategics: []
    }
  },

  async mounted() {
    await this.getOrgstrategics()
  },

  methods: {
    async getOrgstrategics() {
      let result = await this.$axios.$get('orgstrategic.php', {
        params: {
          token: this.$store.state.jwtToken,
        }
      })

      if(result.message === 'Success') {
        this.orgstrategics = JSON.parse(JSON.stringify(result.orgstrategic))
      }
    }
  }

}
</script>
