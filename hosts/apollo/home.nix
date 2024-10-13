{
  pkgs,
  inputs,
  user,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
    backupFileExtension = ".backup";
    users.${user} = {
      imports = [../../modules/home-manager];
      home = {
        homeDirectory = "/home/${user}";
        username = user;
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          EDITOR = "code";
        };
        stateVersion = "24.05";
      };

      programs.home-manager.enable = true;
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "i2c"];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
