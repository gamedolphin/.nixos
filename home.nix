{ configs, pkgs, lib, ...}:

with lib;
let
  user = "nambiar";
in
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    xdg-utils
    vlc
    discord
    vscode
    slack
    git
    git-lfs
    vim
    htop
    silver-searcher
    pavucontrol
    (
    pkgs.appimageTools.wrapType2 {
      name = "everdo";
      src = fetchurl {
        url = "https://release.everdo.net/1.9.0/Everdo-1.9.0.AppImage";
        hash = "sha256-0yxAzM+qmgm4E726QDYS9QwMdp6dUcuvjZzWYEZx7kU=";
      };
    }
    )
  ];

  xdg.desktopEntries = {
    everdo = {
      name = "Everdo";
      genericName = "Todos";
      exec = "everdo";
      terminal = false;
      categories = [ "Office" ];
    };
  };

  services.dunst.enable = true;
  services.swayidle.enable = true;

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    swaylock = {
      enable = true;
    };

    obs-studio.enable = true;

    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
    };

    git = {
      lfs.enable = true;
      enable = true;
      userName  = "gamedolphin";
      userEmail = "7590634+gamedolphin@users.noreply.github.com";
    };

    alacritty = {
      enable = true;
      settings = {
        font.normal.family = "Iosevka";
        font.size = 12;
        shell.program = "zsh";

        window = {
          padding.x = 4;
          padding.y = 4;
        };

        colors = {
          primary = {
            background = "#1f222d";
            foreground = "#d8dee9";
            dim_foreground = "#a5abb6";
          };
          cursor = {
            text = "#2e3440";
            cursor = "#d8dee9";
          };
          normal = {
            black = "#3b4252";
            red = "#bf616a";
            green = "#a3be8c";
            yellow = "#ebcb8b";
            blue = "#81a1c1";
            magenta = "#b48ead";
            cyan = "#88c0d0";
            white = "#e5e9f0";
          };
        };
      };
    };

    emacs = {
      enable = true;
      package = (pkgs.emacs-pgtk.override { withTreeSitter = true; });
      extraPackages = epkgs: [ epkgs.manualPackages.treesit-grammars.with-all-grammars ];
    };

    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 24;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "clock" "tray" "battery" ];
          "tray" = {
            spacing = 10;
          };
          "clock" = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt =  "{:%Y-%m-%d}";
          };
          "cpu" = {
            format = "{usage}% ";
            tooltip = false;
          };
          "memory" = {
            format = "{}% ";
          };
          "temperature"= {
            "critical-threshold" = 80;
            "format"= "{temperatureC}°C {icon}";
            "format-icons"= ["" "" ""];
          };
          "network"= {
            "format-wifi"= "{essid} ({signalStrength}%) ";
            "format-ethernet"= "{ifname}= {ipaddr}/{cidr}";
            "tooltip-format"= "{ifname} via {gwaddr} ";
            "format-linked"= "{ifname} (No IP) ";
            "format-disconnected"= "Disconnected ⚠";
          };
          "pulseaudio"= {
            "format"= "{volume}% {icon} {format_source}";
            "format-bluetooth"= "{volume}% {icon} {format_source}";
            "format-bluetooth-muted"= " {icon} {format_source}";
            "format-muted"= " {format_source}";
            "format-source"= "{volume}% ";
            "format-source-muted"= "";
            "format-icons"= {
              "headphone"= "";
              "default"= ["" "" ""];
            };
            "on-click"= "pavucontrol";
          };
        };
      };
      style = ./waybar.css;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "elementary-Xfce-dark";
      package = pkgs.elementary-xfce-icon-theme;
    };
    theme = {
      name = "nordic";
      package = pkgs.nordic;
    };
  };

  home.file = {
    background = {
      source = ./background.png;
      target = ".background-image";
    };

    emacs-init = {
      source = ./emacs/early-init.el;
      target = ".emacs.d/early-init.el";
    };

    emacs = {
      source = ./emacs/init.el;
      target = ".emacs.d/init.el";
    };

    hyprland = {
      source = ./hyprland.conf;
      target = ".config/hypr/hyprland.conf";
    };

    tofi = {
      source = ./tofi-config;
      target = ".config/tofi/config";
    };

    ".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold-wrapped}/bin/mold"]
    '';
  };

  home.sessionPath = [
      "$HOME/.cargo/bin"
  ];

  programs.home-manager.enable =  true;
}
