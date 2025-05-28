{ inputs, pkgs, ... }:
let
  hyprlandPkgs = inputs.hyprland.packages.${pkgs.system};
in
{
  imports = [ ./hyprland.nix ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = hyprlandPkgs.hyprland;
    portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
  };

  hm =
    { config, ... }:
    {
      imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];
      # programs.hyprpanel = {
      #   enable = true;
      #   systemd.enable = true;
      #   hyprland.enable = true;
      #   overwrite.enable = true;
      # };

      wayland.windowManager.hyprland = {
        enable = true;
        package = hyprlandPkgs.hyprland;
        # settings.source = "${config.home.homeDirectory}/.nixos/modules/hyprland/hyprland.conf";
        systemd.enable = false;
      };

      programs.hyprlock = {
        enable = true;
        settings.source = "${config.home.homeDirectory}/.nixos/modules/hyprland/hyprlock.conf";
      };

      services.hypridle = {
        enable = true;
        settings.source = "${config.home.homeDirectory}/.nixos/modules/hyprland/hypridle.conf";
      };

      xdg.configFile."hypr/xdph.conf".text = ''
        screencopy {
          max_fps = 60
          allow_token_by_default = true
        }
      '';
    };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };
}
