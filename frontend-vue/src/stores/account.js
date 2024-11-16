import { defineStore } from 'pinia';
// eslint-disable-next-line no-unused-vars
import axios from 'axios';

export const useAccountStore = defineStore('accounts', {
  state: () => ({
    accounts: [],
    loggedInAccount: null,
  }),
  actions: {
  },
});
