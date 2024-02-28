{ lib
, rustPlatform
, espflash
, pkg-config
, udev
, openssl
}:

let
  cargoToml = lib.importTOML "${espflash}/cargo-espflash/Cargo.toml";
in
rustPlatform.buildRustPackage {
  pname = cargoToml.package.name;
  inherit (cargoToml.package) version;

  src = espflash;
  OPENSSL_NO_VENDOR=1;

  buildAndTestSubdir = "cargo-espflash";

  cargoLock.lockFile = "${espflash}/Cargo.lock";

  nativeBuildInputs = [ pkg-config openssl ];

  buildInputs = [ udev openssl.dev ];

  meta = with lib; {
    inherit (cargoToml.package) description;
    homepage = cargoToml.package.repository;
    licenses = with licenses; [ gpl2 ];
  };
}
