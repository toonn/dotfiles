{ pkgs ? import ~/src/nix-config/haskell.nix/nixpkgs.nix
, compiler-nix-name ? "ghc8102"
}:
(pkgs.haskell-nix.hackage-package {
  inherit compiler-nix-name;
  name = "arbtt";
  version = "0.10.2";
  index-state = "2020-10-26T22:14:30Z";
  configureArgs = "--constraint 'strict <0.4'";
}).components.exes
