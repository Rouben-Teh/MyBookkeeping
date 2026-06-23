<template>
  <div class="space-y-4 md:space-y-6">
    <div class="bg-white rounded-2xl md:rounded-3xl shadow p-4 md:p-6">
      <div class="flex flex-col gap-3 md:gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <p class="text-xs md:text-sm uppercase tracking-[0.24em] font-semibold" :class="[`${currentThemeColor.tr}`]">Summary</p>
          <h1 class="mt-2 md:mt-3 text-2xl md:text-3xl font-semibold">Financial overview</h1>
          <p class="mt-1 md:mt-2 text-sm md:text-base text-slate-500">Review your transaction trends and performance for the selected period.</p>
        </div>
        <div class="inline-flex items-center gap-2 rounded-full px-3 md:px-4 py-2 md:py-3 text-xs md:text-sm font-semibold" :class="[`${currentThemeColor.xl} ${currentThemeColor.tb}`]">
          <span class="text-xs md:text-sm">{{ capitalize(activeType) }}</span>
          <span class="h-2 w-2 rounded-full" :class="[`${currentThemeColor.r}`]"></span>
          <span class="text-xs md:text-sm">{{ formattedDate(dateFrom) }} — {{ formattedDate(dateTo) }}</span>
        </div>
      </div>

      <div class="mt-4 md:mt-6 inline-flex rounded-full p-1 overflow-hidden" :class="[`${currentThemeColor.xl}`]">
        <button
          @click="setActiveType('year')"
          :class="buttonClass('year')"
        >Year</button>
        <button
          @click="setActiveType('month')"
          :class="buttonClass('month')"
        >Month</button>
        <button
          @click="setActiveType('week')"
          :class="buttonClass('week')"
        >Week</button>
      </div>
    </div>

    <div class="bg-white rounded-2xl md:rounded-3xl p-4 md:p-6 shadow-sm">
      <div class="flex flex-col gap-3 md:gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 class="text-lg md:text-xl font-semibold">Date range</h2>
          <p class="text-xs md:text-sm text-slate-500">Adjust the report window to inspect different periods.</p>
        </div>
        <div class="flex flex-wrap items-center gap-2 md:gap-3">
          <button
            @click="previousDate"
            class="rounded-full px-3 md:px-4 py-2 text-white shadow text-sm md:text-base" :class="[`${currentThemeColor.r} ${currentThemeColor.hlr}`]"
          ><ArrowLeft class="w-4 md:w-5 h-4 md:h-5" /></button>
          <div class="rounded-2xl md:rounded-3xl bg-slate-100 px-3 md:px-4 py-2 md:py-3 text-slate-700 text-xs md:text-sm">
            {{ formattedDate(dateFrom) }} — {{ formattedDate(dateTo) }}
          </div>
          <button
            @click="nextDate"
            class="rounded-full px-3 md:px-4 py-2 text-white shadow text-sm md:text-base" :class="[`${currentThemeColor.r} ${currentThemeColor.hlr}`]"
          ><ArrowRight class="w-4 md:w-5 h-4 md:h-5" /></button>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 md:gap-4">
      <div class="rounded-2xl md:rounded-3xl bg-white p-4 md:p-6 shadow-sm">
        <p class="text-xs md:text-sm text-slate-500">Transaction Count</p>
        <p class="mt-3 md:mt-4 text-2xl md:text-3xl font-bold text-slate-900">{{ visibleCount }}</p>
      </div>
      <div class="rounded-2xl md:rounded-3xl bg-white p-4 md:p-6 shadow-sm">
        <p class="text-xs md:text-sm text-slate-500">Total Expenses</p>
        <p class="mt-3 md:mt-4 text-2xl md:text-3xl font-bold text-slate-900">{{currentCurrency}}{{ totalExpenseAmount.toFixed(2) }}</p>
      </div>
      <div class="rounded-2xl md:rounded-3xl bg-white p-4 md:p-6 shadow-sm">
        <p class="text-xs md:text-sm text-slate-500">Total Income</p>
        <p class="mt-3 md:mt-4 text-2xl md:text-3xl font-bold text-slate-900">{{currentCurrency}}{{ totalIncomeAmount.toFixed(2) }}</p>
      </div>
      <div class="rounded-2xl md:rounded-3xl bg-white p-4 md:p-6 shadow-sm">
        <p class="text-xs md:text-sm text-slate-500">Balance</p>
        <p class="mt-3 md:mt-4 text-2xl md:text-3xl font-bold text-slate-900">{{currentCurrency}}{{ balance.toFixed(2) }}</p>
      </div>
    </div>

    <div class="grid gap-4 md:gap-6 lg:grid-cols-[2fr_1fr]">
      <div class="rounded-2xl md:rounded-3xl bg-white p-4 md:p-6 shadow-sm">
        <div class="mb-4 flex flex-col gap-2 md:gap-3 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <h2 class="text-lg md:text-xl font-semibold">Trend chart</h2>
            <p class="mt-1 md:mt-2 text-xs md:text-sm text-slate-500">Income and expense movements over time.</p>
          </div>
          <div class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-2 md:px-3 py-1 md:py-2 text-xs md:text-sm text-slate-700">
            {{ activeType === 'year' ? 'Annual view' : activeType === 'month' ? 'Monthly view' : 'Weekly view' }}
          </div>
        </div>
        <div class="relative h-64 md:h-80">
          <Line ref="lineChart" class="w-full h-full" :data="lineGraphData" :options="chartOptions" />
        </div>
      </div>

      <div class="space-y-4 md:space-y-6">
        <div class="rounded-2xl md:rounded-3xl bg-white p-4 md:p-6 shadow-sm">
          <h2 class="text-lg md:text-xl font-semibold mb-4">Expense breakdown</h2>
          <div class="relative h-64 md:h-80">
            <Pie ref="pieChart" class="w-full h-full" :data="pieChartData" :options="chartOptions" />
          </div>
        </div>

        <div class="rounded-2xl md:rounded-3xl bg-slate-50 p-4 md:p-6 shadow-sm">
          <h2 class="text-lg md:text-xl font-semibold">Summary tips</h2>
          <p class="mt-2 md:mt-3 text-sm md:text-base text-slate-600">Check your highest expense categories and compare income versus costs to improve your budget planning.</p>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import dayjs from 'dayjs';
