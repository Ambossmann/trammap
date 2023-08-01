import vue from "@vitejs/plugin-vue";

export default {
  plugins: [vue()],
  build: {
    sourcemap: true,
  },
  base: "/trammap/",
};