{
  inputs,
  pkgs,
  user,
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

  home-manager.users.${user} = {config, ...}:{
    imports = [
      inputs.hyprland.homeManagerModules.default
    ];
    wayland.windowManager.hyprland = {
      # enable = true;
      # settings.source = config.lib.file.mkOutOfStoreSymlink /home/neeku/.nixos/modules/programs/hyprland/hyprland.conf;

      # settings.source = toString ./hyprland/hyprland.conf;
    };

    home.file.".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink /home/neeku/.nixos/modules/programs/hyprland/hyprland.conf;

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
