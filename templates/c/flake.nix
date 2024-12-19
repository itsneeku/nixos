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
        buildDeps = with pkgs; [ ];
        runtimeDeps = with pkgs; [ ];
        devDeps =
          with pkgs;
          buildDeps
          ++ runtimeDeps
          ++ [
            clang
            clang-tools
            gdb
            valgrind
          ];
        name = "Example";
      in
      {
        devShells.default = pkgs.mkShell {
          packages = devDeps;
          shellHook = inputs.sugar.welcome devDeps;
        };

        packages.default = pkgs.stdenv.mkDerivation {
          name = name;
          src = ./.;
          buildInputs = buildDeps;
          buildPhase = ''
            gcc -o ${name} -I./include ./src/*.c
          '';
        };
      }
    );
}
