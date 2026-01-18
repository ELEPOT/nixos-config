{
  description = "Dont really matter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    assets = {
      url = "github:ELEPOT/nixos-assets";
      flake = false;
    };

    reaper-config = {
      url = "github:ELEPOT/reaper-config";
      flake = false;
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };

    alacritty-catppuccin = {
      url = "github:catppuccin/alacritty";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-master,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };

    pkgs-master = import nixpkgs-master {
      inherit system;
      config = {allowunfree = true;};
    };

    functions = {
      ifExists = file: pkgs.lib.optional (builtins.pathExists file) file;
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs functions pkgs-master;};
      modules = [
        ./nixos-config/configuration.nix
        ./device-specific/hardware-configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.elepot = import ./nixos-config/home.nix;
            users.guest = import ./nixos-config/home-guest.nix;
            extraSpecialArgs = {inherit inputs functions pkgs-master;};
          };
        }
      ];
    };
  };
}
