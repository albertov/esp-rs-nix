{ inputs, ... }: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = { self', pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      ignoreCollisions = false;
      packages =
        let
          flakePkgs = with self'.packages; [
            cargo
            cargo-espmonitor
            cargo-espflash
            espmonitor
            ldproxy
            #llvm-xtensa
            rust-src
            rustc
            qemu-espressif
            #embuild
          ];
          nixPkgs = with pkgs; [
            #clang
            cargo-generate
            esptool
            cargo-espflash
            espflash
            esp-idf-full
            rustPlatform.bindgenHook
            #git
            gnumake
            #flex
            #bison
            pkg-config
            cmake
            ninja
            #ncurses5

            #python3
            #python3Packages.pip
            #python3Packages.virtualenv
          ];
        in
        flakePkgs ++ nixPkgs;
      #devShells.startup.pre-commit.text = config.pre-commit.installationScript;
    };
  };
}
