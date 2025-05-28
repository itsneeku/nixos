{
  lib,
  pkgs,
  inputs,
  config,
  user,
  ...
}:
{
  hardware.keyboard.qmk.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  services.upower.enable = true;

  programs.adb.enable = true;
  virtualisation.waydroid.enable = true;

  users.users.${user}.extraGroups = [ "adbusers" ];

  home-manager.users.${user} = {
    # without home-manager options
    home.packages = with pkgs; [
      qmk
      obsidian
      (spotify.overrideAttrs (oldAttrs: {
        postInstall = ''sed -i "s|^Exec=.*|& --enable-features=UseOzonePlatform --ozone-platform=wayland|" "$out/share/applications/spotify.desktop"'';
      }))
      libgcc
      spicetify-cli
      wlogout
      vivaldi
      vivaldi-ffmpeg-codecs
      bat
      vesktop
      killall
      eza
      waypaper
      swaybg
      # texlive.combined.scheme-basic
      texliveFull
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
      inputs.zen-browser.packages."${system}".default
      # eslint
      zed-editor
      code-cursor
      android-tools
      qtscrcpy
      # google-chrome
      # libreoffice-qt6
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "zen.desktop" ];
        "x-scheme-handler/http" = [ "zen.desktop" ];
        "x-scheme-handler/https" = [ "zen.desktop" ];
        "x-scheme-handler/about" = [ "zen.desktop" ];
        "x-scheme-handler/unknown" = [ "zen.desktop" ];
        "default-web-browser" = [ "zen.desktop" ];
        "application/octet-stream" = [ "code.desktop" ];
        "text/plain" = [ "code.desktop" ];
        "application/zip" = [ "org.gnome.Nautilus.desktop" ];
        "application/x-7z-compressed" = [ "org.gnome.Nautilus.desktop" ];
      };
    };

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs; [
        # obs-studio-plugins.obs-gstreamer
        # obs-studio-plugins.obs-vkcapture
      ];
    };

    programs.bat.enable = true;
    programs.zoxide.enable = true;
    programs.yazi.enable = true;
    programs.direnv = {
      enable = true;
      silent = true;
      config = {
        hide_env_diff = true;
      };
      nix-direnv.enable = true;
      config.whitelist.prefix = [ "~/Documents/Code" ]; # Very Unsafe :)
    };
    programs.btop = {
      enable = true;
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
