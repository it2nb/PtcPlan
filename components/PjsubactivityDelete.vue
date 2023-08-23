<template>
  <v-card>
    <v-card-title class="red lighten-2">
      <span class="fontBold">ลบกิจกรรมย่อย</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="deleteValidate"
      ref="deleteForm"
      lazy-validation
      @submit.prevent="deletePjsubactivity"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">กิจกรรมหลักที่ {{ pjsubactivity.pjactivityNum }} {{ pjsubactivity.pjactivityName }}</h3>
          </v-col>
          <v-col cols="12" md="2">
            <h3 class="mb-2 fontBold">กิจกรรมย่อยที่</h3>
            {{ deleteData.pjsubactivityNum }}
          </v-col>
          <v-col cols="12" md="10">
            <h3 class="mb-2 fontBold">ชื่อกิจกรรมย่อย</h3>
            {{ deleteData.pjsubactivityName }}
          </v-col>
        </v-row>
      </v-card-text>
      <v-divider class="green lighten-2"></v-divider>
      <v-card-actions>
        <div class="col-12 text-center">
          <v-btn
            @click="cancelDelete"
            outlined
          >
            ยกเลิก
          </v-btn>
          <v-progress-circular
            indeterminate
            color="success"
            v-if="deleteProgress"
          ></v-progress-circular>
          <v-btn
            type="submit"
            color="red darken-1"
            dark
            large
            v-else
          >
            ลบ
          </v-btn>
        </div>
      </v-card-actions>
    </v-form>
  </v-card>
</template>

<script>
import Swal from 'sweetalert2'
export default {
  props: {
    pjsubactivity: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      deleteData: {},
      deleteProgress: false,
      deleteValidate: null,
    }
  },

  async mounted() {
    if(this.pjsubactivity) {
      this.deleteData = JSON.parse(JSON.stringify(this.pjsubactivity))
    }
  },

  methods: {
    async deletePjsubactivity() {
      await this.$refs.deleteForm.validate()
      if(this.deleteValidate) {
        this.deleteProgress = true

        let result = await this.$axios.$post('pjsubactivity.delete.php', this.deleteData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            let params = {
              token: this.$store.state.jwtToken,
              pjsubactivityID: this.deleteData.pjsubactivityID
            }
            await this.$axios.$post('pjbudget.delete.php', params)
            this.deleteProgress = false
            this.$emit('getDeleteStatus', {'status': true})
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.deleteProgress = false
            this.$emit('getDeleteStatus', {'status': true})
          })
        }
      }
    },

    cancelDelete() {
      this.$emit('getDeleteStatus', {'status': true})
    }

  },

  watch: {
    async pjsubactivity() {
      if(this.pjsubactivity) {
        this.deleteData = JSON.parse(JSON.stringify(this.pjsubactivity))
      }
    }
  }
}
</script>
