{
  config,
  pkgs,
  user,
  ...
}:
{
  home-manager.users.${user}.programs = {
    nushell = {
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
        source ~/.cache/carapace/init.nu
      '';
      envFile.text = ''
        $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
        mkdir ~/.cache/carapace
        carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
      '';
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };

  users.users.${user}.shell = pkgs.nushell;
}
