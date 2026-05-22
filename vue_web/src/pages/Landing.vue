<template>
  <div class="min-h-screen bg-white text-black">
    <header class="container mx-auto px-6 py-6 flex items-center justify-between bg-red-400 text-white sticky top-0 z-10">
      <h1 class="text-3xl font-bold">MyBookkeeping</h1>
      <nav class="space-x-4">
        <router-link class="hover:underline" :to="{ path: '/', hash: '#home' }">Home</router-link>
        <router-link class="hover:underline" :to="{ path: '/', hash: '#about' }">About</router-link>
        <router-link class="hover:underline" :to="{ path: '/', hash: '#features' }">Features</router-link>
        <router-link class="hover:underline" :to="{ path: '/', hash: '#contact' }">Contact</router-link>
        <router-link to="/login" class="inline-block px-4 py-2 bg-red-500 hover:bg-red-600 rounded-full font-Regular text-white">
          Get Started
        </router-link>
      </nav>
    </header>

    <main class="container mx-auto">
      <section 
        id="home" 
        class="flex flex-col md:flex-row items-center md:h-150 h-screen justify-center"
      >
        <div class="w-full h-full md:w-1/2 flex flex-col justify-center px-6 md:px-10 text-center md:text-left">
          <h2 class="text-3xl md:text-4xl font-bold mb-4">
            Welcome to MyBookkeeping
          </h2>
          <p class="text-base md:text-lg text-slate-600">
            Easily manage your expenses/income, analyze monthly budgets, and get visual summaries.
          </p>
          <div class="space-x-3">
            <router-link to="/login" class="inline-block my-5 px-6 py-3 bg-red-500 hover:bg-red-400 rounded-full font-semibold text-white">
              Get Started
            </router-link>
          </div>
        </div>

        <div class="w-full h-full md:w-1/2 flex justify-center items-center mt-6 md:mt-0">
          <img 
            src="@/assets/images/landing-illustration.png" 
            alt="Illustration" 
            class=" w-350 h-auto object-contain"
          />
        </div>
      </section>

      <section id="about" class="bg-white/50 rounded-xl m-10 p-10  shadow-lg backdrop-blur justify-center items-center flex flex-col md:flex-row "> 
        <div class="w-full h-full md:w-1/2 flex justify-center items-center mt-6 md:mt-0">
          <img 
            src="@/assets/images/platform.png" 
            alt="Illustration" 
            class=" w-200 h-auto object-contain"
          />
        </div>

        <div class="w-full h-full md:w-1/2 flex flex-col justify-center px-6 md:px-10 text-center md:text-left">
          <h2 class="text-3xl font-bold mb-4">About Us</h2>
          <p class="text-lg">We provide simple, fast, and secure personal bookkeeping and analysis features, supporting mobile and desktop access.</p>
        </div>
      </section>

      <section id="features" class=" p-8 flex items-center justify-center flex-col">
        <h2 class="text-3xl font-bold mb-4">Key Features</h2>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 p-6">
          <div class="flex w-full h-80 items-center gap-4 mb-4 shadow-lg backdrop-blur bg-white/50 rounded-xl p-8">
            <CloudSync class="w-25 h-auto text-red-500" />
            <h3 class="text-xl font-semibold">24/7 Cloud Synchronization</h3>
          </div>

          <div class="flex w-full h-80 items-center justify-center gap-4 mb-4 shadow-lg backdrop-blur bg-white/50 rounded-xl p-8">
            <FunnelPlus class="w-25 h-auto text-red-500" />
            <h3 class="text-xl font-semibold">Category Management and Tag Filtering</h3>
          </div>

          <div class="flex w-full h-80 items-center gap-4 mb-4 shadow-lg backdrop-blur bg-white/50 rounded-xl p-8">
            <Clipboard class="w-25 h-auto text-red-500" />
            <h3 class="text-xl font-semibold">Monthly Reports, Charts, and Trend Analysis</h3>
          </div>

          <div class="flex w-full h-80 items-center gap-4 mb-4 shadow-lg backdrop-blur bg-white/50 rounded-xl p-8">
            <ShieldAlert class="w-25 h-auto text-red-500" />
            <h3 class="text-xl font-semibold">Secure Login and Session Protection</h3>
          </div>

          <div class="flex w-full h-80 items-center gap-4 mb-4 shadow-lg backdrop-blur bg-white/50 rounded-xl p-8">
            <Bot class="w-25 h-auto text-red-500" />
            <h3 class="text-xl font-semibold">AI-Powered Insights<br>*upcoming</h3>
          </div>

          <div class="flex w-full h-80 items-center gap-4 mb-4 shadow-lg backdrop-blur bg-white/50 rounded-xl p-8">
            <Layers2 class="w-25 h-auto text-red-500" />
            <h3 class="text-xl font-semibold">Fast Category Management</h3>
          </div>

        </div>
        
      </section>

      <section id="contact" class="bg-white/10 rounded-xl p-8 shadow-lg backdrop-blur">
        <h2 class="text-3xl font-bold mb-4">Contact</h2>
        <p class="text-lg mb-4">If you have any questions or suggestions, please feel free to contact us.
          <br>
          Email: rouben0216@gmail.com
        </p>
        
      </section>
    </main>

    <footer class="bg-red-400 py-4 text-center text-sm text-white">© 2026 MyBookkeeping</footer>
  </div>
</template>

<script setup>
import { CloudSync, FunnelPlus, Clipboard, ShieldAlert, Bot, Layers2 } from 'lucide-vue-next';
</script>

<script>
export default {
  name: 'Landing',
};
</script>
