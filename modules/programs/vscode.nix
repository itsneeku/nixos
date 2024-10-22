{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  home.packages = with pkgs; [ nodePackages.prettier ];

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
