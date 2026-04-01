<template>
  <div class="flex flex-col h-full">
    <h1 class="text-2xl font-semibold mb-4">记账记录</h1>
    <div class="flex flex-wrap gap-2 mb-4">
      <select
        v-model="category"
        class="border rounded px-3 py-2 w-30"
      >
        <option value="">选择分类</option>
        <option v-for="cat in categoryList" :key="cat.name" :value="cat.name">
          {{ cat.name }}
        </option>
      </select>
      <input
        v-model="amount"
        type="number"
        placeholder="金额"
        class="border rounded px-3 py-2 w-30"
      />
      <input
        v-model="note"
        placeholder="备注"
        class="border rounded px-3 py-2 flex-1 min-w-30"
      />
      <button
        @click="showDatePicker = true"
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-500"
      >
        {{isToday(selectedDate) ? '今天' : formattedDate(selectedDate)}}
      </button>
      <button
        @click="submit"
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-500"
      >
        添加
      </button>
    </div>

    <div class="flex flex-wrap gap-2 mb-4 items-center justify-between">
      <div class="flex items-center gap-2">
        <button 
          @click="previousMonth"
          class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-500"
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
          class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-500"
        >
          <ArrowRight class="w-5 h-5"/>
        </button>
      </div>
      <div class="flex items-center gap-2">
        <span class="text-sm text-slate-500">总数: ¥{{ totalAmount }}</span>
      </div>
    </div>

    <DatePicker
      v-if="showDatePicker"
      :value="selectedDate"
      @select="onDateSelected"
      @close="showDatePicker = false"
    />

    <DatePicker
      v-if="showMonthPicker"
      :date="false"
      :value="this.date"
      @select="onMonthSelected"
      @close="showMonthPicker = false"
    />

    <ul class="space-y-2 overflow-y-auto flex-1">
      <li
        v-for="tx in transactions.filter(tx => tx.deleted !== 1)"
        :key="tx.id || tx.created_at + tx.note"
        class="border rounded p-3 bg-white relative group"
        :class="{ 'bg-slate-100': deleteMode && activeDeleteItem === tx.id }"
        @click="isMobile ? toggleDelete(tx.id) : null"
      >
        <div class="flex items-center justify-between mb-2">
          <!-- icon + name -->
          <div class="flex items-center gap-2">
            <component
              :is="categoryMap[tx.category]?.icon"
              class="w-5 h-5 text-blue-500"
            />
            <span class="font-medium">{{ categoryMap[tx.category]?.name || '未知分类' }}</span>
          </div>
          <!-- amount + time -->
          <div class="flex items-center gap-4">
            <span class="font-medium text-blue-600">¥{{ tx.amount }}</span>
            <span class="text-sm text-slate-500">{{ formattedDate(tx.timestamp) }}</span>

            <button
              @click.stop="removeTransaction(tx)"
              :class="[
                'absolute right-3 bottom-3 text-white bg-red-500 px-2 py-1 rounded hover:bg-red-600 transition-opacity duration-150',
                deleteMode && activeDeleteItem === tx.id
                  ? 'opacity-100 pointer-events-auto'
                  : 'opacity-0 pointer-events-none',
                'group-hover:opacity-100 group-hover:pointer-events-auto'
              ]"
            >
              删除
            </button>
          </div>
        </div>
        <p class="text-slate-600">{{ tx.note }}</p>
      </li>
    </ul>
  </div>
</template>

<script>
import { categoryMap, categories } from '../enum/enum';
import { ArrowRight, ArrowLeft } from "lucide-vue-next";
import DatePicker from '../components/DatePicker.vue';
import dayjs from 'dayjs';

export default {
  components: {
    ArrowRight,
    ArrowLeft,
    DatePicker,
  },
  props: {
    transactions: { type: Array, required: true },
    date: {type: Number, required: true},
  },
  emits: ["add", "nextMonth", "previousMonth", "selectMonth", "deleteTransaction"],
  data() {
    return { 
      category: "", 
      amount: "", 
      note: "", 
      timestamp: "", 
      showDatePicker: false, 
      selectedDate: dayjs().valueOf(),
      showMonthPicker: false,
      activeDeleteItem: null,
      deleteMode: false,
     };
  },
  computed: {
    categoryMap() {
      return categoryMap;
    },
    categoryList() {
      return categories;
    },
    totalAmount() {
      return this.transactions.filter(tx => tx.deleted !== 1).reduce((sum, tx) => {
        return sum + Number(tx.amount || 0);
      }, 0);
    },
    isMobile() {
      if (typeof window === 'undefined') return false;
      return window.matchMedia('(hover: none), (pointer: coarse)').matches;
    },
  },
  methods: {
    formattedDate(timestamp) {
      return dayjs(timestamp).format('YYYY-MM-DD');
    },
    formattedMonth(timestamp) {
      return dayjs(timestamp).format('YYYY-MM');
    },
    submit() {
      if (!this.amount || !this.note || !this.category) return;
      this.$emit("add", {
        id:localStorage.getItem("id") + dayjs().valueOf(),
        category: this.category,
        amount: Number(this.amount),
        note: this.note,
        timestamp: this.selectedDate,
      });
      this.category = "";
      this.amount = "";
      this.note = "";
      this.selectedDate = dayjs().valueOf();
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
    toggleDelete(itemId) {
      if (!this.isMobile) {
        return;
      }
      if (this.deleteMode && this.activeDeleteItem === itemId) {
        this.cancelDeleteMode();
      } else {
        this.activeDeleteItem = itemId;
        this.deleteMode = true;
      }
    },
    cancelDeleteMode() {
      this.deleteMode = false;
      this.activeDeleteItem = null;
    },
    removeTransaction(tx) {
      this.$emit('deleteTransaction', tx);
      this.cancelDeleteMode();
    },
    onDateSelected(timestamp) {
      this.showDatePicker = false;
      this.selectedDate = timestamp;
    },
    isToday(timestamp) {
      return dayjs(timestamp).isSame(dayjs(), 'day');
    },
    onMonthSelected(timestamp) {
      this.showMonthPicker = false;
      this.$emit('selectMonth', timestamp);
    }
  },
};
</script>
