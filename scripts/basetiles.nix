{
  lib,
  flakeConfig,
  pkgs,
}:
pkgs.writeShellApplication {
  name = "basetiles";

  runtimeInputs = with pkgs; [
    wget
    osmium-tool
    osmctools
    tilemaker
    mbutil
  ];

  text = ''
    root="$(${lib.getExe flakeConfig.flake-root.package})";
    if [ -d "$root" ]; then
      echo "Running in $root"
      cd "$root"

      mkdir -p tmp

      cd tmp

      [ -f "./bayern-latest.osm.pbf" ] || wget https://download.geofabrik.de/europe/germany/bayern-latest.osm.pbf -O "./bayern-latest.osm.pbf"

      unshare -m --map-root-user bash -c '
        set -e;
        mkdir -p ./tmpfs;
        mount -t tmpfs none ./tmpfs;
        cd tmpfs
        osmium extract -b 10.79,47.84,12.32,48.43 --set-bounds "../bayern-latest.osm.pbf" -o "./basetiles-cropped.osm" --overwrite -v;
        osmfilter -v "./basetiles-cropped.osm" --drop-ways="railway=tram" --drop-ways="razed:railway=tram" --drop-ways="abandoned:railway=tram" --drop-ways="disused:railway=tram" -o="./basetiles-reduced.o5m";
        osmium cat "./basetiles-reduced.o5m" -o "./basetiles.pbf" --overwrite -v;
        tilemaker --input "./basetiles.pbf" --output "./basetiles.mbtiles" --config "../../tilemakerconfig.json" --process "../../tilemakerprocess.lua";
        rm -rf "../../public/basetiles";
        mb-util "./basetiles.mbtiles" "../../public/basetiles" --image_format=pbf;
      '
    fi
  '';
}
