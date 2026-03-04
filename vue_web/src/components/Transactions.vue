<template>
  <ul>
    <li v-for="t in items" :key="t.id">
      ¥{{ t.amount }} — {{ t.note }} <small>{{ t.created_at }}</small>
    </li>
  </ul>
</template>
<script>
export default { props: ["items"] };
</script>
