{ lib, ... }:
let
  disableMonitor = monitor: "hyprctl keyword monitor desc:${monitor.description}, disable";
  enableMonitor = monitor: "hyprctl keyword monitor ${mkMonitorConfig monitor}";

  mkMonitorConfig =
    monitor: "desc:${monitor.description}, ${monitor.res}, ${monitor.pos}, ${monitor.scale}";

  monitors = {
    internal = {
      description = "BOE 0x0BCA";
      res = "preferred";
      pos = "900x1440";
      scale = "1.175";
    };

    desktop = {
      description = "ASUSTek COMPUTER INC PG34WCDM RCLMRS008453";
      res = "3440x1440@240";
      pos = "0x0";
      scale = "1";
    };
  };
  mod = "SUPER";
in
{
  hm.home.file.".config/uwsm/env-hyprland".text = ''
    export QT_QPA_PLATFORM=wayland
    export GDK_BACKEND=wayland
    export SDL_VIDEODRIVER=wayland
    export CLUTTER_BACKEND=wayland
    export ELECTRON_OZONE_PLATFORM_HINT=wayland
    export XDG_SESSION_TYPE=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
  '';

  hm.wayland.windowManager.hyprland.settings = {
    exec-once = [
      "hyprlock --immediate --immediate-render || hyprctl dispatch exit"
      "waybar"
      "waypaper --restore"
      "swaync"
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user start xdg-desktop-portal-hyprland"
      "${toString ./scripts/socketHandler.sh}"
    ];

    exec = [
      # "grep closed /proc/acpi/button/lid/LID0/state && [[ $(hyprctl monitors all -j | jq 'length') -gt 1 ]] && ${disableMonitor monitors.internal}"
      "grep closed /proc/acpi/button/lid/LID0/state && hyprctl monitors | grep \"${monitors.desktop.description}\" && ${disableMonitor monitors.internal}"
    ];

    workspace = [
      "special:special, on-created-empty:[tiled] kitty"
      "w[t1], gapsout:40 600 30 600"
      "m[eDP-1], gapsout:40 30 30 30"
    ];

    windowrulev2 = [
      # "float, class:^(org.pulseaudio.pwvucontrol|org.gnome.Settings|kitty|org.gnome.Nautilus|blueberry.py)$"
    ];

    monitor = [
      "${mkMonitorConfig monitors.internal}"
      "${mkMonitorConfig monitors.desktop}"
      ", preferred, auto, 1" # Fallback
    ];

    # env =
    #   [ "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1" ]
    #   ++ map (var: "${var}, wayland") [
    #     "GDK_BACKEND"
    #     "SDL_VIDEODRIVER"
    #     "CLUTTER_BACKEND"
    #     "QT_QPA_PLATFORM"
    #     "ELECTRON_OZONE_PLATFORM_HINT"
    #     "XDG_SESSION_TYPE"
    #   ]
    #   ++ map (var: "${var}, Hyprland") [
    #     "XDG_CURRENT_DESKTOP"
    #     "XDG_SESSION_DESKTOP"
    #   ];

    bindl = [
      ", switch:on:Lid Switch, exec, hyprctl monitors | grep \"${monitors.desktop.description}\" && ${disableMonitor monitors.internal}"
      ", switch:off:Lid Switch, exec, ${enableMonitor monitors.internal}"
      ", Print, exec, IMG=~/Pictures/Screenshots/$(date +%Y-%m-%d\" \"%Hh%Mm%Ss).png && grim -g \"$(slurp)\" \"$IMG\" && wl-copy <\"$IMG\""
    ];

    bind =
      [
        "${mod}, RETURN, exec, kitty"
        "${mod}, Q, killactive"
        "${mod}, E, exec, nautilus"
        "${mod}, V, togglefloating"
        "${mod}, R, exec, killall rofi; rofi -show drun"
        "${mod}, M, exec, killall .waybar-wrapped; waybar"
        "${mod}, F, fullscreen"
        "ALT, TAB, togglespecialworkspace"
        "ALT SHIFT, TAB, movetoworkspacesilent, special"
      ]
      ++ lib.genList (n: "${mod}, ${toString n}, workspace, ${toString n}") 9
      ++ lib.genList (n: "${mod} SHIFT, ${toString n}, movetoworkspacesilent, ${toString n}") 9;

    bindm = [
      "${mod}, mouse:272, movewindow"
      "${mod}, mouse:273, resizewindow"
      "${mod} CTRL, mouse:272, resizewindow"
    ];

    general = {
      gaps_in = 5;
      gaps_out = "40 30 30 30";
      border_size = 1;
      "col.active_border" = "0xffcba6f7";
      resize_on_border = true;
      layout = "dwindle";
      allow_tearing = true;
    };

    decoration = {
      rounding = 10;
      dim_special = 0.5;
      inactive_opacity = 1;
      active_opacity = 1;
      blur = {
        enabled = false;
        passes = 2;
        size = 4;
        new_optimizations = true;
        noise = 0.1;
        special = true;
        xray = true;
      };

      shadow = {
        range = 14;
        color = "0x331a1a1a";
      };
    };

    animations = {
      enabled = true;
      bezier = [
        "myBezier, 0.05, 0.9, 0.1, 1.05"
        "easeOutExpo, 0.16, 1, 0.3, 1"
      ];
      animation = [ "global, 1, 4, easeOutExpo" ];
    };

    xwayland = {
      force_zero_scaling = true;
    };

    input = {
      follow_mouse = 1;
      accel_profile = "flat";
      touchpad = {
        disable_while_typing = false;
      };
      # emulate_discrete_scroll = 0;
    };

    device = [
      {
        name = "pixa3854:00-093a:0274-touchpad";
        accel_profile = "adaptive";
      }
    ];

    gestures = {
      workspace_swipe = true;
      workspace_swipe_invert = false;
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
      middle_click_paste = false;
      allow_session_lock_restore = true;
    };
  };
}
