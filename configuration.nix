# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

with lib;

let
  user = "nambiar";
  ld_path_libs = with pkgs; [
    openssl_1_1
    udev
    alsa-lib
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr # To use the x11 feature
    libxkbcommon wayland # To use the wayland feature
  ];

  unityhub-local = (pkgs.callPackage ./unityhub { });
  unityhub-rusty = unityhub-local.overrideAttrs (prevAttrs: {
    nativeBuildInputs = (prevAttrs.nativeBuildInputs or []) ++ [ pkgs.makeWrapper pkgs.pkg-config ];
    buildInputs = (prevAttrs.buildInputs or []) ++ ld_path_libs;

    postInstall = prevAttrs.postInstall or "" + ''
      wrapProgram "$out/bin/unityhub" --set LD_LIBRARY_PATH ${lib.makeLibraryPath ld_path_libs}
    '';
  });

  dotnet_pkgs = (with pkgs.dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_7_0
      sdk_8_0
    ]);
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
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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
    firewall.enable = false;
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

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        lightdm.background = ./lock.png;
        gdm = {
          enable = true;
          wayland = true;
        };
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
    elementary-xfce-icon-theme
    zuki-themes
    dunst
    libnotify
    swww
    kitty
    tofi
    killall
    swaylock
    pamixer
    audacity
    appimage-run
    zoom-us
    cmake
    gnumake
    udiskie
    ollama
    handbrake
    davinci-resolve
    sway-contrib.grimshot
    steam-run
    glibc
    gcc
    clang
    clang-tools_16
    bear
    python3
    graphviz
    tailwindcss
    sqlitebrowser
    dotnet_pkgs
    (unityhub-rusty.override {
      extraLibs = pkgs: with pkgs; [
        openssl_1_1
        pkg-config
        udev
        alsa-lib
        vulkan-loader
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr # To use the x11 feature
        libxkbcommon wayland # To use the wayland feature
      ];
    })
    mold # linker
    nordic # theme
    just # build runner
    cargo-flamegraph # profiling
    brightnessctl # screen brightness controller
    openvpn
    terraform
    cacert
    nh
  ];

  virtualisation.docker.enable = true;

  environment.sessionVariables = {
    XCURSOR_SIZE = "132";
    EDITOR = "emacs";
    FrameworkPathOverride="${pkgs.mono}/lib/mono/4.5";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    CARGO_TARGET_DIR = "/home/nambiar/.cargo/target";
    DOTNET_ROOT = "${dotnet_pkgs}";
    FLAKE = "/home/nambiar/.nixos";
  };

  console.useXkbConfig = true;

  users.users.${user} = {
    isNormalUser = true;
    description = "Sandeep Nambiar";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];

  programs = {
    nix-ld.enable = true; # for dotnet linking
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

    firefox.enable = true;
  };

  security = {
    # for pipewire
    rtkit.enable = true;

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

  system.stateVersion = "23.05";
}
