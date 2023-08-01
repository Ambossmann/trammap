<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useSettingsStore } from "../stores/settings";
import { Map, View } from "ol";
import * as olProj from "ol/proj";
import * as olTileGrid from "ol/tilegrid";
import VectorTileLayer from "ol/layer/VectorTile";
import VectorTileSource from "ol/source/VectorTile";
import MVT from "ol/format/MVT";
import { applyStyle } from "ol-mapbox-style";

const settingsStore = useSettingsStore();

const baseLayer = new VectorTileLayer({
  declutter: true,
  source: new VectorTileSource({
    attributions:
      '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap contributors</a>' +
      ' © <a href="https://openmaptiles.org/">OpenMapTiles</a>',
    format: new MVT(),
    tileGrid: olTileGrid.createXYZ({ tileSize: 512, maxZoom: 14 }),
    url: "/trammap/basetiles/{z}/{x}/{y}.pbf",
  }),
  renderMode: "hybrid",
});

const map = new Map({
  layers: [baseLayer],
  view: new View({
    center: olProj.fromLonLat([11.57537, 48.13712]),
    extent: olProj
      .fromLonLat([10.79, 47.84])
      .concat(olProj.fromLonLat([12.32, 48.43])),
    zoom: 12,
    maxZoom: 24,
  }),
});

onMounted(() => {
  applyStyle(
    baseLayer,
    `/trammap/mapstyles/${settingsStore.basemapStyle}-gl-style/style.json`,
    { updateSource: false },
  );

  settingsStore.$subscribe((_mutation, state) => {
    applyStyle(
      baseLayer,
      `/trammap/mapstyles/${state.basemapStyle}-gl-style/style.json`,
      { updateSource: false },
    );
  });

  map.setTarget("map");
});
</script>

<template>
  <div id="map" style="height: 100%"></div>
</template>
