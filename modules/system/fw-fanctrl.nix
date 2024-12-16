{ pkgs, ... }:
{
  # Enable fw-fanctrl
  programs.fw-fanctrl.enable = true;

  # # Add a custom config
  programs.fw-fanctrl.config = {
    defaultStrategy = "laziest";
    strategyOnDischarging = "laziest";
    # strategies = {
    #   "lazy" = {
    #     fanSpeedUpdateFrequency = 5;
    #     movingAverageInterval = 30;
    #     speedCurve = [
    #       {
    #         temp = 0;
    #         speed = 15;
    #       }
    #       {
    #         temp = 50;
    #         speed = 15;
    #       }
    #       {
    #         temp = 65;
    #         speed = 25;
    #       }
    #       {
    #         temp = 70;
    #         speed = 35;
    #       }
    #       {
    #         temp = 80;
    #         speed = 50;
    #       }
    #       {
    #         temp = 85;
    #         speed = 100;
    #       }
    #     ];
    #   };
    # };
  };
}
