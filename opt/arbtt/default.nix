{ pkgs ? import ~/src/nix-config/haskell.nix/nixpkgs.nix
, compiler-nix-name ? "ghc8107"
}:
(pkgs.haskell-nix.hackage-package {
  inherit compiler-nix-name;
  name = "arbtt";
  version = "0.12.0.1";
  index-state = "2022-09-06T00:00:00Z";
  #configureArgs = "--constraint 'strict <0.4'";
}).components.exes
