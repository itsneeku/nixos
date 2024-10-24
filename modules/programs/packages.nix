{
  lib,
  pkgs,
  inputs,
  config,
  user,
  ...
}:
{
  home-manager.users.${user} = {
    # without home-manager options
    home.packages = with pkgs; [
      obsidian
      (spotify.overrideAttrs (oldAttrs: {
        postInstall = ''sed -i "s|^Exec=.*|& --enable-features=UseOzonePlatform --ozone-platform=wayland|" "$out/share/applications/spotify.desktop"'';
      }))
      libgcc
      spicetify-cli
      vim
      bat
      vesktop
      eza
      waypaper
      swaybg
      libnotify
      nautilus
      gnome-settings-daemon
      adwaita-icon-theme
      gnome-control-center
      bluetuith
      gnome-bluetooth
      overskride
      shfmt
      # ddcutil issue on newest kernel
      grim
      slurp
      wl-clipboard
      hyprpicker
      loupe
      pulseaudio
      blueberry
      wlsunset # Since the service doesnt add binary to path
      socat
      jq
      celluloid
      ffmpeg-full
      bc
      appimage-run
      unityhub
      inputs.zen-browser.packages."${system}".specific
      eslint
      anytype
      # libreoffice-qt6
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/octet-stream" = [ "code.desktop" ];
        "text/plain" = [ "code.desktop" ];
        "application/zip" = [ "org.gnome.Nautilus.desktop" ];
      };
    };

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs; [
        # obs-studio-plugins.obs-gstreamer
        # obs-studio-plugins.obs-vkcapture
      ];
    };

    programs.bat = {
      enable = true;
      catppuccin.enable = true;
      catppuccin.flavor = "mocha";
    };

    programs.zoxide.enable = true;
    programs.yazi.enable = true;
    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
      config.whitelist.prefix = [ "~/Documents/Code" ]; # Very Unsafe :)
    };
    programs.btop = {
      enable = true;
      catppuccin.enable = true;
      catppuccin.flavor = "mocha";
      package = pkgs.btop.override {
        rocmSupport = true; # Add rocm_smi_lib for AMD GPU monitoring
      };
      settings = {
        proc_tree = true;
        proc_filter_kernel = true;
        proc_aggregate = true;
      };
    };

    services = {
      wlsunset = {
        enable = true;
        latitude = 40;
        longitude = -73;
        temperature.night = 3500;
      };
    };
  };
}
