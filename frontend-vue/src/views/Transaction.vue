<!-- eslint-disable vue/multi-word-component-names -->
<template>
  <v-container>
    <!-- Transfer Header without Back Button -->
    <v-card class="mb-4" outlined>
      <v-row justify="center" align="center">
        <v-col cols="auto">
          <v-card-title class="text-center" style="color: #2E8B57;">
            <b>Form Transaction</b>
          </v-card-title>
        </v-col>
      </v-row>
    </v-card>

    <!-- Transfer Form -->
    <v-form v-model="valid" @submit.prevent="submitTransfer">
      <v-row>
        <!-- From Account -->
        <v-col cols="12" md="6">
          <v-text-field
            v-model="transferForm.fromAccount"
            label="From Account (Celengan)"
            :rules="[v => !!v || 'Account is required']"
            readonly
          />
        </v-col>

        <!-- To Account (Dropdown for Bank Selection) -->
        <v-col cols="12" md="6">
          <v-select
            v-model="transferForm.toBank"
            :items="banks"
            label="To Bank"
            item-value="bank_id"
            item-title="name"
            :rules="[v => !!v || 'Bank is required']"
            @change="onBankChange"
          />
<!--
        <v-select
            :items="banks2"
            item-value="id"
            item-title="name"
          /> -->
        </v-col>

        <!-- To Account Number -->
        <v-col cols="12" md="6">
          <v-text-field
            v-model="transferForm.toAccount"
            label="To Account Number"
            :rules="[v => !!v || 'Account number is required']"
          />
        </v-col>

        <!-- Transaction Category -->
        <v-col cols="12" md="6">
          <v-select
            v-model="transferForm.category"
            :items="transactionCategories"
            label="Transaction Category"
            :rules="[v => !!v || 'Category is required']"
          />
        </v-col>

        <!-- Check Account Button -->
        <v-col cols="12" md="6">
          <v-btn @click="checkAccount" color="primary">Check Account</v-btn>
        </v-col>

        <!-- Valid Account Info -->
        <v-col v-if="accountValid !== null" cols="12" md="6">
          <v-alert :type="accountValid ? 'success' : 'error'" dense>
            {{ accountValid ? 'Account is valid!' : 'Account is invalid!' }}
          </v-alert>
        </v-col>

        <!-- Amount -->
        <v-col cols="12" md="6">
          <v-text-field
            v-model="transferForm.amount"
            label="Amount"
            :rules="[v => !!v || 'Amount is required', v => v >= 10000 || 'Amount must be at least 10,000']"
            type="number"
          />
        </v-col>

        <!-- Submit Transfer and Back to Home Buttons in the same row -->
        <v-col cols="12" class="d-flex justify-between mt-10">
          <v-btn :disabled="!valid || !accountValid" type="submit" color="green darken-3" class="mr-4">
            Submit Transfer
          </v-btn>

          <v-btn text color="green darken-3" @click="goToHomepage">
            Back to Home
          </v-btn>
        </v-col>

      </v-row>
    </v-form>

    <!-- Transfer Summary Modal -->
    <v-dialog v-model="showSummaryDialog" max-width="500">
      <v-card>
        <v-card-title>
          <h3 style="color: #2E8B57;"><b>Transaction Summary</b></h3>
        </v-card-title>
        <v-card-text>
          <div>Total Amount Transferred: Rp {{ totalAmountTransferred }}</div>
        </v-card-text>
        <v-card-actions>
          <v-btn text @click="showSummaryDialog = false">Close</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';
import Swal from 'sweetalert2';

const router = useRouter();
const valid = ref(false);
const accountValid = ref(null);
const showSummaryDialog = ref(false);
const totalAmountTransferred = ref(0);
const transferForm = reactive({
  fromAccount: 'MyAccount (Celengan)', // Example account
  toBank: '',
  toAccount: '',
  amount: '',
  category: '', // Include category field
});
const banks = ref([]); // Bank list from API response
const transactionCategories = ['Food', 'Investment', 'Daily', 'Transfer', 'Emergency'];

// const banks2 = ref([
//   {id:"1", name:"ok"}
// ])

// Function to navigate back to the homepage
function goToHomepage() {
  router.push('/');
}

// Fetch list of banks from the API
onMounted(async () => {
  try {
    const response = await axios.get('http://localhost:8080/bank/list');
    if (response.data) {
      banks.value = response.data.map(bank => ({
        bank_id: bank.bank_id,
        name: bank.name,
      }));
    }
    // console.log (banks)
    // console.log (banks.value)

  } catch (error) {
    console.error('Error fetching bank list:', error);
  }
});

// Function to check if the destination account is valid
async function checkAccount() {
  try {
    const response = await axios.get('http://localhost:8080/account/list', {
      account_id: transferForm.toAccount,
      bank_id: transferForm.toBank,
    });
    accountValid.value = response.data.valid;
  } catch (error) {
    Swal.fire('Error', 'Failed to check account', 'error');
    console.error(error);
  }
}

// Function to submit transfer
async function submitTransfer() {
  try {
    const transferData = {
      fromAccount: transferForm.fromAccount,
      toAccount: transferForm.toAccount,
      amount: transferForm.amount,
      bankId: transferForm.toBank,
      category: transferForm.category, // Include category in transfer data
    };

    const response = await axios.post('http://localhost:8080/api/transfer', transferData);

    if (response.status === 200) {
      Swal.fire('Success', 'Transfer completed successfully!', 'success');
      totalAmountTransferred.value += parseFloat(transferForm.amount);
      showSummaryDialog.value = true;
    } else {
      Swal.fire('Error', 'Failed to process the transfer. Please try again.', 'error');
    }
  } catch (error) {
    Swal.fire('Error', 'Failed to process the transfer. Please try again.', 'error');
    console.error('Error during transfer:', error);
  }
}
</script>

<style scoped>
v-btn {
  margin-top: 20px;
}
</style>
