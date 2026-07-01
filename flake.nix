{
  description = "Nix Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    googleworkspace-cli = {
      url = "github:googleworkspace/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, googleworkspace-cli, ... }:
    let
      system = "x86_64-linux";
      overlay = final: prev: {
        gws = googleworkspace-cli.packages.${final.stdenv.hostPlatform.system}.default;
      };
      pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
    in {
      nixosConfigurations = {
        karpalo = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
            }
            {
              nixpkgs.overlays = [ overlay ];
            }
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.pexea12 = {
                  imports = [ ./home.nix ];
                };
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };
    };
  # TODO: use variable for pexea12 and karpalo
}