import { weekdays, themeOptions } from '../enum/enum';
import { ArrowRight, ArrowLeft } from 'lucide-vue-next';
import 'chart.js/auto';
import { Line, Pie } from 'vue-chartjs';
import { useSettingsStore } from '../stores/settingsStore';

export default {
  components: {
    ArrowRight,
    ArrowLeft,
    Line,
    Pie
  },
  props: {
    activeSummaryType: { type: String, required: true },
    dateFrom: { type: Number, required: true },
    dateTo: { type: Number, required: true },
    transactions: { type: Array, required: true },
  },
  setup(){
    const chartOptions = {
      responsive: true,
      maintainAspectRatio: false,
      resizeDelay: 0,
    };

    const settingsStore = useSettingsStore();

    return {chartOptions, settingsStore};
  },
  emits: ['activeSummaryType', 'selectMonthFromSummary', 'selectMonthToSummary'],
  data() {
    return {
      activeType: this.activeSummaryType,
    };
  },
  computed: {
    currentThemeColor() {
      return themeOptions[this.settingsStore.settings.theme_color] || themeOptions[0];
    },
    currentCurrency() {
      return this.settingsStore.settings.currency;
    },
    visibleCount() {
      return this.transactions.filter((tx) => tx.deleted !== 1).length;
    },
    totalExpenseAmount() {
      return this.transactions
        .filter((tx) => tx.deleted !== 1 && tx.type === 'expense')
        .reduce((sum, tx) => sum + Number(tx.amount || 0), 0);
    },
    totalIncomeAmount() {
      return this.transactions
        .filter((tx) => tx.deleted !== 1 && tx.type === 'income')
        .reduce((sum, tx) => sum + Number(tx.amount || 0), 0);
    },
    balance() {
      return this.totalIncomeAmount - this.totalExpenseAmount;
    },
    lineGraphData() {
      return this.buildChartData(this.transactions);
    },
    pieChartData() {
      return this.buildPieChartData(this.transactions);
    },
  },
  mounted() {
    this.handleResizeCharts();
    window.addEventListener('resize', this.handleResizeCharts);
  },
  beforeUnmount() {
    window.removeEventListener('resize', this.handleResizeCharts);
  },
  methods: {

    buttonClass(type) {
      return [
        'px-4 py-2 text-sm font-medium transition-colors rounded-full',
        this.activeType === type
          ? `${this.currentThemeColor.r} text-white shadow`
          : `${this.currentThemeColor.tb} ${this.currentThemeColor.hxl}`,
      ];
    },
    capitalize(value) {
      return value ? value.charAt(0).toUpperCase() + value.slice(1) : '';
    },
    setActiveType(type) {
      this.activeType = type;
      let timestampStart;
      let timestampEnd;
      switch (type) {
        case 'year':
          timestampStart = dayjs().startOf('year').valueOf();
          timestampEnd = dayjs().endOf('year').valueOf();
          break;
        case 'month':
          timestampStart = dayjs().startOf('month').valueOf();
          timestampEnd = dayjs().endOf('month').valueOf();
          break;
        case 'week':
          timestampStart = dayjs().startOf('week').valueOf();
          timestampEnd = dayjs().endOf('week').valueOf();
          break;
      }
      this.$emit('selectMonthFromSummary', timestampStart);
      this.$emit('selectMonthToSummary', timestampEnd);
      this.$emit('activeSummaryType', type);
    },
    previousDate() {
      let timestampStart;
      let timestampEnd;
      switch (this.activeType) {
        case 'year':
          timestampStart = dayjs(this.dateFrom).subtract(1, 'year').valueOf();
          timestampEnd = dayjs(this.dateTo).subtract(1, 'year').valueOf();
          break;
        case 'month':
          timestampStart = dayjs(this.dateFrom).subtract(1, 'month').valueOf();
          timestampEnd = dayjs(this.dateTo).subtract(1, 'month').valueOf();
          break;
        case 'week':
          timestampStart = dayjs(this.dateFrom).subtract(1, 'week').valueOf();
          timestampEnd = dayjs(this.dateTo).subtract(1, 'week').valueOf();
          break;
      }
      this.$emit('selectMonthFromSummary', timestampStart);
      this.$emit('selectMonthToSummary', timestampEnd);
    },
    nextDate() {
      let timestampStart;
      let timestampEnd;
      switch (this.activeType) {
        case 'year':
          timestampStart = dayjs(this.dateFrom).add(1, 'year').valueOf();
          timestampEnd = dayjs(this.dateTo).add(1, 'year').valueOf();
          break;
        case 'month':
          timestampStart = dayjs(this.dateFrom).add(1, 'month').valueOf();
          timestampEnd = dayjs(this.dateTo).add(1, 'month').valueOf();
          break;
        case 'week':
          timestampStart = dayjs(this.dateFrom).add(1, 'week').valueOf();
          timestampEnd = dayjs(this.dateTo).add(1, 'week').valueOf();
          break;
      }
      this.$emit('selectMonthFromSummary', timestampStart);
      this.$emit('selectMonthToSummary', timestampEnd);
    },
    formattedDate(timestamp) {
      return dayjs(timestamp).format('YYYY-MM-DD');
    },
    handleResizeCharts() {
      this.$nextTick(() => {
        this.$refs.lineChart?.chart?.resize?.();
        this.$refs.pieChart?.chart?.resize?.();
      });
    },
    buildChartData(transactions) {
      const visibleTransactions = (transactions || []).filter((tx) => tx.deleted !== 1);
      const timeRangeMap = {};
      const labels = [];
      const startDate = dayjs(this.dateFrom);
      const endDate = dayjs(this.dateTo);

      if (this.activeType === 'year') {
        for (let month = 1; month <= 12; month++) {
          const label = dayjs().month(month - 1).format('MMM');
          labels.push(label);
          timeRangeMap[label] = { income: 0, expense: 0 };
        }
      } else if (this.activeType === 'month') {
        let current = startDate.startOf('day');
        while (current.isBefore(endDate) || current.isSame(endDate, 'day')) {
          const label = current.format('YYYY-MM-DD');
          labels.push(label);
          timeRangeMap[label] = { income: 0, expense: 0 };
          current = current.add(1, 'day');
        }
      } else if (this.activeType === 'week') {
        let current = startDate.startOf('day');
        while (current.isBefore(endDate) || current.isSame(endDate, 'day')) {
          const label = weekdays[current.day()];
          labels.push(label);
          timeRangeMap[label] = { income: 0, expense: 0 };
          current = current.add(1, 'day');
        }
      }

      visibleTransactions.forEach((item) => {
        const date = dayjs(item.timestamp);
        if (!date.isValid() || date.isBefore(startDate, 'day') || date.isAfter(endDate, 'day')) {
          return;
        }
        const label = this.activeType === 'year' ? date.format('MMM') : this.activeType === 'week' ? weekdays[date.day()] : date.format('YYYY-MM-DD');
        if (!timeRangeMap[label]) {
          return;
        }
        if (item.type === 'income') {
          timeRangeMap[label].income += Number(item.amount || 0);
        }
        if (item.type === 'expense') {
          timeRangeMap[label].expense += Number(item.amount || 0);
        }
      });

      return {
        labels,
        datasets: [
          { label: 'Expense', data: labels.map((label) => timeRangeMap[label].expense), borderWidth: 2 },
          { label: 'Income', data: labels.map((label) => timeRangeMap[label].income), borderWidth: 2 },
        ],
      };
    },
    buildPieChartData(transactions) {
      const categoryMap = {};
      transactions.forEach((item) => {
        if (item.type !== 'expense') return;
        categoryMap[item.category] = (categoryMap[item.category] || 0) + Number(item.amount || 0);
      });
      const sorted = Object.entries(categoryMap).sort((a, b) => b[1] - a[1]);
      const top5 = sorted.slice(0, 5);
      const others = sorted.slice(5);
      const labels = top5.map((item) => item[0]);
      const data = top5.map((item) => item[1]);
      const othersTotal = others.reduce((sum, item) => sum + item[1], 0);
      if (othersTotal > 0) {
        labels.push('Others');
        data.push(othersTotal);
      }
      return { labels, datasets: [{ data }] };
    },
  },
};
</script>
