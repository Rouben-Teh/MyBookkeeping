import { defineStore } from "pinia";
import { httpPost } from "../utils/NetUtils";

export const useSettingsStore = defineStore("settings", {
  state: () => ({
    settings: {
      theme_color: 0,
      currency: "$",
    },
    loading: false,
  }),

  getters: {
    getSettings: (state) => state.settings,
    getThemeColor: (state) => state.settings.theme_color,
    getCurrency: (state) => state.settings.currency,
  },

  actions: {
    // 获取设置
    async fetchSettings() {
      try {
        this.loading = true;
        const res = await httpPost("list-settings", {});
        const data = res.data;
        if (data.settings && data.settings[0]) {
          this.settings = JSON.parse(data.settings[0].metadata);
        }
      } catch (error) {
        console.error("fetchSettings error:", error);
      } finally {
        this.loading = false;
      }
    },

    // 更新主题颜色
    async updateThemeColor(themeColor) {
      this.settings.theme_color = themeColor;
      await this.saveSettings();
    },

    // 更新货币
    async updateCurrency(currency) {
      this.settings.currency = currency;
      await this.saveSettings();
    },

    // 保存设置
    async saveSettings() {
      try {
        const res = await httpPost("settings", {
          metadata: JSON.stringify(this.settings),
        });
        const data = res.data;
        if (!data.ok) {
          console.error("Failed to save settings");
        }
      } catch (error) {
        console.error("saveSettings error:", error);
      }
    },

    // 直接更新settings对象
    updateSettings(newSettings) {
      this.settings = { ...this.settings, ...newSettings };
    },
  },
});
