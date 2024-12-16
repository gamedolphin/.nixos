{ pkgs, lib, user, ... }:
{
  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelParams = lib.mkDefault [ "acpi_rev_override" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/210f896f-5359-4ac5-802e-c2015e770e94";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/104A-A8D6";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/26c40599-2710-4361-842c-7448e55af6cf"; }
    ];

  services.fprintd = {
    enable = true;
    package = pkgs.fprintd-tod;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  networking.hostName = "laptopdell";

  home-manager.users.${user}.home.file.hyprland-custom = {
    source = ./hyprland-laptop-dell.conf;
    target = ".config/hypr/hardware.conf";
  };
}
