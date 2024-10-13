{
  config,
  pkgs,
  ...
}: let
  nixosModules = ../../modules/nixos;
  modules = [
    "bluetooth"
    "dualboot"
    "fonts"
    "hyprland"
    "i2c"
    "network"
    "nh"
    "sddm"
    "sound"
    "system"
    "nix-ld"
  ];
in {
  imports =
    [
      ./hardware-configuration.nix
      ./home.nix
    ]
    ++ map (name: "${nixosModules}/${name}.nix") modules;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services = {
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;
    printing.enable = true;
    power-profiles-daemon.enable = true;
    fprintd.enable = true;
    logind.extraConfig = ''
      HandlePowerKey=suspend
    '';
  };

  environment.systemPackages = with pkgs; [
    mtpfs # Android MTP support
    polkit_gnome
  ];

  hardware.sensor.iio.enable = true; # Allow DEs to manage display brightness
  security.polkit.enable = true;

  system.stateVersion = "24.05";
}
