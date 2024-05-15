{ config, pkgs, lib, ... }:
with lib;
{
  boot.kernelModules = [ "kvm-intel" ];
  
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8d7c70be-5caf-4afc-8d83-7ebb2c247250";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A3C3-AE38";
      fsType = "vfat";
    };

  networking.hostName = "devhub";

  swapDevices =
    [ { device = "/dev/disk/by-uuid/f1485171-b780-4bae-b2ba-43946cd4b465"; }
    ];
}
