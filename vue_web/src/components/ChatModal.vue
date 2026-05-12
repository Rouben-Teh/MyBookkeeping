<template>
  <div class="fixed bottom-4 right-4 z-50">
    <button
      @click="toggleChat"
      class="bg-red-500 hover:bg-red-400 text-white rounded-full p-3 shadow-lg transition-colors"
    >
      <Bot class="w-10 h-10" />
    </button>

    <div
      v-if="showModal"
      class="absolute bottom-20 right-0 bg-white rounded-lg shadow-xl w-80 h-96 flex flex-col"
    >
      <div class="flex justify-between items-center p-3 bg-red-500 rounded-t-lg">
        <h3 class="text-sm font-semibold text-white">AI Assistant</h3>
        <button @click="showModal = false" class="text-white hover:text-gray-300">
          <X class="w-4 h-4" />
        </button>
      </div>

      <div class="flex-1 overflow-y-auto overflow-x-hidden p-4 space-y-3 mb-1" ref="chatContainer">
        <div
          v-for="message in messages"
          :key="message.id"
          :class="[
            'flex',
            message.role === 'user' ? 'justify-end' : 'justify-start'
          ]"
        >
          <div
            :class="[
              'max-w-xs px-3 py-2 rounded-lg text-sm',
              message.role === 'user'
                ? 'bg-red-600 text-white'
                : 'bg-red-200 text-gray-800'
            ]"
          >
            {{ message.content }}
          </div>
        </div>
        <div v-if="isLoading" class="flex justify-start">
          <div class="bg-red-200 text-gray-800 px-3 py-2 rounded-lg text-sm">
            thinking...
          </div>
        </div>
      </div>

      <div class="p-3 border-t border-red-500">
        <div class="flex gap-2">
          <input
            v-model="inputMessage"
            @keyup.enter="sendMessage"
            placeholder="key in your message..."
            class="flex-1 border border-red-500 rounded-full px-2 py-1 text-sm focus:outline-none focus:ring-1 focus:ring-red-400"
          />
          <button
            @click="sendMessage"
            :disabled="!inputMessage.trim() || isLoading"
            class="bg-red-600 hover:bg-red-700 disabled:bg-red-300 text-white px-3 py-1 rounded-full text-sm"
          >
            Send
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import dayjs from 'dayjs';
import { Bot, X } from 'lucide-vue-next';
import { httpPost } from '../utils/NetUtils';

export default {
  components: { Bot, X },
  emits: ["fetchTransaction"],
  data() {
    return {
      restoreHis: false,
      showModal: false,
      messages: [],
      inputMessage: '',
      isLoading: false,
      id: "11111111" + dayjs().valueOf(),
      title: "bookkeeping" + dayjs().format('YYYY-MM-DD HH:mm:ss')
    };
  },
  async mounted() {
    if(this.restoreHis) return;
    await this.restoreChatHistory();
    this.restoreHis = true;
  },
  watch: {
    showModal(newVal) {
      if (newVal) {
        this.$nextTick(() => {
          this.scrollToBottom();
        });
      }
    },
    messages: {
      handler() {
        this.$nextTick(() => {
          this.scrollToBottom();
        });
      },
      deep: true
    },
  },
  methods: {
    toggleChat() {
      this.showModal = !this.showModal;
    },
    async sendMessage() {
      if (!this.inputMessage.trim() || this.isLoading) return;

      const userMessage = {
        id: Date.now(),
        role: 'user',
        content: this.inputMessage.trim(),
      };

      this.messages.push(userMessage);
      this.inputMessage = '';
      this.isLoading = true;

      try {
        const response = await this.callLLMAPI(userMessage.content);
        const assistantMessage = {
          id: Date.now() + 1,
          role: 'assistant',
          content: response,
        };
        this.messages.push(assistantMessage);
      } catch (error) {
        console.error('LLM API error:', error);
        const errorMessage = {
          id: Date.now() + 1,
          role: 'assistant',
          content: 'sorry, something went wrong.',
        };
        this.messages.push(errorMessage);
      } finally {
        this.isLoading = false;
      }
    },
    async callLLMAPI(message) {
      const res = await httpPost("chat", {
        message: message,
      });

      const data = res.data;
      if (!data.ok) {
        throw new Error('API request failed');
      }

      const json = JSON.parse(data.response);

      if(json.type == "tool"){
        if(json.tool.name == "add_expense" || json.tool.name == "add_income"){
          this.$emit("fetchTransaction");
        }
      }

      return json.content;
    },
    async restoreChatHistory() {
      const histories = await this.getLLMHistory();

      console.log(histories);
      //use in get index, of get data
      for (const his of histories) {
        // console.log(his);
        if (his.role == 'human') {
          // console.log('human');
          const userMessage = {
            id: his.id,
            role: 'user',
            content: his.content,
          };

          this.messages.push(userMessage);
        } else {
          // console.log('ai');
          // console.log(his.content);
          const parseRes = JSON.parse(his.content);
          const assistantMessage = {
            id: his.id,
            role: 'assistant',
            content: parseRes.content,
          };
          this.messages.push(assistantMessage);
        }
      }
    },
    async getLLMHistory() {
      const res = await httpPost("get_chat_history", {});

      const data = res.data;
      if (!data.ok) {
        throw new Error('API request failed');
      }

      if (data.response.chat_history != null) {
        return data.response.chat_history;
      }
    },
    scrollToBottom() {
      if (this.$refs.chatContainer) {
        this.$refs.chatContainer.scrollTop = this.$refs.chatContainer.scrollHeight;
      }
    },
  },
};
</script>