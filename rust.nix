{ callPackage }:

rec {
  version = "1.75.0.0";

  src = callPackage ./rust-src.nix { };

  fetchCargoTarball = callPackage ./fetch-cargo-tarball { };

  cargoDeps = fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/src/tools/cargo";
    sha256 = "sha256-sBPaCWjjylAtf9nXy7635TPmht3PRkuV84DomFtjlAM=";
  };

  bootstrapCargoDeps = fetchCargoTarball {
    inherit src;
    sha256 = "sha256-iAc7UUR49xPchuy30oU008l7Eq/ZKze6Xxja46tXwik";
    cargoVendorOptions = "-s src/bootstrap/Cargo.toml -s src/tools/rust-analyzer/Cargo.toml";
  };

}
