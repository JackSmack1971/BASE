# design_review_spec.sh
# Tests for .agents/skills/design-review/scripts/

Describe 'design-review/scripts/session_setup.sh'
  SPEC_ROOT_POSIX=$(bash -c "pwd -P")
  ORG_PATH="$PATH"

  setup() {
    export TMP_DIR_S="$SPEC_ROOT_POSIX/.tmp_session"
    export HOME_S="$TMP_DIR_S/home"
    mkdir -p "$HOME_S/.claude/skills/gstack/bin"
    echo 'echo "true"' > "$HOME_S/.claude/skills/gstack/bin/gstack-config"
    chmod +x "$HOME_S/.claude/skills/gstack/bin/gstack-config"
    touch "$HOME_S/.claude/skills/gstack/bin/gstack-update-check"
    touch "$HOME_S/.claude/skills/gstack/bin/gstack-repo-mode"
    touch "$HOME_S/.claude/skills/gstack/bin/gstack-slug"
    touch "$HOME_S/.claude/skills/gstack/bin/gstack-timeline-log"
    chmod +x "$HOME_S/.claude/skills/gstack/bin/"*
    
    mkdir -p "$TMP_DIR_S/bin"
    echo '#!/usr/bin/env bash' > "$TMP_DIR_S/bin/git"
    echo 'case "$*" in "branch --show-current") echo "main";; *) exit 0;; esac' >> "$TMP_DIR_S/bin/git"
    chmod +x "$TMP_DIR_S/bin/git"
  }
  
  cleanup() {
    rm -rf "$SPEC_ROOT_POSIX/.tmp_session"
    export PATH="$ORG_PATH"
  }

  It 'successfully initializes a session JSON'
    export HOME="$HOME_S"
    export PATH="$TMP_DIR_S/bin:$PATH"
    When run bash "$SPEC_ROOT_POSIX/.agents/skills/design-review/scripts/session_setup.sh"
    The output should include '"STATUS": "OK"'
    The status should be success
  End
End

Describe 'design-review/scripts/git_check.sh'
  SPEC_ROOT_POSIX=$(bash -c "pwd -P")
  ORG_PATH="$PATH"

  setup() {
    export TMP_DIR_G="$SPEC_ROOT_POSIX/.tmp_git"
    mkdir -p "$TMP_DIR_G/bin"
  }
  cleanup() {
    rm -rf "$SPEC_ROOT_POSIX/.tmp_git"
    export PATH="$ORG_PATH"
  }

  It 'detects a dirty working tree'
    echo '#!/usr/bin/env bash' > "$TMP_DIR_G/bin/git"
    echo 'echo "M src/App.tsx"' >> "$TMP_DIR_G/bin/git"
    chmod +x "$TMP_DIR_G/bin/git"
    
    export PATH="$TMP_DIR_G/bin:$PATH"
    When run bash "$SPEC_ROOT_POSIX/.agents/skills/design-review/scripts/git_check.sh"
    The output should include '"STATUS": "DIRTY"'
    The status should be success
  End
End

Describe 'design-review/scripts/browser_setup.sh'
  SPEC_ROOT_POSIX=$(bash -c "pwd -P")
  ORG_PATH="$PATH"

  setup() {
    export TMP_DIR_B="$SPEC_ROOT_POSIX/.tmp_browser"
    export FAKE_ROOT="$TMP_DIR_B/fake_root"
    mkdir -p "$FAKE_ROOT/.claude/skills/gstack/browse/dist"
    touch "$FAKE_ROOT/.claude/skills/gstack/browse/dist/browse"
    chmod +x "$FAKE_ROOT/.claude/skills/gstack/browse/dist/browse"
    
    mkdir -p "$TMP_DIR_B/bin"
    echo '#!/usr/bin/env bash' > "$TMP_DIR_B/bin/git"
    echo "echo \"$FAKE_ROOT\"" >> "$TMP_DIR_B/bin/git"
    chmod +x "$TMP_DIR_B/bin/git"
  }
  cleanup() {
    rm -rf "$SPEC_ROOT_POSIX/.tmp_browser"
    export PATH="$ORG_PATH"
  }

  It 'detects gstack browser binary if present'
    export PATH="$TMP_DIR_B/bin:$PATH"
    When run bash "$SPEC_ROOT_POSIX/.agents/skills/design-review/scripts/browser_setup.sh"
    The output should include '"STATUS": "OK"'
    The status should be success
  End
End
