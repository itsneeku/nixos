{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
  ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
    };
    backupFileExtension = "old";
    users.${config.user} = {
      imports = map (name: ../../modules/programs + "/${name}.nix") [
        "firefox/default"
        "rofi/default"
        "git"
        "gtk"
        "kanshi"
        "kitty"
        "nushell"
        "packages"
        "vscode"
        "zathura"
      ];
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
    extraGroups = ["networkmanager" "wheel" "i2c"];
    shell = pkgs.nushell;
  };
}
