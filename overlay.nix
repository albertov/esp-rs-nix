_inputs: final: prev: {
  esp-idf-full = final.esp-idf-full_52;

  esp-idf-full_51 = prev.esp-idf-full.override {
    rev = "v5.1";
    sha256 = "sha256-cfILYvUGsbUmpDL76cnLyxSduj50A9ZWLCQ/yGIwaSA=";
  };
  esp-idf-full_52 = prev.esp-idf-full.override {
    rev = "v5.2";
    sha256 = "sha256-WRPy3+u6pkXRFPmWvUyx7Avac3U6PhBlcb5UdXvaCjU=";
    toolsToInclude = [
      "xtensa-esp-elf-gdb"
      "riscv32-esp-elf-gdb"
      "xtensa-esp-elf"
      "esp-clang"
      "riscv32-esp-elf"
      "esp32ulp-elf"
      "openocd-esp32"
    ];
  };
}
