{
  description = "tender-session - A clear and calm NixOS desktop session";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.callPackage ./nix/default.nix { };
        
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nix
            git
          ];
        };
      }
    ) // {
      # NixOS module for easy integration
      nixosModules.default = import ./nix/module.nix;
    };
}
