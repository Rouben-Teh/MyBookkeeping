<template>
  <div>
    <h1 class="text-2xl font-semibold mb-4">Profile</h1>
    <div class="bg-white border rounded-lg p-6 shadow-sm">
      <p class="mb-2">{{ id }}</p>
      <p class="mb-2">{{email}}</p>
      <p class="text-slate-500 mb-4">Here you can display account information, statistics, and settings.</p>
      <button
        @click="$emit('logout')"
        class="bg-red-600 text-white px-4 py-2 rounded-full hover:bg-red-500"
      >
        Logout
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: "Profile",
  emits: ["logout"],
  data() {
    const id = localStorage.getItem("id");
    const email = localStorage.getItem("email");

    return{
      id: id,
      email: email,
    }
  }
};
</script>
