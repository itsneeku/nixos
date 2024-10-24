{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  services.kanshi = {
    enable = true;
    # package = pkgs.vscode.fhs;
  };

  # home.packages = with pkgs;
  # [
  # nixfmt

  # ];

  # xdg.desktopEntries = {
  #   code = {
  #       name = "Visual Studio Code";
  #       exec = "code %F"; #
  #       icon = "vscode";
  #       # keywords = ["vscode"];
  #       mimeType = ["text/plain" "inode/directory"];
  #       startupNotify = true;
  #       type = "Application";
  #     };
  # };
}
