<script setup>
import { ref } from 'vue'
import { mdiAccountOutline, mdiLockOutline, mdiEye, mdiEyeOff } from '@mdi/js'
import logo from '@/assets/logo.png'
import { useUserStore } from '@/stores/user.js'
import { useRouter } from 'vue-router'

// Menginisialisasi router untuk navigasi halaman
const router = useRouter()
// Mengambil store pengguna yang digunakan untuk autentikasi
const userStore = useUserStore()

// Deklarasi variabel untuk menyimpan input username dan password pengguna
const username = ref('')
const password = ref('')
// Deklarasi variabel untuk menyimpan pesan kesalahan jika login gagal
const submitErr = ref('')

const showPassword = ref(false)
const submitInProgress = ref(false)

// Fungsi asinkron untuk menangani proses login
async function submit() {
  submitInProgress.value = true;
  submitErr.value = '';

  try {
    // Mengirim data login ke server menggunakan fungsi login dari userStore
    const loginResponse = await userStore.login({
      username: username.value,
      password: password.value,
    });

    // Menyimpan token dan account_id yang diterima dari server di localStorage untuk digunakan di sesi mendatang
    localStorage.setItem('token', loginResponse.data.token);
    localStorage.setItem('account_id', loginResponse.data.account_id);

    // Navigasi ke halaman "home" setelah login berhasil
    router.push({ name: 'home' });
  } catch (err) {
    // Jika terjadi kesalahan, tampilkan pesan kesalahan dari respons server jika ada
    if (err.response) {
      submitErr.value = err.response.data.error;
    } else {
      // Jika tidak ada respons server, tampilkan pesan kesalahan umum
      submitErr.value = err.message || 'An unknown error occurred';
    }
  } finally {
    // Setel kembali status proses pengiriman menjadi false setelah proses selesai
    submitInProgress.value = false;
  }
}
</script>

<template>
   <div class="d-flex justify-center align-center">
    <div style="margin-top: 3%;">
      <!-- Form login menggunakan komponen <v-form> -->
      <v-form>
        <!-- Menampilkan logo aplikasi di bagian atas form -->
        <v-img class="mx-auto my-6" max-width="228" :src="logo"></v-img>

        <!-- Kartu yang berisi input username dan password -->
        <v-card class="mx-auto pa-8" elevation="8" min-width="440" rounded="lg">
          <!-- Label untuk input username -->
          <div class="text-subtitle-1 text-medium-emphasis">Username</div>

          <!-- Input field untuk username, menggunakan ikon mdiAccountOutline di depan -->
          <v-text-field
            v-model="username"
            density="compact"
            placeholder="Username"
            :prepend-inner-icon="mdiAccountOutline"
            variant="outlined"
          ></v-text-field>

          <!-- Label untuk input password -->
          <div class="text-subtitle-1 text-medium-emphasis d-flex align-center justify-space-between">
            Password
          </div>

          <!-- Input field untuk password, dengan ikon untuk menampilkan atau menyembunyikan password -->
          <v-text-field
            v-model="password"
            :append-inner-icon="showPassword ? mdiEyeOff : mdiEye"
            :type="showPassword ? 'text' : 'password'"
            density="compact"
            autoComplete="true"
            placeholder="Enter your password"
            :prepend-inner-icon="mdiLockOutline"
            variant="outlined"
            @click:append-inner="showPassword = !showPassword"
          ></v-text-field>

          <!-- Pesan kesalahan ditampilkan jika variabel submitErr memiliki nilai -->
          <v-card class="mb-5" color="error" variant="tonal" v-if="submitErr">
            <v-card-text class="text-medium-emphasis text-caption text-center">
              {{ submitErr }}
            </v-card-text>
          </v-card>

          <!-- Tombol untuk login, dinonaktifkan jika submitInProgress bernilai true -->
          <v-btn
            color="#2E8B57"
            size="large"
            variant="elevated"
            block
            @click="submit"
            :disabled="submitInProgress"
          >
            Login
          </v-btn>
        </v-card>
      </v-form>
    </div>
  </div>
</template>

<style scoped></style>
