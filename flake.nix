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
      pkgs = system: import ./. { pkgs = nixpkgs.legacyPackages.${system}; };
      packages = nixpkgs.lib.genAttrs systems pkgs;
      addDefault = k: packages: packages // { default = packages.${k}; };
    in
    {
      packages = nixpkgs.lib.mapAttrs (_: addDefault "smlsharp") packages;
      devShells = nixpkgs.lib.mapAttrs (
        system: packages:
        packages // { default = nixpkgs.legacyPackages.${system}.mkShell {
          inputsFrom = [ packages.smlsharp ];
          packages = [ nixpkgs.legacyPackages.${system}.autoconf ];
        }; }
      ) packages;
      overlays = {
        packages = final: prev: pkgs final.system;
      };
    };
}
