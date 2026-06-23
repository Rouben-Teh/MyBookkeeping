<template>
  <div class="space-y-4 md:space-y-6">
    <div class="bg-white rounded-2xl md:rounded-3xl shadow p-4 md:p-6">
      <div class="flex flex-col gap-3 md:gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <p class="text-xs md:text-sm uppercase tracking-[0.24em] font-semibold" :class="[`${currentThemeColor.tr}`]">Profile</p>
          <h1 class="mt-2 md:mt-3 text-2xl md:text-3xl font-semibold">MyBookkeeper</h1>
          <p class="mt-1 md:mt-2 text-sm md:text-base text-slate-500">A quick overview of your bookkeeping activity and account details.</p>
        </div>
        <div class="rounded-2xl md:rounded-3xl px-3 md:px-4 py-2 md:py-3 text-xs md:text-sm font-semibold" :class="[`${currentThemeColor.xl} ${currentThemeColor.tb}`]">Personal account</div>
      </div>

      <div class="mt-4 md:mt-6 grid gap-3 md:gap-4 md:grid-cols-2">
        <div class="rounded-2xl md:rounded-3xl bg-slate-50 p-4 md:p-5">
          <p class="text-xs md:text-sm text-slate-500">Email</p>
          <p class="mt-2 md:mt-3 text-sm md:text-lg font-semibold break-all">{{ email }}</p>
        </div>
        <div class="rounded-2xl md:rounded-3xl bg-slate-50 p-4 md:p-5">
          <p class="text-xs md:text-sm text-slate-500">User ID</p>
          <p class="mt-2 md:mt-3 text-sm md:text-lg font-semibold">{{ id || '—' }}</p>
        </div>
      </div>
    </div>

    <div class="grid gap-3 md:gap-4 sm:grid-cols-3">
      <div class="rounded-2xl md:rounded-3xl bg-white p-4 md:p-6 shadow-sm">
        <p class="text-xs md:text-sm text-slate-500">Current Streak</p>
        <p class="mt-2 md:mt-3 text-3xl md:text-4xl font-bold text-slate-900">{{ current_streak }}</p>
      </div>
      <div class="rounded-2xl md:rounded-3xl bg-white p-4 md:p-6 shadow-sm">
        <p class="text-xs md:text-sm text-slate-500">Total Tracking Days</p>
        <p class="mt-2 md:mt-3 text-3xl md:text-4xl font-bold text-slate-900">{{ totalTrackingDays }}</p>
      </div>
      <div class="rounded-2xl md:rounded-3xl bg-white p-4 md:p-6 shadow-sm">
        <p class="text-xs md:text-sm text-slate-500">Total Entries</p>
        <p class="mt-2 md:mt-3 text-3xl md:text-4xl font-bold text-slate-900">{{ totalEntries }}</p>
      </div>
    </div>

    <div class="bg-white rounded-2xl md:rounded-3xl shadow p-4 md:p-6 flex flex-col gap-3 md:gap-4 sm:flex-row sm:items-center sm:justify-between">
      <div>
        <h2 class="text-lg md:text-xl font-semibold">Keep your momentum</h2>
        <p class="mt-1 md:mt-2 text-sm md:text-base text-slate-500">Track daily and maintain your streak for better finance habits.</p>
      </div>
      <button
        @click="$emit('logout')"
        class="inline-flex items-center justify-center rounded-full px-4 md:px-6 py-2 md:py-3 text-white shadow text-sm md:text-base"
        :class="[`${currentThemeColor.r} ${currentThemeColor.hlr}`]"
      >Logout</button>
    </div>
  </div>
</template>

<script>
import { useSettingsStore } from '../stores/settingsStore';
import { themeOptions } from '../enum/enum.js';

export default {
  name: 'Profile',
  emits: ['logout'],
  props: {
    last_current_streak: { type: Number, required: true },
    last_totalTrackingDays: { type: Number, required: true },
    last_totalEntries: { type: Number, required: true },
  },
  data() {
    return {
      id: localStorage.getItem('id'),
      email: localStorage.getItem('email'),
      current_streak: this.last_current_streak,
      totalTrackingDays: this.last_totalTrackingDays,
      totalEntries: this.last_totalEntries,
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
  },
};
</script>
