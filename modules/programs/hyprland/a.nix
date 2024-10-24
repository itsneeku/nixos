{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.hyprland.homeManagerModules.default ];

  home.file.".config/waybar/config".source = config.lib.file.mkOutOfStoreSymlink /home/neeku/.nixos/modules/home-manager/hyprland/waybar/config;

  home.file.".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink /home/neeku/.nixos/modules/home-manager/hyprland/waybar/style.css;

  # https://wiki.hyprland.org/Hypr-Ecosystem/xdg-desktop-portal-hyprland/#configuration
  home.file.".config/hypr/xdph.conf".text = ''
    screencopy {
      max_fps = 60
      allow_token_by_default = true
    }
  '';

  # home.file.".config/hypr/hyprland.conf".source =
  #   config.lib.file.mkOutOfStoreSymlink
  # "${config.home.homeDirectory}/.nixos/modules/home/hyprland/hyprland.conf";

  wayland.windowManager.hyprland = {
    enable = true;
    # package =
    #   inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # plugins = [
    #   # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.borders-plus-plus
    #   # pkgs.hyprlandPlugins.borders-plus-plus
    # ];
    settings.source = "${config.home.homeDirectory}/.nixos/modules/home-manager/hyprland/hyprland.conf";
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_systemd_inhibit = false;
        ignore_dbus_inhibit = false;
      };

      listener = [
        # Decrease brightness after 2 minutes
        # Lock after 5
        {
          timeout = 180;
          on-timeout = "loginctl lock-session";
        }
        # {
        #   timeout = 300;
        #   on-timeout = "loginctl lock-session";
        # }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      background = {
        monitor = "";
      };

      input-field = {
        monitor = "";
        size = "4096, 500";
        outline_thickness = 1;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0)";
        font_color = "rgba(255, 255, 255, 1)";
        fade_on_empty = true;
        fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
        placeholder_text = ""; # Text rendered in the input box when it's empty.
        hide_input = false;

        check_color = "rgba(0, 0, 0, 0)";
        fail_color = "rgba(255, 0, 0, 0)"; # if authentication failed, changes outer_color and fail message color
        fail_text = ""; # can be set to empty
        fail_transition = 300; # transition time in ms between normal outer_color and fail_color

        position = "0, 0";
        halign = "center";
        valign = "center";
      };
    };
  };

}
