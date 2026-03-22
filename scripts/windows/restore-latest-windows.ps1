$ErrorActionPreference = 'Stop'

$Repo = 'ducduyhsme/OpenClawBackup'
$WorkDir = Join-Path $env:TEMP ("openclaw-restore-" + [guid]::NewGuid().ToString())
$ArchivePath = Join-Path $WorkDir 'openclaw-backup.tar.gz'

New-Item -ItemType Directory -Path $WorkDir | Out-Null

try {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        throw 'GitHub CLI (gh) is required for automatic download. Install it from https://cli.github.com/'
    }

    gh auth status *> $null
    if ($LASTEXITCODE -ne 0) {
        throw 'GitHub CLI is not authenticated. Run: gh auth login'
    }

    Write-Host "Finding latest release asset in $Repo..."
    $assetName = gh release view --repo $Repo --json assets --jq '.assets[] | select(.name | endswith(".tar.gz")) | .name' | Select-Object -First 1

    if ([string]::IsNullOrWhiteSpace($assetName)) {
        throw 'No .tar.gz asset found in the latest release.'
    }

    Write-Host "Downloading $assetName ..."
    gh release download --repo $Repo --pattern $assetName --dir $WorkDir

    $downloaded = Get-ChildItem -Path $WorkDir -Filter *.tar.gz | Select-Object -First 1
    if (-not $downloaded) {
        throw 'Download failed: no archive found.'
    }

    Move-Item $downloaded.FullName $ArchivePath -Force

    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    & (Join-Path $scriptDir 'restore-windows.ps1') -ArchivePath $ArchivePath
}
finally {
    if (Test-Path $WorkDir) {
        Remove-Item $WorkDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
