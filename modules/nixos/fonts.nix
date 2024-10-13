{
  inputs,
  pkgs,
  ...
}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = ["CascadiaCode" "Noto" "JetBrainsMono" "FiraCode"];
      })
      noto-fonts-emoji
    ];
  };
}
