{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    stylix.url = "github:danth/stylix";
    ags.url = "github:aylur/ags/v2";
    catppuccin.url = "github:catppuccin/nix";
    flake-firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
    zen-browser.url = "github:ch4og/zen-browser-flake";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      mkConfig =
        host: module:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            inputs.catppuccin.nixosModules.catppuccin
            inputs.home-manager.nixosModules.home-manager
            ./overlays
            (import ./lib.nix { inherit host; })
            module
          ];
        };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style; # TODO: Generalize?
      nixosConfigurations = builtins.mapAttrs mkConfig {
        apollo = ./hosts/apollo;
        sputnik = ./hosts/sputnik;
      };
      templates = import ./templates;
    };
}
