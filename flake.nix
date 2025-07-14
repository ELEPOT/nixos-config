{
  description = "Dont really matter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-browser.url = "github:DanMyers300/zen-browser-flake";
    swww.url = "github:LGFae/swww";
  };

  outputs = { self, nixpkgs, ... } @ inputs:

  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
  
  in { 
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit system inputs; };
        modules = [
          ./nixos/configuration.nix
        ];
      };
    }; 
  }
