<template>
  <div class="h-screen flex bg-slate-50 text-slate-900">
    <aside
      v-if="isLoggedIn"
      :class="[
        'h-screen bg-blue-900 text-white transition-all duration-300 overflow-hidden',
        collapsed ? 'w-20' : 'w-56',
      ]"
    >
      <button
        class="w-full py-2 text-sm bg-blue-800 hover:bg-blue-700"
        @click="collapsed = !collapsed"
      >
        {{ collapsed ? '»' : '«' }}
      </button>
      <ul class="mt-2 space-y-1">
        <li
          v-for="item in menu"
          :key="item.key"
          @click="selected = item.key"
          :class="[
            'flex items-center cursor-pointer px-3 py-2 rounded-md transition-colors',
            item.key === selected ? 'bg-blue-700' : 'hover:bg-blue-700/80',
          ]"
        >
          <span class="w-8 text-center">{{ item.icon }}</span>
          <span v-if="!collapsed" class="ml-2">{{ item.name }}</span>
        </li>
      </ul>
    </aside>

    <main class="flex-1 p-6 h-full overflow-hidden">
      <Login
        v-if="!isLoggedIn"
        @login="handleLogin"
      />
      <component
        v-else
        :is="currentPage"
        :transactions="transactions"
        :date="currentDate"
        @add="addTransaction"
        @logout="handleLogout"
        @nextMonth="handleNextMonth"
        @previousMonth="handlePreviousMonth"
      />
    </main>
  </div>
</template>

<script>
import Records from "./pages/Records.vue";
import Profile from "./pages/Profile.vue";
import Summary from "./pages/Summary.vue";
import Login from "./pages/Login.vue";
import auth from "./plugins/auth";
import { httpPost } from "./utils/NetUtils";
import dayjs from "dayjs";

export default {
  components: { Records, Profile, Summary, Login },
  data() {
    return {
      transactions: [],
      currentDate: dayjs().valueOf(),
      collapsed: false,
      selected: "records",
      isLoggedIn: auth.isAuthenticated(),
      menu: [
        { key: "records", name: "记录", icon: "🧾" },
        { key: "profile", name: "个人页面", icon: "👤" },
        { key: "summary", name: "概览", icon: "📊" },
      ],
    };
  },
  computed: {
    currentPage() {
      if (this.selected === "records") return "Records";
      if (this.selected === "profile") return "Profile";
      return "Summary";
    },
  },
  created() {
    if (this.isLoggedIn) {
      this.fetchCurrenttMonthTransactions();
    }
  },
  methods: {
    async fetchCurrenttMonthTransactions() {
      const res = await httpPost("month-list",{
        'start': dayjs(this.currentDate).startOf('month').valueOf(),
        'end': dayjs(this.currentDate).endOf('month').valueOf(),
      });
      const data = await res.data;
      console.log(data);
      this.transactions = data['transactions'] || [];
    },
    async addTransaction(payload) {
      await fetch("http://localhost:8000/api.php?action=add", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      await this.fetchCurrenttMonthTransactions();
    },
    async handleLogin(payload) {
      try {
        await auth.login(payload.email, payload.password);
        this.isLoggedIn = true;
        this.selected = "records";
        await this.fetchCurrenttMonthTransactions();
      } catch (error) {
        alert(error.message || "登录失败");
      }
    },
    handleLogout() {
      auth.logout();
      this.isLoggedIn = false;
      this.selected = "login";
      this.transactions = [];
    },
    handleNextMonth() {
      this.currentDate = dayjs(this.currentDate).add(1,'month').valueOf();
      this.fetchCurrenttMonthTransactions();
      console.log(this.currentDate);
    },
    handlePreviousMonth() {
      this.currentDate = dayjs(this.currentDate).subtract(1,'month').valueOf();
      this.fetchCurrenttMonthTransactions();
      console.log(this.currentDate);
    }
  },
};
</script>

