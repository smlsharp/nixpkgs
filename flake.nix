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
      getPackages =
        pkgs:
        let
          packages = import ./. { inherit pkgs; };
        in
        if pkgs.stdenv.hostPlatform.isx86 then
          packages
        else
          {
            inherit (packages) massivethreads;
          };
    in
    {
      packages = nixpkgs.lib.genAttrs systems (
        system:
        let
          packages = getPackages nixpkgs.legacyPackages.${system};
        in
        if nixpkgs.lib.hasAttrByPath [ "smlsharp" ] packages then
          packages // { default = packages.smlsharp; }
        else
          packages
      );
      overlays = {
        packages = _: getPackages;
      };
      devShells = nixpkgs.lib.genAttrs systems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            autoconf
            git
            gmp
            llvm
            self.packages.${system}.massivethreads
          ];
        };
      });
    };
}
