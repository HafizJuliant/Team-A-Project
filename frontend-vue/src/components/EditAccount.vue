<template>
  <v-card>
    <v-card-title style="color: #2E8B57;"><b>Edit Account</b></v-card-title>
    <v-card-text>
      <v-form @submit.prevent="updateAccount">
        <v-text-field v-model="name" label="Name" required></v-text-field>
        <v-text-field v-model="balance" label="Balance" type="number" required></v-text-field>
        <v-row class="d-flex justify-end mt-4">
          <v-btn color="#C6DE9B" @click="$emit('close')">Cancel</v-btn>
          <v-btn color="#2E8B57" type="submit" style="margin-left: 1rem;">Save Changes</v-btn>
        </v-row>
      </v-form>
    </v-card-text>
  </v-card>
</template>

<script setup>
import { ref, watch } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'

const props = defineProps(['account'])
const emit = defineEmits(['close', 'refresh'])
const name = ref(props.account?.name || '')
const balance = ref(props.account?.balance || 0)

watch(() => props.account, (newAccount) => {
  name.value = newAccount.name
  balance.value = newAccount.balance
})

async function updateAccount() {
  if (!props.account?.account_id) {
    console.error("Account ID is undefined, cannot update account.")
    return
  }

  try {
    const updatedAccount = {
      name: name.value,
      balance: Number(balance.value)
    }

    const response = await axios.patch(`http://localhost:8080/account/update/${props.account.account_id}`, updatedAccount)

    if (response.status === 200) {
      Swal.fire({
        icon: 'success',
        title: 'Account Updated',
        text: 'Account has been successfully updated!',
        confirmButtonColor: '#2E8B57',
      })

      emit('close')
      emit('refresh')
    } else {
      throw new Error('Failed to update account')
    }
  } catch (error) {
    console.error('Error updating account:', error)
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'There was an error updating the account. Please try again.',
      confirmButtonColor: '#FF4136',
    })
  }
}
</script>

<style scoped>
.v-card-title {
  font-weight: bold;
}

.v-row {
  display: flex;
  justify-content: flex-end;
}

.v-btn {
  border-radius: 20px;
}
</style>
