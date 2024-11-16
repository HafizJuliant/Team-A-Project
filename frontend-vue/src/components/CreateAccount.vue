<template>
  <v-card>
    <v-card-title style="color: #2E8B57;"><b>Create Account</b></v-card-title>
    <v-card-text>
      <v-form @submit.prevent="createAccount">
        <v-text-field v-model="name" label="Name" required></v-text-field>
        <v-text-field v-model="balance" label="Initial Balance" type="number" required></v-text-field>
        <v-row class="d-flex justify-end mt-4">
          <v-btn color="#C6DE9B" @click="closeDialog">Cancel</v-btn>
          <v-btn color="#2E8B57" type="submit" style="margin-left: 1rem;">Save Account</v-btn>
        </v-row>
      </v-form>
    </v-card-text>
  </v-card>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'


const emit = defineEmits(['close'])
const name = ref('')
const balance = ref(0)

async function createAccount() {
  try {
    const accountData = {
      name: name.value,
      balance: Number(balance.value),
    }

    const response = await axios.post('http://localhost:8080/account/create', accountData)
    if (response.status === 200 || response.status === 201) {
      Swal.fire({
        icon: 'success',
        title: 'Account Created',
        text: 'Your account has been successfully created!',
        confirmButtonColor: '#2E8B57',
      })

      emit('close')
      emit('refresh')
    } else {
      throw new Error('Unexpected response status: ' + response.status)
    }

  } catch (error) {
    console.error('Error creating account:', error)
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'There was an error creating the account. Please try again.',
      confirmButtonColor: '#FF4136',
    })
  }
}

function closeDialog() {
  emit('close')
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
