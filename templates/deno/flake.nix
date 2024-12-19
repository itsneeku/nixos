{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    sugar.url = "github:itsneeku/flake-sugar";
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    inputs.utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        devDeps = with pkgs; [
          deno
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          packages = devDeps;
          shellHook = inputs.sugar.welcome devDeps;
        };
      }
    );
}
