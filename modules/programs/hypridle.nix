{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.user}.services.hypridle = {
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
        {
          # 2 min -> decrease monitor brightness
          timeout = 120;
          # /etc/profiles/per-user/neeku/bin/nu -c 'ddcutil getvcp 10 -t | awk {print $4} o> /tmp/hypridle_ddcutil; ddcutil setvcp 10 1'
          on-timeout = "${pkgs.nushell}/bin/nu -c 'ddcutil getvcp 10 -t | split column \" \" | get column4 | save -f /tmp/hypridle_ddcutil; ddcutil setvcp 10 1'";
          on-resume = "${pkgs.nushell}/bin/nu -c 'ddcutil setvcp 10 (open /tmp/hypridle_ddcutil)'";
        }
        {
          # 2 min -> decrease laptop brightness
          timeout = 120;
          on-timeout = "brightnessctl -s set 1";
          on-resume = "brightnessctl -r";
        }
        {
          # 3 min -> lock
          timeout = 180;
          on-timeout = "loginctl lock-session";
        }
        {
          # 5 min -> turn off display
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          # 30 min -> sleep
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
