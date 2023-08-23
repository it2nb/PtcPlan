<template>
  <v-card>
    <v-card-title class="red lighten-2">
      <span class="fontBold">ลบข้อมูลงบประมาณที่ได้รับจัดสรร ปีงบประมาณ พ.ศ.{{ parseInt(budgetslip.budgetslipYear)+543 }}</span>
    </v-card-title>
    <v-divider class="green"></v-divider>
    <v-form
      v-model="deleteValidate"
      ref="deleteForm"
      lazy-validation
      @submit.prevent="deleteBudgetslip"
      class="mt-4"
    >
      <v-card-text>
        <v-row dense>
          <v-col cols="12">
            <h3 class="mb-2 fontBold">หมวดงบประมาณรายรับ</h3>
            {{ budgetplan.budgetFullname }}
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">เลขที่ใบจัดสรร</h3>
            {{ deleteData.budgetslipNo }}
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">วันที่ได้รับจัดสรร</h3>
            {{ thaiDate(deleteData.budgetslipDate) }}
          </v-col>
          <v-col cols="12" md="4">
            <h3 class="mb-2 fontBold">จำนวนเงิน</h3>
            {{ moneyFormat(deleteData.budgetslipMoney) }}
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
import numeral from 'numeral'
import Swal from 'sweetalert2'
export default {
  props: {
    budgetslip: {
      type: Object,
      default: () => {}
    },
  },

  data() {
    return {
      budgetplan: {},
      deleteData: {},
      deleteProgress: false,
      deleteValidate: null,
    }
  },

  async mounted() {
    if(this.budgetslip) {
      await this.getBudgetplan()
      this.deleteData = JSON.parse(JSON.stringify(this.budgetslip))
    }
  },

  methods: {
    async getBudgetplan() {
      let params = {
        token: this.budgetslip.token,
        budgetplanID: this.budgetslip.budgetplanID
      }
      let result = await this.$axios.$get('budgetplan.php', {params})
      if(result.message === 'Success') {
        this.budgetplan = JSON.parse(JSON.stringify(result.budgetplan))
      }
    },

    async deleteBudgetslip() {
      await this.$refs.deleteForm.validate()
      if(this.deleteValidate) {
        this.deleteProgress = true

        let result = await this.$axios.$post('budgetslip.delete.php', this.deleteData)

        if(result.message == 'Success') {
          Swal.fire({
            title: 'สำเร็จ',
            text: result.msg,
            icon: 'success'
          }).then(async ()=> {
            let params = {
              token: this.$store.state.jwtToken,
              budgetslipID: this.deleteData.budgetslipID
            }
            await this.$axios.$post('pjsubactivity.delete.php', params)
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
    },

    moneyFormat(money) {
      return numeral(money).format('0,0.00')
    },

    thaiDate(inDate) {
      let result = ''
      if(inDate) {
        let thdate = new Date(inDate)
        result = thdate.toLocaleDateString('th-TH', {
          year: 'numeric',
          month: 'long',
          day: 'numeric',
        })
      }
      return result
    }

  },

  watch: {
    async budgetslip() {
      if(this.budgetslip) {
        await this.getBudgetplan()
        this.deleteData = JSON.parse(JSON.stringify(this.budgetslip))
      }
    }
  }
}
</script>
