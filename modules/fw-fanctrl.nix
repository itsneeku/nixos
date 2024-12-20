{ pkgs, ... }:
{
  programs.fw-fanctrl.enable = true;

  programs.fw-fanctrl.config = {
    defaultStrategy = "laziest";
    strategyOnDischarging = "laziest";
  };
}
