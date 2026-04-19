# context_compact_spec.sh
# Tests for .agents/skills/context-compact/scripts/

Describe 'context-compact scripts'
  SPEC_ROOT_POSIX=$(bash -c "pwd -P")
  TMP_ROOT="$SPEC_ROOT_POSIX/.tmp_context_compact"
  TMP_KNOWLEDGE="$TMP_ROOT/.gemini/antigravity/knowledge"

  BeforeAll 'mkdir -p "$TMP_KNOWLEDGE"'
  AfterAll 'rm -rf "$TMP_ROOT"'

  Mock bc
    echo "75.0"
  End

  Mock jq
    case "$1" in
      -r)
        case "$2" in
          ".current_objective"*) echo "Test Objective" ;;
          ".finalized_decisions"*) echo "Test Decision" ;;
          ".modified_files"*) echo "None" ;;
          ".active_blockers"*) echo "None" ;;
          ".next_action_delta"*) echo "Resume" ;;
          *) echo "unknown" ;;
        esac
        ;;
      *) echo "{}" ;;
    esac
  End

  Describe 'measure_tokens.sh'
    It 'returns token utilization statistics'
      When run bash "$SPEC_ROOT_POSIX/.agents/skills/context-compact/scripts/measure_tokens.sh" --window-ceiling 1000000
      The output should include '"status": "OK"'
      The output should include '"utilization_pct": 75.0'
      The status should be success
    End
  End

  Describe 'assess_trajectory.sh'
    It 'returns a classification manifest'
      When run bash "$SPEC_ROOT_POSIX/.agents/skills/context-compact/scripts/assess_trajectory.sh" --project-root "$TMP_ROOT"
      The output should include '"status": "OK"'
      The output should include '"evict_blocks"'
      The status should be success
    End
  End

  Describe 'synthesize_state.sh'
    It 'writes session-state.md'
      # Create a dummy payload file as expected by the script
      echo '{"current_objective": "Test Objective"}' > "/tmp/session_state_payload.json"
      
      When run bash "$SPEC_ROOT_POSIX/.agents/skills/context-compact/scripts/synthesize_state.sh" --knowledge-dir "$TMP_KNOWLEDGE" --session-id "test_session"
      The output should include '"status": "OK"'
      The status should be success
      Assert [ -f "$TMP_KNOWLEDGE/session-state.md" ]
      
      rm -f "/tmp/session_state_payload.json"
    End
  End

  Describe 'verify_artifact.sh'
    It 'validates an existing non-empty artifact'
      TEST_FILE="$TMP_ROOT/test.txt"
      echo "data" > "$TEST_FILE"
      When run bash "$SPEC_ROOT_POSIX/.agents/skills/context-compact/scripts/verify_artifact.sh" --path "$TEST_FILE"
      The output should include '"status": "OK"'
      The status should be success
    End
  End

  Describe 'compaction_audit.sh'
    It 'generates a compaction summary'
      When run bash "$SPEC_ROOT_POSIX/.agents/skills/context-compact/scripts/compaction_audit.sh" --session-id "test_session" --knowledge-dir "$TMP_KNOWLEDGE" --tokens-before 100000 --tokens-evicted 80000
      The output should include '"status": "OK"'
      The output should include '"reduction_pct": 75.0'
      The status should be success
      Assert [ -f "$TMP_KNOWLEDGE/compaction_summary_test_session.json" ]
    End
  End
End
