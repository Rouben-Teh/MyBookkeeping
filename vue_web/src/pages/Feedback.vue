<template>
  <div class="space-y-6">
    <div class="bg-white rounded-3xl shadow p-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
        <div>
          <p class="text-sm uppercase tracking-[0.24em] font-semibold" :class="[`${currentThemeColor.tr}`]">Feedback</p>
          <h1 class="mt-3 text-3xl font-semibold">Your Voice</h1>
          <p class="mt-2 text-slate-500">Tell us how we can improve MyBookkeeping.</p>
        </div>
        <div class="inline-flex items-center gap-2 rounded-full px-4 py-3 text-sm font-semibold"
        :class="[`${currentThemeColor.xl} ${currentThemeColor.tb}`]">
          We read every message</div>
      </div>

      <div class="grid gap-4">
        <!-- <label class="block">
          <span class="text-sm font-medium text-slate-700">Subject</span>
          <input
            v-model="subject"
            type="text"
            placeholder="Enter a short subject"
            class="mt-2 w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-red-400 focus:outline-none focus:ring-2 focus:ring-red-100"
          />
        </label> -->

        <label class="block">
          <span class="text-sm font-medium text-slate-700">Message</span>
          <textarea
            v-model="message"
            placeholder="Describe your idea, problem, or suggestion"
            rows="7"
            class="mt-2 w-full rounded-2xl border border-slate-200 px-4 py-3 resize-none focus:outline-none focus:ring-2"
            :class="[`${currentThemeColor.fblr} ${currentThemeColor.frxl}`]"
          ></textarea>
        </label>

        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <div class="space-y-1">
            <span class="text-sm font-medium text-slate-700">Priority</span>
            <div class="inline-flex items-center rounded-2xl bg-slate-100 px-4 py-2 text-sm text-slate-700">
              <span class="font-semibold">{‌{ priority }}</span>
              <span class="ml-2 text-slate-500">(optional)</span>
            </div>
          </div>
          <button
            @click="sendFeedback"
            :disabled="isSending || !message.trim()"
            class="inline-flex items-center justify-center rounded-full px-6 py-3 text-white shadow disabled:cursor-not-allowed"
            :class="[`${currentThemeColor.r} ${currentThemeColor.hlr} ${currentThemeColor.dxl}`]"
          >
            <span v-if="!isSent && !isSending">Send Feedback</span>
            <span v-else-if="isSending">Sending...</span>
            <span v-else>Sent</span>
          </button>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div class="rounded-3xl bg-slate-50 p-6 shadow-sm">
        <h2 class="text-xl font-semibold mb-3">What happens next?</h2>
        <p class="text-slate-600">We review feedback daily and incorporate improvements into the next releases. You can also check the app for small updates and polish.</p>
      </div>
      <div class="rounded-3xl bg-slate-50 p-6 shadow-sm">
        <h2 class="text-xl font-semibold mb-3">Need support?</h2>
        <p class="text-slate-600">If your issue is urgent, please email support@mybookkeeping.app or use the contact form on the landing page.</p>
      </div>
    </div>
  </div>
</template>

<script>
import { httpPost } from '../utils/NetUtils';
import { useSettingsStore } from '../stores/settingsStore';
import { themeOptions, currencyOptions } from '../enum/enum.js';

export default {
  name: 'Feedback',
  data() {
    return {
      subject: '',
      message: '',
      priority: 'Normal',
      isSending: false,
      isSent: false,
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
  methods: {
    async sendFeedback() {
      if (!this.message.trim()) {
        return;
      }

      this.isSending = true;
      this.isSent = false;

      try {
        const res = await httpPost('contact', { 
          device_type: 'WEB', 
          name: localStorage.getItem('id'), 
          email: localStorage.getItem('email'), 
          message:  this.message });
        const data = res.data;
        if (data.ok) {
          this.isSending = false;
          this.isSent = true;
          this.subject = '';
          this.message = '';
        }
      } catch (error) {
        this.isSending = false;
        console.error(error);
      }
    },
  },
};
</script>
