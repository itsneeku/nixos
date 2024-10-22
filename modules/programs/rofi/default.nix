{
  lib,
  pkgs,
  config,
  ...
}: {
  home-manager.users.${config.user}.programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = ./catppuccin-latte.rasi;
    extraConfig = {
      modi = "drun";
      icon-theme = "Papirus";
      show-icons = true;
      location = 0;
      terminal = "kitty";
      run-command = "{cmd}";
      run-shell-command = "{terminal} --hold -e {cmd}";
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      # display-run = "  ";
      display-drun = " 󰀻 ";
      display-combi = " 󰀻 Apps ";
      display-window = " 󱂬 Window ";
      display-Network = " 󰤨  Network";
      display-clipboard = " 󱘞 Clipboard ";
      sidebar-mode = false;
      hover-select = true;
    };
  };
}
