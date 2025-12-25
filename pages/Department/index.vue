<template>
  <div v-if="userID" class="mt-5">
    <UserDepartmentInfoVue :userID="userID"/>
    <!-- <VueSignaturePad width="500px" height="300px" ref="signaturePad" :options="signatureOptions" />
    <div>
      <button @click="saveSignature">Save</button>
      <button @click="undoSignature">Undo</button>
      <button @click="clearSignature">Clear</button>
    </div> -->
  </div>
</template>

<script>
import UserDepartmentInfoVue from '~/components/UserDepartmentInfo.vue';
export default {
  layout: 'department_layout',
  components: {
    UserDepartmentInfoVue,
  },

  data() {
    return {
      userID: null,
      signatureOptions: {
        penColor: 'rgb(0, 0, 0)',
        backgroundColor: 'rgb(255, 255, 255)',
      },
    }
  },

  async mounted() {
    let loginuser = JSON.parse(sessionStorage.getItem("loginuser"))
    this.userID = loginuser.user.userID
  },

  methods: {
    saveSignature() {
      const { isEmpty, data } = this.$refs.signaturePad.saveSignature();
      console.log('Is empty:', isEmpty);
      console.log('Signature data:', data);
      // You can send 'data' to your backend or display it
    },
    undoSignature() {
      this.$refs.signaturePad.undoSignature();
    },
    clearSignature() {
      this.$refs.signaturePad.clearSignature();
    },
  }
}
</script>
