{ pkgs, ... }:
{
  programs.fw-fanctrl.enable = true;

  environment.systemPackages = [ pkgs.fw-ectool ];

  programs.fw-fanctrl.config = {
    strategies = {
      "lazy" = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 30;
        speedCurve = [
          {
            temp = 0;
            speed = 15;
          }
          {
            temp = 50;
            speed = 15;
          }
          {
            temp = 65;
            speed = 25;
          }
          {
            temp = 70;
            speed = 35;
          }
          {
            temp = 75;
            speed = 40;
          }
          {
            temp = 85;
            speed = 40;
          }
          {
            temp = 95;
            speed = 50;
          }
          {
            temp = 100;
            speed = 100;
          }
        ];
      };
    };
  };
}
