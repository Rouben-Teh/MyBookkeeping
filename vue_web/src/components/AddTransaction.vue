<template>
    <div class="flex flex-col">
        <div class="flex flex-wrap gap-2 mb-4">
          <div class="relative shadow rounded-full w-30 bg-white">
            <select
                v-model="category"
                class="px-3 py-2 appearance-none w-full rounded-full bg-transparent focus:outline-none focus:ring-1 focus:ring-red-400"
            >
                <option value="">Category</option>
                <option v-for="cat in categoryList" :key="cat.name" :value="cat.name">
                {{ cat.name }}
                </option>
            </select>

            <div class="pointer-events-none absolute inset-y-0 right-3 flex items-center text-xs">
              ▼
            </div>
          </div>
            
            <input
                v-model="amount"
                type="number"
                placeholder="Amount"
                class="shadow rounded-full px-3 py-2 w-30 bg-white focus:outline-none focus:ring-1 focus:ring-red-400"
            />
            <input
                v-model="note"
                placeholder="Note"
                class="shadow rounded-full px-3 py-2 flex-1 min-w-30 bg-white focus:outline-none focus:ring-1 focus:ring-red-400"
            />
            <button
                @click="showDatePicker = true"
                class="shadow bg-red-500 text-white px-4 py-2 rounded-full hover:bg-red-400"
            >
                {{isToday(selectedDate) ? 'Today' : formattedDate(selectedDate)}}
            </button>
            <button
                v-if="initial && initial.id"
                @click="$emit('cancel')"
                class="shadow bg-gray-500 text-white px-4 py-2 rounded-full hover:bg-gray-400"
            >
                Cancel
            </button>
            <button
                @click="submit"
                class="shadow bg-red-500 text-white px-4 py-2 rounded-full hover:bg-red-400"
            >
                {{ initial && initial.id ? 'Update' : 'Add' }}
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
import { expenseCategories, incomeCategories } from '../enum/enum';
import DatePicker from './DatePicker.vue';
import dayjs from 'dayjs';

export default {
  components: { DatePicker },
  props: {
    type: { type: String, required: true },
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
      if (this.type === 'expense') {
        return expenseCategories;
      }
      return incomeCategories;
    },
  },
  methods: {
    formattedDate(timestamp) {
      return dayjs(timestamp).format('YYYY-MM-DD');
    },
    submit() {
      if (!this.amount || !this.category) return;
      const payload = {
        type: this.type,
        category: this.category,
        amount: Number(this.amount),
        note: this.note,
        timestamp: this.selectedDate,
        deleted: 0,
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