{ inputs, ... }: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = { config, self', pkgs, ... }: {
    devshells.default = {
      packages =
        let
          flakePkgs = with self'.packages; [
            cargo
            cargo-espmonitor
            espmonitor
            ldproxy
            llvm-xtensa
            rust-src
            rustc
          ];
          nixPkgs = with pkgs; [
            cargo-generate
            esptool
            cargo-espflash
            espflash
          ];
        in
        flakePkgs ++ nixPkgs;
      devshell.startup.pre-commit.text = config.pre-commit.installationScript;
    };
  };
}
