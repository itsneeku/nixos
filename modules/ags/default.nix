{ inputs, pkgs, ... }:
{
  hm =
    { config, ... }:
    {
      # add the home manager module
      imports = [ inputs.ags.homeManagerModules.default ];

      home.file.".config/ags" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/modules/ags/app";
        recursive = true;
      };

      programs.ags = {
        enable = true;

        # symlink to ~/.config/ags
        configDir = null;

        # additional packages to add to gjs's runtime
        extraPackages = with inputs.ags.packages.${pkgs.system}; [
          battery
          apps
          bluetooth
          greet
          hyprland
          mpris
          network
          notifd
          powerprofiles
          tray
          wireplumber
        ];
      };
    };
}
