<template>
  <div class="container">
    <div class="card mb-4">
      <div class="row justify-between align-center">
        <div class="col-auto">
          <h2 style="color: #2E8B57;"><b>Transaction History</b></h2>
        </div>
      </div>
    </div>

    <!-- Date Range Picker -->
    <div class="date-filter mb-3">
      <label for="fromDate" class="mr-2">From Date:</label>
      <input type="date" id="fromDate" v-model="fromDate" class="date-input" />
      <label for="toDate" class="mr-2">To Date:</label>
      <input type="date" id="toDate" v-model="toDate" class="date-input" />
      <button @click="filterTransactions" class="filter-btn">Filter</button>
    </div>

    <!-- Transaction List using HTML table -->
    <table class="table table-striped table-bordered">
      <thead>
        <tr>
          <th>Transaction ID</th>
          <th>To/From Account ID</th>
          <th>Transaction Date</th>
          <th>Amount</th>
          <th>Description</th>
          <th>Transaction Category</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in filteredTransactions" :key="item.TransactionID">
          <td>{{ item.TransactionID }}</td>
          <td>{{ item.to_account_id }}</td>
          <td>{{ formatDate(item.transaction_date) }}</td>
          <td>{{ item.amount }}</td>
          <td>{{ item.transaction_desc || 'No Description' }}</td>
          <td>{{ item.transaction_category_id || 'Uncategorized' }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

// Data transaksi yang disimpan di dalam kode
const transactions = ref([
  {
    TransactionID: 'TXN12345',
    to_account_id: '1',
    transaction_date: '2024-11-10T14:00:00',
    amount: 500.00,
    transaction_desc: 'Deposit',
    transaction_category_id: 'Deposit',
  },
  {
    TransactionID: 'TXN12346',
    to_account_id: '2',
    transaction_date: '2024-11-11T09:30:00',
    amount: -200.00,
    transaction_desc: 'Withdrawal',
    transaction_category_id: 'Withdrawal',
  },
  // {
  //   TransactionID: 'TXN12347',
  //   // to_account_id: '5',
  //   transaction_date: '2024-11-12T10:15:00',
  //   amount: 1000.00,
  //   transaction_desc: 'Deposit',
  //   transaction_category_id: 'Deposit',
  // },
  {
    TransactionID: 'TXN12348',
    to_account_id: '3',
    transaction_date: '2024-11-13T12:45:00',
    amount: -50.00,
    transaction_desc: 'Service Fee',
    transaction_category_id: 'Fee',
  },
  // {
  //   TransactionID: 'TXN12349',
  //   to_account_id: '5',
  //   transaction_date: '2024-11-14T15:00:00',
  //   amount: 300.00,
  //   transaction_desc: 'Deposit',
  //   transaction_category_id: 'Deposit',
  // },
])

// State for the date filter
const fromDate = ref('')
const toDate = ref('')

// Fungsi untuk memformat tanggal ke format yang lebih mudah dibaca
function formatDate(dateString) {
  const date = new Date(dateString)
  return date.toLocaleDateString() + ' ' + date.toLocaleTimeString()
}

// Filtered transactions based on the date range
const filteredTransactions = computed(() => {
  return transactions.value.filter(item => {
    const transactionDate = new Date(item.transaction_date)
    const from = fromDate.value ? new Date(fromDate.value) : null
    const to = toDate.value ? new Date(toDate.value) : null

    if (from && transactionDate < from) return false
    if (to && transactionDate > to) return false
    return true
  })
})

// Function to trigger the filter (optional for direct binding)
function filterTransactions() {
  // The filter is already applied reactively through computed property
}
</script>

<style scoped>
.container {
  margin: 20px;
}

.card {
  padding: 16px;
  border: 1px solid #ddd;
  border-radius: 8px;
  margin-bottom: 20px;
}

.table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 12px;
  text-align: center;
  border: 1px solid #ddd;
}

th {
  background-color: #f4f4f4;
  font-weight: bold;
}

tr:nth-child(even) {
  background-color: #f9f9f9;
}

.date-filter {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
}

.date-filter label {
  margin-right: 8px;
  font-size: 14px;
}

.date-filter input {
  margin-right: 16px;
  padding: 6px;
  font-size: 14px;
}

.filter-btn {
  padding: 8px 16px;
  background-color: #2E8B57;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.filter-btn:hover {
  background-color: #246e46;
}
</style>
