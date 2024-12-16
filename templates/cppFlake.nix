{
  inputs.utils.url = "github:numtide/flake-utils";
  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        projectName = "OpenGL_Project";

        buildDeps = with pkgs; [ ];
        runtimeDeps = with pkgs; [ ];
        devDeps = with pkgs; [ ];
        allPackages = pkgs.lib.removeDuplicates (buildDeps ++ runtimeDeps ++ devDeps);
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = projectName;
          src = ./.;
          nativeBuildInputs = buildDeps;
          buildInputs = runtimeDeps;
        };

        devShells.default = pkgs.mkShell {
          packages = devDeps;
          shellHook = ''
            echo "Entering dev shell for ${projectName}..."

            # # Create symbolic links to buildDeps in devDeps
            # rm -r "./includeNixStore" &> /dev/null
            # mkdir -p "./includeNixStore"
            # for pkg in ${toString buildDeps}; do
            #   if [ -d "$pkg/include" ]; then
            #     ln -sf "$pkg/include" "./includeNixStore/$(basename $pkg)"
            #   else
            #     ln -sf "$pkg" "./includeNixStore/$(basename $pkg)"
            #   fi
            # done
          '';
        };
      }
    );
}
