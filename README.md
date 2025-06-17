# SML# nixpkgs repository

This respository provides SML# compiler packages for Nix/NixOS.

## Getting Started

To run SML# on Nix/NixOS, execute the following command:

```sh
nix run github:smlsharp/nixpkgs
```

## Using with Flakes

Include this respository as an input in your `flake.nix` and add overlay
to include smlsharp into nixpkgs.

For example:

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.smlsharp.url = "github:smlsharp/nixpkgs";
  inputs.smlsharp.inputs.nixpkgs.follows = "nixpkgs";
  outputs =
    { self, nixpkgs, smlsharp }:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs.overlays = [ smlsharp.overlays.packages ]; }
          ./configuratrion.nix
        ];
      };
    };
}
```

## Build Environment

Start a bash shell by

```sh
nix develop github:smlsharp/nixpkgs
```

If you'd like to rebuild minismlsharp, install LLVM 7 by the following command:

```sh
nix build github:nixos/nixpkgs/nixos-23.11#llvm_7.dev -o llvm7
```

Then, you will find `llvm7-dev` symbolic link in the current directory.

## License

MIT
