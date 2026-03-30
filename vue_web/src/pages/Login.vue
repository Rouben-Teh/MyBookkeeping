<template>
  <div class="max-w-md mx-auto mt-12 bg-white p-6 rounded shadow">
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
    </div>
  </div>
</template>

<script>
export default {
  props: {
    isLoggedIn: { type: Boolean, default: false },
  },
  emits: ["login"],
  data() {
    return {
      email: "",
      password: "",
      error: "",
    };
  },
  methods: {
    submit() {
      this.error = "";
      if (!this.email || !this.password) {
        this.error = "请输入邮箱和密码";
        return;
      }
      this.$emit("login", { email: this.email, password: this.password });
    },
  },
};
</script>
