{ lib
, rustPlatform
, embuild
}:

let
  cargoToml = lib.importTOML "${embuild}/Cargo.toml";
in
rustPlatform.buildRustPackage {
  pname = cargoToml.package.name;
  inherit (cargoToml.package) version;

  src = embuild;
  cargoHash = "sha256-40CcEmmD8TPkpTiIyZV1ejB7W1ZAGlnbQyvQWs+zl/U=";

  meta = with lib; {
    inherit (cargoToml.package) description;
    homepage = cargoToml.package.repository;
  };
}
