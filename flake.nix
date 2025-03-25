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
    in
    {
      packages = nixpkgs.lib.genAttrs systems (
        system:
        let
          packages = import ./. { pkgs = nixpkgs.legacyPackages.${system}; };
        in
        packages // { default = packages.smlsharp; }
      );
      overlays = {
        packages = final: prev: import ./. { pkgs = final; };
      };
    };
}
