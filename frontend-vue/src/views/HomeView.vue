<template>
  <v-container class="d-flex justify-center" style="margin-left: 1%; padding-top: 10vh;">
    <v-card class="pa-6" outlined max-width="400" style="border-radius: 10px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);">
      <v-card-title class="text-h4 text-center" style="color: #285b28; font-weight: bold;">
        Hello! <span v-if="loggedInAccount">{{ loggedInAccount?.name }}</span> <span v-else>Guest</span>
      </v-card-title>
      <v-divider></v-divider>
      <v-card-text class="text-center">
        <p class="text-h5" style="font-weight: bold; margin-top: 16px;">
          Your Balance: $
          <span style="color: #2E8B57; font-size: 2rem;">
            {{ loggedInAccount?.balance || 0 }}
          </span>
        </p>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const loggedInAccount = ref(null)

async function fetchLoggedInAccount() {
  try {
    const token = localStorage.getItem('token')

    if (!token) {
      console.error('No token found, user is not authenticated.')
      return
    }

    const response = await axios.get('http://localhost:8080/account/my', {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })

    if (response.data && response.data.data) {
      loggedInAccount.value = response.data.data
    } else {
      console.error('Invalid response structure:', response.data)
    }
  } catch (error) {
    console.error('Error fetching logged-in account:', error.message)
  }
}

onMounted(async () => {
  await fetchLoggedInAccount()
})
</script>

<style scoped>
.v-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding-top: 10vh;
}

.v-card {
  background-color: #ffffff;
  border-radius: 15px;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}

.v-card-title {
  font-weight: bold;
  font-size: 2rem;  /* Increased size for the title */
}

.v-card-text {
  font-size: 1.25rem;  /* Slightly larger text for balance */
}

.v-btn {
  border-radius: 20px;
}
</style>
