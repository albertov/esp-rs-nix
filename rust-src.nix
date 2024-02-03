{ fetchFromGitHub }:

fetchFromGitHub {
  owner = "esp-rs";
  repo = "rust";
  rev = "8edb9b87e75769a7656750176d5cad285229a789";
  fetchSubmodules = true;
  hash = "sha256-rW3QHZhDhckETWihCeeWbArB7fTB3L9rtavVnULkmgs";
  # reduce closure size by removing llvm-project
  postFetch = ''
    rm -fr $out/src/llvm-project
  '';
}
