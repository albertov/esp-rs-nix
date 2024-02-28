{ inputs, ... }: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = { self', pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      ignoreCollisions = true;
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
          ];
          nixPkgs = with pkgs; [
            clang
            cargo-generate
            esptool
            #cargo-espflash
            espflash
            esp8266-rtos-sdk
          ];
        in
        flakePkgs ++ nixPkgs;
      #devShells.startup.pre-commit.text = config.pre-commit.installationScript;
    };
  };
}
