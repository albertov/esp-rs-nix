{ lib
, stdenv
, espressif-llvm-project
, python3
, cmake
, ninja

, rsync
}:
let
  # TODO: make this the main export of the file and do symlink in installPhase
  llvm-xtensa = stdenv.mkDerivation rec {
    name = "llvm-xtensa";
    version = "16.0.0";

    src = espressif-llvm-project;

    buildInputs = [
      python3
      cmake
      ninja
    ];

    sourceRoot = "source/llvm";

    cmakeFlags = [
      "-DLLVM_ENABLE_PROJECTS='clang'"
      "-DLLVM_INSTALL_UTILS=ON"
      "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD='Xtensa'"
      "-DLLVM_LINK_LLVM_DYLIB=ON"
    ];

    meta = with lib; {
      description = "LLVM xtensa";
      homepage = "https://github.com/espressif/llvm-project";
      license = licenses.asl20;
    };
  };
in
stdenv.mkDerivation {
  name = "llvm-xtensa-wrapped";
  version = "16.0.0";

  src = llvm-xtensa;

  buildInputs = [
    rsync
  ];

  phases = [ "buildPhase" ];

  buildPhase = ''
    mkdir $out
    rsync -av --no-perms $src/ $out/
    chmod -R +w $out
    ln -s $out/lib/libLLVM.dylib $out/lib/libLLVM-16.dylib
  '';
}
