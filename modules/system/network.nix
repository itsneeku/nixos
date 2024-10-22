{
  config,
  pkgs,
  ...
}: {
  networking = {
    hostName = config.host;
    networkmanager.enable = true;
    nameservers = ["1.1.1.1"];
  };

  services.sunshine = {
    enable = true;
    autoStart = false;
    settings = {
      encoder = "amdvce";
      capture = "kms";
    };
  };
  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [47984 47989 47990 48010];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
      #{ from = 8000; to = 8010; }
    ];
  };

  environment.systemPackages = with pkgs; [
    moonlight-qt
  ];
  services.cloudflare-warp.enable = true;
}
