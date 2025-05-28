{ pkgs, ... }:
{
  services.power-profiles-daemon.enable = true;

  hm.systemd.user.services.ppd-power-switcher = {
    Install = {
      WantedBy = [ "default.target" ];
      Restart = "on-failure";
    };
    Service = {
      ExecStart = "${
        pkgs.writeShellApplication {
          name = "watch-ppd-power";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.inotify-tools
            pkgs.power-profiles-daemon
          ];
          text = # bash
            ''
              BAT=$(echo /sys/class/power_supply/BAT*)
              BAT_STATUS="$BAT/status"
              BAT_CAP="$BAT/capacity"

              AC_PROFILE="performance"
              BAT_PROFILE="power-saver"

              prev=0
              while true; do
                # read the current state
                if [[ $(cat "$BAT_STATUS") == "Discharging" && $(cat "$BAT_CAP") -le 85 ]]; then
                  profile=$BAT_PROFILE
                  hyprctl keyword animations:enabled false
                else
                  profile=$AC_PROFILE
                  hyprctl keyword animations:enabled true
                fi

                # set the new profile
                if [[ $prev != "$profile" ]]; then
                  echo setting power profile to $profile
                  powerprofilesctl set $profile
                fi

                prev=$profile

              # wait for the next power change event
              inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
              done
            '';
        }
      }/bin/watch-ppd-power";
    };
  };
}
