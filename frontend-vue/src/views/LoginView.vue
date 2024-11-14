<script setup>
import { ref } from 'vue'
import { mdiAccountOutline, mdiLockOutline, mdiEye, mdiEyeOff } from '@mdi/js'
import logo from '@/assets/logo.png'
import { useUserStore } from '@/stores/user.js'
import { useRouter } from 'vue-router'

const router = useRouter()
const userStore = useUserStore()

const username = ref('')
const password = ref('')
const submitErr = ref('')

const showPassword = ref(false)
const submitInProgress = ref(false)

async function submit() {
  submitInProgress.value = true;
  submitErr.value = ''; // Reset error message on new submission

  try {
    const loginResponse = await userStore.login({
      username: username.value,
      password: password.value,
    });

    // Store the token and account_id in localStorage
    localStorage.setItem('token', loginResponse.data.token);
    localStorage.setItem('account_id', loginResponse.data.account_id);


    router.push({ name: 'home' });
  } catch (err) {
    if (err.response) {
      submitErr.value = err.response.data.error;
    } else {
      submitErr.value = err.message || 'An unknown error occurred';
    }
  } finally {
    submitInProgress.value = false;
  }
}
</script>

<template>
  <div class="d-flex justify-center align-center">
    <div style="margin-top: 3%;">
      <v-form>
        <v-img class="mx-auto my-6" max-width="228" :src="logo"></v-img>

        <v-card class="mx-auto pa-8" elevation="8" min-width="440" rounded="lg">
          <div class="text-subtitle-1 text-medium-emphasis">Username</div>

          <v-text-field
            v-model="username"
            density="compact"
            placeholder="Username"
            :prepend-inner-icon="mdiAccountOutline"
            variant="outlined"
          ></v-text-field>

          <div class="text-subtitle-1 text-medium-emphasis d-flex align-center justify-space-between">
            Password
          </div>

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

          <v-card class="mb-5" color="error" variant="tonal" v-if="submitErr">
            <v-card-text class="text-medium-emphasis text-caption text-center">
              {{ submitErr }}
            </v-card-text>
          </v-card>

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
