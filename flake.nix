{
  description = "Dont really matter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:DanMyers300/zen-browser-flake";

    assets = {
      url = "github:ELEPOT/nixos-assets";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };

    functions = {
      ifExists = file: pkgs.lib.optional (builtins.pathExists file) file;
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs functions;};
      modules = [
        ./nixos/configuration.nix
        ./nixos/hardware-configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.elepot = import ./home.nix;
            extraSpecialArgs = {inherit inputs functions;};
          };
        }
      ];
    };
  };
}
