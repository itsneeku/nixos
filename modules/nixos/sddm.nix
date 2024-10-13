{
  pkgs,
  user,
  ...
}: {
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = user;
    };
    sddm = {
      enable = true;
      theme = "where_is_my_sddm_theme_qt5";
      enableHidpi = true;
      wayland.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    (where-is-my-sddm-theme.override {
      variants = ["qt5"];
    })
  ];
}
