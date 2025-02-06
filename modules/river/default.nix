{ inputs, pkgs, ... }:
let
  mkAttrset =
    keys: value:
    builtins.listToAttrs (
      map (key: {
        name = key;
        value = value;
      }) keys
    );
in
{
  programs.river.enable = true;
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = false;

  environment.sessionVariables =
    {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "river";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    }
    // mkAttrset [
      "GDK_BACKEND"
      "SDL_VIDEODRIVER"
      "CLUTTER_BACKEND"
      "QT_QPA_PLATFORM"
      "ELECTRON_OZONE_PLATFORM_HINT"
      "XDG_SESSION_TYPE"
    ] "wayland";
  hm =
    { config, ... }:
    {

      wayland.windowManager.river = {
        enable = true;
        xwayland.enable = true;
        settings = {
          default-layout = "rivertile";
          output-layout = "rivertile";
          focus-follows-cursor = "always";

          # input = {
          #   pointer-foo-bar = {
          #     accel-profile = "flat";
          #     events = true;
          #     pointer-accel = -0.3;
          #     tap = false;
          #   };

          input = {
            "*Touchpad" = {
              tap = true;
            };
          };

          map = {
            normal = {
              "Super Q" = "close";
              "Super Return" = "spawn kitty";
              "Super R" = "spawn \"rofi -show drun\"";
              "Super V" = "toggle-float";
              "Super F" = "toggle-fullscreen";

              # Switch workspaces
              "Super 1" = "set-focused-tags 1";
              "Super 2" = "set-focused-tags 2";
              "Super 3" = "set-focused-tags 4";
              "Super 4" = "set-focused-tags 8";
              "Super 5" = "set-focused-tags 16";

              # Send window to workspace
              "Super+Shift 1" = "set-view-tags 1";
              "Super+Shift 2" = "set-view-tags 2";
              "Super+Shift 3" = "set-view-tags 4";
              "Super+Shift 4" = "set-view-tags 8";
              "Super+Shift 5" = "set-view-tags 16";
            };
          };
          map-pointer = {
            normal = {
              "Super BTN_LEFT" = "move-view";
              "Super BTN_RIGHT" = "resize-view";
              "Super+Control BTN_LEFT" = "resize-view";
            };
          };

          set-repeat = "50 300";
          spawn = [
            "zen"
            "rivertile"
            "waybar"
            "waypaper --restore"
            # "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            # "systemctl --user start xdg-desktop-portal-hyprland"
            # "systemctl --user start xdg-desktop-portal-wlr"
            # "systemctl --user start xdg-desktop-portal"
          ];
          xcursor-theme = "Bibata-Modern-Classic 12";
        };
      };
    };
}
