{
  inputs,
  pkgs,
  ...
}:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Essential
      noto-fonts
      noto-fonts-emoji

      # Nerd Fonts
      nerd-fonts.caskaydia-cove
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
