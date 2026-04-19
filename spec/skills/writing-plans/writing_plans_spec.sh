# writing_plans_spec.sh
# Tests for .agents/skills/writing-plans/scripts/

set_up() {
  export TMP_PLAN=$(mktemp)
}

tear_down() {
  rm -f "$TMP_PLAN"
}

set_up_dir() {
  export TMP_DIR=$(mktemp -d)
  mkdir -p "$TMP_DIR/docs/superpowers/plans"
}

tear_down_dir() {
  rm -rf "$TMP_DIR"
}

Describe 'writing-plans/scripts/get_date.sh'
  Mock date
    echo "2026-04-19"
  End

  It 'returns the mocked date'
    When run bash .agents/skills/writing-plans/scripts/get_date.sh
    The line 1 should equal "DATE=2026-04-19"
    The status should be success
  End
End

Describe 'writing-plans/scripts/validate_plan.sh'
  BeforeEach 'set_up'
  AfterEach 'tear_down'

  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    bash "$SPEC_ROOT_POSIX/.agents/skills/writing-plans/scripts/validate_plan.sh" --plan-path "$TMP_PLAN" | tr -d '\r'
  }

  It 'passes on a clean plan'
    echo -e "### Task 1: Do something\nNo placeholders here." > "$TMP_PLAN"
    When run run_script
    The output should include '"status": "PASS"'
    The output should include '"task_count": 1'
    The output should include '"placeholder_hit_count": 0'
    The status should be success
  End

  It 'fails when placeholders are present'
    echo -e "### Task 1: Implement later\nTODO: fix this." > "$TMP_PLAN"
    When run run_script
    The output should include '"status": "FAIL"'
    The output should include '"placeholder_hit_count": 2'
    The status should be success
  End
End

Describe 'writing-plans/scripts/save_plan.sh'
  Mock date
    echo "2026-04-19"
  End
  
  BeforeEach 'set_up_dir'
  AfterEach 'tear_down_dir'

  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    ( cd "$TMP_DIR" && bash "$SPEC_ROOT_POSIX/.agents/skills/writing-plans/scripts/save_plan.sh" --path "docs/superpowers/plans/2026-04-19-plan-test.md" --content "Mock Plan Content" | tr -d '\r' )
  }

  It 'saves the plan successfully'
    When run run_script
    The output should include 'STATUS: SAVED'
    The file "$TMP_DIR/docs/superpowers/plans/2026-04-19-plan-test.md" should be exist
    The status should be success
  End
End
