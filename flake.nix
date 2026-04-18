{
  description = "Haskell development flake for mpdesigner";

  inputs.nixpkgs.url = "nixpkgs/nixos-25.11";
  inputs.nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      hp = pkgs.haskell.packages.ghc96;
    in {
      packages.default = hp.developPackage {
        root = ./.;
        withHoogle = true;
        overrides = self: super: {
          sdl3 = hp.callCabal2nix
            "sdl3"
            (pkgs.fetchFromGitHub {
              owner = "klukaszek";
              repo = "sdl3-hs";
              rev = "d4a6b6e21f48cafb40028537a6cc9f55aa0943d3";
              sha256 = "sha256-0t4JcElzPLM4LmaJvn8S6VF1bdkeHoIbZcTSaPAynGI=";
            })
            { SDL3 = pkgs-unstable.sdl3.dev; };
        };
        modifier = drv: pkgs.haskell.lib.addBuildTools drv [
          hp.cabal-install
          hp.haskell-language-server

          # not required to build (since we override sdl3), but needed for
          # haskell-language-server (or cabal build) to work properly
          pkgs-unstable.sdl3
        ];
      };
    });
}

# packages.sdl3-hs = hp.callCabal2nix
#   "sdl3"
#   (pkgs.fetchFromGitHub {
#     owner = "klukaszek";
#     repo = "sdl3-hs";
#     rev = "d4a6b6e21f48cafb40028537a6cc9f55aa0943d3";
#     sha256 = "sha256-0t4JcElzPLM4LmaJvn8S6VF1bdkeHoIbZcTSaPAynGI=";
#   })
#   { SDL3 = pkgs-unstable.sdl3.dev; };

# buildInputs = [
#   pkgs-unstable.sdl3.dev # want newer version of sdl3
#   pkgs-unstable.sdl3-image.dev
#   pkgs.alsa-lib.dev
#   pkgs.libjack2.dev
#   pkgs.pipewire.dev
#   pkgs.libpulseaudio.dev
#   pkgs.libx11.dev
#   pkgs.libxcb.dev
#   pkgs.libxau.dev
#   pkgs.libxdmcp.dev
#   pkgs.libxext.dev
#   pkgs.libxcursor.dev
#   pkgs.libxrender.dev
#   pkgs.libxfixes.dev
#   pkgs.libxi.dev
#   pkgs.libxrandr.dev
#   pkgs.libxscrnsaver # no .dev
#   pkgs.libxtst
#   pkgs.libdrm.dev
#   pkgs.libgbm
#   pkgs.waylandpp.dev
# ];
