# simplification_spec.sh
# Tests for .agents/skills/simplification-cascades/scripts/scan_cascade_signals.sh

Describe 'simplification-cascades/scripts/scan_cascade_signals.sh'
  set_up() {
    export TMP_SCAN_DIR=$(mktemp -d)
  }

  tear_down() {
    rm -rf "$TMP_SCAN_DIR"
  }

  BeforeEach 'set_up'
  AfterEach 'tear_down'

  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    bash "$SPEC_ROOT_POSIX/.agents/skills/simplification-cascades/scripts/scan_cascade_signals.sh" --path "$TMP_SCAN_DIR" "$@"
  }

  It 'handles empty directories with no signals'
    When run run_script
    The output should include '"cascade_score": 0'
    The status should be success
  End

  It 'detects duplicate patterns (similar line counts)'
    for i in {1..30}; do echo "line $i" >> "$TMP_SCAN_DIR/file1.py"; done
    for i in {1..31}; do echo "line $i" >> "$TMP_SCAN_DIR/file2.py"; done
    When run run_script
    The output should include '"duplicate_pattern_files": 1'
    The status should be success
  End
End
