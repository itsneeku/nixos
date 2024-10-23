{
  inputs.utils.url = "github:numtide/flake-utils";
  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {})
        ];
      };
      buildDeps = with pkgs; [];
      runtimeDeps = with pkgs; [];
      devDeps = with pkgs;
        buildDeps
        ++ runtimeDeps
        ++ [
          clang
          clang-tools
          gdb
          valgrind
        ];
      appName = "AppName";
    in {
      devShells.default = pkgs.mkShell {
        packages = devDeps;

        shellHook = ''
          echo -e "Entering dev shell for $(basename "$(pwd)")...\n"

          echo "Installed nix packages:"
          for path in ${builtins.concatStringsSep " " devDeps}; do
            pkg=$(basename "$path" | awk -F '-' '{print substr($0, index($0, $2))}')
            echo -e "\t$pkg"
          done
        '';
      };

      packages.default = pkgs.stdenv.mkDerivation {
        name = appName;
        src = ./.;
        buildInputs = buildDeps;
        buildPhase = ''
          gcc -o ${appName} -I./include ./src/*.c
        '';
        # installPhase = ''
        #   mkdir -p $out/bin
        #   cp ${appName} $out/bin/
        # '';
      };
    });
}
