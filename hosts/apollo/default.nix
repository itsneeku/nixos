{
  pkgs,
  inputs,
  lib,
  config,
  user,
  ...
}:
let
  modules = [
    "bluetooth"
    "dualboot"
    "mount"
    "network"
    "sound"
    "system"
    "touchpad"
    "i2c"

    "gtk"
    "waybar"
    "sddm"

    "hyprland"
    # "river"
    # "gnome"
    "rofi"
    "fonts"
    "swaync"
    "ags"

    "dev"
    "nushell"
    "kitty"

    "packages"
    "fw-fanctrl"
    "zathura"
  ];

  getModulePath =
    module:
    let
      basePath = ../../modules;
    in
    "${basePath}/${module}"
    + lib.optionalString (lib.pathIsRegularFile "${basePath}/${module}.nix") ".nix";
in
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    inputs.home-manager.nixosModules.home-manager
    inputs.fw-fanctrl.nixosModules.default
    ./hardware-configuration.nix
    ./home.nix
  ] ++ (lib.map getModulePath modules);

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services = {
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;

    # Printing
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    power-profiles-daemon.enable = true;

    logind.powerKey = "suspend";
    fprintd.enable = false;
  };

  home-manager.users.${user}.systemd.user.services.ppd-power-switcher = {
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "watch-ppd-power" ''
        #!/run/current-system/sw/bin/bash
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
            ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set $profile
          fi

          prev=$profile

          # wait for the next power change event
          ${pkgs.inotify-tools}/bin/inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
        done
      ''}";
    };
  };

  environment.systemPackages = with pkgs; [
    mtpfs # Android MTP support
    polkit_gnome
    amf # AMD AMF encoder
  ];

  hardware.sensor.iio.enable = true; # Allow DEs to manage display brightness
  security.polkit.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # hardware.amdgpu = {
  #   opencl.enable = true;
  #   amdvlk.enable = true;
  #   initrd.enable = true;
  # };

  boot.loader.grub.memtest86.enable = true;

  # Enables the zenpower sensor in lieu of the k10temp sensor on Zen CPUs https://git.exozy.me/a/zenpower3
  # On Zen CPUs zenpower produces much more data entries

  boot.blacklistedKernelModules = [ "k10temp" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];
  boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ];
  boot.kernelModules = [ "zenpower" ];

  system.stateVersion = "24.05";
}
