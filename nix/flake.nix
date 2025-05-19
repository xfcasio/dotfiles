{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    amadeus = {
      type = "path";
      path = "/home/toji/nixos/amadeus";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fabric-python = {
      url = "github:Fabric-Development/fabric";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.amadeus = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
      	home-manager.nixosModules.home-manager
      	{
      	  home-manager.useGlobalPkgs = true;
      	  home-manager.users.toji = import ./home.nix;
      	  home-manager.backupFileExtension = "hm-backup";
      	}
      ];
    };

    nixpkgs.overlays = [
      (final: prev: {
        hyprland = prev.hyprland.overrideAttrs (old: {
          postInstall = old.postInstall + ''
            mkdir -p $out/share/hypr
            cp ./amadeus/Wallpapers/blue-clouds.png $out/share/hypr/wall0.png
          '';
        });
      })
    ];
  };
}
