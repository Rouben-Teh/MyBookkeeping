<template>
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
    <div class="bg-white rounded-lg p-4 w-full max-w-md shadow-lg">
      <h3 class="text-lg font-semibold mb-3">选择日期</h3>
      <div class="grid grid-cols-3 gap-3 mb-4">
        <div v-if="year">
          <label class="block text-sm text-slate-600 mb-1">年</label>
          <select v-model.number="selectedYear" class="w-full border rounded px-2 py-1">
            <option v-for="year in years" :key="year" :value="year">{{ year }}</option>
          </select>
        </div>
        <div v-if="month">
          <label class="block text-sm text-slate-600 mb-1">月</label>
          <select v-model.number="selectedMonth" class="w-full border rounded px-2 py-1">
            <option v-for="m in 12" :key="m" :value="m">{{ m }}</option>
          </select>
        </div>
        <div v-if="date">
          <label class="block text-sm text-slate-600 mb-1">日</label>
          <select v-model.number="selectedDay" class="w-full border rounded px-2 py-1">
            <option v-for="d in dayCount" :key="d" :value="d">{{ d }}</option>
          </select>
        </div>
      </div>
      <div class="flex justify-end gap-2">
        <button @click="$emit('close')" class="px-4 py-2 rounded border hover:bg-gray-200">取消</button>
        <button @click="confirm" class="px-4 py-2 rounded bg-red-500 text-white hover:bg-red-400">确定</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    year: { type: Boolean, default: true },
    month: { type: Boolean, default: true },  
    date: { type: Boolean, default: true  },
    value: {
      type: Number,
      default: () => Date.now(),
    },
  },
  data() {
    const d = new Date(this.value);
    return {
      selectedYear: d.getFullYear(),
      selectedMonth: d.getMonth() + 1,
      selectedDay: d.getDate(),
    };
  },
  computed: {
    years() {
      const curr = new Date().getFullYear();
      const range = [];
      for (let y = curr - 10; y <= curr + 10; y++) {
        range.push(y);
      }
      return range;
    },
    dayCount() {
      const month = this.selectedMonth;
      const year = this.selectedYear;
      const count = new Date(year, month, 0).getDate();
      return Array.from({ length: count }, (_, i) => i + 1);
    },
  },
  watch: {
    selectedYear() {
      this.adjustDay();
    },
    selectedMonth() {
      this.adjustDay();
    },
  },
  methods: {
    adjustDay() {
      const maxDay = new Date(this.selectedYear, this.selectedMonth, 0).getDate();
      if (this.selectedDay > maxDay) {
        this.selectedDay = maxDay;
      }
    },
    confirm() {
      const timestamp = new Date(this.selectedYear, this.selectedMonth - 1, this.selectedDay).valueOf();
      this.$emit('select', timestamp);
    },
  },
};
</script>
