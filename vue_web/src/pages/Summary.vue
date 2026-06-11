<template>
  <div>
    <h1 class="text-2xl font-semibold mb-4">Summary</h1>

    <div class="mb-4">
      <div class="inline-flex rounded-full  bg-red-100 overflow-hidden">
        <button
          @click="setActiveType('year')"
          :class="[
            'px-4 py-2 text-sm font-medium transition-colors rounded-full w-30',
            activeType === 'year'
              ? 'bg-red-500 text-white shadow'
              : 'text-slate-700 hover:bg-red-200'
          ]"
        >
          Year
        </button>
        <button
          @click="setActiveType('month')"
          :class="[
            'px-4 py-2 text-sm font-medium transition-colors rounded-full w-30',
            activeType === 'month'
              ? 'bg-red-500 text-white shadow'
              : 'text-slate-700 hover:bg-red-200'
          ]"
        >
          Month
        </button>
        <button
          @click="setActiveType('week')"
          :class="[
            'px-4 py-2 text-sm font-medium transition-colors rounded-full w-30',
            activeType === 'week'
              ? 'bg-red-500 text-white shadow'
              : 'text-slate-700 hover:bg-red-200'
          ]"
        >
          Week
        </button>
      </div>
    </div>

    <div class="flex flex-row items-center">
        <button 
          @click="previousDate"
          class="shadow bg-red-500 text-white px-4 py-2 rounded-full hover:bg-red-400"
        >
          <ArrowLeft class="w-5 h-5"/>
        </button>

        <div class="w-60 inline-flex justify-center self-center">
          <p>{{formattedDate(dateFrom)}}</p>

          <p class="px-4"> - </p>

          <p>{{formattedDate(dateTo)}}</p>
        </div>

        <button 
          @click="nextDate"
          class="shadow bg-red-500 text-white px-4 py-2 rounded-full hover:bg-red-400"
        >
          <ArrowRight class="w-5 h-5"/>
        </button>
      </div>

    <div class="my-4"></div>

    <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
      <div class="bg-white shadow rounded-lg p-4">
        <h2 class="text-lg font-medium">Transaction Count</h2>
        <p class="text-3xl font-bold mt-2">{{ transactions.filter(tx => tx.deleted !== 1).length }}</p>
      </div>
      <div class="bg-white shadow rounded-lg p-4">
        <h2 class="text-lg font-medium">Total Expenses Amount</h2>
        <p class="text-3xl font-bold mt-2">¥{{ totalExpenseAmount.toFixed(2) }}</p>
      </div>
      <div class="bg-white shadow rounded-lg p-4">
        <h2 class="text-lg font-medium">Total Income Amount</h2>
        <p class="text-3xl font-bold mt-2">¥{{ totalIncomeAmount.toFixed(2) }}</p>
      </div>
      <div class="bg-white shadow rounded-lg p-4">
        <h2 class="text-lg font-medium">Balance</h2>
        <p class="text-3xl font-bold mt-2">¥{{ (totalIncomeAmount - totalExpenseAmount).toFixed(2) }}</p>
      </div>
    </div>

    <div class="my-4"></div>

    <div class="flex flex-col lg:flex-row items-stretch justify-center gap-4">
      <div class="flex-2 min-w-0 p-5 bg-white shadow rounded-lg flex justify-center items-center">
        <div class="relative w-full h-80">
          <Line ref="lineChart" class="w-full h-full" :data="lineGraphData" :options="chartOptions" />
        </div>
      </div>

      <div class="flex-1 min-w-0 lg:ml-0 p-5 bg-white shadow rounded-lg flex justify-center items-center">
        <div class="relative w-full h-80 max-w-sm mx-auto">
          <Pie ref="pieChart" class="w-full h-full" :data="pieChartData" :options="chartOptions" />
        </div>
      </div>
    </div>

  </div>

</template>

<script setup>
import { ArrowRight, ArrowLeft } from "lucide-vue-next";
import 'chart.js/auto'
import { Line } from 'vue-chartjs'
import { Pie } from 'vue-chartjs'

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  resizeDelay: 0
}
</script>

<script>
import dayjs from 'dayjs';
import { weekdays }from '../enum/enum';

