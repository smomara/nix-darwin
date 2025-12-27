{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      stylix,
    }:
    {
      darwinConfigurations."Seans-MacBook-Air" = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          stylix.darwinModules.stylix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.somara = import ./home.nix;
              sharedModules = [ stylix.homeModules.stylix ];
            };
          }
        ];
      };
    };
}
