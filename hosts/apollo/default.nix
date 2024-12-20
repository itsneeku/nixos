{
  pkgs,
  inputs,
  lib,
  user,
  self,
  ...
}:
let
  modules = [
    # Hardware / System
    "bluetooth"
    "dualboot"
    "fw-fanctrl"
    "i2c"
    "mount"
    "network"
    "sound"
    "system"
    "touchpad"
    "hyprland"
    "swaync"
    "kitty"
    "nh"
    "nushell"
    "zathura"
    "packages"
    "rofi"

    # Rice
    "gtk"
    "waybar"
    "fonts"

    # Programs
    "sddm"
    "dev"
  ];

  getModulePath =
    module:
    let
      basePath = ../../modules;
    in
    "${basePath}/${module}"
    + lib.optionalString (lib.pathIsRegularFile "${basePath}/${module}.nix") ".nix";

in
# mapModulesByType =
#   modules:
#   lib.flatten (
#     lib.mapAttrsToList (
#       type: modulesList: map (module: ../../modules + "/${type}/${module}.nix") modulesList
#     ) modules
#   );
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    inputs.home-manager.nixosModules.home-manager
    inputs.fw-fanctrl.nixosModules.default
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ./hardware-configuration.nix
    ./home.nix
  ] ++ (lib.map getModulePath modules);

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services = {
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;
    printing.enable = true;
    power-profiles-daemon.enable = true;

    logind.powerKey = "suspend";
    fprintd.enable = false;
    # upower.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mtpfs # Android MTP support
    polkit_gnome
    amf # AMD AMF encoder
  ];

  hardware.sensor.iio.enable = true; # Allow DEs to manage display brightness
  security.polkit.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.loader.grub.catppuccin.enable = true;
  console.catppuccin.enable = true;

  system.stateVersion = "24.05";
}
