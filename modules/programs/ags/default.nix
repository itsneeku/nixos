{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  requiredDeps =
    with pkgs;
    [
    ];

  guiDeps =
    with pkgs;
    [
    ];

  dependencies = requiredDeps ++ guiDeps;

  cfg = config.programs.ags;
in
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  # home.packages = builtins.attrValues inputs.ags.packages.${pkgs.system};

  # programs.ags = {
  #   enable = true;
  #   extraPackages = with pkgs;
  #     [fzf]
  #     ++ builtins.attrValues (removeAttrs inputs.ags.packages.${pkgs.system} ["docs"]);
  #   # Must run `ags -g` if extraPackages changes for ts type generation
  # };

  home.file.".config/ags/" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/neeku/.nixos/modules/home-manager/ags;
    recursive = true;
  };

  # additional packages to add to gjs's runtime
  # NOT EXPOSED TO HOME ENVIRONMENT
  # extraPackages = with pkgs; [
  #   inputs.ags.packages.${pkgs.system}.battery
  #   fzf
  # ];

  # systemd.user.services.ags = {
  #   Unit = {
  #     Description = "Aylur's Gtk Shell";
  #     PartOf = [
  #       "tray.target"
  #       "graphical-session.target"
  #     ];
  #   };
  #   Service = {
  #     Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
  #     ExecStart = "${cfg.package}/bin/ags";
  #     Restart = "on-failure";
  #   };
  #   Install.WantedBy = ["graphical-session.target"];
  # };
}
