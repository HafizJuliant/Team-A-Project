import axios from 'axios'

const api = axios.create({
  baseURL: 'http://localhost:8080', // Replace with your API URL
  timeout: 5000,
})
// Request interceptor to add the API key to the headers
api.interceptors.request.use(
  (config) => {
    const apiKey = localStorage.getItem('token')  // Retrieve the API key (stored as token) from localStorage
    if (apiKey) {
      config.headers.Authorization = `Bearer ${apiKey}`;  // Add the "Bearer " prefix before the token
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  },
);

export default api;

