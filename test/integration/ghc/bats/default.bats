#!/usr/bin/env bats

@test "installs ghc" {
  ghc --version | grep -q '7.6.3'
}

@test "installs cabal" {
  hash cabal 2>/dev/null
}
