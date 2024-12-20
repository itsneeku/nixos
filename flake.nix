{
  inputs = {
    # System #
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Software #
    hyprland.url = "github:hyprwm/Hyprland";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    catppuccin.url = "github:catppuccin/nix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    fw-fanctrl.url = "github:TamtamHero/fw-fanctrl/packaging/nix";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      # TODO: Replace all occurances of "neeku" with ${user}
      # when https://github.com/nix-community/nixd/issues/615 gets fixed
      user = "neeku";

      mkSystem =
        host: module:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs host user; };
          modules = [
            module
            ./lib.nix
          ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem {
        apollo = ./hosts/apollo;
        sputnik = ./hosts/sputnik;
      };

      templates = import ./templates; # nix flake init -t ($env.FLAKE + "#deno")
    };
}
