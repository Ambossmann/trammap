import vue from "@vitejs/plugin-vue";
import { defineConfig } from "vite";
import autoprefixer from "autoprefixer";

export default defineConfig({
  plugins: [vue()],
  build: {
    sourcemap: false,
  },
  base: "/trammap/",
  css: {
    postcss: {
      plugins: [autoprefixer],
    },
  },
});
