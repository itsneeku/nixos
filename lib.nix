{host, ...}: {
  config,
  lib,
  ...
}: {
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
  };

  config.host = host;
  config.user = "neeku";

  config.createSymlink = localPath:
    config.lib.file.mkOutOfStoreSymlink "home/${config.user}/.nixos/modules/${localPath}";
}
