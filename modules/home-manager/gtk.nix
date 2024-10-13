{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cursor = "Bibata-Modern-Classic";
  cursorPackage = pkgs.bibata-cursors;
  cursorSize = 32;

  theme = "adw-gtk3-dark"; # ls /etc/profiles/per-user/neeku/share/themes
  themePackage = pkgs.adw-gtk3;
in {
  gtk.enable = true;
  home.packages = [pkgs.font-manager];

  # Font
  gtk.font = {
    name = "SFRounded Nerd Font";
    package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
  };

  # Theme
  imports = [inputs.catppuccin.homeManagerModules.catppuccin];
  catppuccin.flavor = "mocha";
  gtk = {
    catppuccin.enable = true;
    catppuccin.icon.enable = true;
    # theme.package = themePackage;
    # theme.name = theme;
  };

  # Cursor
  home.pointerCursor = {
    name = cursor;
    size = cursorSize;
    package = cursorPackage;
    x11.enable = true;
    gtk.enable = true;
  };
  home.sessionVariables.HYPRCURSOR_SIZE = cursorSize;
  home.sessionVariables.HYPRCURSOR_THEME = "HyprBibataModernClassicSVG";
  home.sessionVariables.QT_CURSOR_THEME = cursor;
  home.sessionVariables.QT_CURSOR_SIZE = cursorSize;
  home.sessionVariables.XCURSOR_THEME = cursor;
  home.sessionVariables.XCURSOR_SIZE = cursorSize;
  home.file.".local/share/icons/HyprBibataModernClassicSVG" = {
    source = ../../resources/HyprBibataModernClassicSVG;
    recursive = true;
  };
  systemd.user.services.setCursor = {
    Unit.Description = "Set hyprcursor";
    Install.WantedBy = ["graphical-session.target"];
    Service.ExecStart = "/run/current-system/sw/bin/bash -c 'hyprctl setcursor HyprBibataModernClassicSVG ${
      toString cursorSize
    }'";
  };
}
