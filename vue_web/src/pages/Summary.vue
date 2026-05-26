<template>
  <div>
    <h1 class="text-2xl font-semibold mb-4">Summary</h1>

    <div class="flex flex-row items-center">
      <button 
        class="text-black px-4 shadow bg-white py-2 rounded-lg hover:bg-slate-100"
        @click="showMonthFromPicker = true"
      >
        {{formattedMonth(dateFrom)}}
      </button>

      <p class="px-4"> - </p>

      <button 
        class="text-black px-4 shadow bg-white py-2 rounded-lg hover:bg-slate-100"
        @click="showMonthToPicker = true"
      >
        {{formattedMonth(dateTo)}}
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
        <p class="text-3xl font-bold mt-2">¥{{ totalExpenseAmount }}</p>
      </div>
      <div class="bg-white shadow rounded-lg p-4">
        <h2 class="text-lg font-medium">Total Income Amount</h2>
        <p class="text-3xl font-bold mt-2">¥{{ totalIncomeAmount }}</p>
      </div>
      <div class="bg-white shadow rounded-lg p-4">
        <h2 class="text-lg font-medium">Balance</h2>
        <p class="text-3xl font-bold mt-2">¥{{ totalIncomeAmount - totalExpenseAmount }}</p>
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

  <DatePicker
    v-if="showMonthFromPicker"
    :date="false"
    :value="dateFrom"
    :limitMax="dateTo"
    @select="onMonthFromSelected"
    @close="showMonthFromPicker = false"
  />

  <DatePicker
    v-if="showMonthToPicker"
    :date="false"
    :value="dateTo"
    :limitMin="dateFrom"
    @select="onMonthToSelected"
    @close="showMonthToPicker = false"
  />

</template>

<script setup>
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
import DatePicker from '../components/DatePicker.vue';
import dayjs from 'dayjs';

export default {
  components: {
    DatePicker,
  },
  props: {
    dateFrom: {type: Number, required: true},
    dateTo: {type: Number, required: true},
    transactions: { type: Array, required: true },
  },
  emits: ["selectMonthFromSummary", "selectMonthToSummary"],
  data() {
    return { 
      showMonthFromPicker: false,
      showMonthToPicker: false,
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
    formattedMonth(timestamp) {
      return dayjs(timestamp).format('YYYY-MM');
    },
    handleResizeCharts() {
      this.$nextTick(() => {
        this.$refs.lineChart?.chart?.resize?.();
        this.$refs.pieChart?.chart?.resize?.();
      });
    },
    onMonthFromSelected(timestamp) {
      this.showMonthFromPicker = false;
      this.$emit('selectMonthFromSummary', timestamp);
    },
    onMonthToSelected(timestamp) {
      this.showMonthToPicker = false;
      this.$emit('selectMonthToSummary', timestamp);
    },
    buildChartData(transactions) {
      const monthMap = {}

      transactions.forEach(item => {
        const date = new Date(item.timestamp)

        const month = date.toLocaleString('en-US', {
          month: 'short'
        })

        if (!monthMap[month]) {
          monthMap[month] = {
            income: 0,
            expense: 0
          }
        }

        if (item.type === 'income') {
          monthMap[month].income += Number(item.amount)
        }

        if (item.type === 'expense') {
          monthMap[month].expense += Number(item.amount)
        }
      })

      const labels = Object.keys(monthMap)

      return {
        labels,

        datasets: [
          {
            label: 'Expense',
            data: labels.map(m => monthMap[m].expense),
            borderWidth: 2
          },

          {
            label: 'Income',
            data: labels.map(m => monthMap[m].income),
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
