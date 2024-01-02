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
            cargo-espflash
            cargo-espmonitor
            espflash
            espmonitor
            ldproxy
            llvm-xtensa
            rust-src
            rustc
          ];
          nixPkgs = with pkgs; [
            cargo-generate
            esptool
          ];
        in
        flakePkgs ++ nixPkgs;
      devshell.startup.pre-commit.text = config.pre-commit.installationScript;
    };
  };
}
