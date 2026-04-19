# brainstorming_full_spec.sh
# Comprehensive tests for .agents/skills/brainstorming/scripts/

set_up() {
  mkdir -p .agents/skills/brainstorming/resources
  echo "Mock Guide Markdown" > .agents/skills/brainstorming/resources/visual-companion.md
}

tear_down() {
  rm -rf .agents/skills/brainstorming/resources
}

Describe 'brainstorming/scripts/commit_spec.sh'
  Mock git
    echo "Mock git: $*"
  End

  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    export TMP_FILE=$(mktemp)
    echo "content" > "$TMP_FILE"
    # Ensure pipefail for exit code propagation
    set -o pipefail
    bash "$SPEC_ROOT_POSIX/.agents/skills/brainstorming/scripts/commit_spec.sh" "$@" | tr -d '\r'
    local status=$?
    rm -f "$TMP_FILE"
    return $status
  }

  It 'fails when PATH is missing'
    When run bash "$SPEC_ROOT_POSIX/.agents/skills/brainstorming/scripts/commit_spec.sh"
    The output should include '"commit_result": "ERROR"'
    The status should be failure
  End

  It 'successfully executes git add and commit'
    export MY_SPEC=$(mktemp)
    echo "test" > "$MY_SPEC"
    When run bash "$SPEC_ROOT_POSIX/.agents/skills/brainstorming/scripts/commit_spec.sh" --spec-path "$MY_SPEC"
    The output should include '"commit_result": "SUCCESS"'
    The status should be success
    rm -f "$MY_SPEC"
  End
End

Describe 'brainstorming/scripts/load_visual_companion.sh'
  BeforeEach 'set_up'
  AfterEach 'tear_down'

  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  It 'loads the visual companion successfully'
    # Use absolute path to the script to avoid location ambiguity
    When run bash "$SPEC_ROOT_POSIX/.agents/skills/brainstorming/scripts/load_visual_companion.sh"
    The output should include '"load_result": "SUCCESS"'
    The output should include '"guide": "Mock Guide Markdown'
    The status should be success
  End
End

Describe 'brainstorming/scripts/explore_context.sh'
  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    bash "$SPEC_ROOT_POSIX/.agents/skills/brainstorming/scripts/explore_context.sh" "stack" "tree" "commits" "docs" "specs" "readme" | tr -d '\r'
  }

  It 'aggregates context into a structured JSON'
    When run run_script
    The output should include '"context_result": "FOUND"'
    The status should be success
  End
End
