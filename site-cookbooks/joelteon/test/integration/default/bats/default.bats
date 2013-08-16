@test "installs ghc" {
  ghc --version | grep -q 7.6.3
}
