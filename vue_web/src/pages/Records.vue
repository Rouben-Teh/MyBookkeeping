<template>
  <div class="flex flex-col h-full">
    <!-- <h1 class="text-2xl font-semibold mb-4">Records</h1> -->

    <div class="mb-4">
      <div class="inline-flex rounded-full  bg-red-100 overflow-hidden">
        <button
          @click="setActiveType('expense')"
          :class="[
            'px-4 py-2 text-sm font-medium transition-colors rounded-full',
            activeType === 'expense'
              ? 'bg-red-500 text-white'
              : 'text-slate-700 hover:bg-red-200'
          ]"
        >
          Expenses
        </button>
        <button
          @click="setActiveType('income')"
          :class="[
            'px-4 py-2 text-sm font-medium transition-colors rounded-full',
            activeType === 'income'
              ? 'bg-red-500 text-white'
              : 'text-slate-700 hover:bg-red-200'
          ]"
        >
          Income
        </button>
      </div>
    </div>

    <AddTransaction
      :type="activeType"
      :date="date"
      @add="$emit('add', $event)"/>

    <div class="flex flex-wrap gap-2 mb-4 items-center justify-between">
      <div class="flex items-center gap-2">
        <button 
          @click="previousMonth"
          class="bg-red-500 text-white px-4 py-2 rounded-full hover:bg-red-400"
        >
          <ArrowLeft class="w-5 h-5"/>
        </button>
        <button 
          class="text-black px-4"
          @click="showMonthPicker = true"
        >
          {{formattedMonth(date)}}
        </button>
        <button 
          @click="nextMonth"
          class="bg-red-500 text-white px-4 py-2 rounded-full hover:bg-red-400"
        >
          <ArrowRight class="w-5 h-5"/>
        </button>
      </div>
      <div class="flex items-center gap-2">
        <span class="text-sm text-slate-500">Total {{ activeType === 'expense' ? 'Expenses' : 'Income' }}: ¥{{ totalAmount }}</span>
      </div>
    </div>

    <DatePicker
      v-if="showMonthPicker"
      :date="false"
      :value="this.date"
      @select="onMonthSelected"
      @close="showMonthPicker = false"
    />

    <Transactions
      :transactions="filteredTransactions"
      @deleteTransaction="$emit('deleteTransaction', $event)"
      @updateTransaction="$emit('updateTransaction', $event)"
      />
  </div>
</template>

<script>

import { ArrowRight, ArrowLeft } from "lucide-vue-next";
import DatePicker from '../components/DatePicker.vue';
import Transactions from '../components/Transactions.vue';
import AddTransaction from "../components/AddTransaction.vue";
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
    date: {type: Number, required: true},
  },
  emits: ["add", "nextMonth", "previousMonth", "selectMonth", "deleteTransaction", "updateTransaction"],
  data() {
    return { 
      showMonthPicker: false,
      activeType: 'expense',
     };
  },
  computed: {
    filteredTransactions() {
      return this.transactions.filter(tx => tx.deleted !== 1 && tx.type === this.activeType);
    },
    totalAmount() {
      return this.filteredTransactions.reduce((sum, tx) => {
        return sum + Number(tx.amount || 0);
      }, 0);
    }
  },
  methods: {
    setActiveType(type) {
      this.activeType = type;
    },
    formattedMonth(timestamp) {
      return dayjs(timestamp).format('YYYY-MM');
    },
    nextMonth() {
      if(dayjs(this.date).add(1,'month').valueOf() > dayjs().valueOf()) {
        console.log('latest month');
        return;
      }
      this.$emit("nextMonth");
    },
    previousMonth() {
      this.$emit("previousMonth");
    },
    onMonthSelected(timestamp) {
      this.showMonthPicker = false;
      this.$emit('selectMonth', timestamp);
    }
  },
};
</script>
