{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { nixpkgs, home-manager, plasma-manager, ... }:
    let
      vars = import  ./username.nix;
      inherit (vars) username;
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit username; };

        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager

          {
            home-manager.sharedModules = [
              plasma-manager.homeModules.plasma-manager
            ];

            home-manager.users.${username} = {
              imports = [
                ./home/kde.nix
                ./home/browser.nix
              ];
              _module.args = { inherit username; };
            };

            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
}
