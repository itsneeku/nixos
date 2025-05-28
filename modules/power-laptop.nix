{ pkgs, ... }:
{
  power-profiles-daemon.enable = true;

  hm.systemd.user.services.ppd-power-switcher = {
    Install = {
      WantedBy = [ "default.target" ];
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
          text = ''
            BAT=$(echo /sys/class/power_supply/BAT*)
            BAT_STATUS="$BAT/status"
            BAT_CAP="$BAT/capacity"
            LOW_BAT_PERCENT=20

            AC_PROFILE="performance"
            BAT_PROFILE="power-saver"
            LOW_BAT_PROFILE="power-saver"

            prev=0
            while true; do
              # read the current state
              if [[ $(cat "$BAT_STATUS") == "Discharging" ]]; then
                if [[ $(cat "$BAT_CAP") -gt $LOW_BAT_PERCENT ]]; then
                  profile=$BAT_PROFILE
                else
                  profile=$LOW_BAT_PROFILE
                fi
              else
                profile=$AC_PROFILE
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
