param(
    [Parameter(Mandatory = $true)]
    [string]$ArchivePath
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $ArchivePath)) {
    throw "Archive not found: $ArchivePath"
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "npm is required. Install Node.js first."
}

if (-not (Get-Command tar -ErrorAction SilentlyContinue)) {
    throw "tar is required. Use modern Windows 10/11 or install bsdtar/Git Bash."
}

$OpenClawHome = Join-Path $HOME '.openclaw'
$Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$BackupDir = Join-Path $HOME ".openclaw.before-restore-$Stamp"

$openclawCmd = Get-Command openclaw -ErrorAction SilentlyContinue
if (-not $openclawCmd) {
    Write-Host 'Installing OpenClaw...'
    npm install -g openclaw
}

Write-Host 'Stopping OpenClaw processes if present...'
Get-Process | Where-Object { $_.ProcessName -match 'openclaw|node' } | ForEach-Object {
    try {
        $path = $_.Path
    } catch {
        $path = ''
    }
    if ($path -match 'openclaw') {
        Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    }
}

if (Test-Path $OpenClawHome) {
    Write-Host "Backing up existing $OpenClawHome to $BackupDir"
    Move-Item $OpenClawHome $BackupDir
}

Write-Host 'Restoring archive into your home directory...'
tar -xzf $ArchivePath -C $HOME

Write-Host 'Restore complete.'
Write-Host 'You can now run: openclaw status'
Write-Host 'If needed, start it with: openclaw gateway start'
