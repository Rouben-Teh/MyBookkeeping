<template>
  <div class="h-screen flex flex-col md:flex-row bg-slate-50 text-slate-900">

    <div v-if="!isLoadingSetting" class="fixed inset-0 flex bg-slate-100 z-100 items-center justify-center">
      <div class="flex flex-col items-center justify-center gap-2">
        <Wallet class="w-10 h-10 mb-1 stroke-red-400"/>
        <h3 class="text-center">Loading...</h3>
      </div>
    </div>

    <button 
      @click="sidebarOpen = !sidebarOpen"
      class="md:hidden fixed top-4 right-4 z-80 p-2 rounded-lg bg-white shadow"
    >
      <Menu class="w-5 h-5 inline stroke-black" />
    </button>
    
    <aside
      :class="[
        `${currentThemeColor.lr} fixed md:static h-screen text-white w-56 p-4 space-y-4 transition-transform duration-300 z-50`,
        sidebarOpen ? 'translate-x-0' : '-translate-x-full md:translate-x-0'
      ]"
    >
      <h2 class="text-xl font-bold mt-8 md:mt-0">MyBookkeeping</h2>
      <nav class="space-y-2">
        <router-link
          :to="{ name: 'Dashboard', params: { tab: 'records' } }"
          :class="[`block px-3 py-2 rounded-full ${currentThemeColor.hxl}`, { [`shadow ${currentThemeColor.r}`]: selectedTab === 'records' } ]"
        ><NotebookPen class="w-5 h-5 inline mr-2" />Records</router-link>
        <router-link
          :to="{ name: 'Dashboard', params: { tab: 'profile' } }"
          :class="[`block px-3 py-2 rounded-full ${currentThemeColor.hxl}`, { [`shadow ${currentThemeColor.r}`]: selectedTab === 'profile' } ]"
        ><User class="w-5 h-5 inline mr-2" />Profile</router-link>
        <router-link
          :to="{ name: 'Dashboard', params: { tab: 'summary' } }"
          :class="[`block px-3 py-2 rounded-full ${currentThemeColor.hxl}`, { [`shadow ${currentThemeColor.r}`]: selectedTab === 'summary' } ]"
        ><ChartNoAxesCombined class="w-5 h-5 inline mr-2" />Summary</router-link>
        <router-link
          :to="{ name: 'Dashboard', params: { tab: 'setting' } }"
          :class="[`block px-3 py-2 rounded-full ${currentThemeColor.hxl}`, { [`shadow ${currentThemeColor.r}`]: selectedTab === 'setting' } ]"
        ><Settings class="w-5 h-5 inline mr-2" />Setting</router-link>
        <router-link
          :to="{ name: 'Dashboard', params: { tab: 'feedback' } }"
          :class="[`block px-3 py-2 rounded-full ${currentThemeColor.hxl}`, { [`shadow ${currentThemeColor.r}`]: selectedTab === 'feedback' } ]"
        ><MessageSquare class="w-5 h-5 inline mr-2" />Feedback</router-link>
      </nav>
    </aside>
    
    <div 
      v-if="sidebarOpen"
      @click="sidebarOpen = false"
      class="md:hidden fixed inset-0 bg-black/50 z-40"
    ></div>
    
    <main class="flex-1 p-4 md:p-6 overflow-auto w-full md:w-auto">
      <Profile
        v-if="selectedTab === 'profile'"
        :last_current_streak="currentStreak"
        :last_totalTrackingDays="totalTrackingDays"
        :last_totalEntries="totalEntries"
        @logout="handleLogout"
      />

      <Summary
        v-else-if="selectedTab === 'summary'"
        :activeSummaryType="activeSummaryType"
        :transactions="summaryData"
        :dateFrom="dateFromSummary"
        :dateTo="dateToSummary"
        @activeSummaryType="handleSummaryType"
        @selectMonthFromSummary="handleMonthFromSummary"
        @selectMonthToSummary="handleMonthToSummary"
      />

      <Setting
        v-else-if="selectedTab === 'setting'"
      />

      <Feedback
        v-else-if="selectedTab === 'feedback'"
        :faqData="faqData"
      />

      <Records
        v-else
        :transactions="transactions"
        :date="currentDate"
        @add="addTransaction"
        @nextMonth="handleNextMonth"
        @previousMonth="handlePreviousMonth"
        @selectMonth="handleMonthSelected"
        @deleteTransaction="handleDeleteTransaction"
        @updateTransaction="handleUpdateTransaction"
      />

      <!-- <component
        :is="currentComponent"
        :transactions="transactions"
        :date="currentDate"
        :dateFrom="dateFromSummary"
        :dateTo="dateToSummary"
        @add="addTransaction"
        @logout="handleLogout"
        @nextMonth="handleNextMonth"
        @previousMonth="handlePreviousMonth"
        @selectMonth="handleMonthSelected"
        @deleteTransaction="handleDeleteTransaction"
        @updateTransaction="handleUpdateTransaction"
        @selectMonthFromSummary="handleMonthFromSummary"
        @selectMonthToSummary="handleMonthToSummary"
      /> -->
    </main>

    <ChatModal 
    @fetchTransaction="handleFetchCurrentMonthTransaction" />
  </div>
</template>

