<template>
  <div class="space-y-6">
    <div class="bg-white rounded-3xl shadow p-6">
      <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <p class="text-sm uppercase tracking-[0.24em] font-semibold" :class="[`${currentThemeColor.tr}`]">Records</p>
          <h1 class="mt-3 text-3xl font-semibold">Transaction manager</h1>
          <p class="mt-2 text-slate-500">Add, filter and review your expense and income records with ease.</p>
        </div>
        <div class="inline-flex items-center gap-2 rounded-full px-4 py-3 text-sm font-semibold"
        :class="[`${currentThemeColor.xl} ${currentThemeColor.tb}`]">
          <span>{{ activeType === 'expense' ? 'Expenses' : 'Income' }}</span>
        </div>
      </div>

      <div class="mt-6 inline-flex rounded-full p-1 overflow-hidden" :class="[`${currentThemeColor.xl}`]">
        <button
          @click="setActiveType('expense')"
          :class="toggleClass('expense')"
        >Expenses</button>
        <button
          @click="setActiveType('income')"
          :class="toggleClass('income')"
        >Income</button>
      </div>
    </div>

    <div class="grid gap-6">
      <div class="rounded-3xl bg-slate-50 p-6 shadow-sm">
        <AddTransaction
          :type="activeType"
          :date="date"
          @add="$emit('add', $event)"
        />
      </div>

      <div class="rounded-3xl bg-white p-6 shadow-sm">
        <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <p class="text-sm text-slate-500">Selected month</p>
            <p class="mt-2 text-lg font-semibold">{{ formattedMonth(date) }}</p>
          </div>
          <div class="flex items-center gap-3 flex-wrap">
            <button
              @click="previousMonth"
              class="rounded-full px-4 py-2 text-white shadow"
              :class="[`${currentThemeColor.r} ${currentThemeColor.hlr}`]"
            >
              <ArrowLeft class="w-5 h-5" />
            </button>
            <button
              @click="showMonthPicker = true"
              class="rounded-full bg-slate-100 px-4 py-2 text-slate-700 hover:bg-slate-200"
            >Choose month</button>
            <button
              @click="nextMonth"
              class="rounded-full px-4 py-2 text-white shadow"
              :class="[`${currentThemeColor.r} ${currentThemeColor.hlr}`]"
            >
              <ArrowRight class="w-5 h-5" />
            </button>
          </div>
        </div>
        <div class="mt-6 rounded-3xl bg-slate-50 p-5">
          <p class="text-sm text-slate-500">Total {{ activeType === 'expense' ? 'Expenses' : 'Income' }}</p>
          <p class="mt-3 text-3xl font-bold text-slate-900">{{currentCurrency}}{{ totalAmount }}</p>
        </div>
      </div>

      <div class="rounded-3xl bg-white p-6 shadow-sm">
        <div class="flex items-center justify-between gap-4 mb-4">
          <div>
            <h2 class="text-xl font-semibold">{{ activeType === 'expense' ? 'Expense records' : 'Income records' }}</h2>
            <p class="mt-2 text-slate-500">Swipe through your latest entries for the month.</p>
          </div>
        </div>
        <DatePicker
          v-if="showMonthPicker"
          :date="false"
          :value="date"
          @select="onMonthSelected"
          @close="showMonthPicker = false"
        />
        <Transactions
          :transactions="filteredTransactions"
          @deleteTransaction="$emit('deleteTransaction', $event)"
          @updateTransaction="$emit('updateTransaction', $event)"
        />
      </div>
    </div>
  </div>
</template>

<script>
import { ArrowRight, ArrowLeft } from 'lucide-vue-next';
import { useSettingsStore } from '../stores/settingsStore';
import { themeOptions, currencyOptions } from '../enum/enum.js';
import DatePicker from '../components/DatePicker.vue';
import Transactions from '../components/Transactions.vue';
import AddTransaction from '../components/AddTransaction.vue';
import dayjs from 'dayjs';

export default {
  components: {
    ArrowRight,
    ArrowLeft,
    DatePicker,
    Transactions,
    AddTransaction,
  },
  props: {
    transactions: { type: Array, required: true },
    date: { type: Number, required: true },
  },
  emits: ['add', 'nextMonth', 'previousMonth', 'selectMonth', 'deleteTransaction', 'updateTransaction'],
  data() {
    return {
      showMonthPicker: false,
      activeType: 'expense',
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
    currentCurrency() {
      return this.settingsStore.settings.currency;
    },
    filteredTransactions() {
      return this.transactions.filter((tx) => tx.deleted !== 1 && tx.type === this.activeType);
    },
    totalAmount() {
      return this.filteredTransactions.reduce((sum, tx) => sum + Number(tx.amount || 0), 0);
    },
  },
  methods: {
    setActiveType(type) {
      this.activeType = type;
    },
    toggleClass(type) {
      return [
        'px-4 py-2 text-sm font-medium transition-colors rounded-full',
        this.activeType === type
          ? `${this.currentThemeColor.r} text-white shadow`
          : `${this.currentThemeColor.tb} ${this.currentThemeColor.hxl}`,
      ];
    },
    formattedMonth(timestamp) {
      return dayjs(timestamp).format('YYYY-MM');
    },
    nextMonth() {
      if (dayjs(this.date).add(1, 'month').valueOf() > dayjs().valueOf()) {
        return;
      }
      this.$emit('nextMonth');
    },
    previousMonth() {
      this.$emit('previousMonth');
    },
    onMonthSelected(timestamp) {
      this.showMonthPicker = false;
      this.$emit('selectMonth', timestamp);
    },
  },
};
</script>
