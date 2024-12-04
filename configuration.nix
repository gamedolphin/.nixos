# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

with lib;

let
  user = "nambiar";
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    supportedFilesystems = [ "ntfs" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      grub = {
        configurationLimit = 50;
      };

      timeout = 5;
    };
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = ["https://hyprland.cachix.org" "https://nix-community.cachix.org"];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    dates = "weekly";
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  services = {
    blueman.enable = true;
    fwupd.enable = true;
    fprintd.enable = true;
    fstrim.enable = true;
    thermald.enable = true;
    printing.enable = true;
    udisks2.enable = true;
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;

    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images

    avahi = { # printer discovery
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
          user = "nambiar";
        };
      };
    };

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        lightdm.background = ./lock.png;
        # gdm = {
        #   enable = true;
        #   wayland = true;
        # };
      };

      xkb.layout = "us";
      xkb.options = "ctrl:nocaps";
      xkb.variant = "";
      dpi = 196;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    zip
    unzip
    binutils
    dmidecode
    usbutils
    libnotify
    swww
    kitty
    tofi
    killall
    pamixer
    cmake
    gnumake
    udiskie
    steam-run
    glibc
    python3
    openvpn
    cacert
    nh
    gparted
    lxqt.lxqt-policykit
    greetd.tuigreet
    openssl
    vulkan-headers
    vulkan-loader
    vulkan-tools
    virt-viewer
    spice spice-gtk
    spice-protocol
    win-virtio
    win-spice
  ];

  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  users.extraGroups.vboxusers.members = [ "nambiar" ];

  environment.sessionVariables = {
    XCURSOR_SIZE = "24";
    EDITOR = "emacs";
    NIXOS_OZONE_WL = "1";
    FLAKE = "/home/nambiar/.nixos";
  };

  console.useXkbConfig = true;

  users.users.${user} = {
    isNormalUser = true;
    description = "Sandeep Nambiar";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" "scanner" "lp" "libvirtd"];
    shell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];

  programs = {
    nix-ld.enable = true;

    virt-manager.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    zsh.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    appimage.enable = true;

    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };

    file-roller.enable = true; # thunar zip support

    firefox.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  security = {
    # for pipewire
    rtkit.enable = true;

    polkit.enable = true;

    pam = {
      # for sway things
      services.swaylock = {};
      services.gdm.enableGnomeKeyring = true;

      loginLimits = [{
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "100000";
      }];
    };
  };

  fonts.packages = [pkgs.iosevka];

  system.stateVersion = "24.11";
}
