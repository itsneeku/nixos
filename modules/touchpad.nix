{ pkgs, ... }:
{
  services.libinput = {
    enable = true;
    /**
      More settings defined in hyprland:input as they take priority
    */
    touchpad = {
      disableWhileTyping = false;
    };
    # touchpad = {
    #   clickMethod = "clickfinger";
    # };

    # mouse = {
    #   accelProfile = "flat";
    # };
  };
}
