{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.kitty = {
    enable = true;
    font.name = "CaskaydiaCove Nerd Font";

    # home.file.".config/kitty/kitty.conf".source =
    #   config.lib.file.mkOutOfStoreSymlink
    #   /home/neeku/.nixos/modules/home/kitty.conf;
    # theme = "Catppuccin-Mocha";
    settings = {
      shell = "nu";
      touch_scroll_multiplier = 8;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      # background_opacity = "0.8";
      window_margin_width = 10;
      include = "theme.conf";
    };
    keybindings = {"ctrl+backspace" = "send_text all \\x17";};
  };
}
