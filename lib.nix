{
  host,
  lib,
  user,
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
      type = types.str;
    };
  };

  # config.host = host;
  # config.user = "neeku";
  # config.hm = "home-manager.users.${user}";
}
