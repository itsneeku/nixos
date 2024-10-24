{
  config,
  pkgs,
  user,
  ...
}:
{
  home-manager.users.${user}.programs.nushell = {
    enable = true;
    # extraConfig = ''
    #   source /home/${user}/.nixos/modules/programs/nushell/config.nu
    # '';
    configFile.source = ./nushell/config.nu;
    shellAliases = {
      ls = "ls -la";
    };
    extraConfig = ''
      use ${./nushell/utils.nu} *
    '';
  };

  users.users.${user}.shell = pkgs.nushell;
}
