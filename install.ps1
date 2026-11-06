# ==============================================================================
#  ⚡ One-Line Installer for `shortcuts` (Windows PowerShell)
# ==============================================================================

Write-Host ""
Write-Host "╭──────────────────────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "│  ⚡ INSTALLING SHORTCUTS CLI (WINDOWS)                        │" -ForegroundColor White
Write-Host "│  Fast, noise-free installed tools & shortcuts detector       │" -ForegroundColor DarkGray
Write-Host "╰──────────────────────────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""

$repo = "0xposa/shortcuts"
$branch = "main"
$rawUrl = "https://raw.githubusercontent.com/$repo/$branch/windows/shortcuts.ps1"

# Target directory
$targetDir = "$HOME\.local\bin"
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

$scriptPath = Join-Path $targetDir "shortcuts.ps1"
$cmdWrapper = Join-Path $targetDir "shortcuts.cmd"

Write-Host "  Downloading : $rawUrl..." -ForegroundColor DarkGray
Invoke-WebRequest -Uri $rawUrl -OutFile $scriptPath -UseBasicParsing

# Create CMD wrapper so 'shortcuts' works directly in cmd & powershell
$cmdContent = @"
@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$scriptPath" %*
"@
Set-Content -Path $cmdWrapper -Value $cmdContent

# Add to user PATH if not present
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$targetDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$targetDir", "User")
    $env:PATH = "$env:PATH;$targetDir"
    Write-Host "  Added $targetDir to your User PATH." -ForegroundColor Green
}

Write-Host ""
Write-Host "✔ Successfully installed 'shortcuts'!" -ForegroundColor Green
Write-Host ""
Write-Host "You can now run:" -ForegroundColor White
Write-Host "  shortcuts          # Show all installed tools" -ForegroundColor Green
Write-Host "  shortcuts <query>  # Search specific tool" -ForegroundColor Green
Write-Host ""
