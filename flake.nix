{
  description = "SML# package repository";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      packages = nixpkgs.lib.genAttrs systems (
        system:
        import ./default.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        }
      );
    in
    {
      packages = {
        x86_64-linux = rec {
          inherit (packages.x86_64-linux) massivethreads smlsharp;
          default = smlsharp;
        };
        x86_64-darwin = rec {
          inherit (packages.x86_64-darwin) massivethreads smlsharp;
          default = smlsharp;
        };
        aarch64-linux = {
          inherit (packages.aarch64-linux) massivethreads;
        };
        aarch64-darwin = {
          inherit (packages.aarch64-darwin) massivethreads;
        };
      };
      devShells = nixpkgs.lib.genAttrs systems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            autoconf
            git
            gmp
            llvm
            packages.${system}.massivethreads
          ];
        };
      });
    };
}
