# write_spec_spec.sh
# Tests for .agents/skills/brainstorming/scripts/write_spec.sh

set_up() {
  export SANDBOX_DIR=$(mktemp -d)
  mkdir -p "$SANDBOX_DIR/docs/superpowers/specs"
}

tear_down() {
  rm -rf "$SANDBOX_DIR"
}

Describe 'brainstorming/scripts/write_spec.sh'
  BeforeEach 'set_up'
  AfterEach 'tear_down'

  # Mock absolute date for deterministic slugs
  Mock date
    echo "2026-04-19"
  End

  # Helper to run script within sandbox
  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    ( cd "$SANDBOX_DIR" && bash "$SPEC_ROOT_POSIX/.agents/skills/brainstorming/scripts/write_spec.sh" "$@" )
  }

  Context 'Argument Validation'
    It 'fails when --topic is missing'
      When run run_script
      The output should include '"write_result": "ERROR"'
      The output should include '"reason": "Missing --topic argument"'
      The status should be failure
    End
  End

  Context 'Success Scenario'
    It 'successfully generates a slug and returns success'
      export SPEC_CONTENT="PoC Test Content"
      When run run_script --topic "Test New Feature"
      The output should include '"write_result": "SUCCESS"'
      The output should include '"slug": "test-new-feature"'
      The output should include '"date": "2026-04-19"'
      The output should include '"spec_path": "docs/superpowers/specs/2026-04-19-test-new-feature-design.md"'
      The status should be success
      
      # Verify file was actually created in sandbox
      The file "$SANDBOX_DIR/docs/superpowers/specs/2026-04-19-test-new-feature-design.md" should be exist
    End
  End
End
