{
  inputs,
  pkgs,
  config,
  ...
}:
let
  hyprlandPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    package = hyprlandPkgs.hyprland;
    portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
  };

  home-manager.users.${config.user} = {
    imports = [
      inputs.hyprland.homeManagerModules.default
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      settings.source = toString ./hyprland/hyprland.conf;
    };

    home.file.".config/hypr/xdph.conf".text = ''
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
