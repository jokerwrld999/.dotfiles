{

    description = "My first flake!";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.05";
        vscode-server.url = "github:nix-community/nixos-vscode-server";
        home-manager.url = "github:nix-community/home-manager/release-24.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, vscode-server, home-manager, ... }:
        let
            system = "x86_64-linux";
            lib = nixpkgs.lib;
            pkgs = nixpkgs.legacyPackages.${system};

            forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

            nixpkgsFor =
                forAllSystems (system: import inputs.nixpkgs { inherit system; });
        in {
        nixosConfigurations = {
            nixos = lib.nixosSystem {
                inherit system;
                modules = [
                    ./configuration.nix
                    vscode-server.nixosModules.default
                ];
            };
        };
        homeConfigurations = {
            jokerwrld = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [
                    ./home.nix
                ];
            };
        };
    };

}