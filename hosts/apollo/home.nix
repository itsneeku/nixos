{
  inputs,
  user,
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

    users.${user} = {
      home = {
        homeDirectory = "/home/${user}";
        username = user;
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

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
