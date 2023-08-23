<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลรายการค่าใช้จ่าย ปีงบประมาณ พ.ศ.{{ parseInt(expenseplan.expenseplanYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateExpenseplan"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">หมวดค่าใช้จ่าย</h3>
            <v-autocomplete
              v-model="updateData.expenseID"
              label="หมวดค่าใช้จ่าย"
              :items="expenses"
              item-text="expenseName"
              item-value="expenseID"
              outlined
              required
              :rules="[
                ()=>!!updateData.expenseID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="8">
            <h3 class="mb-2 fontBold">รายการ</h3>
            <v-text-field
              v-model="updateData.expenseplanDes"
              label="รายการ"
              outlined
              required
              :rules="[
                ()=>!!updateData.expenseplanDes || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
        </v-row>
      </v-card-text>
      <v-divider class="green lighten-2"></v-divider>
      <v-card-actions>
        <div class="col-12 text-center">
          <v-btn
            @click="cancelUpdate"
            outlined
          >
            ยกเลิก
          </v-btn>
          <v-progress-circular
            indeterminate
            color="success"
            v-if="updateProgress"
          ></v-progress-circular>
          <v-btn
            type="submit"
            color="warning darken-1"
            large
            v-else
          >
            แก้ไข
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
      expenses: [],
      updateData: {},
      updateProgress: false,
      updateValidate: null,
    }
  },

  async mounted() {
    if(this.expenseplan) {
      this.updateData = JSON.parse(JSON.stringify(this.expenseplan))
      await this.getExpense()
    }
  },

  methods: {
    async getExpense() {
      let params = {
        token: this.$store.state.jwtToken,
        fn: 'All'
      }
      let result = await this.$axios.$get('expense.php', {params})
      if(result.message == 'Success') {
        this.expenses = JSON.parse(JSON.stringify(result.expense))
      }
    },

    async updateExpenseplan() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        let result = await this.$axios.$post('expenseplan.update.php', this.updateData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            this.updateProgress = false
            this.$emit('getUpdateStatus', {'status': true})
          })
        } else {
          Swal.fire({
            title: 'ไม่สำเร็จ',
            text: result.msg,
            icon: 'error'
          }).then(()=>{
            this.updateProgress = false
            this.$emit('getUpdateStatus', {'status': true})
          })
        }
      }
    },

    cancelUpdate() {
      this.$emit('getUpdateStatus', {'status': true})
    }

  },

  watch: {
    async expenseplan() {
      if(this.expenseplan) {
        this.updateData = JSON.parse(JSON.stringify(this.expenseplan))
        await this.getExpense()
      }
    }
  }
}
</script>
