import "./style.css";
import { createApp, watch } from "vue";
import "./style.css";
import App from "./App.vue";
import { createPinia } from "pinia";

const app = createApp(App);

const pinia = createPinia();

const settingsJson = localStorage.getItem("trammap.settings");
if (settingsJson) {
  pinia.state.value.settings = JSON.parse(settingsJson);
}

watch(
  () => pinia.state.value.settings,
  (state) => {
    localStorage.setItem("trammap.settings", JSON.stringify(state));
  },
  { deep: true },
);

app.use(pinia);

app.mount("#app");
