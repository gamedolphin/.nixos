{
  description = "Sandeep's nixos configuration";

  inputs = {
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-pinned.url = "github:nixos/nixpkgs/179e0f110d859ec7f64c52de56de5b264d5db98a";
  };

  outputs = { self, nixpkgs, lix-module, home-manager, hyprland-pinned }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
      hyprland-custom = import hyprland-pinned {
        inherit system;
      };
      common_modules = [
        lix-module.nixosModules.default
        {
          nixpkgs.overlays = [
            (final: prev: {
              hyprland = hyprland-custom.hyprland;
            })
           ];
        }
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nambiar = {
            imports =  [./home.nix];
          };
        }
      ];
    in {
      nixosConfigurations = {
        bigbox = lib.nixosSystem {
          inherit system;
          modules = common_modules ++ [./home-pc.nix];
        };

        laptopdell= lib.nixosSystem {
          inherit system;
          modules = common_modules ++ [./laptop-dell.nix];
        };
      };
    };
}
