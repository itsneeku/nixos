{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = [ ];
  };

  home-manager.users.neeku.programs.git = {
    enable = true;

    userName = "Nicolae Rusu";
    userEmail = "nicolae@rusu.dev";

    diff-so-fancy.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  hm = {
    home.packages = with pkgs; [ nodePackages.prettier ];
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
  };
}
