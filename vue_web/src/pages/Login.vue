<template>
  <div class="min-h-screen bg-red-400 flex-row items-center justify-center">
    <header class="container mx-auto px-6 py-6 flex items-center justify-between">
      <button>
        <router-link to="/" class="text-white ">
          <h1 class="text-3xl font-bold text-white">My Bookkeeping</h1>
        </router-link>
      </button>
    </header>
    
    <main class="container mx-auto px-6 space-y-20 py-10 flex items-center justify-center">
      <div class="max-w-md w-full bg-white p-6 rounded-lg shadow-lg">
        <h1 class="text-2xl font-semibold mb-4">Login</h1>
        <div class="space-y-3">
          <input
            v-model="email"
            type="email"
            placeholder="Email"
            class="w-full border rounded px-3 py-2"
          />
          <input
            v-model="password"
            type="password"
            placeholder="Password"
            class="w-full border rounded px-3 py-2"
          />
          <button
            @click="submit"
            class="w-full bg-red-500 text-white py-2 rounded hover:bg-red-400"
          >
            Login
          </button>
          <p v-if="error" class="text-red-500 text-sm">{{ error }}</p>
          <div class="space-y-2">
            <p class="text-sm text-slate-500">Don't have an account? Sign up now!</p>
            <button
              @click="$router.push({ name: 'Register' })"
              class="w-full bg-green-600 text-white py-2 rounded hover:bg-green-500"
            >
              Sign Up
            </button>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
import auth from '../plugins/auth';

export default {
  data() {
    return {
      email: '',
      password: '',
      error: '',
    };
  },
  methods: {
    async submit() {
      this.error = '';
      if (!this.email || !this.password) {
        this.error = 'Please enter your email and password';
        return;
      }
      try {
        await auth.login(this.email, this.password);
        this.$router.push({ name: 'Dashboard', params: { tab: 'records' } });
      } catch (e) {
        this.error = e.message || 'Login failed';
      }
    },
  },
};
</script>
