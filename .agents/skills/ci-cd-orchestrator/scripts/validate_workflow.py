import sys
import yaml
import os

def validate_workflow(file_path):
    if not os.path.exists(file_path):
        print(f"❌ FAIL: File {file_path} not found.")
        sys.exit(1)

    try:
        with open(file_path, 'r') as f:
            workflow = yaml.safe_load(f)
    except Exception as e:
        print(f"❌ FAIL: Invalid YAML syntax: {str(e)}")
        sys.exit(1)

    # Hard rules for Agent-Native CI
    issues = []

    # 1. Must have workflow_dispatch
    if 'on' not in workflow or 'workflow_dispatch' not in workflow['on']:
        issues.append("MISSING: 'workflow_dispatch' trigger (required for agentic orchestration).")

    # 2. Must have matrix_config input if it uses matrices
    has_matrix = False
    for job_name, job in workflow.get('jobs', {}).items():
        if 'strategy' in job and 'matrix' in job['strategy']:
            has_matrix = True
            break
    
    if has_matrix:
        inputs = workflow.get('on', {}).get('workflow_dispatch', {}).get('inputs', {})
        if 'matrix_config' not in inputs:
            issues.append("MISSING: 'matrix_config' input (required for parallel matrix jobs).")

    # 3. Security check: No hardcoded secrets
    workflow_str = yaml.dump(workflow)
    if "ghp_" in workflow_str or "vercel_" in workflow_str:
        issues.append("SECURITY: Hardcoded token patterns detected. Use ${{ secrets.NAME }}.")

    if issues:
        print(f"❌ FAILED VALIDATION for {file_path}:")
        for issue in issues:
            print(f"  - {issue}")
        sys.exit(1)
    else:
        print(f"✅ PASS: {file_path} meets orchestrator standards.")
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python validate_workflow.py <path_to_yaml>")
        sys.exit(1)
    validate_workflow(sys.argv[1])
