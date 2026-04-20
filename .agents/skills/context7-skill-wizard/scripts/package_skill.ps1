# package_skill.ps1 — Creates the skill directory structure and writes SKILL.md + references/
# Usage: .\scripts\package_skill.ps1 <skill-name>
Param(
    [Parameter(Mandatory=$true)]
    [string]$SkillName
)

if ($SkillName -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
    Write-Error "STATUS: ERROR skill name '$SkillName' contains invalid characters (use lowercase-kebab-case)"
    exit 1
}

$TargetDir = ".agents/skills/$SkillName"

# Create directory structure
New-Item -ItemType Directory -Force -Path "$TargetDir/references"
New-Item -ItemType Directory -Force -Path "$TargetDir/scripts"

# Copy validate script
$ScriptSource = ".agents/skills/context7-skill-wizard/scripts/validate_generated_skill.py"
if (Test-Path $ScriptSource) {
    Copy-Item $ScriptSource -Destination "$TargetDir/scripts/validate_generated_skill.py" -Force
}

# Verify SKILL.md
$SkillMdPath = "$TargetDir/SKILL.md"
if (-not (Test-Path $SkillMdPath)) {
    $placeholder = "# PLACEHOLDER -- agent must write real SKILL.md content"
    Set-Content -Path $SkillMdPath -Value $placeholder
    Write-Output "STATUS: WARNING SKILL.md not found -- created placeholder at $TargetDir/SKILL.md"
} else {
    Write-Output "STATUS: CREATED $TargetDir"
}
