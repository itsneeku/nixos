{ lib, ... }:
let
  scanPaths = path:
    builtins.map (f: (path + "/${f}")) (builtins.attrNames
      (lib.attrsets.filterAttrs (path: _type:
        (_type == "directory") # include directories
        || ((path != "default.nix") # ignore default.nix
          && (lib.strings.hasSuffix ".nix" path) # include .nix files
        )) (builtins.readDir path)));
in {
  imports = scanPaths ./.;
}

# { config, pkgs, ... }:
# {
#   imports = [
#     ./programs
#     ./hyprland
#   ];
#   # ".emacs.d/init.el".source = config.lib.file.mkOutOfStoreSymlink ./init.el;
#   #    source = config.lib.file.mkOutOfStoreSymlink ./.config;

#   home.file.".config/" = {
#     source = ./.config;
#     recursive = true;
#   };

#   home = {
#     sessionVariables = {
#       NIXOS_OZONE_WL = "1";
#       EDITOR = "code";
#     };

#     

#     packages = [
#       pkgs.waypaper
#       pkgs.swaybg
#       pkgs.nix-output-monitor
#     ];
#   };
#   gtk.enable = true;
# }
