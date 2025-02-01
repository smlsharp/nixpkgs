{
  pkgs ? import <nixpkgs> { },
}:

let
  massivethreads = pkgs.callPackage ./massivethreads { };
  smlsharp = pkgs.callPackage ./smlsharp { inherit massivethreads; };
in
{
  inherit massivethreads smlsharp;
}
