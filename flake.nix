{
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    hosts = {
      apollo = ./hosts/apollo;
      server = ./hosts/server;
    };
    user = "neeku";
  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs (hostname: hostModule:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs hostname user;};
        modules = [hostModule (import ./overlays)];
      })
    hosts;

    templates = import ./templates;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    stylix.url = "github:danth/stylix";
    ags.url = "github:aylur/ags/v2";
    catppuccin.url = "github:catppuccin/nix";
    flake-firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
    zen-browser.url = "github:ch4og/zen-browser-flake";
  };
}
