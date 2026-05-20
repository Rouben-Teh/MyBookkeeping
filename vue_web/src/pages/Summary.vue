<template>
  <div>
    <h1 class="text-2xl font-semibold mb-4">Summary</h1>

    <div class="grid grid-cols-1 sm:grid-cols-1 gap-4">
      <div class="bg-white border rounded-lg p-4">
        <h2 class="text-lg font-medium">Transaction Count</h2>
        <p class="text-3xl font-bold mt-2">{{ transactions.filter(tx => tx.deleted !== 1).length }}</p>
      </div>
    </div>

    <div class="my-4"></div>

    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
      <div class="bg-white border rounded-lg p-4">
        <h2 class="text-lg font-medium">Total Expenses Amount</h2>
        <p class="text-3xl font-bold mt-2">¥{{ totalExpenseAmount }}</p>
      </div>
      <div class="bg-white border rounded-lg p-4">
        <h2 class="text-lg font-medium">Total Income Amount</h2>
        <p class="text-3xl font-bold mt-2">¥{{ totalIncomeAmount }}</p>
      </div>
    </div>

    <div class="my-4"></div>

    <div class="grid grid-cols-1 sm:grid-cols-1 gap-4">
      <div class="bg-white border rounded-lg p-4">
        <h2 class="text-lg font-medium">Balance</h2>
        <p class="text-3xl font-bold mt-2">¥{{ totalIncomeAmount - totalExpenseAmount }}</p>
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
    totalExpenseAmount() {
      return this.transactions.filter(tx => tx.deleted !== 1 && tx.type === 'expense').reduce((sum, tx) => sum + Number(tx.amount || 0), 0);
    },
    totalIncomeAmount() {
      return this.transactions.filter(tx => tx.deleted !== 1 && tx.type === 'income').reduce((sum, tx) => sum + Number(tx.amount || 0), 0);
    },
  },
};
</script>
