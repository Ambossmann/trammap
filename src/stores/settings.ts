import { defineStore } from "pinia";
import { ref } from "vue";

export enum BasemapStyle {
  Positron = "positron",
  OsmBright = "osm-bright",
}

export const useSettingsStore = defineStore("settings", () => {
  const basemapStyle = ref(BasemapStyle.Positron);

  return { basemapStyle };
});
