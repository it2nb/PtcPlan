<template>
  <v-card>
    <v-card-title class="red lighten-2">
      <span class="fontBold">ลบข้อมูลรายการค่าใช้จ่าย ปีงบประมาณ พ.ศ.{{ parseInt(expenseplan.expenseplanYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="deleteValidate"
      ref="deleteForm"
      lazy-validation
      @submit.prevent="deleteExpenseplan"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดงบค่าใช้จ่าย</h3>
            {{ deleteData.expenseName }}
          </v-col>
          <v-col cols="12" md="8">
            <h3 class="mb-2 fontBold">รายการ</h3>
            {{ deleteData.expenseplanDes }}
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
    expenseplan: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      budget: {},
      deleteData: {},
      deleteProgress: false,
      deleteValidate: null,
    }
  },

  async mounted() {
    if(this.expenseplan) {
      this.deleteData = JSON.parse(JSON.stringify(this.expenseplan))
      await this.getBudget()
    }
  },

  methods: {
    async getBudget() {
      let params = {
        token: this.$store.state.jwtToken,
        budgetID: this.deleteData.budgetID
      }
      let result = await this.$axios.$get('budget.php', {params})
      if(result.message == 'Success') {
        this.budget = JSON.parse(JSON.stringify(result.budget))
      }
    },

    async deleteExpenseplan() {
      await this.$refs.deleteForm.validate()
      if(this.deleteValidate) {
        this.deleteProgress = true

        let result = await this.$axios.$post('expenseplan.delete.php', this.deleteData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            let params = {
              token: this.$store.state.jwtToken,
              expenseplanID: this.deleteData.expenseplanID
            }
            await this.$axios.$post('expensebudget.delete.php', params)
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
    async expenseplan() {
      if(this.expenseplan) {
        this.deleteData = JSON.parse(JSON.stringify(this.expenseplan))
        await this.getBudget()
      }
    }
  }
}
</script>
