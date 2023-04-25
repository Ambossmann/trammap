import './style.css';
import {Map, View} from 'ol';
import * as olProj from 'ol/proj';
import * as olExtent from 'ol/extent';
import * as olTileGrid from 'ol/tilegrid';
import VectorTileLayer from 'ol/layer/VectorTile';
import VectorTileSource from 'ol/source/VectorTile';
import MVT from 'ol/format/MVT';
import {applyStyle} from 'ol-mapbox-style';

const baseLayer = new VectorTileLayer({
  declutter: true,
  source: new VectorTileSource({
    attributions: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap contributors</a>'
      + ' © <a href="https://openmaptiles.org/">OpenMapTiles</a>',
    format: new MVT(),
    tileGrid: olTileGrid.createXYZ({ tileSize: 512, maxZoom: 14 }),
    url: "/trammap/basetiles/{z}/{x}/{y}.pbf"
  }),
  renderMode: 'hybrid'
});

const map = new Map({
  target: 'map',
  layers: [
    baseLayer
  ],
  view: new View({
    center: olProj.fromLonLat([11.57537, 48.13712]),
    extent: olProj.fromLonLat([10.79, 47.84]).concat(olProj.fromLonLat([12.32, 48.43])),
    zoom: 13,
    maxZoom: 24
  })
});

//applyStyle(baseLayer, "/trammap/mapstyles/osm-bright-gl-style/style.json", {updateSource: false})
applyStyle(baseLayer, "/trammap/mapstyles/positron-gl-style/style.json", {updateSource: false})