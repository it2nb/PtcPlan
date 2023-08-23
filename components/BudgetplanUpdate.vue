<template>
  <v-card>
    <v-card-title class="amber lighten-2">
      <span class="fontBold">แก้ไขข้อมูลแผนงบประมาณรายรับ ปีงบประมาณ พ.ศ.{{ parseInt(budgetplan.budgetplanYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="updateValidate"
      ref="updateForm"
      lazy-validation
      @submit.prevent="updateBudgetplan"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">หมวดงบประมาณ</h3>
            <v-autocomplete
              v-model="updateData.budgetID"
              label="หมวดงบประมาณ"
              :items="budgets"
              item-text="budgetFullname"
              item-value="budgetID"
              outlined
              required
              :rules="[
                ()=>!!updateData.budgetID || 'กรุณากรอกข้อมูล'
              ]"
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" md="8">
            <h3 class="mb-2 fontBold">รายการ</h3>
            <v-text-field
              v-model="updateData.budgetplanDes"
              label="รายการ"
              outlined
              required
              :rules="[
                ()=>!!updateData.budgetplanDes || 'กรุณากรอกข้อมูล'
              ]"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">ประมาณการรายรับ</h3>
            <v-text-field
              v-model="updateData.budgetplanMoney"
              label="ประมาณการรายรับ (บาท)"
              outlined
              required
              :rules="[
                ()=>!!updateData.budgetplanMoney || 'กรุณากรอกข้อมูล'
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
    budgetplan: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      budgets: [],
      updateData: {},
      updateProgress: false,
      updateValidate: null,
    }
  },

  async mounted() {
    if(this.budgetplan) {
      this.updateData = JSON.parse(JSON.stringify(this.budgetplan))
      await this.getBudget()
    }
  },

  methods: {
    async getBudget() {
      let params = {
        token: this.$store.state.jwtToken,
        fn: 'All'
      }
      let result = await this.$axios.$get('budget.php', {params})
      if(result.message == 'Success') {
        this.budgets = JSON.parse(JSON.stringify(result.budget))
      }
    },

    async updateBudgetplan() {
      await this.$refs.updateForm.validate()
      if(this.updateValidate) {
        this.updateProgress = true

        let result = await this.$axios.$post('budgetplan.update.php', this.updateData)

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
    async budgetplan() {
      if(this.budgetplan) {
        this.updateData = JSON.parse(JSON.stringify(this.budgetplan))
      }
    }
  }
}
</script>
