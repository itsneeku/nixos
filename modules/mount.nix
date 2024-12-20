{
  pkgs,
  user,
  config,
  ...
}:
{
  programs.gnome-disks.enable = true;

  services.udisks2.enable = true;

  # Auto Mount using udisks2
  home-manager.users.neeku.services.udiskie = {
    enable = true;
    tray = "never";
  };

  # Android MTP
  services.gvfs.enable = true;
}
