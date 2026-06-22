<template>
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
    <div class="bg-white rounded-lg p-4 w-full max-w-md shadow-lg">
      <h3 class="text-lg font-semibold mb-3">Select Date</h3>

      <div class="grid grid-cols-3 gap-3 mb-4">
        <div v-if="year">
          <label class="block text-sm text-slate-600 mb-1">Year</label>
          <select v-model.number="selectedYear" class="w-full shadow rounded-full px-2 py-1">
            <option v-for="year in years" :key="year" :value="year">{{ year }}</option>
          </select>
        </div>
        <div v-if="month">
          <label class="block text-sm text-slate-600 mb-1">Month</label>
          <select v-model.number="selectedMonth" class="w-full shadow rounded-full px-2 py-1">
            <option v-for="m in 12" :key="m" :value="m">{{ m }}</option>
          </select>
        </div>
        <div v-if="date">
          <label class="block text-sm text-slate-600 mb-1">Day</label>
          <select v-model.number="selectedDay" class="w-full shadow rounded-full px-2 py-1">
            <option v-for="d in dayCount" :key="d" :value="d">{{ d }}</option>
          </select>
        </div>
      </div>

      <p class='text-red-600 text-xs'>{{ warning }}</p>

      <div class="flex justify-end gap-2">
        <button @click="$emit('close')" class="px-4 py-2 rounded-full shadow hover:bg-slate-100">Cancel</button>
        <button @click="confirm" class="px-4 py-2 rounded-full shadow text-white" :class="[`${currentThemeColor.r} ${currentThemeColor.hlr}`]">Confirm</button>
      </div>
    </div>
  </div>
</template>

<script>
import dayjs from 'dayjs';
import { useSettingsStore } from '../stores/settingsStore';
import { themeOptions } from '../enum/enum.js';

export default {
  props: {
    year: { type: Boolean, default: true },
    month: { type: Boolean, default: true },  
    date: { type: Boolean, default: true  },
    value: {
      type: Number,
      default: () => Date.now(),
    },
    limitMin: {
      type: Number,
      default: () => dayjs('1999-01-01').valueOf(),
    },
    limitMinWarn: {
      type: String,
      default: () => "The date you chose exceeded minimun date.",
    },
    limitMax: {
      type: Number,
      default: () => dayjs().valueOf(),
    },
    limitMaxWarn: {
      type: String,
      default: () => "The date you chose exceeded today.",
    },
  },
  data() {
    const d = new Date(this.value);
    return {
      selectedYear: d.getFullYear(),
      selectedMonth: d.getMonth() + 1,
      selectedDay: d.getDate(),
      warning: "",
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
      
      const min = new Date(this.limitMin);
      min.setHours(0, 0, 0, 0);

      if (timestamp < min.valueOf()) {
        this.warning = this.limitMinWarn;
        return;
      }
      
      const max = new Date(this.limitMax);
      max.setHours(0, 0, 0, 0);

      if (timestamp > max.valueOf()) {
        this.warning = this.limitMaxWarn;
        return;
      }

      this.$emit('select', timestamp);
    },
  },
};
</script>
