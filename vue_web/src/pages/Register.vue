<template>
  <div class="min-h-screen  bg-green-700 flex-row items-center justify-center">
    <header class="container mx-auto px-6 py-6 flex items-center justify-between">
      <button>
        <router-link to="/" class="text-white ">
          <h1 class="text-3xl font-bold text-white">My Bookkeeping</h1>
        </router-link>
      </button>
    </header>

    <main class="container mx-auto px-6 space-y-20 py-10 flex items-center justify-center">
      <div class="max-w-md w-full bg-white p-6 rounded-lg shadow-lg">
        <h1 class="text-2xl font-semibold mb-4">Register</h1>
        <div class="space-y-3">
          <input
            v-model="email"
            type="email"
            placeholder="Email"
            class="w-full border rounded-full px-3 py-2"
          />
          <input
            v-model="password"
            type="password"
            placeholder="Password (at least 6 characters)"
            class="w-full border rounded-full px-3 py-2"
          />
          <input
            v-model="confirmPassword"
            type="password"
            placeholder="Confirm Password"
            class="w-full border rounded-full px-3 py-2"
          />
          <button
            @click="submit"
            class="w-full bg-green-600 text-white py-2 rounded-full hover:bg-green-500"
          >
            Register and Login
          </button>
          <button
            @click="$router.push({ name: 'Login' })"
            class="w-full border border-green-600 text-green-600 py-2 rounded-full hover:bg-green-50"
          >
            Already have an account? Go to Login
          </button>
          <p v-if="error" class="text-red-500 text-sm">{{ error }}</p>
          <p v-if="success" class="text-green-600 text-sm">{{ success }}</p>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
import auth from "../plugins/auth";

export default {
  data() {
    return {
      email: "",
      password: "",
      confirmPassword: "",
      error: "",
      success: "",
    };
  },
  methods: {
    async submit() {
      this.error = "";
      this.success = "";

      if (!this.email || !this.password || !this.confirmPassword) {
        this.error = "Please fill in all fields.";
        return;
      }
      if (this.password.length < 6) {
        this.error = "Password must be at least 6 characters.";
        return;
      }
      if (this.password !== this.confirmPassword) {
        this.error = "The passwords you entered do not match.";
        return;
      }

      try {
        await auth.register(this.email, this.password);
        this.success = "Registration successful, redirecting to login page...";

        setTimeout(() => {
          this.$router.push({ name: "Login" });
        }, 1200);
      } catch (e) {
        this.error = e.response?.data?.message || e.message || "Registration failed";
      }
    },
  },
};
</script>
