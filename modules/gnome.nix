{ pkgs, user, ... }:
let
  gnome-extensions = with pkgs.gnomeExtensions; [
    user-themes
    tiling-shell
    just-perfection
    open-bar
    window-is-ready-remover
    transparent-top-bar-adjustable-transparency
    top-bar-organizer
    power-profile-switcher
    super-key
    steal-my-focus-window
    space-bar
    speedinator
    serenity-desktop
    rounded-window-corners-reborn
    hide-top-bar
    compact-top-bar
    compact-quick-settings
    disable-workspace-switch-animation-for-gnome-40
    date-menu-formatter
    disable-workspace-switcher-overlay
    disable-workspace-animation
    pop-shell
    pano
    clipboard-indicator
    bluetooth-battery-meter
    do-not-disturb-while-screen-sharing-or-recording
    battery-time
    battery-time-2
    undecorate
    forge
    move-clock
    lilypad
    impatience
    panel-free
    highlight-focus
    fw-fanctrl
  ];
in
{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = [ pkgs.mutter ];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      # Fractional Scaling
      experimental-features=['scale-monitor-framebuffer'] 
    '';
  };
  environment.gnome.excludePackages = with pkgs; [
    orca
    evince
    geary
    seahorse
    sushi
    gnome-backgrounds
    gnome-tour
    gnome-user-docs
    baobab
    epiphany
    gnome-text-editor
    gnome-calendar
    gnome-characters
    gnome-console
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-weather
    gnome-connections
    simple-scan
    snapshot
    totem
    yelp
    gnome-software
  ];

  home-manager.users.${user} = {
    home.packages = gnome-extensions;
    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = map (e: e.extensionUuid) gnome-extensions;
        };
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";

      };
    };

  };
}
