<template>
  <v-container>
    <v-card class="mb-4" outlined>
      <v-row justify="space-between" align="center">
        <v-col cols="auto">
          <v-card-title style="color: #2E8B57;"><b>Transaction History</b></v-card-title>
        </v-col>
      </v-row>
    </v-card>

    <!-- Transaction List Table -->
    <v-table height="500px" fixed-header class="table table-striped" style="width: 100%; text-align: center; margin-bottom: 20px;">
      <thead>
        <tr>
          <th class="text-center font-weight-bold">Account Name</th>
          <th class="text-center font-weight-bold">Transaction Date</th>
          <th class="text-center font-weight-bold">Amount</th>
          <th class="text-center font-weight-bold">Description</th>
          <th class="text-center font-weight-bold">Transaction Category</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(mutation) in mutations" :key="mutation.transaction_id">
          <td>{{ mutation.account_id }}</td>
          <td>{{ mutation.transaction_date }}</td>
          <td>{{ mutation.amount }}</td>
          <td>{{ mutation.description }}</td>
          <td>{{ mutation.transaction_category }}</td>
        </tr>
      </tbody>
    </v-table>
  </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const mutations = ref([]) // Array untuk menyimpan data mutasi

// Fungsi untuk mengambil data mutasi
async function fetchMutations() {
  try {
    const response = await axios.get('http://localhost:8080/account/mutation')
    if (response.data && response.data.data) {
      mutations.value = response.data.data // Update data mutasi
    } else {
      console.error('Invalid response structure:', response.data)
    }
  } catch (error) {
    console.error('Error fetching mutations:', error)
  }
}

// Ambil data mutasi saat komponen dimuat
onMounted(() => {
  fetchMutations()
})
</script>

<style scoped>
th, td {
  text-align: center;
}
</style>
