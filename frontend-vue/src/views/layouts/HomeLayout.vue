<template>
  <v-responsive>
    <v-app id="app">
      <v-navigation-drawer v-model="drawer">
        <!-- sidebar -->
        <v-sheet class="pa-4" color="#2E8B57">
          Welcome to Celengan Bank
        </v-sheet>

        <v-divider></v-divider>

        <v-list>
          <RouterLink
            v-for="{ icon, text, route, click } in sidebarLinks"
            :key="route"
            :to="route"
            custom
          >
            <v-list-item
              :prepend-icon="icon"
              :title="text"
              link
              @click="click"
              v-if="click"
            ></v-list-item>
            <v-list-item :prepend-icon="icon" :title="text" link :to="route" v-else></v-list-item>
          </RouterLink>
        </v-list>
      </v-navigation-drawer>

      <v-app-bar>
        <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
        <v-img class="" max-width="150" :src="logo"></v-img>

        <v-spacer></v-spacer>
      </v-app-bar>

      <v-main id="main">
        <RouterView />
      </v-main>
    </v-app>
  </v-responsive>
</template>

<script setup>
import { ref } from 'vue'
import logo from '@/assets/logo.png'
import { mdiHome, mdiLogout, mdiAccount, mdiLock, mdiWallet, mdiTransfer } from '@mdi/js'
import { RouterView, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user.js'

const userStore = useUserStore()
const router = useRouter()

const drawer = ref(null)

function logout() {
  userStore.logout()
  router.push({ name: 'login' })
}

const sidebarLinks = [
  { icon: mdiHome, text: 'Home', route: '/' },
  { icon: mdiTransfer, text: 'Transaction', route: '/transaction' },
  { icon: mdiAccount, text: 'Account Mutation', route: '/account' },
  { icon: mdiLock, text: 'Change Password', route: '/change-password' },
  { icon: mdiWallet, text: 'Transaction Archive', route: '/dompetku' },
  { icon: mdiLogout, text: 'Logout', route: '/login', click: logout },
]
</script>
