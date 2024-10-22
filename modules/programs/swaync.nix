{config, ...}: {
  home-manager.users.${config.user}.services.swaync = {enable = true;};
}
