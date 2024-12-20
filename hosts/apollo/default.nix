{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  modules = {
    system = [
      "bluetooth"
      "catppuccin"
      "dualboot"
      "fonts"
      "i2c"
      "mount"
      "network"
      "nix-ld"
      "sddm"
      "sound"
      "system"
      "fw-fanctrl"
    ];

    programs = [
      "hyprland"
      "hypridle"
      "hyprlock"
      "nh"
      "git"
      "swaync"
      "waybar"
      "kitty"
      "rofi/default"
      "gtk"
      "nushell"
      "packages"
      "vscode"
      "zathura"

    ];
  };

  mapModulesByType =
    modules:
    lib.flatten (
      lib.mapAttrsToList (
        type: modulesList: map (module: ../../modules + "/${type}/${module}.nix") modulesList
      ) modules
    );
in
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    inputs.home-manager.nixosModules.home-manager
    inputs.fw-fanctrl.nixosModules.default
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ./hardware-configuration.nix
    ./home.nix
  ] ++ mapModulesByType modules;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services = {
    fwupd.enable = true;
    fwupd.extraRemotes = [ "lvfs-testing" ];
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

  system.stateVersion = "24.05";
}
