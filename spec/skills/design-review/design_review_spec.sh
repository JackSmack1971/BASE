# design_review_spec.sh
# Tests for .agents/skills/design-review/scripts/

Describe 'design-review scripts'
  SPEC_ROOT_POSIX=$(bash -c "pwd -P")
  # Use a local path for TMP_HOME to guarantee write permissions
  TMP_HOME_MOCK="$SPEC_ROOT_POSIX/.tmp_home_mock"

  setup() {
    export ORG_HOME="$HOME"
    export HOME="$TMP_HOME_MOCK"
    mkdir -p "$HOME/.claude/skills/gstack/browse/dist/"
  }

  cleanup() {
    rm -rf "$TMP_HOME_MOCK"
    export HOME="$ORG_HOME"
  }

  It 'detects gstack browser binary if present'
    Mock git
      echo "" # Empty return for rev-parse to skip ROOT check
    End
    
    # Create the mock binary structure
    mkdir -p "$HOME/.claude/skills/gstack/browse/dist/"
    touch "$HOME/.claude/skills/gstack/browse/dist/browse"
    chmod +x "$HOME/.claude/skills/gstack/browse/dist/browse"
    
    When run bash "$SPEC_ROOT_POSIX/.agents/skills/design-review/scripts/browser_setup.sh"
    The output should include '"STATUS": "OK"'
    The status should be success
  End
End
