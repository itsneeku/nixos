{ inputs, pkgs, ... }:
{
  imports = [ inputs.niri.nixosModules.niri ];
  programs.niri.enable = true;
  hm =
    { config, ... }:
    {

      programs.niri.settings = {
        binds = {
          "Mod+T".action.spawn = [ "kitty" ];
          "Mod+R".action.spawn = [
            "rofi"
            "-show"
            "drun"
          ];
        };
      };
    };
}
