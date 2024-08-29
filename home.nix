{ pkgs, lib, ...}:

with lib;
let
  user = "nambiar";
  lockCmd = "${pkgs.swaylock}/bin/swaylock --image ~/.nixos/lock.png";
in
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    nordzy-icon-theme
    nordzy-cursor-theme
    audacity
    zoom-us
    handbrake
    davinci-resolve
    sway-contrib.grimshot
    unityhub
    nordic # theme
    upwork
    nil
    omnisharp-roslyn
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
    everdo
    wlogout
    swayidle
    swaylock
    dunst
    mold
  ];

  services.dunst.enable = true;

  programs = {
    wlogout = {
      enable = true;
      layout = [
        {
          "label"  = "lock";
          "action" = lockCmd;
          "text" = "Lock";
          "keybind" = "l";
        }
        {
          "label" = "hibernate";
          "action" = "systemctl hibernate";
          "text" = "Hibernate";
          "keybind" = "h";
        }
        {
          "label" = "logout";
          "action" = "loginctl terminate-user $USER";
          "text" = "Logout";
          "keybind" = "e";
        }
        {
          "label" = "shutdown";
          "action" = "systemctl poweroff";
          "text" = "Shutdown";
          "keybind" = "s";
        }
        {
          "label" = "suspend";
          "action" = "${lockCmd} & systemctl suspend";
          "text" = "Suspend";
          "keybind" = "u";
        }
        {
          "label" = "reboot";
          "action" = "systemctl reboot";
          "text" = "Reboot";
          "keybind" = "r";
        }
      ];
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    swaylock = {
      enable = true;
      settings = {
        color = "808080";
        font-size = 24;
        indicator-idle-visible = false;
        indicator-radius = 100;
        line-color = "ffffff";
        show-failed-attempts = true;
      };
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
            format =  "{:%Y-%m-%d %H:%M:%S}";
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
      name = "Nordzy-icon";
      package = pkgs.nordzy-icon-theme;
    };
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    cursorTheme = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
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
  };

  home.sessionPath = [
      "$HOME/.cargo/bin"
  ];

  programs.home-manager.enable =  true;
}
