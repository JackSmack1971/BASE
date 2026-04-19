# worktree_spec.sh
# Tests for .agents/skills/using-git-worktrees/scripts/

set_up() {
  export TMP_DIR=$(mktemp -d)
}

tear_down() {
  rm -rf "$TMP_DIR"
}

Describe 'using-git-worktrees/scripts/build_worktree_path.sh'
  Mock date
    echo "2026-04-19"
  End
  
  # Mock git for rev-parse inside build_worktree_path.sh
  Mock git
    case "$*" in
      "rev-parse --show-toplevel" ) echo "/mnt/c/Users/click/Desktop/BASE_PROJECT" ;;
      * ) echo "Mock git: $*" ;;
    esac
  End

  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    bash "$SPEC_ROOT_POSIX/.agents/skills/using-git-worktrees/scripts/build_worktree_path.sh" "$@" | tr -d '\r'
  }

  It 'builds a path with location and branch'
    When run run_script --location "/worktrees" --branch "feat/test-ui"
    The output should include 'PATH_READY'
    The output should include '/worktrees/feat/test-ui'
    The status should be success
  End
End

Describe 'using-git-worktrees/scripts/verify_gitignore.sh'
  Mock git
    case "$*" in
      "check-ignore -q ignored_dir" ) exit 0 ;;
      "check-ignore -q clean_dir" ) exit 1 ;;
      * ) echo "Mock git: $*"; exit 1 ;;
    esac
  End

  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    bash "$SPEC_ROOT_POSIX/.agents/skills/using-git-worktrees/scripts/verify_gitignore.sh" "$@"
  }

  It 'reports IGNORED when directory is in .gitignore'
    When run run_script --dir "ignored_dir"
    The output should include '"status":"IGNORED"'
    The status should be success
  End

  It 'reports NOT_IGNORED when directory is free'
    When run run_script --dir "clean_dir"
    The output should include '"status":"NOT_IGNORED"'
    The status should be success
  End
End

Describe 'using-git-worktrees/scripts/create_worktree.sh'
  Mock git
    case "$*" in
      "branch --list existing" ) echo "existing"; exit 0 ;;
      "worktree add "* ) echo "Mocked worktree add successful"; exit 0 ;;
      * ) echo "Mock git: $*"; exit 1 ;;
    esac
  End

  SPEC_ROOT_POSIX=$(pwd -P | sed 's/^\([A-Z]\):/\/\L\1/')

  run_script() {
    bash "$SPEC_ROOT_POSIX/.agents/skills/using-git-worktrees/scripts/create_worktree.sh" "$@"
  }

  It 'fails when arguments are missing'
    When run run_script
    The output should include '"status":"ERROR"'
    The status should be failure
  End

  It 'reports BRANCH_EXISTS if branch already exists'
    When run run_script --path "/t" --branch "existing"
    The output should include '"status":"BRANCH_EXISTS"'
    The status should be success
  End

  It 'creates a worktree if everything is valid'
    When run run_script --path "/t" --branch "new-feat"
    The output should include '"status":"CREATED"'
    The status should be success
  End
End
