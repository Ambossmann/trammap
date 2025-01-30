{
  lib,
  flakeConfig,
  pkgs,
}:
pkgs.writeShellApplication {
  name = "data_minify";

  runtimeInputs = with pkgs; [
    osmctools
  ];

  text = ''
    root="$(${lib.getExe flakeConfig.flake-root.package})";
    if [ -d "$root" ]; then
      echo "Running in $root"
      cd "$root"

      osmfilter -v ./data/data.osm -o=./data/data_min.osm --drop-version --drop-tags="source:de source"

    fi
  '';
}
