{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cursor = "Bibata-Modern-Classic";
  cursorPackage = pkgs.bibata-cursors;
  cursorSize = 32;
in
{
  home-manager.users.${config.user} = {
    gtk.enable = true;
    home.packages = [ pkgs.font-manager ];

    # Font
    gtk.font = {
      name = "SFRounded Nerd Font";
      package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
    };

    # Theme
    imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
    catppuccin.flavor = "mocha";
    gtk.catppuccin.enable = true;

    # Cursor
    home.pointerCursor = {
      name = cursor;
      size = cursorSize;
      package = cursorPackage;
      x11.enable = true;
      gtk.enable = true;
    };

    home.sessionVariables = {
      HYPRCURSOR_SIZE = cursorSize;
      HYPRCURSOR_THEME = "HyprBibataModernClassicSVG";
      QT_CURSOR_THEME = cursor;
      QT_CURSOR_SIZE = cursorSize;
      XCURSOR_THEME = cursor;
      XCURSOR_SIZE = cursorSize;
    };

    home.file.".local/share/icons/HyprBibataModernClassicSVG" = {
      source = ../../resources/HyprBibataModernClassicSVG;
      recursive = true;
    };

    systemd.user.services.setCursor = {
      Unit.Description = "Set hyprcursor";
      Install.WantedBy = [ "graphical-session.target" ];
      Service.ExecStart = "/run/current-system/sw/bin/bash -c 'hyprctl setcursor HyprBibataModernClassicSVG ${toString cursorSize}'";
    };
  };
}
