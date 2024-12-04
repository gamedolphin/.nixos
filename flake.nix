{
  description = "Sandeep's nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { nixpkgs, lix-module, home-manager, emacs-overlay, ... } :
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      common_modules = [
        lix-module.nixosModules.default
        {
          nixpkgs.overlays = [
            emacs-overlay.overlays.default
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
