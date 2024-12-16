{
  lib,
  pkgs,
  config,
  user,
  ...
}:
{
  home-manager.users.${user}.programs.kitty = {
    enable = true;
    font.name = "CaskaydiaCove Nerd Font";
    themeFile = "Catppuccin-Mocha";

    settings = {
      shell = "nu";
      touch_scroll_multiplier = 8;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      # background_opacity = "0.8";
      window_margin_width = 10;
      # include = "theme.conf";
    };
    keybindings = {
      "ctrl+backspace" = "send_text all \\x17";
    };
  };
}
