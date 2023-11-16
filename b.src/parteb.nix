{ mpi, stdenv }:
stdenv.mkDerivation {
  pname = "parteb";
  version = "0.0.1";

  src = ./.;

  buildPhase = ''
    mkdir -p $out/bin
    ${mpi}/bin/mpicc -o $out/bin/parteb parteb.c
  '';
}
