<template>
  <div class="space-y-4 md:space-y-6">
    <div class="bg-white rounded-2xl md:rounded-3xl shadow p-4 md:p-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 md:gap-4 mb-6">
        <div>
          <p class="text-xs md:text-sm uppercase tracking-[0.24em] font-semibold" :class="[`${currentThemeColor.tr}`]">Feedback</p>
          <h1 class="mt-2 md:mt-3 text-2xl md:text-3xl font-semibold">Your voice</h1>
          <p class="mt-1 md:mt-2 text-sm md:text-base text-slate-500">Tell us how we can improve MyBookkeeping.</p>
        </div>
        <div class="inline-flex items-center gap-2 rounded-full px-3 md:px-4 py-2 md:py-3 text-xs md:text-sm font-semibold"
        :class="[`${currentThemeColor.xl} ${currentThemeColor.tb}`]">
          We read every message</div>
      </div>

      <div class="grid gap-3 md:gap-4">
        <label class="block">
          <span class="text-xs md:text-sm font-medium text-slate-700">Message</span>
          <textarea
            v-model="message"
            placeholder="Describe your idea, problem, or suggestion"
            rows="7"
            class="mt-2 w-full rounded-xl md:rounded-2xl border border-slate-200 px-3 md:px-4 py-2 md:py-3 resize-none focus:outline-none focus:ring-2 text-sm md:text-base"
            :class="[`${currentThemeColor.fblr} ${currentThemeColor.frxl}`]"
          ></textarea>
        </label>

        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 md:gap-4">
          <div class="space-y-1">
            <span class="text-xs md:text-sm font-medium text-slate-700">Priority</span>
            <div class="inline-flex items-center rounded-xl md:rounded-2xl bg-slate-100 px-3 md:px-4 py-2 text-xs md:text-sm text-slate-700">
              <span class="font-semibold">{‌{ priority }}</span>
              <span class="ml-2 text-slate-500">(optional)</span>
            </div>
          </div>
          <button
            @click="sendFeedback"
            :disabled="isSending || !message.trim()"
            class="inline-flex items-center justify-center rounded-full px-4 md:px-6 py-2 md:py-3 text-white shadow disabled:cursor-not-allowed text-sm md:text-base"
            :class="[`${currentThemeColor.r} ${currentThemeColor.hlr} ${currentThemeColor.dxl}`]"
          >
            <span v-if="!isSent && !isSending">Send Feedback</span>
            <span v-else-if="isSending">Sending...</span>
            <span v-else>Sent</span>
          </button>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4">
      <div class="rounded-2xl md:rounded-3xl bg-slate-50 p-4 md:p-6 shadow-sm">
        <h2 class="text-lg md:text-xl font-semibold mb-2 md:mb-3">What happens next?</h2>
        <p class="text-sm md:text-base text-slate-600">We review feedback daily and incorporate improvements into the next releases. You can also check the app for small updates and polish.</p>
      </div>
      <div class="rounded-2xl md:rounded-3xl bg-slate-50 p-4 md:p-6 shadow-sm">
        <h2 class="text-lg md:text-xl font-semibold mb-2 md:mb-3">Need support?</h2>
        <p class="text-sm md:text-base text-slate-600">If your issue is urgent, please email support@mybookkeeping.app or use the contact form on the landing page.</p>
      </div>
    </div>

    <div class="bg-white rounded-2xl md:rounded-3xl shadow p-4 md:p-6">
      <h2 class="text-lg md:text-xl font-semibold mb-2 md:mb-3">Frequently asked questions</h2>
      <div class="space-y-3">
        <div
          v-for="(faq, index) in faqData"
          :key="index"
          class="rounded-2xl border border-slate-200 bg-slate-50 p-4"
        >
          <button
            type="button"
            @click="toggleFaq(index)"
            class="flex w-full items-start justify-between text-left gap-4"
          >
            <span class="font-semibold text-slate-900">{{ faq.title }}</span>
            <span class="text-slate-500 text-xl leading-none">
              {{ openFaq[index] ? '−' : '+' }}
            </span>
          </button>
          <p
            v-if="openFaq[index]"
            class="mt-3 text-sm md:text-base text-slate-600 whitespace-pre-line"
          >
            {{ faq.content }}
          </p>
        </div>
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
  props: {
    faqData: { type: Array, required: true },
  },
  data() {
    return {
      subject: '',
      message: '',
      priority: 'Normal',
      isSending: false,
      isSent: false,
      openFaq: [],
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
    initFaqState() {
      this.openFaq = this.faqData.map(() => false);
    },
    toggleFaq(index) {
      this.openFaq.splice(index, 1, !this.openFaq[index]);
    },
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
  mounted() {
    this.initFaqState();
  },
  watch: {
    faqData(newData) {
      this.openFaq = newData.map(() => false);
    },
  },
};
</script>
