# test-skills.ps1
# Native PowerShell entry point for running skill script tests via ShellSpec.

$ErrorActionPreference = "Stop"

# Resolve paths
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ShellSpecPath = Join-Path $ScriptRoot "..\vendor\shellspec-master\shellspec"

# Ensure ShellSpec exists
if (-not (Test-Path $ShellSpecPath)) {
    Write-Error "ShellSpec not found at $ShellSpecPath. Please ensure the vendor directory is correctly populated."
}

Write-Host "--- Antigravity Skill Testing Protocol ---" -ForegroundColor Cyan
Write-Host "Target: ShellSpec (Bash BDD Framework)"
Write-Host ""

# Convert ShellSpec path to a forward-slash absolute path
$AbsoluteShellSpecPath = (Resolve-Path $ShellSpecPath).Path
# Convert Windows C:\path to Bash /mnt/c/path format
$DriveLetter = $AbsoluteShellSpecPath.Substring(0, 1).ToLower()
$PathPart = $AbsoluteShellSpecPath.Substring(2).Replace('\', '/')
$BashFriendlyPath = "/mnt/$DriveLetter$PathPart"

# Invoke ShellSpec through bash
bash $BashFriendlyPath $args

exit $LASTEXITCODE
