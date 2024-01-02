# esp-rs with nix

[esp-rs] is a project that contains libraries, crates and examples for using Rust on Espressif SoC's.

This repository package [esp-rs] tools with [nix]. Packages can then be used with `nix run` or `nix develop`.

## Tools

* [`rustc`](https://github.com/esp-rs/rust)
* [`cargo`](https://github.com/esp-rs/rust)
* [`toolchain`](https://github.com/espressif/crosstool-NG)
* [`cargo-espflash`](https://github.com/esp-rs/espflash)
* [`cargo-espmonitor`](https://github.com/esp-rs/espmonitor)
* [`espflash`](https://github.com/esp-rs/espflash)
* [`espmonitor`](https://github.com/esp-rs/espmonitor)
* [`ldproxy`](https://github.com/ivmarkov/embuild)

## Usage

1. [Install NixOS or nixpkgs](https://nixos.org/download.html)
2. Enable [nix flakes](https://nixos.wiki/wiki/Flakes)
3. Run a tool, e.g. `nix run github:newam/esp-rs-nix#espflash`

## Compiling Code

At the moment anything that depends on the std and esp-idf will fail to compile.
We only support building [no_std](https://docs.rust-embedded.org/book/intro/no-std.html) crates.

[esp-hal@02c5f4564b0fca1321b18e98e66e124a0b276643](https://github.com/esp-rs/esp-hal/tree/02c5f4564b0fca1321b18e98e66e124a0b276643):

```bash
nix develop github:newAM/esp-rs-nix -i -L -c cargo -Z build-std build --target xtensa-esp32-none-elf -p esp32-hal
```

## TODO

* [ ] Create nix package for [espressif QEMU fork](https://github.com/espressif/qemu)
* [ ] Add [opt-in nix support in cargo generate for esp-rs](https://github.com/esp-rs/esp-template)
* [ ] Add more documentation, example for using `esp-rs` with `nix`
* [ ] Support `esp-idf` sdk

## References

* [sdobz/rust-esp-nix](https://github.com/sdobz/rust-esp-nix)
* [Using Nix to write rust on the esp32](https://specific.solutions.limited/projects/hanging-plotter/esp-rust)
* [tomjnixon/nix-esp-idf](https://github.com/tomjnixon/nix-esp-idf)

[esp-rs]: https://github.com/esp-rs
[nix]: https://nixos.org
