let
  haskellNix = import (builtins.fetchTarball
    ( "https://github.com/input-output-hk/haskell.nix/archive/"
    + "59cf05606e7efbbc4741ae28fd8cc610cec94eb8.tar.gz"
    )) {};
  nixpkgsSrc = haskellNix.sources.nixpkgs-default;
  nixpkgsArgs = haskellNix.nixpkgsArgs;
in
  import nixpkgsSrc nixpkgsArgs
