{ config, pkgs, lib, ... }:
with lib;
{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/911d76da-1990-4e83-aefb-fa116e9cd0ee";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/BAD3-5A84";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/18818348-1ee4-4fa5-9984-e4e01b9fa304";
      fsType = "ext4";
    };

  swapDevices = [ ];

  hardware.sane.extraBackends = [ pkgs.sane-airscan pkgs.utsushi ];
  services.udev.packages = [ pkgs.utsushi ]; # scanner backend for epson

  home-manager.users.nambiar.home.file.hyprland-custom = {
    source = ./hyprland-home-pc.conf;
    target = ".config/hypr/hardware.conf";
  };

  networking.hostName = "bigbox";
}
