# tdd_spec.sh
# Tests for .agents/skills/test-driven-development/scripts/run_tdd_cycle.sh

set_up() {
  export TMP_DIR=$(mktemp -d)
  # Create a dummy package.json to satisfy the runner detection
  echo 'jest' > "$TMP_DIR/package.json"
  # Create a dummy test file
  echo "// test file" > "$TMP_DIR/test.js"
}

setup_npx() {
  export MOCK_NPX="$TMP_DIR/bin/npx"
  mkdir -p "$TMP_DIR/bin"
  cat <<EOF > "$MOCK_NPX"
#!/usr/bin/env bash
case "\$*" in
  *"test.js"* )
    echo "\${MOCK_TEST_OUTPUT:-passed}"
    exit \${MOCK_TEST_EXIT:-0}
    ;;
  * ) 
    echo "\${MOCK_SUITE_OUTPUT:-passed}"
    exit \${MOCK_SUITE_EXIT:-0}
    ;;
esac
EOF
  chmod +x "$MOCK_NPX"
  export PATH="$TMP_DIR/bin:$PATH"
}

tear_down() {
  rm -rf "$TMP_DIR"
}

Describe 'test-driven-development/scripts/run_tdd_cycle.sh'
  BeforeEach 'set_up'
  BeforeEach 'setup_npx'
  AfterEach 'tear_down'

  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    ( cd "$TMP_DIR" && bash "$SPEC_ROOT_POSIX/.agents/skills/test-driven-development/scripts/run_tdd_cycle.sh" --test-path "test.js" "$@" | tr -d '\r' )
  }

  Context 'Stage: red'
    It 'passes the red stage correctly if tests fail'
      export MOCK_TEST_OUTPUT="FAILED: expected true to be false"
      export MOCK_TEST_EXIT=1
      When run run_script --stage red
      The output should include '"stage_result": "FAIL_CORRECT"'
      The output should include '"stage": "red"'
      The status should be success
    End

    It 'reports PASS_UNEXPECTED if tests pass immediately'
      export MOCK_TEST_OUTPUT="PASS: test.js"
      export MOCK_TEST_EXIT=0
      When run run_script --stage red
      The output should include '"stage_result": "PASS_UNEXPECTED"'
      The status should be success
    End
  End

  Context 'Stage: green'
    It 'passes the green stage if tests pass and no regressions'
      export MOCK_TEST_OUTPUT="PASS: test.js"
      export MOCK_TEST_EXIT=0
      When run run_script --stage green
      The output should include '"stage_result": "ALL_PASS"'
      The output should include '"stage": "green"'
      The status should be success
    End

    It 'reports REGRESSION if suite fails'
      export MOCK_TEST_OUTPUT="PASS: test.js"
      export MOCK_TEST_EXIT=0
      export MOCK_SUITE_OUTPUT="FAIL: regression in other_test.js"
      export MOCK_SUITE_EXIT=1
      
      When run run_script --stage green
      The output should include '"stage_result": "REGRESSION"'
      The status should be success
    End
  End
End
