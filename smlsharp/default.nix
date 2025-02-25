{
  stdenv,
  fetchurl,
  lib,
  binutils,
  gcc,
  gmp,
  llvm_19,
  massivethreads,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smlsharp";
  version = "4.1.0";

  src = fetchurl {
    url = "https://github.com/smlsharp/smlsharp/releases/download/v${finalAttrs.version}/smlsharp-${finalAttrs.version}.tar.gz";
    hash = "sha256-sZVDpCZU9L2h1pDG6m5NnuFtx1RLlYKPinxkngkZqKE=";
  };

  buildInputs = [
    stdenv.cc
    gmp
    llvm_19
    massivethreads.out
  ];
  nativeBuildInputs = [
    massivethreads.dev
  ];

  enableParallelBuilding = true;
  preBuild = ''
    make "-j$NIX_BUILD_CORES" SHELL="$SHELL" stage
  '';

  postInstall = ''
    substituteInPlace $out/lib/smlsharp/config.mk \
      --replace-fail 'CC = gcc' \
                     'CC = ${stdenv.cc}/bin/cc' \
      --replace-fail 'CXX = g++' \
                     'CXX = ${stdenv.cc}/bin/c++' \
      --replace-fail 'LD = ld' \
                     'LD = ${stdenv.cc}/bin/ld' \
      --replace-fail 'AR = ar' \
                     'AR = ${stdenv.cc}/bin/ar' \
      --replace-fail 'RANLIB = ranlib' \
                     'RANLIB = ${stdenv.cc}/bin/ranlib' \
      --replace-fail 'LDFLAGS =' \
                     'LDFLAGS = -L${gmp}/lib -L${massivethreads.out}/lib'
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
    ];
  };
})
