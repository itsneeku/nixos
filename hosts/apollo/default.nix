{
  pkgs,
  inputs,
  lib,
  config,
  user,
  ...
}:
let
  modules = [
    "power-laptop"
    "bluetooth"
    "dualboot"
    "mount"
    "network"
    "sound"
    "system"
    "touchpad"
    "i2c"

    "gtk"
    "waybar"
    "sddm"

    "hyprland"
    # "river"
    # "gnome"
    "rofi"
    "fonts"
    "swaync"
    "ags"

    "dev"
    "nushell"
    "kitty"

    "packages"
    "fw-fanctrl"
    "zathura"
  ];

  getModulePath =
    module:
    let
      basePath = ../../modules;
    in
    "${basePath}/${module}"
    + lib.optionalString (lib.pathIsRegularFile "${basePath}/${module}.nix") ".nix";
in
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    inputs.home-manager.nixosModules.home-manager
    inputs.fw-fanctrl.nixosModules.default
    ./hardware-configuration.nix
    ./home.nix
  ] ++ (lib.map getModulePath modules);

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services = {
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;

    # Printing
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    logind.powerKey = "suspend";
    fprintd.enable = false;
  };

  environment.systemPackages = with pkgs; [
    mtpfs # Android MTP support
    polkit_gnome
    amf # AMD AMF encoder
  ];

  security.polkit.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.loader.grub.memtest86.enable = true;

  # Enables the zenpower sensor in lieu of the k10temp sensor on Zen CPUs https://git.exozy.me/a/zenpower3
  # On Zen CPUs zenpower produces much more data entries
  boot.blacklistedKernelModules = [ "k10temp" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];
  boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ];
  boot.kernelModules = [ "zenpower" ];

  system.stateVersion = "24.05";
}
