<template>
  <v-container class="d-flex justify-center" style="margin-left: 1%; padding-top: 10vh;">
    <!-- card yang menampilkan nama pengguna dan saldo, memiliki styling tambahan untuk bayangan dan radius -->
    <v-card class="pa-6" outlined max-width="400" style="border-radius: 10px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);">
      <v-card-title class="text-h4 text-center" style="color: #285b28; font-weight: bold;">
        Hello! <span v-if="loggedInAccount">{{ loggedInAccount?.name }}</span> <span v-else>Guest</span>
      </v-card-title>
      <v-divider></v-divider>
      <!-- Teks yang menampilkan saldo akun pengguna dalam tampilan teks utama -->
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
// Mengimpor fungsi dan pustaka yang diperlukan
import { ref, onMounted } from 'vue'
import axios from 'axios'

// Menginisialisasi variabel untuk menyimpan data akun yang sudah login
const loggedInAccount = ref(null)

// Fungsi untuk mengambil data akun yang sudah login dari API
async function fetchLoggedInAccount() {
  try {
    // Mengambil token autentikasi dari local storage
    const token = localStorage.getItem('token')

    // Jika token tidak ada, tampilkan pesan kesalahan
    if (!token) {
      console.error('No token found, user is not authenticated.')
      return
    }

    // Mengirim permintaan GET ke endpoint untuk mendapatkan data akun dengan token autentikasi
    const response = await axios.get('http://localhost:8080/account/my', {
      headers: {
        Authorization: `Bearer ${token}`, // Mengatur header Authorization
      },
    })

    // Memeriksa struktur respons dan memperbarui data akun jika valid
    if (response.data && response.data.data) {
      loggedInAccount.value = response.data.data
    } else {
      console.error('Invalid response structure:', response.data)
    }
  } catch (error) {
    // Menangani kesalahan yang terjadi saat mengambil data akun
    console.error('Error fetching logged-in account:', error.message)
  }
}

// Memanggil fungsi fetchLoggedInAccount ketika komponen dimuat pertama kali
onMounted(async () => {
  await fetchLoggedInAccount()
})
</script>

<style scoped>
/* Gaya untuk v-container, menyesuaikan posisi dan padding */
.v-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding-top: 10vh;
}

/* Gaya untuk v-card, termasuk warna latar, radius, dan bayangan */
.v-card {
  background-color: #ffffff;
  border-radius: 15px;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}

/* Gaya judul pada v-card, dengan ukuran font lebih besar dan tebal */
.v-card-title {
  font-weight: bold;
  font-size: 2rem; /* Ukuran teks judul yang lebih besar */
}

/* Gaya teks pada v-card-text, dengan ukuran teks saldo yang lebih besar */
.v-card-text {
  font-size: 1.1rem; /* Ukuran teks sedikit lebih besar untuk saldo */
}

/* Gaya tombol jika ada, dengan radius melingkar */
.v-btn {
  border-radius: 20px;
}
</style>
