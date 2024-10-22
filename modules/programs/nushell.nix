{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.user}.programs.nushell = {
    enable = true;
    # extraConfig = ''
    #   source /home/${config.user}/.nixos/modules/programs/nushell/config.nu
    # '';
    configFile.source = ./nushell/config.nu;
    shellAliases = {
      ls = "ls -la";
    };
    extraConfig = ''
      use ${./nushell/utils.nu} *
    '';
  };

  users.users.${config.user}.shell = pkgs.nushell;
}
