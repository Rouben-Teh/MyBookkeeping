<template>
  <div class="flex flex-col h-full">
    <h1 class="text-2xl font-semibold mb-4">记账记录</h1>
    <div class="flex flex-wrap gap-2 mb-4">
      <select
        v-model="category"
        class="border rounded px-3 py-2 w-40"
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
        class="border rounded px-3 py-2 w-40"
      />
      <input
        v-model="note"
        placeholder="备注"
        class="border rounded px-3 py-2 flex-1 min-w-45"
      />
      <button
        @click="submit"
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-500"
      >
        添加
      </button>
    </div>

    <div class="flex flex-wrap gap-2 mb-4">
      <button 
        @click="previousMonth"
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-500"
      >
        <ArrowLeft class="w-5 h-5"/>
      </button>
      <button 
        class="text-black px-4"
      >
      {{formattedDate(date)}}
      </button>
      <button 
        @click="nextMonth"
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-500"
      >
        <ArrowRight class="w-5 h-5"/>
      </button>
    </div>

    <ul class="space-y-2 overflow-y-auto flex-1">
      <li
        v-for="tx in transactions"
        :key="tx.id || tx.created_at + tx.note"
        class="border rounded p-3 bg-white"
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
import dayjs from 'dayjs';

export default {
  components: {
    ArrowRight,
    ArrowLeft,
  },
  props: {
    transactions: { type: Array, required: true },
    date: {type: Number, required: true},
  },
  emits: ["add", "nextMonth", "previousMonth"],
  data() {
    return { category: "", amount: "", note: "", timestamp:"" };
  },
  computed: {
    categoryMap() {
      return categoryMap;
    },
    categoryList() {
      return categories;
    }
  },
  methods: {
    formattedDate(timestamp) {
      return dayjs(timestamp).format('YYYY-MM-DD');
    },
    submit() {
      if (!this.amount || !this.note || !this.category) return;
      this.$emit("add", {
        category: this.category,
        amount: Number(this.amount),
        note: this.note,
      });
      this.category = "";
      this.amount = "";
      this.note = "";
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
    }
  },
};
</script>
