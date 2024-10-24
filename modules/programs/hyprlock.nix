{
  config,
  user,
  ...
}:
{
  home-manager.users.${user}.programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      background = {
        monitor = "";
      };

      input-field = {
        monitor = "";
        size = "4096, 500";
        outline_thickness = 1;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0)";
        font_color = "rgba(255, 255, 255, 1)";
        fade_on_empty = true;
        fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
        placeholder_text = ""; # Text rendered in the input box when it's empty.
        hide_input = false;

        check_color = "rgba(0, 0, 0, 0)";
        fail_color = "rgba(255, 0, 0, 0)"; # if authentication failed, changes outer_color and fail message color
        fail_text = ""; # can be set to empty
        fail_transition = 300; # transition time in ms between normal outer_color and fail_color

        position = "0, 0";
        halign = "center";
        valign = "center";
      };
    };
  };
}
