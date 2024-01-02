{ callPackage
, cargo
, rustc
}:

let
  rust = callPackage ./rust.nix { };
in
cargo.overrideAttrs (_oA: {
  name = "cargo-xtensa";
  inherit (rust) version src cargoDeps;
  buildAndTestSubdir = "src/tools/cargo";
  passthru = {
    inherit rustc;
  };

  postConfigure = ''
    unpackFile "$cargoDeps"
    mv $(stripHash $cargoDeps) vendor
    # export VERBOSE=1
  '';

  postInstall = ''
    wrapProgram "$out/bin/cargo" --suffix PATH : "${rustc}/bin"

    installManPage src/tools/cargo/src/etc/man/*

    installShellCompletion --bash --name cargo \
      src/tools/cargo/src/etc/cargo.bashcomp.sh

    installShellCompletion --zsh src/tools/cargo/src/etc/_cargo
  '';
})
