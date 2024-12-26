{ inputs, pkgs, ... }:
let
  hyprlandPkgs = inputs.hyprland.packages.${pkgs.system};
in
{
  programs.hyprland = {
    enable = true;
    package = hyprlandPkgs.hyprland;
    portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
  };

  hm =
    { config, ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        package = hyprlandPkgs.hyprland;
        settings.source = "${config.home.homeDirectory}/.nixos/modules/hyprland/hyprland.conf";
        systemd.variables = [ "--all" ];
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
