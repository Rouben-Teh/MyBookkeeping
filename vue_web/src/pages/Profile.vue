<template>
  <div>
    <h1 class="text-2xl font-semibold mb-4">Profile</h1>
    <div class="bg-white rounded-lg p-6 shadow-sm">
      <h2 class="mb-2"><b>My'Book'keeper</b></h2>
      <p class="mb-2">{{email}}</p>
      <div class="grid grid-cols-3 gap-4">
  
        <div class="flex flex-col items-center justify-center rounded-xl bg-red-100 p-4">
          <span class="text-2xl font-bold">{{current_streak}}</span>
          <span class="mt-1 text-sm text-gray-500">
            Current Streak
          </span>
        </div>

        <div class="flex flex-col items-center justify-center rounded-xl bg-red-100 p-4">
          <span class="text-2xl font-bold">{{totalTrackingDays}}</span>
          <span class="mt-1 text-sm text-gray-500">
            Total Tracking Days
          </span>
        </div>

        <div class="flex flex-col items-center justify-center rounded-xl bg-red-100 p-4">
          <span class="text-2xl font-bold">{{totalEntries}}</span>
          <span class="mt-1 text-sm text-gray-500">
            Total Entries
          </span>
        </div>

      </div>
      
    </div>

      <button
        @click="$emit('logout')"
        class="shadow bg-red-600 text-white px-4 py-2 rounded-full hover:bg-red-500 mt-4" 
      >
        Logout
      </button>
  </div>
</template>

<script>
import { httpPost } from '../utils/NetUtils';

export default {
  name: "Profile",
  emits: ["recordEntry", "recordStreak", "logout"],
  props: {
    last_current_streak: {type: Number, required: true},
    last_totalTrackingDays: {type: Number, required: true},
    last_totalEntries: {type: Number, required: true},
  },
  data() {
    const id = localStorage.getItem("id");
    const email = localStorage.getItem("email");

    return{
      id: id,
      email: email,
      current_streak: this.last_current_streak,
      totalTrackingDays: this.last_totalTrackingDays,
      totalEntries: this.last_totalEntries,
    }
  },
  created() {
    this.fetchCount();
    this.fetchStreak();
  },
  methods: {
    async fetchCount() {
      try {
        const res = await httpPost('count', {});
        const data = res.data;
        this.totalEntries = data.response.total_entries;
        this.$emit('recordEntry', this.totalEntries);
      } catch (error) {
        console.error('fetchCurrentStreak error:', error.response?.data || error.message || error);
      }
    },
    async fetchStreak() {
      try {
        const res = await httpPost('streak', {});
        const data = res.data;
        const list = data.response;
        this.current_streak = this.calculateStreak(list);
        this.totalTrackingDays = list.length;
        this.$emit('recordStreak', this.current_streak, this.totalTrackingDays);
      } catch (error) {
        console.error('fetchCurrentStreak error:', error.response?.data || error.message || error);
      }
    },
    calculateStreak(list) {
      const set = new Set(list.map(i => i.day))

      let streak = 0
      let current = new Date()

      // 如果今天没记，从昨天开始
      if (!set.has(this.formatDate(current))) {
        current.setDate(current.getDate() - 1)
      }

      while (set.has(this.formatDate(current))) {
        streak++
        current.setDate(current.getDate() - 1)
      }

      return streak
    },
    formatDate(date) {
      const yyyy = date.getFullYear()
      const mm = String(date.getMonth() + 1).padStart(2, '0')
      const dd = String(date.getDate()).padStart(2, '0')

      return `${yyyy}-${mm}-${dd}`
    }
  }
};
</script>
