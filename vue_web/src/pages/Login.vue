<template>
  <div class="min-h-screen flex items-center justify-center bg-slate-100 relative">
    <header class="mx-auto px-6 py-6 flex items-center justify-between top-0 left-0 z-10 absolute">
      <router-link to="/" class="text-slate-900 hover:opacity-80 transition">
        <h1 class="text-3xl font-bold text-red-500">MyBookkeeping</h1>
      </router-link>
    </header>

    <main class="flex container mx-auto px-6 items-center justify-center">
      <div class="flex-1 px-30 items-center justify-between">
        <img 
              src="@/assets/images/landing-illustration.png" 
              alt="Illustration" 
              class=" w-350 h-auto object-contain"
            />
      </div>

      <div class="flex-1">
        <div class="w-full max-w-md">
          <div class="bg-white rounded-3xl shadow p-8 space-y-6">
            <div>
              <p class="text-red-500 text-sm uppercase tracking-[0.24em] font-semibold">Welcome Back</p>
              <h1 class="mt-3 text-3xl font-semibold text-slate-900">Login</h1>
              <p class="mt-2 text-slate-500">Sign in to your account to continue</p>
            </div>

            <div class="space-y-4">
              <div>
                <label class="text-sm font-medium text-slate-700">Email</label>
                <input
                  v-model="email"
                  type="email"
                  placeholder="your@email.com"
                  class="mt-2 w-full rounded-2xl border border-slate-200 px-4 py-3 focus:ring-red-100 text-slate-900 placeholder-slate-400 focus:border-red-500 focus:outline-none focus:ring-2 focus:ring-offset-0"
                />
              </div>
              <div>
                <label class="text-sm font-medium text-slate-700">Password</label>
                <input
                  v-model="password"
                  type="password"
                  placeholder="Enter your password"
                  class="mt-2 w-full rounded-2xl border border-slate-200 px-4 py-3 focus:ring-red-100 text-slate-900 placeholder-slate-400 focus:border-red-500 focus:outline-none focus:ring-2 focus:ring-offset-0"
                />
              </div>
            </div>

            <div class="space-y-3 pt-2">
              <button
                @click="submit"
                class="w-full inline-flex items-center justify-center rounded-full px-6 py-3 text-white shadow font-semibold transition hover:shadow-lg bg-red-500 hover:bg-red-400"
              >
                Sign In
              </button>
              <p v-if="error" class="text-red-500 text-sm text-center">{{ error }}</p>
            </div>

            <div class="border-t border-slate-200 pt-6">
              <p class="text-sm text-slate-600 text-center">Don't have an account?</p>
              <button
                @click="$router.push({ name: 'Register' })"
                class="mt-3 w-full inline-flex items-center justify-center rounded-full px-6 py-3 border-2 text-slate-900 font-semibold transition hover:bg-slate-50 border-red-500"
              >
                Create Account
              </button>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
import auth from '../plugins/auth';
import { useSettingsStore } from '../stores/settingsStore';
import { themeOptions } from '../enum/enum.js';

export default {
  name: 'Login',
  data() {
    return {
      email: '',
      password: '',
      error: '',
    };
  },
  setup() {
    const settingsStore = useSettingsStore();
    return { settingsStore };
  },
  computed: {
    currentThemeColor() {
      return themeOptions[this.settingsStore.settings.theme_color] || themeOptions[0];
    },
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
