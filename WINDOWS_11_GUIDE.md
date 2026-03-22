# Windows 11 Restore Guide

This guide explains how to restore an OpenClaw backup on Windows 11.

## Quick options

### Restore from a local backup file

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\restore-windows.ps1 -ArchivePath C:\path\to\openclaw-backup.tar.gz
```

### Download the latest release asset automatically, then restore

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\restore-latest-windows.ps1
```

## Requirements

Install:
- Node.js
- GitHub CLI (`gh`) if you want automatic latest-release downloads
- Git for Windows or another environment that gives you `tar`, if your Windows build does not already include it
- PowerShell (already included on Windows 11)

Authenticate GitHub CLI if you want automatic downloads:

```powershell
gh auth login
```

## Manual restore steps

### 1. Install OpenClaw

Open PowerShell and run:

```powershell
npm install -g openclaw
```

### 2. Stop OpenClaw before restoring

If OpenClaw is running, stop it before extracting the backup.

The helper scripts attempt to stop matching OpenClaw processes safely.

### 3. Download the backup archive

Manual:

```text
C:\Users\YourName\Downloads\openclaw-backup.tar.gz
```

Automatic:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\restore-latest-windows.ps1
```

### 4. Back up the current machine state

In PowerShell:

```powershell
if (Test-Path "$HOME\.openclaw") {
  Move-Item "$HOME\.openclaw" "$HOME\.openclaw.before-restore-$(Get-Date -Format yyyyMMdd-HHmmss)"
}
```

### 5. Restore the archive

```powershell
tar -xzf C:\path\to\openclaw-backup.tar.gz -C $HOME
```

### 6. Start and verify

```powershell
openclaw status
```

If needed:

```powershell
openclaw gateway start
```

## Included scripts

- `scripts/restore-windows.ps1`
- `scripts/restore-latest-windows.ps1`

## Notes

- The `restore-latest-windows.ps1` script uses GitHub CLI (`gh`) to download the newest `.tar.gz` asset from the latest release.
- Because the repository is private, `gh auth login` is required first.
- If something goes wrong, restore your saved `.openclaw.before-restore-*` backup folder.
