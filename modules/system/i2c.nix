{
  pkgs,
  config,
  user,
  ...
}:
{
  hardware.i2c.enable = true;
  environment.systemPackages = with pkgs; [
    ddcutil
  ];
  boot.kernelModules = [
    "i2c-dev"
    "ddcci_backlight"
  ];
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';
  users.users.${user}.extraGroups = [ "i2c" ];
}