<script>
import Records from './Records.vue';
import Profile from './Profile.vue';
import Summary from './Summary.vue';
import Setting from './Setting.vue';
import Feedback from './Feedback.vue';
import ChatModal from '../components/ChatModal.vue';
import auth from '../plugins/auth';
import { useSettingsStore } from '../stores/settingsStore';
import { themeOptions, currencyOptions } from '../enum/enum.js';
import { httpPost } from '../utils/NetUtils';
import dayjs from 'dayjs';
import { NotebookPen, User, ChartNoAxesCombined, Settings, MessageSquare, Menu, Wallet } from 'lucide-vue-next';

export default {
  components: { Records, Profile, Summary, Setting, Feedback, ChatModal, NotebookPen, User, ChartNoAxesCombined, Settings, MessageSquare, Menu, Wallet },
  data() {
    return {
      isLoadingSetting: false,
      sidebarOpen: false,
      transactions: [],
      currentDate: dayjs().valueOf(),
      currentStreak: 0,
      totalTrackingDays: 0,
      totalEntries: 0,
      activeSummaryType: 'year',
      dateFromSummary: dayjs().subtract(6, 'month').valueOf(),
      dateToSummary: dayjs().valueOf(),
      summaryData: [],
      faqData: [],
    };
  },
  setup() {
    const settingsStore = useSettingsStore();
    return { settingsStore };
  },
  computed: {
    selectedTab() {
      return this.$route.params.tab || 'records';
    },
    currentThemeColor() {
      return themeOptions[this.settingsStore.settings.theme_color] || themeOptions[0];
    },
    settings() {
      return this.settingsStore.settings;
    },
  },
  async created() {
    if (!auth.isAuthenticated()) {
      this.$router.replace({ name: 'Login' });
      return;
    }
    this.$router.afterEach(() => {
      this.sidebarOpen = false;
    });
    await this.validation();
    await this.settingsStore.fetchSettings();
    this.isLoadingSetting = true;
    this.fetchCurrentMonthTransactions();
    this.fetchCount();
    this.fetchStreak();
    this.handleFetchSummaryData();
    this.faq();
  },
  methods: {
    async validation() {
      try {
        const res = await httpPost('validation', {});
        const data = res.data;

        console.log('validation: ', data);

        if(!data.ok){
          auth.removeCookie();
          this.$router.replace({ name: 'Login' });
        }

        if(data.reason == 'expired') {
          //TODO: renew token if want stay login status
        }

      } catch (error) {
        console.error(error);
      }
    },
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
          this.fetchCurrentMonthTransactions();
          this.fetchCount();
          this.fetchStreak();
          this.handleFetchSummaryData();
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
        const res = await httpPost('soft-delete', { id: tx.id, synced: 0 });
        const data = res.data;
        if (data.ok) {
          this.fetchCurrentMonthTransactions();
          this.fetchCount();
          this.fetchStreak();
          this.handleFetchSummaryData();
        }
      } catch (error) {
        console.error(error);
      }
    },
    async handleUpdateTransaction(tx) {
      try {
        const res = await httpPost('sync-transaction', tx);
        const data = res.data;
        if (data.ok) {
          this.fetchCurrentMonthTransactions();
          this.handleFetchSummaryData();
        }
      } catch (error) {
        console.error(error);
      }
    },
    async handleFetchCurrentMonthTransaction() {
      await this.fetchCurrentMonthTransactions();
    }, 
    async fetchCount() {
      try {
        const res = await httpPost('count', {});
        const data = res.data;
        this.totalEntries= data.response.total_entries;
      } catch (error) {
        console.error('fetchCurrentStreak error:', error.response?.data || error.message || error);
      }
    },
    async fetchStreak() {
      try {
        const res = await httpPost('streak', {});
        const data = res.data;
        const list = data.response;
        this.currentStreak= this.calculateStreak(list);
        this.totalTrackingDays= list.length;
      } catch (error) {
        console.error('fetchCurrentStreak error:', error.response?.data || error.message || error);
      }
    },
    handleMonthFromSummary(timestamp) {
      this.dateFromSummary = timestamp;
    },
    handleMonthToSummary(timestamp) {
      this.dateToSummary = timestamp;
    },
    handleSummaryType(type) {
      this.activeSummaryType = type;
    },
    async handleFetchSummaryData() {
      try {
        const res = await httpPost('statistic', { start: this.dateFromSummary, end: this.dateToSummary });
        const data = res.data;
        if (data.ok) {
          this.summaryData = data.response;
          console.log(data);
        }
      } catch (error) {
        console.error(error);
      }
    },
    calculateStreak(list) {
      const set = new Set(list.map(i => i.day))

      let streak = 0
      let current = new Date()

      // 如果今天没记，从昨天开始
      if (!set.has(this.formatDate(current))) {
        current.setDate(current.getDate() - 1)
      }

      while (set.has(this.formatDate(current))) {
        streak++
        current.setDate(current.getDate() - 1)
      }

      return streak
    },
    formatDate(date) {
      const yyyy = date.getFullYear()
      const mm = String(date.getMonth() + 1).padStart(2, '0')
      const dd = String(date.getDate()).padStart(2, '0')

      return `${yyyy}-${mm}-${dd}`
    },
    async faq(){
      try {
        const res = await httpPost('faq', {});
        const data = res.data;
        if (data.faq) {
          this.faqData = data.faq;
          console.log(data);
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
    dateToSummary(newVal, oldVal) {
      this.handleFetchSummaryData();
      console.log('to date changed:', newVal)
    }
  },
};
</script>
