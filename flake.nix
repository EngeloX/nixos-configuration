{
  description = "My NixOS configuration";

  inputs = {
    # Основная система — НЕСТАБИЛЬНАЯ ВЕТКА НЕ ИСПОЛЬЗУЕТСЯ ЗДЕСЬ.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Только для AmneziaVPN.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    plasma-manager,
    ...
  }:

    let
      vars = import ./username.nix;
      inherit (vars) username;

      # Отдельный package set из nixos-unstable.
      unstablePkgs = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit username unstablePkgs;
        };

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

              _module.args = {
                inherit username;
              };
            };

            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
}
