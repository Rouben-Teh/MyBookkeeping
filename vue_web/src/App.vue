<template>
  <div style="max-width: 720px; margin: 24px auto; padding: 12px">
    <h1>记账 Web</h1>
    <div>
      <input v-model="amount" placeholder="金额" type="number" />
      <input v-model="note" placeholder="备注" />
      <button @click="add">添加</button>
    </div>
    <transactions :items="transactions" />
  </div>
</template>

<script>
import Transactions from "./components/Transactions.vue";
export default {
  components: { Transactions },
  data() {
    return { amount: "", note: "", transactions: [] };
  },
  created() {
    this.fetch();
  },
  methods: {
    async fetch() {
      const r = await fetch("http://localhost:8000/api.php?action=list");
      const j = await r.json();
      this.transactions = j.transactions || [];
    },
    async add() {
      await fetch("http://localhost:8000/api.php?action=add", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ amount: Number(this.amount), note: this.note }),
      });
      this.amount = "";
      this.note = "";
      this.fetch();
    },
  },
};
</script>
