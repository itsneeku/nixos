{ lib, user, ... }:

with lib;
{
  imports = [ (mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ]) ];

  options.user = mkOption {
    default = user;
    readOnly = true;
    type = types.str;
  };
}
