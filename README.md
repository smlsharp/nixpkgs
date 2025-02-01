# SML# nixpkgs repository

This respository provides SML# compiler packages for Nix/NixOS.

## Getting Started

To run SML# on Nix/NixOS, execute the following command:

```sh
nix run github:smlsharp/nixpkgs
```

## Using with Flakes

Include the following in your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    smlsharp = {
      url = "github:smlsharp/nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
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
