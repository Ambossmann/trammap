#!/usr/bin/env pwsh

mkdir tmp

Set-Location -Path (Split-Path -Parent $PSScriptRoot)

if (-Not (Test-Path -Path "./tmp/bayern-latest.osm.pbf" -PathType Leaf)) {
    wget https://download.geofabrik.de/europe/germany/bayern-latest.osm.pbf -O "./tmp/bayern-latest.osm.pbf"
}
osmosis --rb "./tmp/bayern-latest.osm.pbf" --bb left=10.79 bottom=47.84 right=12.32 top=48.43 clipIncompleteEntities=true --write-xml "./tmp/basetiles.osm"
osmfilter "./tmp/basetiles.osm" --drop-ways="railway=tram" --drop-ways="razed:railway=tram" --drop-ways="abandoned:railway=tram" --drop-ways="disused:railway=tram" -o="./tmp/basetiles-reduced.osm"
osmosis --rx "./tmp/basetiles-reduced.osm" --wb "./tmp/basetiles.pbf"
tilemaker --input "./tmp/basetiles.pbf" --output "./tmp/basetiles.mbtiles" --config "./tilemakerconfig.json" --process "./tilemakerprocess.lua"
Remove-Item "./public/basetiles" -Recurse -ErrorAction Ignore
python "./mbutil/mb-util" "./tmp/basetiles.mbtiles" "./public/basetiles" --image_format=pbf