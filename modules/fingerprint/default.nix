# TODO: PR to nixpkgs for security/pam.nix changes: https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md
# TODO: Might as well add timeout option too and debug. Just everything from fprintd.pam
{
  pkgs,
  config,
  lib,
  ...
}:
let
  laptop-lid = pkgs.writeShellScript "laptop-lid" ''
    lock=$HOME/fingerprint-reader-disabled

    # match for either display port or hdmi port
    if grep -Fq closed /proc/acpi/button/lid/LID0/state &&
       (grep -Fxq connected /sys/class/drm/card*-DP-*/status ||
        grep -Fxq connected /sys/class/drm/card*-HDMI-*/status)
    then
      touch "$lock"s
      echo 0 > /sys/bus/usb/devices/1-4/authorized
    elif [ -f "$lock" ]
    then
      echo 1 > /sys/bus/usb/devices/1-4/authorized
      rm "$lock"
    fi
  '';
in
{
  disabledModules = [ "security/pam.nix" ];
  options.services.fprintd.max-tries = lib.mkOption {
    type = lib.types.int;
    default = 3;
    description = ''
      The number of attempts at fingerprint authentication to try before returning an authentication failure. The minimum number of tries is 1 while the default is 3.
    '';
  };
  config.assertions = [
    {
      assertion = config.services.fprintd.max-tries >= 1;
      message = "The minimum number of tries is 1 while the default is 3.";
    }
  ];

  imports = [ ./pam.nix ];
  config = {
    services.fprintd.enable = true;
    services.fprintd.max-tries = 99;
    services.acpid = {
      enable = true;
      lidEventCommands = "${laptop-lid}";
    };
    systemd.services.fingerprint-laptop-lid = {
      enable = true;
      description = "Disable fingerprint reader when laptop lid closes";
      serviceConfig = {
        ExecStart = laptop-lid;
      };
      wantedBy = [
        "multi-user.target"
        "suspend.target"
      ];
      after = [ "suspend.target" ];
    };
  };
}
