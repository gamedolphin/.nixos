{ config, pkgs, lib, ... }:
with lib;
{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b391aaf2-cf17-4119-8060-fe78efde6e4e";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3054-12FD";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/18818348-1ee4-4fa5-9984-e4e01b9fa304";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/b088731c-d5e0-4e5e-a5d9-9852dd619c95"; }
    ];

  home-manager.users.nambiar.home.file.hyprland-custom = {
    source = ./hyprland-home-pc.conf;
    target = ".config/hypr/hardware.conf";
  };
}
