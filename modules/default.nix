{ host, ... }:
let
  importsByHost = {
    apollo = [
      # Hardware / System
      ./bluetooth.nix
      ./dualboot.nix
      ./fw-fanctrl.nix
      ./i2c.nix
      ./mount.nix
      ./network.nix
      ./sound.nix
      ./system.nix
      ./touchpad.nix
      ./hyprland
      ./swaync.nix
      ./kitty
      ./nh.nix
      ./nushell
      ./zathura.nix
      ./packages.nix
      ./rofi

      # Rice
      ./gtk.nix
      ./waybar
      ./fonts.nix

      # Programs
      ./sddm.nix
      ./dev.nix
    ];

    sputnik = [ ];
  };

in
{
  imports = importsByHost.${host} or [ ];
}
