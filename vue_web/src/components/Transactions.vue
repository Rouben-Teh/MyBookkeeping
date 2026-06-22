<template>
  <ul class="space-y-2 overflow-y-auto flex-1">
      <li
        v-for="tx in transactions.filter(tx => tx.deleted !== 1)"
        :key="tx.id || tx.created_at + tx.note"
        class="shadow rounded p-3 bg-white relative group"
        :class="{ 'bg-slate-100': menuMode && activeItemMenu === tx.id }"
        @click="isMobile ? toggleMenu(tx.id) : null"
      >
        <div v-if="activateItemUpdate === tx.id">
          <AddTransaction
            :type="tx.type"
            :date="selectedDate"
            :initial="tx"
            @cancel="onCancelUpdate"
            @updateTransaction="onUpdateTransaction"
          />
        </div>

        <div v-else>
          <div class="flex items-center justify-between mb-2">
            <!-- icon + name -->
            <div class="flex items-center gap-2">
              <component
                :is="categoryMap[tx.category]?.icon"
                class="w-5 h-5"
                :class="[`${currentThemeColor.tr}`]"
              />
              <span class="font-medium">{{ categoryMap[tx.category]?.name || 'Unknown' }}</span>
            </div>
            <!-- amount + time -->
            <div class="flex items-center gap-4">
              <span class="font-medium" :class="[`${currentThemeColor.tb}`]">{{currentCurrency}}{{ tx.amount }}</span>
              <span class="text-sm text-slate-500">{{ formattedDate(tx.timestamp) }}</span>

              <button
                @click.stop="toggleUpdate(tx)"
                :class="[
                  'absolute right-20 bottom-3 shadow text-white bg-green-500 px-2 py-1 rounded-full hover:bg-green-400 transition-opacity duration-150',
                  menuMode && activeItemMenu === tx.id
                    ? 'opacity-100 pointer-events-auto'
                    : 'opacity-0 pointer-events-none',
                  'group-hover:opacity-100 group-hover:pointer-events-auto'
                ]"
              >
                Update
              </button>

              <button
                @click.stop="removeTransaction(tx)"
                :class="[
                  'absolute right-3 bottom-3 shadow text-white bg-red-500 px-2 py-1 rounded-full hover:bg-red-400 transition-opacity duration-150',
                  menuMode && activeItemMenu === tx.id
                    ? 'opacity-100 pointer-events-auto'
                    : 'opacity-0 pointer-events-none',
                  'group-hover:opacity-100 group-hover:pointer-events-auto'
                ]"
              >
                Delete
              </button>
            </div>
          </div>
          <p class="text-slate-600 h-6 overflow-hidden">{{ tx.note }}</p>
        </div>

      </li>
    </ul>
</template>

<script>
import dayjs from 'dayjs';
import { categoryMap, themeOptions, currencyOptions } from '../enum/enum';
import { useSettingsStore } from '../stores/settingsStore';
import AddTransaction from './AddTransaction.vue';

export default {
  components: { AddTransaction },
  props: {
    transactions: { type: Array, required: true },
  },
  emits: ["selectMonth", "deleteTransaction", "updateTransaction"],
  data() {
    return { 
      category: "", 
      amount: "", 
      note: "", 
      timestamp: "", 
      showDatePicker: false, 
      selectedDate: dayjs().valueOf(),
      activeItemMenu: null,
      menuMode: false,
      activateItemUpdate: null,
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
    currentCurrency() {
      return this.settingsStore.settings.currency || '$';
    },
    categoryMap() {
      return categoryMap;
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
    toggleMenu(itemId) {
      if (!this.isMobile) {
        return;
      }
      if (this.menuMode && this.activeItemMenu === itemId) {
        this.cancelMenuMode();
      } else {
        this.activeItemMenu = itemId;
        this.menuMode = true;
      }
    },
    cancelMenuMode() {
      this.menuMode = false;
      this.activeItemMenu = null;
    },
    removeTransaction(tx) {
      this.$emit('deleteTransaction', tx);
      this.cancelMenuMode();
    },
    toggleUpdate(tx) {
      this.activateItemUpdate = tx.id;
      this.cancelMenuMode();

      this.category = tx.category;
      this.amount = tx.amount;
      this.note = tx.note;
      this.selectedDate = tx.timestamp;
    },
    onCancelUpdate() {
      this.activateItemUpdate = null;
    },
    onUpdateTransaction(payload) {
      this.$emit('updateTransaction', payload);
      this.activateItemUpdate = null;
      this.cancelMenuMode();
    },
    onDateSelected(timestamp) {
      this.showDatePicker = false;
      this.selectedDate = timestamp;
    },
    isToday(timestamp) {
      return dayjs(timestamp).isSame(dayjs(), 'day');
    },
  },
 };
</script>
