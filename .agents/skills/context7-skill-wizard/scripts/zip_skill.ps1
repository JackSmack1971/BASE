# zip_skill.ps1 — Packages a skill directory into a ZIP archive
# Usage: .\scripts\zip_skill.ps1 <skill-name>
Param(
    [Parameter(Mandatory=$true)]
    [string]$SkillName
)

$SourceDir = ".agents/skills/$SkillName"
$OutputDir = ".agents/outputs"
$TmpZip = "$SkillName.zip"

if (-not (Test-Path $SourceDir)) {
    Write-Error "STATUS: ERROR source directory not found: $SourceDir"
    exit 1
}

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir
}

# Remove stale archive
if (Test-Path $TmpZip) { Remove-Item $TmpZip }

# Create ZIP
$ParentDir = Split-Path $SourceDir
$BaseName = Split-Path $SourceDir -Leaf

# Go to the parent dir to archive correctly
Push-Location $ParentDir
Compress-Archive -Path $BaseName -DestinationPath "../../$TmpZip" -Force
Pop-Location

# Move to outputs
Move-Item $TmpZip -Destination "$OutputDir/$SkillName.zip" -Force

if (Test-Path "$OutputDir/$SkillName.zip") {
    Write-Output "STATUS: PACKAGED $OutputDir/$SkillName.zip"
} else {
    Write-Error "STATUS: ERROR output ZIP is empty or missing"
    exit 1
}
