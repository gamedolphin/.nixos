{
  description = "Sandeep's nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
      common_modules = [
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

        devhub = lib.nixosSystem {
          inherit system;
          modules = common_modules ++ [./devhub-pc.nix];
        };

        laptopdell= lib.nixosSystem {
          inherit system;
          modules = common_modules ++ [./laptop-dell.nix];
        };
      };
    };
}
