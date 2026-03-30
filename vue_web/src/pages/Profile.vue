<template>
  <div>
    <h1 class="text-2xl font-semibold mb-4">个人页面</h1>
    <div class="bg-white border rounded-lg p-6 shadow-sm">
      <p class="mb-2">{{ id }}</p>
      <p class="mb-2">{{email}}</p>
      <p class="text-slate-500 mb-4">在这里可以显示账户信息、统计、设置入口等。</p>
      <button
        @click="$emit('logout')"
        class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-500"
      >
        注销
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
