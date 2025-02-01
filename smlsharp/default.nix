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
    binutils
    gcc
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
                     'CC = ${gcc}/bin/gcc' \
      --replace-fail 'CXX = g++' \
                     'CXX = ${gcc}/bin/g++' \
      --replace-fail 'LD = ld' \
                     'LD = ${binutils}/bin/ld' \
      --replace-fail 'AR = ar' \
                     'AR = ${binutils}/bin/ar' \
      --replace-fail 'RANLIB = ranlib' \
                     'RANLIB = ${binutils}/bin/ranlib' \
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
