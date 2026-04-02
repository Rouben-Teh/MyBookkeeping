<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-600 to-indigo-700 flex-row items-center justify-center">
    <header class="container mx-auto px-6 py-6 flex items-center justify-between">
      <button>
        <router-link to="/" class="text-white ">
          <h1 class="text-3xl font-bold text-white">My Bookkeeping</h1>
        </router-link>
      </button>
    </header>
    
    <main class="container mx-auto px-6 space-y-20 py-10 flex items-center justify-center">
      <div class="max-w-md w-full bg-white p-6 rounded-lg shadow-lg">
        <h1 class="text-2xl font-semibold mb-4">登录</h1>
        <div class="space-y-3">
          <input
            v-model="email"
            type="email"
            placeholder="邮箱"
            class="w-full border rounded px-3 py-2"
          />
          <input
            v-model="password"
            type="password"
            placeholder="密码"
            class="w-full border rounded px-3 py-2"
          />
          <button
            @click="submit"
            class="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-500"
          >
            登录
          </button>
          <p v-if="error" class="text-red-500 text-sm">{{ error }}</p>
          <div class="space-y-2">
            <p class="text-sm text-slate-500">还没有账号？立即注册！</p>
            <button
              @click="$router.push({ name: 'Register' })"
              class="w-full bg-green-600 text-white py-2 rounded hover:bg-green-500"
            >
              去注册
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
        this.error = '请输入邮箱和密码';
        return;
      }
      try {
        await auth.login(this.email, this.password);
        this.$router.push({ name: 'Dashboard', params: { tab: 'records' } });
      } catch (e) {
        this.error = e.message || '登录失败';
      }
    },
  },
};
</script>
