<template>
  <div>
    <h1 class="text-2xl font-semibold mb-4">概览</h1>
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
      <div class="bg-white border rounded-lg p-4">
        <h2 class="text-lg font-medium">交易笔数</h2>
        <p class="text-3xl font-bold mt-2">{{ transactions.filter(tx => tx.deleted !== 1).length }}</p>
      </div>
      <div class="bg-white border rounded-lg p-4">
        <h2 class="text-lg font-medium">总金额</h2>
        <p class="text-3xl font-bold mt-2">¥{{ totalAmount }}</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    transactions: { type: Array, required: true },
  },
  computed: {
    totalAmount() {
      return this.transactions.filter(tx => tx.deleted !== 1).reduce((sum, tx) => sum + Number(tx.amount || 0), 0);
    },
  },
};
</script>
