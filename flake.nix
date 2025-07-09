{
  description = "Dont really matter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-browser.url = "github:FBIGlowie/zen-browser-flake";
    swww.url = "github:LGFae/swww";
#    niri.url = "github:sodiboo/niri-flake";
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
#          {
#            nixpkgs.overlays = [
#              inputs.niri.overlays.niri
#            ];
#          }
          ./nixos/configuration.nix
        ];
      };
    }; 
  }
