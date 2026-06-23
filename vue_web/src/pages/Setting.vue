<template>
  <div class="space-y-4 md:space-y-6">
    <div class="bg-white rounded-2xl md:rounded-3xl shadow p-4 md:p-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 md:gap-4 mb-6">
        <div>
          <p class="text-xs md:text-sm uppercase tracking-[0.24em] font-semibold" :class="[`${themeOptions[selectedThemeIndex].tr}`]">Settings</p>
          <h1 class="mt-2 md:mt-3 text-2xl md:text-3xl font-semibold">Your preference</h1>
          <p class="mt-1 md:mt-2 text-sm md:text-base text-slate-500">Customize your app experience and currency format.</p>
        </div>
        <div class="inline-flex items-center gap-2 rounded-full px-3 md:px-4 py-2 md:py-3 text-xs md:text-sm font-semibold"
        :class="[`${themeOptions[selectedThemeIndex].xl} ${themeOptions[selectedThemeIndex].tb}`]">
          Personalize it</div>
      </div>

      <div class="grid gap-6">
        <div class="rounded-2xl md:rounded-3xl border border-slate-200 bg-slate-50 p-4 md:p-6">
          <h2 class="text-lg md:text-xl font-semibold mb-3 md:mb-4">Theme Color</h2>
          <p class="text-sm md:text-base text-slate-600 mb-3 md:mb-4">Pick the color theme for your dashboard and cards.</p>
          <div class="grid grid-cols-2 md:grid-cols-4 gap-2 md:gap-3">
            <button
              v-for="(option, index) in themeOptions"
              :key="option.value"
              @click="selectTheme(index)"
              :class="[
                'rounded-xl md:rounded-2xl p-3 md:p-4 border transition-colors',
                selectedThemeIndex === index
                  ? `${option.br} ${option.xl} shadow-inner`
                  : 'border-transparent hover:border-slate-300 hover:bg-white'
              ]"
            >
              <div class="mb-2 h-6 md:h-8 w-full rounded-lg" :class="[`${option.r}`]"></div>
              <p class="text-xs md:text-sm font-medium text-slate-700">{{ option.label }}</p>
            </button>
          </div>
        </div>

        <div class="rounded-2xl md:rounded-3xl border border-slate-200 bg-slate-50 p-4 md:p-6">
          <h2 class="text-lg md:text-xl font-semibold mb-3 md:mb-4">Currency</h2>
          <p class="text-sm md:text-base text-slate-600 mb-3 md:mb-4">Choose your preferred currency for amounts.</p>
          <div class="grid gap-3 sm:grid-cols-3">
            <label class="block">
              <span class="text-xs md:text-sm font-medium text-slate-700">Currency</span>
              <div class="relative w-full md:w-60">
                <select
                  v-model="selectedCurrency"
                  class="mt-2 w-full appearance-none rounded-xl md:rounded-2xl border border-slate-200 bg-white px-3 md:px-4 py-2 md:py-3 focus:outline-none focus:ring-2 text-sm md:text-base"
                  :class="[`${themeOptions[selectedThemeIndex].fblr} ${themeOptions[selectedThemeIndex].frxl}` ]"
                >
                
                  <option v-for="currency in currencyOptions" :key="currency.value" :value="currency.value">
                    {{ currency.label }}
                  </option>
                </select>

                <div class="pointer-events-none absolute inset-y-8 md:inset-y-3 right-3 flex items-center text-xs">
                  ▼
                </div>
              </div>
            </label>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {themeOptions, currencyOptions} from '../enum/enum';
import { useSettingsStore } from '../stores/settingsStore';

export default {
  name: 'Setting',
  setup() {
    const settingsStore = useSettingsStore();
    return { settingsStore };
  },
  data() {
    return {
      saved: false,
      themeOptions,
      currencyOptions,
    };
  },
  computed: {
    selectedThemeIndex: {
      get() {
        return this.settingsStore.settings.theme_color || 0;
      },
      async set(value) {
        const themeIndex = value;
        if (themeIndex !== -1) {
          await this.settingsStore.updateThemeColor(themeIndex);
          this.showSaveMessage();
        }
      }
    },
    selectedCurrency: {
      get() {
        return this.settingsStore.settings.currency || '$';
      },
      async set(value) {
        await this.settingsStore.updateCurrency(value);
        this.showSaveMessage();
      }
    },
    currencyLabel() {
      const currency = this.currencyOptions.find((item) => item.value === this.selectedCurrency);
      return currency ? currency.label : this.selectedCurrency;
    },
  },
  methods: {
    selectTheme(index) {
      this.selectedThemeIndex = index;
    },
    showSaveMessage() {
      this.saved = true;
      setTimeout(() => {
        this.saved = false;
      }, 2200);
    },
  },
};
</script>
