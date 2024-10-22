{config, ...}: {
  programs.nh = {
    enable = true;
    flake = "/home/${config.user}/.nixos/";
  };
}
