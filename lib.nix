{ host, ... }:
{
  config,
  lib,
  ...
}:
{
  options = with lib; {
    host = mkOption {
      type = types.str;
    };
    user = mkOption {
      type = types.str;
    };
    createSymlink = mkOption {
      type = types.submodule;
    };
    hm = mkOption {
      type = types.attrsOf types.anything;
    };
  };

  config.host = host;
  config.user = "neeku";
}
