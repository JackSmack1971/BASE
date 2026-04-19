#!/usr/bin/env python3
"""
verify_output.py — Deterministic output verifier for ui-ux-pro-max skill.
Reads last run output from stdin or a temp file and asserts structural completeness.

Usage:
  python3 .agents/skills/ui-ux-pro-max/scripts/verify_output.py --mode <design-system|domain|audit>
"""

import sys
import json
import argparse
import os

TEMP_OUTPUT_FILE = "/tmp/ui_ux_pro_max_last_output.txt"


def verify_design_system(content: str) -> dict:
    """Verify design system output contains required sections."""
    required_sections = ["pattern", "style", "color", "typography"]
    found = {s: s.lower() in content.lower() for s in required_sections}
    all_passed = all(found.values())
    return {
        "VERIFICATION": "PASS" if all_passed else "FAIL",
        "MODE": "design-system",
        "CHECKS": found,
        "REASON": None if all_passed else f"Missing sections: {[k for k,v in found.items() if not v]}"
    }


def verify_domain(content: str) -> dict:
    """Verify domain search returned at least one result."""
    has_content = len(content.strip()) > 50
    return {
        "VERIFICATION": "PASS" if has_content else "FAIL",
        "MODE": "domain",
        "CHECKS": {"has_results": has_content},
        "REASON": None if has_content else "Domain search returned empty or minimal output."
    }


def verify_audit(content: str) -> dict:
    """Verify UX audit output contains rule references."""
    has_rules = any(keyword in content.lower() for keyword in [
        "accessibility", "contrast", "touch", "animation", "navigation"
    ])
    return {
        "VERIFICATION": "PASS" if has_rules else "FAIL",
        "MODE": "audit",
        "CHECKS": {"has_ux_rules": has_rules},
        "REASON": None if has_rules else "Audit output did not reference UX rule categories."
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--mode", required=True, choices=["design-system", "domain", "audit"])
    parser.add_argument("--input", default=TEMP_OUTPUT_FILE, help="Path to script output file")
    args = parser.parse_args()

    # Read content from file or stdin
    content = ""
    if not sys.stdin.isatty():
        content = sys.stdin.read()
    elif os.path.exists(args.input):
        with open(args.input, "r") as f:
            content = f.read()
    else:
        result = {
            "VERIFICATION": "FAIL",
            "MODE": args.mode,
            "REASON": f"No output found. Expected at {args.input} or via stdin."
        }
        print(json.dumps(result, indent=2))
        sys.exit(1)

    # Dispatch to verifier
    if args.mode == "design-system":
        result = verify_design_system(content)
    elif args.mode == "domain":
        result = verify_domain(content)
    elif args.mode == "audit":
        result = verify_audit(content)
    else:
        result = {"VERIFICATION": "FAIL", "REASON": "Unknown mode"}

    print(json.dumps(result, indent=2))
    sys.exit(0 if result["VERIFICATION"] == "PASS" else 1)


if __name__ == "__main__":
    main()
