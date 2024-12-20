{ ... }:
{
  boot.loader = {
    # Dual boot with Windows 11 (1 drive - 2 bootloader partitions)
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };
}
