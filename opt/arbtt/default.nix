{ pkgs ? import ./nixpkgs.nix
, haskellCompiler ? "ghc883"
}:
(pkgs.haskell-nix.hackage-package { name = "arbtt";
                                    version = "0.10.2";
                                  }).components.exes
