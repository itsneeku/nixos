{
  config,
  lib,
  inputs,
  pkgs,
  user,
  ...
}:
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [ nodePackages.prettier ];
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
  };

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
