#!/usr/bin/env pwsh

Set-Location -Path (Split-Path -Parent $PSScriptRoot)

mkdir tmp

if (-Not (Test-Path -Path "./tmp/bayern-latest.osm.pbf" -PathType Leaf)) {
    wget https://download.geofabrik.de/europe/germany/bayern-latest.osm.pbf -O "./tmp/bayern-latest.osm.pbf"
}

osmium extract -b 10.79,47.84,12.32,48.43 --set-bounds "./tmp/bayern-latest.osm.pbf" -o "./tmp/basetiles.osm" --overwrite -v
osmfilter -v "./tmp/basetiles.osm" --drop-ways="railway=tram" --drop-ways="razed:railway=tram" --drop-ways="abandoned:railway=tram" --drop-ways="disused:railway=tram" -o="./tmp/basetiles-reduced.osm"
osmium cat "./tmp/basetiles-reduced.osm" -o "./tmp/basetiles.pbf" --overwrite -v
tilemaker --input "./tmp/basetiles.pbf" --output "./tmp/basetiles.mbtiles" --config "./tilemakerconfig.json" --process "./tilemakerprocess.lua"
Remove-Item "./public/basetiles" -Recurse -ErrorAction Ignore
python3 "./mbutil/mb-util" "./tmp/basetiles.mbtiles" "./public/basetiles" --image_format=pbf
