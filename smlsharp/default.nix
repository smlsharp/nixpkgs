{
  stdenv,
  fetchurl,
  lib,
  gmp,
  llvm_20,
  massivethreads,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smlsharp";
  version = "4.2.0";

  src = fetchurl {
    url = "https://github.com/smlsharp/smlsharp/releases/download/v${finalAttrs.version}/smlsharp-${finalAttrs.version}.tar.gz";
    hash = "sha256-kx+1R2LDCrAYyATmadaWUiz6uv4Kb4XK3v7O4e/3ELc=";
  };

  buildInputs = [
    stdenv.cc
    gmp
    llvm_20
    massivethreads.out
  ];
  nativeBuildInputs = [
    massivethreads.dev
  ];

  preConfigure = ''
    configureFlagsArray+=(
      'CC=${stdenv.cc}/bin/cc'
      'CXX=${stdenv.cc}/bin/c++'
      'LD=${stdenv.cc}/bin/ld'
      'AR=${stdenv.cc}/bin/ar'
      'RANLIB=${stdenv.cc}/bin/ranlib'
      'LDFLAGS=-L${gmp}/lib -L${massivethreads.out}/lib'
    )
  '';

  enableParallelBuilding = true;
  preBuild = ''
    make "-j$NIX_BUILD_CORES" SHELL="$SHELL" stage
  '';

  meta = with lib; {
    description = "Standard ML compiler with practical extensions";
    longDescription = ''
      SML# is a variant of Standard ML programming language
      equipped with practical features including seamless
      interoperability with C, integration with SQL, native
      multithread support, and separate compilation.
    '';
    homepage = "https://smlsharp.github.io";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux;
  };
})
