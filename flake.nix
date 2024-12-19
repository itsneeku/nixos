{
  outputs =
    inputs@{
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      user = "neeku";

      mkHost =
        host: module:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs host user;
          };
          modules = [ module ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkHost {
        apollo = ./hosts/apollo;
        sputnik = ./hosts/sputnik;
      };
      formatter = nixpkgs.${inputs.system}.nixfmt-rfc-style;

      templates = import ./templates; # nix flake init -t ($env.FLAKE + "#deno")
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "github:hyprwm/Hyprland";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    catppuccin.url = "github:catppuccin/nix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
