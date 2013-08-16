#!/usr/bin/env bats

@test "installs convert" {
  hash convert 2>/dev/null
}
