{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    espmonitor = {
      url = "github:esp-rs/espmonitor";
      flake = false;
    };
    espflash = {
      # >= 3 doesn't support esp8266
      url = "github:esp-rs/espflash/v2.1.0";
      flake = false;
    };
    nixpkgs-esp-dev.url = "github:mirrexagon/nixpkgs-esp-dev";
    embuild = {
      url = "github:ivmarkov/embuild";
      flake = false;
    };
    espressif-llvm-project = {
      url = "github:espressif/llvm-project/esp-16.0.4-20231113";
      flake = false;
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
      systems = [
        "x86_64-linux" "aarch64-darwin"
      ];
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
        ./check.nix
        ./devshell.nix
        ./fmt.nix
      ];
      perSystem = { system, pkgs, self', ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.nixpkgs-esp-dev.overlays.default ];
        };
        packages = {
          cargo = pkgs.callPackage ./cargo.nix { inherit (self'.packages) rustc; };
          cargo-espmonitor = pkgs.callPackage ./cargo-espmonitor.nix { inherit (inputs) espmonitor; };
          espmonitor = pkgs.callPackage ./espmonitor.nix { inherit (inputs) espmonitor; };
          ldproxy = pkgs.callPackage ./ldproxy.nix { inherit (inputs) embuild; };
          llvm-xtensa = pkgs.callPackage ./llvm-xtensa.nix { inherit (inputs) espressif-llvm-project; };
          rust-src = pkgs.callPackage ./rust-src.nix { };
          rustc = pkgs.callPackage ./rustc.nix { inherit (self'.packages) llvm-xtensa; };
          toolchain = pkgs.callPackage ./toolchain.nix { };
          cargo-espflash = pkgs.callPackage ./cargo-espflash.nix { inherit (inputs) espflash;};
        };
        apps = {
          cargo = {
            type = "app";
            program = "${self'.packages.cargo}/bin/cargo";
          };
          espmonitor = {
            type = "app";
            program = "${self'.packages.espmonitor}/bin/espmonitor";
          };
          rustc = {
            type = "app";
            program = "${self'.packages.rustc}/bin/rustc";
          };
        };
        overlayAttrs = self'.packages;
      };
    }
    );
}
