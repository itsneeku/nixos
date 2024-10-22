{
  pkgs,
  lib,
  inputs,
  nixpkgs,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;

      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "America/Toronto";
  };
}
