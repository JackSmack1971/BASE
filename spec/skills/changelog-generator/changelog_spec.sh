# changelog_spec.sh
# Tests for .agents/skills/changelog-generator/scripts/

Describe 'changelog-generator/scripts/analyze_commits.sh'
  Mock git
    case "$*" in
      *"--pretty=format"* ) 
        echo "hash1|||feat: test feature|||body1---COMMIT_END---"
        echo "hash2|||docs: test doc|||body2---COMMIT_END---"
        ;;
      * ) echo "Mock git: $*" ;;
    esac
  End

  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    bash "$SPEC_ROOT_POSIX/.agents/skills/changelog-generator/scripts/analyze_commits.sh" "$@"
  }

  It 'successfully categorizes commits'
    When run run_script --since "2026-04-19"
    The output should include '"status": "OK"'
    The output should include '"commit_count": 2'
    The status should be success
  End
End

Describe 'changelog-generator/scripts/verify_changelog.sh'
  set_up() {
    export TMP_VERIFY_DIR=$(mktemp -d)
    echo '{"categories":{"features":1,"improvements":1,"fixes":0,"breaking":0,"security":0}}' > "$TMP_VERIFY_DIR/manifest.json"
    echo -e "## [v1.0.0]\n- Feat 1\n- Doc 1" > "$TMP_VERIFY_DIR/draft.md"
  }

  tear_down() {
    rm -rf "$TMP_VERIFY_DIR"
  }

  BeforeEach 'set_up'
  AfterEach 'tear_down'

  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    bash "$SPEC_ROOT_POSIX/.agents/skills/changelog-generator/scripts/verify_changelog.sh" --draft "$TMP_VERIFY_DIR/draft.md" --manifest "$TMP_VERIFY_DIR/manifest.json"
  }

  It 'passes when entry counts match'
    When run run_script
    The output should include '"status":"PASS"'
    The status should be success
  End
End
