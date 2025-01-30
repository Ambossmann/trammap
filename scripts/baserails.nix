{
  lib,
  flakeConfig,
  pkgs,
}:
pkgs.writeShellApplication {
  name = "baserails";

  runtimeInputs = with pkgs; [
    wget
  ];

  text = ''
    root="$(${lib.getExe flakeConfig.flake-root.package})";
    if [ -d "$root" ]; then
      echo "Running in $root"
      cd "$root"

      wget "https://overpass-api.openhistoricalmap.org/api/interpreter?data=%5Bout%3Axml%5D%3B%0Away%5B%22railway%22~%22%5Etram%24%22%5D(48.0241%2C11.3365%2C48.2270%2C11.8755)%3B%0A(._%3B%3E%3B)%3B%0Aout%20meta%3B" -O ./data/baserails.osm

    fi
  '';
}
