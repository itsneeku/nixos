{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    stylix.url = "github:danth/stylix";
    ags.url = "github:aylur/ags/v2";
    catppuccin.url = "github:catppuccin/nix";
    flake-firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      user = "neeku";

      modulesForAll = [
        inputs.catppuccin.nixosModules.catppuccin
        inputs.home-manager.nixosModules.home-manager
        ./overlays
        ./lib.nix
      ];

      mkConfig =
        host: modules:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs host user;
          };
          modules = modulesForAll ++ modules;
        };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style; # TODO: Generalize?
      nixosConfigurations = builtins.mapAttrs mkConfig {
        apollo = [ ./hosts/apollo ];
        sputnik = [ ./hosts/sputnik ];
      };
      templates = import ./templates;
    };
}
