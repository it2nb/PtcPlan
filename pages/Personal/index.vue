<template>
  <div v-if="personalIDcard" class="mt-5">
    <PersonalInfoVue :personalIDcard="personalIDcard"/>
  </div>
</template>

<script>
import PersonalInfoVue from '~/components/PersonalInfo.vue';
export default {
  layout: 'personal_layout',
  components: {
    PersonalInfoVue,
  },

  data() {
    return {
      personalIDcard: null
    }
  },

  async mounted() {
    let loginpersonal = JSON.parse(sessionStorage.getItem("loginuser"))
    this.personalIDcard = loginpersonal.personal.personalIDcard
  }
}
</script>
