{ lib
, rustPlatform
, embuild
}:

let
  cargoToml = lib.importTOML "${embuild}/ldproxy/Cargo.toml";
in
rustPlatform.buildRustPackage {
  pname = cargoToml.package.name;
  inherit (cargoToml.package) version;

  src = embuild;

  buildAndTestSubdir = "ldproxy";

  cargoHash = "sha256-+5ZB2tYvhY8bjJsOqfBzZ/7fPqHKmWjUt8LNMSom6zU=";

  meta = with lib; {
    inherit (cargoToml.package) description;
    homepage = cargoToml.package.repository;
    licenses = with licenses; [ gpl3 ];
  };
}
