{ config, user, ... }:
{
  home-manager.users.${user}.services.swaync = {
    enable = true;
  };
}
