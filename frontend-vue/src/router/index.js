import { createRouter, createWebHistory } from 'vue-router'
import LoginLayout from '@/views/layouts/LoginLayout.vue'
import HomeLayout from '@/views/layouts/HomeLayout.vue'
import HomeView from '@/views/HomeView.vue'
import AccountPage from '@/views/AccountPage.vue'
import Dompetku from '@/views/Dompetku.vue'
import ChangePasswordPage from '@/views/ChangePasswordPage.vue'
import LoginView from '@/views/LoginView.vue'
import { useUserStore } from '@/stores/user.js'
import Transaction from '@/views/Transaction.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/login',
      name: 'login',
      meta: { layout: LoginLayout },
      component: LoginView,
    },
    {
      path: '/',
      name: 'home',
      meta: { layout: HomeLayout },
      component: HomeView,
    },
    {
      path: '/transaction',
      name: 'transaction',
      meta: { layout: Transaction },
      component: Transaction,
    },
    {
      path: '/account',
      name: 'account',
      meta: { layout: HomeLayout },
      component: AccountPage,
    },
    {
      path: '/change-password',
      name: 'ChangePassword',
      meta: { layout: HomeLayout },
      component: ChangePasswordPage,
    },
    {
      path: '/dompetku',
      name: 'Dompetku',
      meta: { layout: HomeLayout },
      component: Dompetku,
    },
  ],
})

// Global route guard to check for token
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()

  if (to.name !== 'login' && !userStore.token) {
    next({ name: 'login' })
  } else if (to.name === 'login' && userStore.token) {
    next({ name: 'home' })
  } else {
    next()
  }
})

export default router
