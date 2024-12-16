# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, user, stateVersion, ... }:

with lib;

let
  locale = "sv_SE.UTF-8";
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
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w" #for unity 2021
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd 'uwsm start hyprland-uwsm.desktop'";
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
      };
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
    uwsm
    hyprland
  ];

  virtualisation = {
    docker.enable = true;
  };

  environment.sessionVariables = {
    XCURSOR_SIZE = "24";
    EDITOR = "emacs";
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "Nordzy-cursors";
    HYPRCURSOR_THEME = "Nordzy-cursors";
    HYPRCURSOR_SIZE = "24";
    FLAKE = "/home/${user}/.nixos";
  };

  console.useXkbConfig = true;

  users.users.${user} = {
    isNormalUser = true;
    description = "Sandeep Nambiar";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" "scanner" "lp"];
    shell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];

  programs = {
    uwsm.enable = true;
    uwsm.waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
    
    nix-ld.enable = true;

    hyprland = {
      withUWSM  = true;
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
    wireshark.enable = true;
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

  system.stateVersion = stateVersion;
}
