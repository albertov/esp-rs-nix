{ lib
, callPackage
, llvm-xtensa
, rustc
, stdenv
, file
, python3
, cmake
, which
, libffi
, removeReferencesTo
, pkg-config
, xz
, openssl
, pkgsBuildHost
, cargo
}:

let
  rust = callPackage ./rust.nix { };
  cargoDeps = rust.bootstrapCargoDeps;
in
stdenv.mkDerivation (_finalAttrs: {
  pname = "esp32-rustc";
  inherit (rust) version src;
  inherit cargoDeps;
  configureFlags =
    let
      setBuild = "--set=target.${stdenv.buildPlatform.rust.rustcTarget}";
      setHost = "--set=target.${stdenv.hostPlatform.rust.rustcTarget}";
      setTarget = "--set=target.${stdenv.targetPlatform.rust.rustcTarget}";
    in
    [
      "--llvm-root=${llvm-xtensa}"
      "--experimental-targets=Xtensa"
      "--release-channel=nightly"
      "--sysconfdir=${placeholder "out"}/etc"
      "--set=build.rustc=${rustc}/bin/rustc"
      "--set=build.cargo=${cargo}/bin/cargo"
      "--enable-vendor"
      "--enable-rpath"
      "--enable-llvm-link-shared"
      "${setBuild}.llvm-config=${llvm-xtensa}/bin/llvm-config"
      "${setHost}.llvm-config=${llvm-xtensa}/bin/llvm-config"
      "${setTarget}.llvm-config=${llvm-xtensa}/bin/llvm-config"
      "--tools=rustc,rust-analyzer-proc-macro-srv"
    ];

  # rustc unfortunately needs cmake to compile llvm-rt but doesn't
  # use it for the normal build. This disables cmake in Nix.
  dontUseCmakeConfigure = true;

  depsBuildBuild = [ pkgsBuildHost.stdenv.cc pkg-config ];

  nativeBuildInputs = [
    file
    python3
    rustc
    cmake
    which
    libffi
    removeReferencesTo
    pkg-config
    xz
    llvm-xtensa
  ];

  buildInputs = [ openssl llvm-xtensa ];

  postPatch = ''
    patchShebangs src/etc

    rm -rf src/llvm

    mkdir .cargo
    cat > .cargo/config <<\EOF
    [source.crates-io]
    replace-with = "vendored-sources"
    [source.vendored-sources]
    directory = "vendor"
    EOF
  '';

  postConfigure = ''
    unpackFile "$cargoDeps"
    mv $(stripHash $cargoDeps) vendor
    # export VERBOSE=1
  '';
  postInstall = ''
    mkdir -p $out/lib/rustlib/src

    ln -s $src $out/lib/rustlib/src/rust
    mkdir $out/vendor

    ln -s $src/library/rustc-std-workspace-alloc $out/vendor/rustc-std-workspace-alloc
    ln -s $src/library/rustc-std-workspace-core $out/vendor/rustc-std-workspace-core
    ln -s $src/library/rustc-std-workspace-std $out/vendor/rustc-std-workspace-std
  '';
  meta = with lib; {
    homepage = "https://www.rust-lang.org/";
    description = "A safe, concurrent, practical language";
    license = [ licenses.mit licenses.asl20 ];
    platforms = [
      "x86_64-linux"
      "xtensa-esp32-espidf"
      "xtensa-esp32-none-elf"
      "xtensa-esp32s2-espidf"
      "xtensa-esp32s2-none-elf"
      "xtensa-esp32s3-espidf"
      "xtensa-esp32s3-none-elf"
      "xtensa-esp8266-none-elf"
    ];
  };

  passthru = {
    llvm = llvm-xtensa;
  };
})
