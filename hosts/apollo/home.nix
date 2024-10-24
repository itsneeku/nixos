{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "old";

    extraSpecialArgs = {
      inherit inputs;
    };

    users.${config.user} = {
      home = {
        homeDirectory = "/home/${config.user}";
        username = config.user;
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          EDITOR = "code";
          NIXPKGS_ALLOW_UNFREE = "1";
        };
        stateVersion = "24.05";
      };

      programs.home-manager.enable = true;
    };
  };

  users.users.${config.user} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
