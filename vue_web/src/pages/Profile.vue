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
  emits: ["logout"],
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
};
</script>
