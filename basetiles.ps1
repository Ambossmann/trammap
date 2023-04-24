osmosis --rb ./oberbayern-latest.osm.pbf --bb left=11.32 bottom=47.97 right=11.86 top=48.29 clipIncompleteEntities=true --wb ./basetiles.pbf
tilemaker --input ./basetiles.pbf --output ./basetiles.mbtiles --config ./tilemakerconfig.json --process ./tilemakerprocess.lua
Remove-Item ./public/basetiles -Recurse -ErrorAction Ignore
python ./mbutil/mb-util ./basetiles.mbtiles ./public/basetiles --image_format=pbf