{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    cabal-install
    ghc
    SDL2
    sdl3
    sdl3-image
    haskell-language-server
    ccls
    # stylish-haskell
  ];
  nativeBuildInputs = with pkgs; [
    pkg-config
  ];
}
