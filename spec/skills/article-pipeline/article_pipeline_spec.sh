# article_pipeline_spec.sh
# Tests for .agents/skills/ article pipeline suite scripts

Describe 'Article Pipeline Skill Suite'
  SPEC_ROOT_POSIX=$(bash -c "pwd -P")
  ORCH_DIR="$SPEC_ROOT_POSIX/.agents/skills/multi-agent-article-pipeline"
  RES_DIR="$SPEC_ROOT_POSIX/.agents/skills/article-research-dialectic"
  QA_DIR="$SPEC_ROOT_POSIX/.agents/skills/article-qa-auditor"
  RT_DIR="$SPEC_ROOT_POSIX/.agents/skills/article-red-team"

  Describe 'pipeline_triage.sh (Orchestrator)'
    It 'triages a COMPLEX topic correctly'
      When run bash "$ORCH_DIR/scripts/pipeline_triage.sh" \
        --novelty 3 --contention 3 --scope 3 \
        --expertise "expert" --assumed-knowledge "AI,Law" \
        --must-explain "Extraterritoriality" --jargon-policy "no-definitions" \
        --topic "EU AI Act" \
        --output "test_config_complex.json"
      The output should include '"depth": "COMPLEX"'
      The output should include '"token_budget": 8000'
      The output should include '"red_team_enabled": true'
      The status should be success
      rm "test_config_complex.json"
    End

    It 'triages a SIMPLE topic correctly'
      When run bash "$ORCH_DIR/scripts/pipeline_triage.sh" \
        --novelty 0 --contention 0 --scope 1 \
        --expertise "novice" --assumed-knowledge "None" \
        --must-explain "Bitcoin" --jargon-policy "define-all" \
        --topic "What is Bitcoin" \
        --output "test_config_simple.json"
      The output should include '"depth": "SIMPLE"'
      The output should include '"dialectic_enabled": false'
      The status should be success
      rm "test_config_simple.json"
    End
  End

  Describe 'research_scraper.sh (Research Dialectic)'
    It 'returns a stub response in mode advocate'
      When run bash "$RES_DIR/scripts/research_scraper.sh" --query "AI regulation" --mode advocate
      The output should include '"status": "STUB"'
      The output should include '"mode": "advocate"'
      The output should include '"alignment": "supporting"'
      The status should be success
    End
  End

  Describe 'audit_verify.sh (QA Auditor)'
    It 'blocks meta-narration in a section'
      echo "This article will cover the major risks of AI." > "meta_test.md"
      When run bash "$QA_DIR/scripts/audit_verify.sh" --mode inline --section "Intro" --section-file "meta_test.md"
      The output should include '"verdict": "BLOCKED"'
      The output should include '"description": "Meta-narration found"'
      The status should be success
      rm "meta_test.md"
    End

    It 'passes a clean section'
      echo "AI regulation is evolving rapidly across the globe." > "clean_test.md"
      When run bash "$QA_DIR/scripts/audit_verify.sh" --mode inline --section "Context" --section-file "clean_test.md"
      The output should include '"verdict": "PASS"'
      The status should be success
      rm "clean_test.md"
    End
  End

  Describe 'threat_classify.sh (Red Team)'
    It 'classifies a STRUCTURAL threat as HIGH'
      When run bash "$RT_DIR/scripts/threat_classify.sh" \
        --thesis "AI is good" --attack-type "STRUCTURAL" --conclusion-addressed "NO"
      The output should include '"threat_level": "HIGH"'
      The output should include '"default_response": "address"'
      The status should be success
    End
  End
End