export default {
  components: {
    ArrowRight,
    ArrowLeft,
  },
  props: {
    activeSummaryType: {type: String, required: true},
    dateFrom: {type: Number, required: true},
    dateTo: {type: Number, required: true},
    transactions: { type: Array, required: true },
  },
  emits: ["activeSummaryType", "selectMonthFromSummary", "selectMonthToSummary"],
  data() {
    return { 
      activeType: this.activeSummaryType,
     };
  },
  computed: {
    totalExpenseAmount() {
      return this.transactions.filter(tx => tx.deleted !== 1 && tx.type === 'expense').reduce((sum, tx) => sum + Number(tx.amount || 0), 0);
    },
    totalIncomeAmount() {
      return this.transactions.filter(tx => tx.deleted !== 1 && tx.type === 'income').reduce((sum, tx) => sum + Number(tx.amount || 0), 0);
    },
    lineGraphData() {
      return this.buildChartData(this.transactions)
    },
    pieChartData() {
      return this.buildPieChartData(this.transactions)
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
    setActiveType(type) {
      this.activeType = type;
      let timestampStart;
      let timestampEnd;
      switch(type)
      {
        case 'year':
          timestampStart=dayjs().startOf('year').valueOf();
          timestampEnd=dayjs().endOf('year').valueOf();
          break;
        case 'month':
          timestampStart=dayjs().startOf('month').valueOf();
          timestampEnd=dayjs().endOf('month').valueOf();
          break;
        case 'week':
          timestampStart=dayjs().startOf('week').valueOf();
          timestampEnd=dayjs().endOf('week').valueOf();
          break;
      }

      this.$emit('selectMonthFromSummary', timestampStart);
      this.$emit('selectMonthToSummary', timestampEnd);
      
      this.$emit("activeSummaryType", type);
    },
    previousDate() {
      let timestampStart;
      let timestampEnd;
      switch(this.activeType)
      {
        case 'year':
          timestampStart=dayjs(this.dateFrom).subtract(1, 'year').valueOf();
          timestampEnd=dayjs(this.dateTo).subtract(1, 'year').valueOf();
          break;
        case 'month':
          timestampStart=dayjs(this.dateFrom).subtract(1, 'month').valueOf();
          timestampEnd=dayjs(this.dateTo).subtract(1, 'month').valueOf();
          timestampEnd=dayjs(timestampEnd).endOf('month').valueOf();
          break;
        case 'week':
          timestampStart=dayjs(this.dateFrom).subtract(1, 'week').valueOf();
          timestampEnd=dayjs(this.dateTo).subtract(1, 'week').valueOf();
          break;
      }

      this.$emit('selectMonthFromSummary', timestampStart);
      this.$emit('selectMonthToSummary', timestampEnd);
    },
    nextDate() {
      let timestampStart;
      let timestampEnd;
      switch(this.activeType)
      {
        case 'year':
          timestampStart=dayjs(this.dateFrom).add(1, 'year').valueOf();
          timestampEnd=dayjs(this.dateTo).add(1, 'year').valueOf();
          break;
        case 'month':
          timestampStart=dayjs(this.dateFrom).add(1, 'month').valueOf();
          timestampEnd=dayjs(this.dateTo).add(1, 'month').valueOf();
          timestampEnd=dayjs(timestampEnd).endOf('month').valueOf();
          break;
        case 'week':
          timestampStart=dayjs(this.dateFrom).add(1, 'week').valueOf();
          timestampEnd=dayjs(this.dateTo).add(1, 'week').valueOf();
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
      const visibleTransactions = (transactions || []).filter(tx => tx.deleted !== 1)
      const timeRangeMap = {}
      const labels = []
      const startDate = dayjs(this.dateFrom)
      const endDate = dayjs(this.dateTo)

      if (this.activeType === 'year') {
        for (let month = 1; month <= 12; month++) {
          const label = dayjs().month(month - 1).format('MMM')
          labels.push(label)
          timeRangeMap[label] = {
            income: 0,
            expense: 0
          }
        }
      } else if (this.activeType === 'month') {
        let current = startDate.startOf('day')

        while (current.isBefore(endDate) || current.isSame(endDate, 'day')) {
          const label = current.format('YYYY-MM-DD')
          labels.push(label)
          timeRangeMap[label] = {
            income: 0,
            expense: 0
          }
          current = current.add(1, 'day')
        }
      } else if (this.activeType === 'week') {
        let current = startDate.startOf('day')

        while (current.isBefore(endDate) || current.isSame(endDate, 'day')) {
          const label = weekdays[current.day()]
          labels.push(label)
          timeRangeMap[label] = {
            income: 0,
            expense: 0
          }
          current = current.add(1, 'day')
        }
      }

      visibleTransactions.forEach(item => {
        const date = dayjs(item.timestamp)

        if (!date.isValid()) {
          return
        }

        if (date.isBefore(startDate, 'day') || date.isAfter(endDate, 'day')) {
          return
        }

        const label = this.activeType === 'year'
          ? date.format('MMM')
          : this.activeType === 'week' ? weekdays[date.day()] : date.format('YYYY-MM-DD')

        if (!timeRangeMap[label]) {
          return
        }

        if (item.type === 'income') {
          timeRangeMap[label].income += Number(item.amount || 0)
        }

        if (item.type === 'expense') {
          timeRangeMap[label].expense += Number(item.amount || 0)
        }
      })

      return {
        labels,

        datasets: [
          {
            label: 'Expense',
            data: labels.map(label => timeRangeMap[label].expense),
            borderWidth: 2
          },

          {
            label: 'Income',
            data: labels.map(label => timeRangeMap[label].income),
            borderWidth: 2
          }
        ]
      }
    },
    buildPieChartData(transactions) {
      const categoryMap = {}

      transactions.forEach(item => {

        // 只统计 expense
        if (item.type !== 'expense') return

        if (!categoryMap[item.category]) {
          categoryMap[item.category] = 0
        }

        categoryMap[item.category] += Number(item.amount)
      })

      // 转 array
      const sorted = Object.entries(categoryMap)
        .sort((a, b) => b[1] - a[1])

      // 前 5 个
      const top5 = sorted.slice(0, 5)

      // 剩余
      const others = sorted.slice(5)

      let othersTotal = 0

      others.forEach(item => {
        othersTotal += item[1]
      })

      // labels
      const labels = top5.map(item => item[0])

      // data
      const data = top5.map(item => item[1])

      // 有 others 才加
      if (othersTotal > 0) {
        labels.push('Others')
        data.push(othersTotal)
      }

      return {
        labels,

        datasets: [
          {
            data
          }
        ]
      }
    },
  }
};
</script>
