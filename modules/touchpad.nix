{ pkgs, ... }:
{
  services.libinput = {
    enable = true;
    # touchpad = {
    #   enable = true;
    #   naturalScrolling = true;
    #   tapToClick = true;
    #   disableWhileTyping = false;
    #   clickMethod = "clickfinger";

    # };
  };
}
