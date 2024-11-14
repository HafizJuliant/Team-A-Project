<!-- eslint-disable vue/multi-word-component-names -->
<script setup>
import { ref, onMounted } from 'vue';

// Refs for data
const entries = ref([]); // Array to store entries
const description = ref(''); // Model for "Keterangan" input
const amount = ref(''); // Model for "Jumlah Uang" input
const category = ref(''); // Model for category input
const type = ref('income'); // Model for transaction type (income/expense)

// Available categories
const categories = ['Food', 'Transport', 'Shopping', 'Entertainment', 'Bills', 'Others'];

// Load data from localStorage on mount
onMounted(() => {
  const savedEntries = JSON.parse(localStorage.getItem('entries')) || [];
  entries.value = savedEntries;
});

// Save data to localStorage
const saveEntriesToLocalStorage = () => {
  localStorage.setItem('entries', JSON.stringify(entries.value));
};

// Function to submit a new entry
const submitEntry = () => {
  if (description.value && amount.value && category.value && type.value) {
    entries.value.push({
      id: Date.now(),
      description: description.value,
      amount: parseFloat(amount.value),
      category: category.value,
      type: type.value,
    });
    saveEntriesToLocalStorage(); // Save to localStorage after submission
    description.value = '';
    amount.value = '';
    category.value = '';
    type.value = 'income'; // Reset to default 'income'
  }
};

// Function to delete a specific entry
const deleteEntry = (id) => {
  entries.value = entries.value.filter(entry => entry.id !== id);
  saveEntriesToLocalStorage(); // Save to localStorage after deletion
};

// Function to delete all entries with confirmation
const clearAllEntries = () => {
  if (confirm('Are you sure you want to delete all entries?')) {
    entries.value = [];
    saveEntriesToLocalStorage(); // Save to localStorage after clearing
  }
};

// Compute total income, total expenses, and surplus/deficit
const getSummary = () => {
  let totalIncome = 0;
  let totalExpense = 0;

  entries.value.forEach(entry => {
    if (entry.type === 'income') totalIncome += entry.amount;
    else if (entry.type === 'expense') totalExpense += entry.amount;
  });

  const surplus = totalIncome - totalExpense; // Surplus or deficit calculation

  return {
    totalIncome,
    totalExpense,
    surplus,
  };
};
</script>

<template>
  <div class="arsip-dompetku">
    <h2>Transaction Archive</h2>

    <div class="input-group">
      <label for="description">Transaction Description:</label>
      <input id="description" v-model="description" placeholder="Enter Transaction Details" />

      <label for="amount">Transaction Amount:</label>
      <input id="amount" v-model="amount" type="number" placeholder="Enter Amount" />

      <label for="category">Transaction Category:</label>
      <select v-model="category">
        <option value="" disabled selected>Select Category</option>
        <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
      </select>

      <label for="type">Transaction Type:</label>
      <select v-model="type">
        <option value="income">Deposit</option>
        <option value="expense">Withdrawal</option>
      </select>

      <button @click="submitEntry">Submit Transaction</button>
    </div>

    <div v-if="entries.length" class="entry-list">
      <h3>Transaction History</h3>
      <ul>
        <li v-for="entry in entries" :key="entry.id" class="entry-item">
          <div class="entry-info">
            <span>{{ entry.description }} - ${{ entry.amount.toLocaleString() }} ({{ entry.category }})</span>
            <span class="type-label" :class="entry.type">{{ entry.type === 'income' ? 'Deposit' : 'Withdrawal' }}</span>
          </div>
          <button @click="deleteEntry(entry.id)">Delete</button>
        </li>
      </ul>
      <button @click="clearAllEntries" class="clear-button">Delete All Transactions</button>
    </div>
    <p v-else>No Transactions Available</p>

    <div v-if="entries.length" class="summary">
      <h3>Account Summary</h3>
      <p>Total Deposits: ${{ getSummary().totalIncome.toLocaleString() }}</p>
      <p>Total Withdrawals: ${{ getSummary().totalExpense.toLocaleString() }}</p>
      <p>Net Balance: ${{ getSummary().surplus.toLocaleString() }}</p>
    </div>
  </div>
</template>

<style scoped>
.arsip-dompetku {
  max-width: 750px;
  margin: 0 auto;
  padding: 1rem;
  background-color: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

h2 {
  text-align: center;
  font-size: 2rem;
  color: #2e8b57; /* Green color for the title */
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 1rem;
}

label {
  font-weight: bold;
}

input, select {
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}

button {
  padding: 0.5rem;
  color: #fff;
  background-color: #2e8b57; /* Green button */
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
}

button:hover {
  background-color: #1c6b3d; /* Darker green on hover */
}

.entry-list {
  margin-top: 1rem;
}

.entry-list h3 {
  text-align: center;
}

ul {
  list-style-type: none;
  padding: 0;
}

.entry-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.5rem 0;
  border-bottom: 1px solid #ddd;
}

.entry-info {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
  width: 80%;
}

li button {
  padding: 0.3rem;
  background-color: #dc3545; /* Red button */
}

li button:hover {
  background-color: #c82333; /* Darker red on hover */
}

.clear-button {
  width: 100%;
  margin-top: 1rem;
  background-color: #dc3545;
}

.clear-button:hover {
  background-color: #c82333;
}

.summary {
  margin-top: 2rem;
  padding: 1rem;
  background-color: #e9ecef;
  border-radius: 8px;
  text-align: center;
}

.summary p {
  font-size: 1.2rem;
  margin: 0.5rem 0;
}

.type-label {
  font-weight: bold;
  padding: 0.3rem;
  border-radius: 4px;
  width: fit-content;
}

.income {
  background-color: #28a745;
  color: white;
}

.expense {
  background-color: #dc3545;
  color: white;
}
</style>
