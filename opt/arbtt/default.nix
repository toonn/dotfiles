{ pkgs ? import ~/src/nix-config/haskell.nix/nixpkgs.nix
, compiler-nix-name ? "ghc910"
}:
(pkgs.haskell-nix.hackage-package {
  inherit compiler-nix-name;
  name = "arbtt";
  version = "0.12.0.3";
  index-state = "2025-03-02T00:00:00Z";
}).components.exes
