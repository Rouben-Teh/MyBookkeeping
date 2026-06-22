<template>
  <div class="space-y-6">
    <div class="bg-white rounded-3xl shadow p-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
        <div>
          <p class="text-sm uppercase tracking-[0.24em] font-semibold" :class="[`${themeOptions[selectedThemeIndex].tr}`]">Settings</p>
          <h1 class="mt-3 text-3xl font-semibold">Your Preference</h1>
          <p class="mt-2 text-slate-500">Customize your app experience and currency format.</p>
        </div>
        <div class="inline-flex items-center gap-2 rounded-full px-4 py-3 text-sm font-semibold"
        :class="[`${themeOptions[selectedThemeIndex].xl} ${themeOptions[selectedThemeIndex].tb}`]">
          Personalize it</div>
      </div>

      <div class="grid gap-6">
        <div class="rounded-3xl border border-slate-200 bg-slate-50 p-6">
          <h2 class="text-xl font-semibold mb-4">Theme Color</h2>
          <p class="text-slate-600 mb-4">Pick the color theme for your dashboard and cards.</p>
          <div class="grid grid-cols-2 gap-3 sm:grid-cols-4">
            <button
              v-for="(option, index) in themeOptions"
              :key="option.value"
              @click="selectTheme(index)"
              :class="[
                'rounded-2xl p-4 border transition-colors',
                selectedThemeIndex === index
                  ? `${option.br} ${option.xl} shadow-inner`
                  : 'border-transparent hover:border-slate-300 hover:bg-white'
              ]"
            >
              <div class="mb-2 h-8 w-full rounded-xl" :class="[`${option.r}`]"></div>
              <p class="text-sm font-medium text-slate-700">{{ option.label }}</p>
            </button>
          </div>
        </div>

        <div class="rounded-3xl border border-slate-200 bg-slate-50 p-6">
          <h2 class="text-xl font-semibold mb-4">Currency</h2>
          <p class="text-slate-600 mb-4">Choose your preferred currency for amounts.</p>
          <div class="grid gap-3 sm:grid-cols-3">
            <label class="block">
              <span class="text-sm font-medium text-slate-700">Currency</span>
              <div class="relative w-60">
                <select
                  v-model="selectedCurrency"
                  class="mt-2 w-full appearance-none rounded-2xl border border-slate-200 bg-white px-4 py-3 focus:outline-none focus:ring-2"
                  :class="[`${themeOptions[selectedThemeIndex].fblr} ${themeOptions[selectedThemeIndex].frxl}` ]"
                >
                
                  <option v-for="currency in currencyOptions" :key="currency.value" :value="currency.value">
                    {{ currency.label }}
                  </option>
                </select>

                <div class="pointer-events-none absolute inset-y-8 right-3 flex items-center text-xs">
                  ▼
                </div>
              </div>
            </label>
            <!-- <div class="rounded-2xl bg-white p-4 shadow-sm">
              <p class="text-sm text-slate-500">Selected Currency</p>
              <p class="mt-3 text-2xl font-semibold">{{ currencyLabel }}</p>
              <p class="text-slate-500">{{ selectedCurrency }}</p>
            </div> -->
          </div>
        </div>

        <!-- <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <button
            @click="saveSettings"
            class="inline-flex items-center justify-center rounded-full bg-red-500 px-6 py-3 text-white shadow hover:bg-red-400"
          >Save Changes</button>
          <div class="text-sm text-slate-500">
            <p>Your preferences are saved locally and will apply when you return.</p>
            <p v-if="saved" class="text-sm text-green-600 mt-1">Settings saved successfully.</p>
          </div>
        </div> -->
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
