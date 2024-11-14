import { defineStore } from 'pinia';
import axios from 'axios';

export const useAccountStore = defineStore('accounts', {
  state: () => ({
    accounts: [], 
    loggedInAccount: null, 
  }),
  actions: {
  },
});