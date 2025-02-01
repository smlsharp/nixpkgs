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

## License

MIT
