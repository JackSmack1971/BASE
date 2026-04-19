# game_changing_features_spec.sh
# Tests for .agents/skills/game-changing-features/scripts/

Describe 'game-changing-features scripts'
  SPEC_ROOT_POSIX=$(bash -c "pwd -P")
  SKILL_DIR="$SPEC_ROOT_POSIX/.agents/skills/game-changing-features"

  Describe 'init_session.sh'
    It 'initializes a session for a new area'
      When run bash "$SKILL_DIR/scripts/init_session.sh" --area "test-area"
      The output should include '"status":"ready"'
      The output should include '"area":"test-area"'
      The output should include '"session_number":1'
      The output should include '"output_path":".agents/docs/ai/test-area/10x/session-1.md"'
      The status should be success
      
      # Cleanup
      rm -rf .agents/docs/ai/test-area
    End

    It 'increments session number for existing area'
      mkdir -p .agents/docs/ai/test-inc/10x
      touch .agents/docs/ai/test-inc/10x/session-1.md
      
      When run bash "$SKILL_DIR/scripts/init_session.sh" --area "test-inc"
      The output should include '"session_number":2'
      The status should be success
      
      # Cleanup
      rm -rf .agents/docs/ai/test-inc
    End

    It 'errors when --area is missing'
      When run bash "$SKILL_DIR/scripts/init_session.sh"
      The output should include '"status":"error"'
      The output should include '"message":"--area argument is required"'
      The status should be failure
    End
  End

  Describe 'verify_artifact.sh'
    It 'verifies existing non-empty artifact'
      TEMP_ART=".agents/skills/game-changing-features/scripts/temp_art.md"
      printf "# Analysis\nThis is a test of the 10x strategy engine.\nIt should be at least 100 bytes long to pass the size check correctly." > "$TEMP_ART"
      # Padding to ensure > 100 bytes
      printf "\nExtra padding for verification logic pass. Antigravity Mission Control protocol required." >> "$TEMP_ART"

      When run bash "$SKILL_DIR/scripts/verify_artifact.sh" --path "$TEMP_ART"
      The output should include '"status":"verified"'
      The status should be success
      
      # Cleanup
      rm "$TEMP_ART"
    End

    It 'fails for empty artifact'
      TEMP_EMPTY=".agents/skills/game-changing-features/scripts/temp_empty.md"
      touch "$TEMP_EMPTY"
      
      When run bash "$SKILL_DIR/scripts/verify_artifact.sh" --path "$TEMP_EMPTY"
      The output should include '"status":"error"'
      The output should include 'Artifact appears empty or too small'
      The status should be failure
      
      # Cleanup
      rm "$TEMP_EMPTY"
    End
  End
End
