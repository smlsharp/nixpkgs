{
  stdenv,
  fetchurl,
  lib,
  autoconf269,
  automake116x,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "massivethreads";
  version = "1.02";

  src = fetchurl {
    url = "https://github.com/massivethreads/massivethreads/archive/v${finalAttrs.version}.tar.gz";
    hash = "sha256-svYyD1HL+8BRImphuvkyPAFsKPAzKD4mkAdJOvqwEjw=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  nativeBuildInputs = [
    autoconf269
    automake116x
    libtool
  ];

  preConfigure = ''
    autoreconf -fvi
  '';

  enableParallelBuilding = true;

  doCheck = true;
  enableParallelChecking = false;
  preCheck = ''
    make -j"$NIX_BUILD_CORES" SHELL="$SHELL" -C tests build
    export MYTH_NUM_WORKERS=2
  '';

  # drview depends on Python2, which have reached end of life.
  postInstall = ''
    rm $bin/bin/drview
  '';

  meta = with lib; {
    description = "Lightweight thread library for high productivity languages";
    longDescription = ''
      MassiveThreads is a user-level thread library that can create
      a massive number of lightweight threads that are significantly
      faster than native operating system threads.
    '';
    homepage = "https://github.com/massivethreads/massivethreads";
    license = licenses.bsd2;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
