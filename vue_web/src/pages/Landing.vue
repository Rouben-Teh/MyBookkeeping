<template>
  <div class="min-h-screen bg-gradient-to-b from-sky-500 to-indigo-700 text-white">
    <header class="container mx-auto px-6 py-6 flex items-center justify-between">
      <h1 class="text-3xl font-bold">My Bookkeeping</h1>
      <nav class="space-x-4">
        <router-link class="hover:underline" to="#home">Home</router-link>
        <router-link class="hover:underline" to="#about">About</router-link>
        <router-link class="hover:underline" to="#features">Features</router-link>
        <router-link class="hover:underline" to="#getstarted">Get Started</router-link>
      </nav>
    </header>

    <main class="container mx-auto px-6 space-y-20 py-10">
      <section id="home" class="bg-white/10 rounded-xl p-8 shadow-lg backdrop-blur">
        <h2 class="text-4xl font-bold mb-4">欢迎来到记账工具</h2>
        <p class="text-lg">轻松管理你的支出/收入，分析月度预算并获得可视化总结。</p>
      </section>

      <section id="about" class="bg-white/10 rounded-xl p-8 shadow-lg backdrop-blur">
        <h2 class="text-3xl font-bold mb-4">关于我们</h2>
        <p class="text-lg">提供简单、快速、安全的个人记账与分析功能，支持移动与桌面访问。</p>
      </section>

      <section id="features" class="bg-white/10 rounded-xl p-8 shadow-lg backdrop-blur">
        <h2 class="text-3xl font-bold mb-4">功能亮点</h2>
        <ul class="list-disc list-inside space-y-2 text-lg">
          <li>全天候云端同步</li>
          <li>分类管理与标签过滤</li>
          <li>月度报表、图表与趋势分析</li>
          <li>安全登录与会话保护</li>
        </ul>
      </section>

      <section id="getstarted" class="bg-white/10 rounded-xl p-8 shadow-lg backdrop-blur">
        <h2 class="text-3xl font-bold mb-4">开始使用</h2>
        <p class="text-lg mb-4">点击下面按钮，注册新账号或登录进入管理页面。</p>
        <div class="space-x-3">
          <router-link to="/login" class="inline-block px-6 py-3 bg-indigo-600 hover:bg-indigo-500 rounded font-semibold">立即登录</router-link>
          <router-link to="/register" class="inline-block px-6 py-3 bg-green-600 hover:bg-green-500 rounded font-semibold">立即注册</router-link>
        </div>
      </section>
    </main>

    <footer class="bg-slate-900/30 py-4 text-center text-sm">© 2026 My Bookkeeping</footer>
  </div>
</template>

<script>
export default {
  name: 'Landing',
};
</script>
