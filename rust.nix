{ callPackage
, fetchFromGitHub
}:

rec {
  version = "1.74.0.1";

  src = callPackage ./rust-src.nix { };

  fetchCargoTarball = callPackage ./fetch-cargo-tarball { };

  cargoDeps = fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/src/tools/cargo";
    sha256 = "sha256-sBPaCWjjylAtf9nXy7635TPmht3PRkuV84DomFtjlAM=";
  };

  bootstrapCargoDeps = fetchCargoTarball {
    inherit src;
    sha256 = "sha256-vAPVxNBL9ye7LyCS2iHM5M1OCdlixoqpKtsaRjH5aec=";
    cargoVendorOptions = "-s src/bootstrap/Cargo.toml -s src/tools/rust-analyzer/Cargo.toml";
  };

}
