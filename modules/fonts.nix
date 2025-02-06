{ inputs, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Essential
      noto-fonts
      noto-fonts-emoji

      # Nerd Fonts
      nerd-fonts.caskaydia-cove
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.sauce-code-pro
      inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
      inputs.apple-fonts.packages.${pkgs.system}.ny-nerd

      # Very Nice
      open-sans
      source-sans
      source-serif
      inter
      poppins
    ];
  };
}
