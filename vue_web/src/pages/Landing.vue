<template>
  <div class="min-h-screen bg-white text-black">
    <header class="mx-auto px-6 py-6 flex items-center justify-between bg-red-400 text-white sticky top-0 z-10">
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
            <h3 class="text-xl font-semibold">Weekly, Monthly & Yearly Reports</h3>
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
            <Calendar1 class="w-25 h-auto text-red-500" />
            <h3 class="text-xl font-semibold">Scheduled Tasks<br>*App feature</h3>
          </div>

        </div>
        
      </section>

      <section id="contact" class="p-8 rounded-xl backdrop-blur bg-white/10">
        <div class="flex flex-col h-full">
          <h2 class="text-3xl font-bold mb-4">Contact</h2>
          
          <div class="flex flex-1 gap-4 flex-col md:flex-row">
            <div class="w-full md:w-1/2 h-full md:h-1/2 flex items-center justify-center">
              <img src="@/assets/images/contact.png" alt="Contact" class="h-full object-contain" />
            </div>

            <div class="w-full md:w-1/2 h-full flex flex-col px-4 md:px-8">
            
              <form v-if="!isSentContact" class="flex flex-col h-full">
                <input v-model="inputName" type="text" placeholder="Your name" class="mb-3 px-4 py-3 border rounded-lg bg-white/80" />
                <input v-model="inputEmail" type="email" placeholder="Your email" class="mb-3 px-4 py-3 border rounded-lg bg-white/80" />
                <textarea v-model="inputMessage" placeholder="Your message" class="h-70 mb-3 p-4 border rounded-lg bg-white/80 resize-none"></textarea>
                <div class="flex justify-end">
                  <button @click="submit" :disabled="isSending" type="button" class="px-6 py-3 bg-red-500 hover:bg-red-600 text-white rounded-full cursor-pointer disabled:bg-red-300">Send</button>
                </div>
              </form>
              
              <div v-else class="flex flex-col h-90 items-center justify-center">
                <CircleCheck class="w-25 h-25 text-green-500"/>
                <p class="mt-6">You have sent the message.</p>
              </div>
              
            </div>
          </div>
        </div>
      </section>
    </main>

    <footer class="bg-red-400 py-4 text-center text-sm text-white">© 2026 MyBookkeeping</footer>
  </div>
</template>

<script setup>
import { CloudSync, FunnelPlus, Clipboard, ShieldAlert, Bot, Layers2, Calendar1, CircleCheck } from 'lucide-vue-next';
</script>

<script>
import { httpPost } from '../utils/NetUtils';

export default {
  name: 'Landing',
  data() {
    return{
      isSending: false,
      isSentContact: false,
      inputName: '',
      inputEmail: '',
      inputMessage: '',
    }
  },
  methods: {
    async submit(){
      try {
        if(!this.inputName?.trim() || !this.inputEmail?.trim() || !this.inputMessage?.trim()) {
          alert('Please fill in all fields.')
          return;
        }

        this.isSending = true;

        const res = await httpPost('contact', {
          device_type: "WEB",
          name: this.inputName,
          email: this.inputEmail,
          message: this.inputMessage
        });
        const data = res.data;

        if(data.ok){
          this.isSending = false;
          this.isSentContact = true;
        }
        
      } catch (error) {
        console.error(error);
      }
    }
  }
};
</script>
