{ stdenv
, autoPatchelfHook
, pkgs
, fetchurl
, lib
}:
stdenv.mkDerivation rec {
  pname = "esp32-toolchain";
  version = "13.2.0_20230928";

  src = fetchurl {
    url = "https://github.com/espressif/crosstool-NG/releases/download/esp-${version}/xtensa-esp-elf-${version}-x86_64-linux-gnu.tar.xz";
    sha256 = "sha256-uufaI+qFFvt+QmQPRCDE3R6/1kGJoU/DMNc+Fzs6A4s=";
  };

  nativeBuildInputs = if stdenv.isLinux then [ autoPatchelfHook ] else [ ];

  buildInputs = with pkgs; [ zlib stdenv.cc.cc.lib ];

  installPhase = ''
    cp -r . $out
  '';

  meta = with lib; {
    description = "ESP32 toolchain";
    homepage = "https://docs.espressif.com/projects/esp-idf/en/stable/get-started/linux-setup.html";
    license = licenses.gpl3;
  };
}
