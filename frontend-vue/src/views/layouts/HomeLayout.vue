<template>
  <v-responsive>
    <v-app id="app">
      <!-- Sidebar atau navigasi samping -->
      <v-navigation-drawer v-model="drawer">
        <!-- Bagian header sidebar dengan background warna hijau -->
        <v-sheet class="pa-4" color="#2E8B57">
          Welcome to Celengan Bank
        </v-sheet>

        <!-- Garis pemisah di bawah header sidebar -->
        <v-divider></v-divider>

        <!-- Daftar navigasi di sidebar -->
        <v-list>
          <!-- Iterasi setiap link di sidebarLinks menggunakan v-for -->
          <RouterLink
            v-for="{ icon, text, route, click } in sidebarLinks"
            :key="route"
            :to="route"
            custom
          >
            <!-- Item daftar yang memiliki aksi khusus (klik) -->
            <v-list-item
              :prepend-icon="icon"
              :title="text"
              link
              @click="click"
              v-if="click"
            ></v-list-item>
            <!-- Item daftar yang hanya berfungsi sebagai link -->
            <v-list-item :prepend-icon="icon" :title="text" link :to="route" v-else></v-list-item>
          </RouterLink>
        </v-list>
      </v-navigation-drawer>

      <!-- App bar (navigasi atas) -->
      <v-app-bar>
        <!-- Ikon hamburger untuk membuka/menutup sidebar -->
        <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
        <!-- Gambar logo aplikasi -->
        <v-img class="" max-width="150" :src="logo"></v-img>

        <!-- Spacer untuk mendorong elemen ke kanan -->
        <v-spacer></v-spacer>
      </v-app-bar>

      <!-- Komponen utama yang akan menampilkan konten berdasarkan rute -->
      <v-main id="main">
        <RouterView />
      </v-main>
    </v-app>
  </v-responsive>
</template>

<script setup>
import { ref } from 'vue' // Mengimpor ref untuk membuat data reaktif
import logo from '@/assets/logo.png' // Mengimpor logo aplikasi
import { mdiHome, mdiLogout, mdiAccount, mdiLock, mdiWallet, mdiTransfer } from '@mdi/js' // Mengimpor ikon dari Material Design Icons
import { RouterView, useRouter } from 'vue-router' // Mengimpor RouterView untuk rute dinamis dan useRouter untuk navigasi
import { useUserStore } from '@/stores/user.js' // Mengimpor store pengguna (manajemen state pengguna)

const userStore = useUserStore() // Membuat instance dari store pengguna
const router = useRouter() // Membuat instance dari router

const drawer = ref(null) // State untuk mengontrol visibilitas drawer (sidebar)

function logout() {
  // Fungsi logout yang memanggil logout dari userStore dan mengarahkan ke halaman login
  userStore.logout()
  router.push({ name: 'login' })
}

// Array berisi informasi link navigasi sidebar
const sidebarLinks = [
  { icon: mdiHome, text: 'Home', route: '/' }, // Link menuju halaman Home
  { icon: mdiTransfer, text: 'Transaction', route: '/transaction' }, // Link menuju halaman Transaksi
  { icon: mdiAccount, text: 'Account Mutation', route: '/account' }, // Link menuju halaman Mutasi Akun
  { icon: mdiLock, text: 'Change Password', route: '/change-password' }, // Link untuk mengubah password
  { icon: mdiWallet, text: 'Transaction Archive', route: '/dompetku' }, // Link menuju arsip transaksi
  { icon: mdiLogout, text: 'Logout', route: '/login', click: logout }, // Link untuk logout dengan fungsi klik logout
]
</script>
