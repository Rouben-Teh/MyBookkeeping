<template>
  <div class="space-y-6">
    <div class="bg-white rounded-3xl shadow p-6">
      <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <p class="text-sm uppercase tracking-[0.24em] font-semibold" :class="[`${currentThemeColor.tr}`]">Profile</p>
          <h1 class="mt-3 text-3xl font-semibold">MyBookkeeper</h1>
          <p class="mt-2 text-slate-500">A quick overview of your bookkeeping activity and account details.</p>
        </div>
        <div class="rounded-3xl px-4 py-3 text-sm font-semibold" :class="[`${currentThemeColor.xl} ${currentThemeColor.tb}`]">Personal account</div>
      </div>

      <div class="mt-6 grid gap-4 md:grid-cols-2">
        <div class="rounded-3xl bg-slate-50 p-5">
          <p class="text-sm text-slate-500">Email</p>
          <p class="mt-3 text-lg font-semibold break-all">{{ email }}</p>
        </div>
        <div class="rounded-3xl bg-slate-50 p-5">
          <p class="text-sm text-slate-500">User ID</p>
          <p class="mt-3 text-lg font-semibold">{{ id || '—' }}</p>
        </div>
      </div>
    </div>

    <div class="grid gap-4 sm:grid-cols-3">
      <div class="rounded-3xl bg-white p-6 shadow-sm">
        <p class="text-sm text-slate-500">Current Streak</p>
        <p class="mt-3 text-4xl font-bold text-slate-900">{{ current_streak }}</p>
      </div>
      <div class="rounded-3xl bg-white p-6 shadow-sm">
        <p class="text-sm text-slate-500">Total Tracking Days</p>
        <p class="mt-3 text-4xl font-bold text-slate-900">{{ totalTrackingDays }}</p>
      </div>
      <div class="rounded-3xl bg-white p-6 shadow-sm">
        <p class="text-sm text-slate-500">Total Entries</p>
        <p class="mt-3 text-4xl font-bold text-slate-900">{{ totalEntries }}</p>
      </div>
    </div>

    <div class="bg-white rounded-3xl shadow p-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
      <div>
        <h2 class="text-xl font-semibold">Keep your momentum</h2>
        <p class="mt-2 text-slate-500">Track daily and maintain your streak for better finance habits.</p>
      </div>
      <button
        @click="$emit('logout')"
        class="inline-flex items-center justify-center rounded-full px-6 py-3 text-white shadow"
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
