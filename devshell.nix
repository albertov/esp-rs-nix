{ inputs, ... }: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = { self', pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      ignoreCollisions = false;
      shellHook = ''
        LIBCLANG_PATH=${self'.packages.llvm-xtensa}/lib
        '';
      packages =
        let
          flakePkgs = with self'.packages; [
            cargo
            cargo-espmonitor
            cargo-espflash
            espmonitor
            ldproxy
            llvm-xtensa
            rust-src
            rustc
            qemu-espressif
            #embuild
          ];
          nixPkgs = with pkgs; [
            cargo-generate
            esptool
            cargo-espflash
            espflash
            # can't get esp32 to compile with 5.2
            # it can with 5.1
            esp-idf-full_51
            gnumake
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
