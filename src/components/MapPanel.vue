<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useSettingsStore } from "../stores/settings";
import { Feature, Map, View } from "ol";
import * as olProj from "ol/proj";
import * as olTileGrid from "ol/tilegrid";
import VectorImageTileLayer from "ol/layer/VectorTile";
import VectorTileSource from "ol/source/VectorTile";
import MVT from "ol/format/MVT";
import { applyStyle } from "ol-mapbox-style";
import { Attribution, defaults as defaultControls } from "ol/control";
import VectorSource from "ol/source/Vector";
import VectorImageLayer from "ol/layer/Vector";
import OSMXML from "ol/format/OSMXML";
import { Style, Stroke } from "ol/style";
import { StyleFunction } from "ol/style/Style";
import tramxmlurl from "../../data/data_min.osm?url";

const settingsStore = useSettingsStore();

const activeStyle = new Style({
  stroke: new Stroke({
    color: "#f21602",
    width: 2,
  }),
});

const stylefunction = function (feature: Feature) {
  if (feature.get("railway") == "tram") {
    return activeStyle;
  } else {
    return activeStyle;
  }
} as StyleFunction;

const attribution = new Attribution({
  collapsible: false,
});

const baseLayer = new VectorImageTileLayer({
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
  controls: defaultControls({ attribution: false }).extend([attribution]),
});

async function applyBaseLayerStyle() {
  await applyStyle(
    baseLayer,
    `/trammap/mapstyles/${settingsStore.basemapStyle}-gl-style/style.json`,
    { updateSource: false },
  );
}

onMounted(() => {
  applyBaseLayerStyle();

  settingsStore.$subscribe(() => {
    applyBaseLayerStyle();
  });

  map.setTarget("map");
});

async function createTramLayer() {
  // const response = await fetch(tramjsonurl);
  // const tramjson = await response.json();

  const tramlayer = new VectorImageLayer({
    source: new VectorSource({
      format: new OSMXML(),
      url: tramxmlurl,
    }),
    style: stylefunction,
  });

  map.addLayer(tramlayer);
}

createTramLayer();
</script>

<template>
  <div id="map" style="height: 100%"></div>
</template>
