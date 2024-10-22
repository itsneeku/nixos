{config, ...}: {
  home-manager.users.${config.user} = {
    config,
    pkgs,
    ...
  }: {
    programs.waybar = {
      enable = true;
    };

    home.file.".config/waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink /home/neeku/.nixos/modules/programs/waybar;
      recursive = true;
    };

    home.packages = with pkgs; [
      brightnessctl
    ];
  };
}
