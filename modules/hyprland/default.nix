{ inputs, pkgs, ... }:
let
  hyprlandPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.hyprland.nixosModules.default ];

  programs.hyprland = {
    enable = true;
    package = hyprlandPkgs.hyprland;
    portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
  };

  hm =
    { config, ... }:
    {
      imports = [ inputs.hyprland.homeManagerModules.default ];
      wayland.windowManager.hyprland = {
        enable = true;
        settings.source = "${config.home.homeDirectory}/.nixos/modules/hyprland/hyprland.conf";
      };

      # xdg.configFile."hypr/hyprland.conf".source =
      #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/modules/programs/hypr/hyprland.conf";

      # xdg.configFile."hypr" = {
      #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/modules/programs/hypr/";
      # };

      # home.file.".config/hypr/hyprland.conf".source =
      #   config.lib.file.mkOutOfStoreSymlink /home/neeku/.nixos/modules/programs/hyprland/hyprland.conf;

      # home.file.".config/hypr/hyprland.conf".source =
      #   config.lib.file.mkOutOfStoreSymlink ./. + "/hyprland/hyprland.conf";

      # home.file.".config/hypr/xdph.conf".text = ''
      #   screencopy {
      #     max_fps = 60
      #     allow_token_by_default = true
      #   }
      # '';

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
