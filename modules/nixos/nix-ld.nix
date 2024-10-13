{
  pkgs,
  user,
  ...
}: {
  programs.nix-ld = {
    enable = true;
  };
}
