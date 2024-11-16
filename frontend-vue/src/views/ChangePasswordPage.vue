<template>
  <v-container class="d-flex justify-center align-center" style="min-height: 70vh;">
    <v-row justify="center" align="center">
      <v-col cols="12" md="5">
        <v-card>
          <v-card-title class="text-center">
            <h3 style="color: #2E8B57;"><b>Change Password</b></h3>
          </v-card-title>
          <v-card-text>
            <v-form ref="form" @submit.prevent="changePassword">
              <v-text-field
                v-model="oldPassword"
                label="Old Password"
                type="password"
                :rules="[rules.required, rules.minLength]"
                required
              ></v-text-field>
              <v-text-field
                v-model="newPassword"
                label="New Password"
                type="password"
                :rules="[rules.required, rules.minLength]"
                required
              ></v-text-field>
              <v-text-field
                v-model="confirmPassword"
                label="Confirm New Password"
                type="password"
                :rules="[rules.required, rules.matchPassword]"
                required
              ></v-text-field>
              <v-btn type="submit" color="#2E8B57" block>Change Password</v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import Swal from 'sweetalert2'

const router = useRouter()
const form = ref(null)

const oldPassword = ref('')
const newPassword = ref('')
const confirmPassword = ref('')

const rules = {
  required: (value) => !!value || 'Field is required',
  minLength: (value) => value.length >= 6 || 'Password must be at least 6 characters',
  matchPassword: (value) => value === newPassword.value || 'Passwords do not match',
}

const changePassword = async () => {
  const isFormValid = await form.value?.validate()
  if (!isFormValid) {
    Swal.fire('Error', 'Please fill in all required fields correctly.', 'error')
    return
  }

  Swal.fire({
    title: 'Are you sure?',
    text: 'Do you really want to change your password?',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#2E8B57',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Yes, change it!',
  }).then(async (result) => {
    if (result.isConfirmed) {
      try {
        const token = localStorage.getItem('token')
        if (!token) {
          Swal.fire('Not logged in', 'You are not logged in. Please login first.', 'warning')
          router.push({ name: 'login' })
          return
        }

        const payload = {
          oldPassword: oldPassword.value,
          newPassword: newPassword.value,
          confirmPassword: confirmPassword.value,
        }

        const response = await axios.post('http://localhost:8080/auth/change-password', payload, {
          headers: { Authorization: `Bearer ${token}` },
        })

        if (response.data.message === 'Password updated successfully') {
          // Clear the token
          localStorage.removeItem('token')

          await Swal.fire('Success', 'Password has been successfully changed.', 'success')
          router.push({ name: 'login' })
        } else {
          Swal.fire('Failed', response.data.message || 'Failed to change password. Please try again.', 'error')
        }
      } catch (error) {
        console.error('Error changing password:', error)
        const errorMessage = error.response?.data?.message || error.message
        Swal.fire('Error', `Error changing password: ${errorMessage}`, 'error')
      }
    }
  })
}
</script>

<style scoped>
.v-container {
  padding: 0;
}
</style>
