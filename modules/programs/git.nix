{
  lib,
  pkgs,
  config,
  user,
  ...
}:
{
  home-manager.users.${user}.programs.git = {
    enable = true;

    userName = "Nicolae Rusu";
    userEmail = "nicolae@rusu.dev";

    diff-so-fancy.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
