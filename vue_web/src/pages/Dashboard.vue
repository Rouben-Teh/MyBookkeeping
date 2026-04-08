<template>
  <div class="h-screen flex bg-slate-50 text-slate-900">
    <aside class="h-screen bg-red-400 text-white w-56 p-4 space-y-4">
      <h2 class="text-xl font-bold">My Bookkeeping</h2>
      <nav class="space-y-2">
        <router-link
          :to="{ name: 'Dashboard', params: { tab: 'records' } }"
          class="block px-3 py-2 rounded-full hover:bg-red-500"
          :class="{ 'bg-red-500': selectedTab === 'records' }"
        ><NotebookPen class="w-5 h-5 inline mr-2" />Records</router-link>
        <router-link
          :to="{ name: 'Dashboard', params: { tab: 'profile' } }"
          class="block px-3 py-2 rounded-full hover:bg-red-500"
          :class="{ 'bg-red-500': selectedTab === 'profile' }"
        ><User class="w-5 h-5 inline mr-2" />Profile</router-link>
        <router-link
          :to="{ name: 'Dashboard', params: { tab: 'summary' } }"
          class="block px-3 py-2 rounded-full hover:bg-red-500"
          :class="{ 'bg-red-500': selectedTab === 'summary' }"
        ><ChartNoAxesCombined class="w-5 h-5 inline mr-2" />Summary</router-link>
      </nav>
    </aside>
    <main class="flex-1 p-6 overflow-auto">
      <component
        :is="currentComponent"
        :transactions="transactions"
        :date="currentDate"
        @add="addTransaction"
        @logout="handleLogout"
        @nextMonth="handleNextMonth"
        @previousMonth="handlePreviousMonth"
        @selectMonth="handleMonthSelected"
        @deleteTransaction="handleDeleteTransaction"
        @updateTransaction="handleUpdateTransaction"
      />
    </main>

    <ChatModal />
  </div>
</template>

<script>
import Records from './Records.vue';
import Profile from './Profile.vue';
import Summary from './Summary.vue';
import ChatModal from '../components/ChatModal.vue';
import auth from '../plugins/auth';
import { httpPost } from '../utils/NetUtils';
import dayjs from 'dayjs';
import { NotebookPen, User, ChartNoAxesCombined } from 'lucide-vue-next';

export default {
  components: { Records, Profile, Summary, ChatModal, NotebookPen, User, ChartNoAxesCombined },
  data() {
    return {
      transactions: [],
      currentDate: dayjs().valueOf(),
    };
  },
  computed: {
    selectedTab() {
      return this.$route.params.tab || 'records';
    },
    currentComponent() {
      if (this.selectedTab === 'profile') return 'Profile';
      if (this.selectedTab === 'summary') return 'Summary';
      return 'Records';
    },
  },
  created() {
    if (!auth.isAuthenticated()) {
      this.$router.replace({ name: 'Login' });
      return;
    }
    this.fetchCurrentMonthTransactions();
  },
  methods: {
    async fetchCurrentMonthTransactions() {
      try {
        const res = await httpPost('month-list', {
          start: dayjs(this.currentDate).startOf('month').valueOf(),
          end: dayjs(this.currentDate).endOf('month').valueOf(),
        });
        const data = res.data;
        this.transactions = data.transactions || [];
      } catch (error) {
        console.error(error);
      }
    },
    async addTransaction(payload) {
      try {
        const res = await httpPost('add', payload);
        const data = res.data;
        if (data.ok) {
          await this.fetchCurrentMonthTransactions();
        }
      } catch (error) {
        console.error(error);
      }
    },
    async handleLogout() {
      await auth.logout();
      this.$router.replace({ name: 'Login' });
    },
    handleNextMonth() {
      this.currentDate = dayjs(this.currentDate).add(1, 'month').valueOf();
      this.fetchCurrentMonthTransactions();
    },
    handlePreviousMonth() {
      this.currentDate = dayjs(this.currentDate).subtract(1, 'month').valueOf();
      this.fetchCurrentMonthTransactions();
    },
    handleMonthSelected(timestamp) {
      this.currentDate = timestamp;
      this.fetchCurrentMonthTransactions();
    },
    async handleDeleteTransaction(tx) {
      try {
        const res = await httpPost('soft-delete', { id: tx.id });
        const data = res.data;
        if (data.ok) {
          await this.fetchCurrentMonthTransactions();
        }
      } catch (error) {
        console.error(error);
      }
    },
    async handleUpdateTransaction(tx) {
      try {
        const res = await httpPost('sync', tx);
        const data = res.data;
        if (data.ok) {
          await this.fetchCurrentMonthTransactions();
        }
      } catch (error) {
        console.error(error);
      }
    },
  },
  watch: {
    '$route.params.tab'() {
      // Keep main view consistent; tab changed by router-link.
    },
  },
};
</script>
