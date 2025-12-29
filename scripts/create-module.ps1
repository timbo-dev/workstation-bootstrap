param (
    [Parameter(Mandatory=$true)]
    [string]$ModuleName
)

# Robust path detection
$RootPath = Get-Item $PSScriptRoot | Select-Object -ExpandProperty Parent
$ModulesDir = Join-Path $RootPath "setup\modules"
if (-not (Test-Path $ModulesDir)) {
    # Fallback to local setup/modules if not found in parent
    $ModulesDir = Join-Path $PSScriptRoot "setup\modules"
    if (-not (Test-Path $ModulesDir)) {
        # Last resort fallback to a relative path
        $ModulesDir = "setup/modules"
    }
}

# Determine next number
$ExistingModules = Get-ChildItem $ModulesDir | Where-Object { $_.Name -match "^[0-9]{2}-" } | Sort-Object Name
if ($ExistingModules) {
    $LastModule = $ExistingModules[-1].Name
    $LastNum = [int]$LastModule.Substring(0, 2)
    $NextNum = ($LastNum + 1).ToString("D2")
} else {
    $NextNum = "00"
}

$FullName = "${NextNum}-${ModuleName}"
$TargetDir = Join-Path $ModulesDir $FullName

Write-Host "Creating module: $FullName in $TargetDir..." -ForegroundColor Cyan

New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null

function Create-BashScript {
    param ($Name, $Description)
    $FilePath = Join-Path $TargetDir "${Name}.sh"
    
    # Use single-quoted here-string to avoid ANY interpolation issues
    # or escape properly with backticks
    $Content = @"
#!/usr/bin/env bash

set -euo pipefail

# Source utils for logging and helpers
source "`$(dirname "`$0")/../../lib/utils.sh"

log_info "${Description}..."

# Your code here
"@

    # Ensure LF line endings and UTF8 without BOM for Linux compatibility
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $LfContent = $Content -replace "`r`n", "`n"
    [System.IO.File]::WriteAllText($FilePath, $LfContent, $Utf8NoBom)
}

Create-BashScript "pre" "Pre-install configuration for $ModuleName"
Create-BashScript "install" "Installing $ModuleName"
Create-BashScript "post" "Post-install configuration for $ModuleName"

Write-Host "[OK] Module $FullName created successfully!" -ForegroundColor Green
