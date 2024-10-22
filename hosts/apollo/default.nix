{
  config,
  pkgs,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ./home.nix
    ]
    ++ (map (name: ../../modules/system + "/${name}.nix") [
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
    ])
    ++ (map (name: ../../modules/programs + "/${name}.nix") [
      "hyprland"
      "hypridle"
      "hyprlock"
      "nh"
      "swaync"
      "waybar"
    ]);
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services = {
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;
    printing.enable = true;
    power-profiles-daemon.enable = true;

    logind.extraConfig = ''
      HandlePowerKey=suspend
    '';
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
