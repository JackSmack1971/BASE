# agent_browser_spec.sh
# Tests for .agents/skills/agent-browser/scripts/

Describe 'agent-browser scripts'
  SPEC_ROOT_POSIX=$(bash -c "pwd -P")

  Mock agent-browser
    case "$1" in
      --version) echo "agent-browser 1.0.0" ;;
      session) echo '{"status":"ok","session":"test"}' ;;
      snapshot) echo '{"status":"ok","tree":{}}' ;;
      click|fill|navigate|press) echo 'success' ;;
      screenshot) 
        # Extract the path from --output flag
        out_path=""
        while [[ $# -gt 0 ]]; do
          if [[ "$1" == "--output" ]]; then out_path="$2"; break; fi
          shift
        done
        if [ -n "$out_path" ]; then touch "$out_path"; fi
        echo '{"status":"ok","path":"captured.png"}' 
        ;;
      scrape) echo '{"status":"ok","data":[],"count":0}' ;;
      *) exit 0 ;;
    esac
  End

  Describe 'verify_install.sh'
    It 'detects a functional installation'
      When run bash "$SPEC_ROOT_POSIX/.agents/skills/agent-browser/scripts/verify_install.sh"
      The output should include '"status":"ok"'
      The status should be success
    End
  End

  Describe 'launch_browser.sh'
    It 'launches a URL session'
      When run bash "$SPEC_ROOT_POSIX/.agents/skills/agent-browser/scripts/launch_browser.sh" --url "https://example.com"
      The output should include '"status":"ok"'
      The status should be success
    End
  End

  Describe 'snapshot.sh'
    It 'retrieves a snapshot'
      When run bash "$SPEC_ROOT_POSIX/.agents/skills/agent-browser/scripts/snapshot.sh"
      The output should include '"status":"ok"'
      The status should be success
    End
  End

  Describe 'interact.sh'
    It 'performs a click action'
      When run bash "$SPEC_ROOT_POSIX/.agents/skills/agent-browser/scripts/interact.sh" --action click --selector "@e1"
      The output should include '"status":"ok"'
      The output should include '"result":"success"'
      The status should be success
    End
  End

  Describe 'screenshot.sh'
    It 'takes a screenshot'
      rm -f "./test_capture.png"
      When run bash "$SPEC_ROOT_POSIX/.agents/skills/agent-browser/scripts/screenshot.sh" --out "./test_capture.png"
      The output should include '"status":"ok"'
      The output should include '"path":"./test_capture.png"'
      The status should be success
      Assert [ -f "./test_capture.png" ]
      rm -f "./test_capture.png"
    End
  End

  Describe 'scrape.sh'
    It 'scrapes data'
      When run bash "$SPEC_ROOT_POSIX/.agents/skills/agent-browser/scripts/scrape.sh" --selector "h1"
      The output should include '"status":"ok"'
      The status should be success
    End
  End
End
