# context_engineering_spec.sh
# Tests for .agents/skills/context-engineering/scripts/

Describe 'context-engineering/scripts/audit_context.sh'
  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    bash "$SPEC_ROOT_POSIX/.agents/skills/context-engineering/scripts/audit_context.sh" "$@" | tr -d '\r'
  }

  It 'successfully audits the context layers'
    When run run_script
    The output should include '"status": "CONTEXT_'
    The status should be success
  End

  It 'detects a missing GEMINI.md'
    setup() { touch AGENTS.md; }
    cleanup() { rm -f AGENTS.md; }
    
    # Run in a clean temporary directory to avoid picking up the real codebase
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    When run bash "$SPEC_ROOT_POSIX/.agents/skills/context-engineering/scripts/audit_context.sh"
    The output should include '"gemini_md_present": false'
    The output should include '"status": "CONTEXT_CRITICAL"'
    
    cd "$SPEC_ROOT_POSIX"
    rm -rf "$TEMP_DIR"
  End
End

Describe 'context-engineering/scripts/generate_brain_dump.sh'
  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    bash "$SPEC_ROOT_POSIX/.agents/skills/context-engineering/scripts/generate_brain_dump.sh" "$@" | tr -d '\r'
  }

  It 'generates a brain dump successfully'
    When run run_script
    The output should include '"status": "BRAIN_DUMP_GENERATED"'
    The output should include '"project_name":'
    The status should be success
  End

  It 'detects the tech stack from package.json'
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    echo '{"dependencies": {"react": "18.0.0"}}' > package.json
    
    When run bash "$SPEC_ROOT_POSIX/.agents/skills/context-engineering/scripts/generate_brain_dump.sh"
    The output should include '"stack_detected": "node:react"'
    
    cd "$SPEC_ROOT_POSIX"
    rm -rf "$TEMP_DIR"
  End
End
