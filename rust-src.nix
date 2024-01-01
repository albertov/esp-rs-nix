{ fetchFromGitHub }:

fetchFromGitHub {
  owner = "esp-rs";
  repo = "rust";
  rev = "98053514f4ed7df16235ada9b89beeee59e1a747";
  fetchSubmodules = true;
  sha256 = "sha256-r+Xfj0aBKWao+deRCwZPwBFFb+Rgc2+J0TNIFEMOZB0=";
  # reduce closure size by removing llvm-project
  postFetch = ''
    rm -fr $out/src/llvm-project
  '';
}
