<template>
    <div class="flex flex-col">
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
                class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-400"
            >
                {{isToday(selectedDate) ? '今天' : formattedDate(selectedDate)}}
            </button>
            <button
                v-if="initial && initial.id"
                @click="$emit('cancel')"
                class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-400"
            >
                取消
            </button>
            <button
                @click="submit"
                class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-400"
            >
                {{ initial && initial.id ? '更新' : '添加' }}
            </button>
        </div>

        <DatePicker
            v-if="showDatePicker"
            :value="selectedDate"
            @select="onDateSelected"
            @close="showDatePicker = false"
        />
        
    </div>
</template>

<script>
import { categories } from '../enum/enum';
import DatePicker from './DatePicker.vue';
import dayjs from 'dayjs';

export default {
  components: { DatePicker },
  props: {
    date: { type: Number, required: true },
    initial: { type: Object, default: null },
  },
  emits: ["add", "cancel", "updateTransaction"],
  data() {
    return {
      category: this.initial?.category || "",
      amount: this.initial?.amount || "",
      note: this.initial?.note || "",
      timestamp: this.initial?.timestamp || "",
      showDatePicker: false,
      selectedDate: this.initial?.timestamp || this.date || dayjs().valueOf(),
      showMonthPicker: false,
    };
  },
  watch: {
    date(newDate) {
      if (!this.initial) {
        this.selectedDate = newDate;
      }
    },
    initial(newInitial) {
      if (newInitial) {
        this.category = newInitial.category || "";
        this.amount = newInitial.amount || "";
        this.note = newInitial.note || "";
        this.selectedDate = newInitial.timestamp || this.date || dayjs().valueOf();
      }
    },
  },
  computed: {
    categoryList() {
      return categories;
    },
  },
  methods: {
    formattedDate(timestamp) {
      return dayjs(timestamp).format('YYYY-MM-DD');
    },
    submit() {
      if (!this.amount || !this.note || !this.category) return;
      const payload = {
        category: this.category,
        amount: Number(this.amount),
        note: this.note,
        timestamp: this.selectedDate,
      };

      if (this.initial && this.initial.id) {
        this.$emit("updateTransaction", { id: this.initial.id, ...payload });
      } else {
        this.$emit("add", {
          id: localStorage.getItem("id") + dayjs().valueOf(),
          ...payload,
        });
      }

      this.category = "";
      this.amount = "";
      this.note = "";
      this.selectedDate = dayjs().valueOf();
    },
    onDateSelected(timestamp) {
      this.showDatePicker = false;
      this.selectedDate = timestamp;
    },
    isToday(timestamp) {
      return dayjs(timestamp).isSame(dayjs(), 'day');
    },
  },
}
</script>