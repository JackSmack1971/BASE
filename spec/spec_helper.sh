# spec_helper.sh
# Shared setup and helpers for ShellSpec tests

set_up() {
  # Create a sandbox directory for filesystem-related tests
  export SANDBOX_DIR
  SANDBOX_DIR=$(mktemp -d)
}

tear_down() {
  # Clean up sandbox
  rm -rf "$SANDBOX_DIR"
}
