# OpenClawBackup

Automated backups for OpenClaw.

- Schedule: every 2 hours
- Retention in repo: latest backup only
- Filename format: `HH dd-mm-yyyy.tar.gz` (UTC)

## What is in the backup?

Each backup archive is intended to preserve the OpenClaw user data directory so it can be restored onto another machine.

Typical contents include:
- `~/.openclaw/`
- configuration
- sessions/history
- installed skills
- local workspace data stored inside the OpenClaw home directory

Exact contents depend on what existed on the source machine when the backup was created.

## Fastest restore options

This repo now supports two levels of restore automation:

1. **Restore from a local backup file you already downloaded**
2. **Download the latest GitHub release asset automatically and restore it**

## Restore from a local backup file

### Linux

```bash
bash scripts/restore-linux.sh /path/to/openclaw-backup.tar.gz
```

### macOS

```bash
bash scripts/restore-macos.sh /path/to/openclaw-backup.tar.gz
```

### Windows (PowerShell)

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\restore-windows.ps1 -ArchivePath C:\path\to\openclaw-backup.tar.gz
```

## Download latest release asset automatically, then restore

These scripts fetch the newest `.tar.gz` asset from the latest GitHub release in `ducduyhsme/OpenClawBackup`, then hand off to the normal restore script.

### Requirements for auto-download scripts

- GitHub CLI (`gh`) installed
- `gh auth login` already completed
- access to the private repository/releases

### Linux

```bash
bash scripts/restore-latest-linux.sh
```

### macOS

```bash
bash scripts/restore-latest-macos.sh
```

### Windows (PowerShell)

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\restore-latest-windows.ps1
```

What the scripts do:
- install OpenClaw if missing
- stop running OpenClaw processes
- back up any existing `.openclaw`
- download the latest release asset automatically if you use the `restore-latest-*` scripts
- extract the backup into your home directory
- leave you ready to run `openclaw status`

## Linux restore steps

These steps are meant for moving or recovering OpenClaw onto a Linux machine.

### 1. Install prerequisites

```bash
sudo apt update
sudo apt install -y curl git tar
```

Install Node.js first if it is not already present.

If you want automatic release downloads, also install GitHub CLI:

```bash
sudo apt install -y gh
```

Then authenticate:

```bash
gh auth login
```

### 2. Install OpenClaw

```bash
npm install -g openclaw
```

If your npm global bin path is custom, make sure it is in your `PATH`.

### 3. Stop OpenClaw before restoring

```bash
pkill -x openclaw-gateway || true
```

If you use a service manager, stop it there instead.

### 4. Download the backup archive

Manual example:

```bash
wget -O openclaw-backup.tar.gz "PASTE_RELEASE_ASSET_URL_HERE"
```

Or use the automatic script:

```bash
bash scripts/restore-latest-linux.sh
```

### 5. Back up the current machine state

```bash
mv ~/.openclaw ~/.openclaw.before-restore-$(date +%Y%m%d-%H%M%S) 2>/dev/null || true
```

### 6. Restore the archive

```bash
tar -xzf openclaw-backup.tar.gz -C "$HOME"
```

### 7. Fix ownership and permissions

```bash
chown -R "$USER":"$(id -gn)" ~/.openclaw
chmod -R u+rwX ~/.openclaw
```

### 8. Start and verify

```bash
openclaw gateway start
openclaw status
```

## macOS restore steps

These steps are meant for moving or recovering OpenClaw onto a Mac.

### 1. Install prerequisites

Install:
- Node.js
- `tar` (already included on macOS)
- optionally Homebrew if you use it for package management

If you use Homebrew, a typical setup is:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install node gh
```

Then authenticate GitHub CLI if you want automatic latest-release downloads:

```bash
gh auth login
```

### 2. Install OpenClaw

```bash
npm install -g openclaw
```

### 3. Stop OpenClaw before restoring

```bash
pkill -x openclaw-gateway || true
```

### 4. Download the backup archive

Manual: download the `.tar.gz` backup from this repo or from a release asset.

Automatic:

```bash
bash scripts/restore-latest-macos.sh
```

### 5. Back up the current machine state

```bash
mv ~/.openclaw ~/.openclaw.before-restore-$(date +%Y%m%d-%H%M%S) 2>/dev/null || true
```

### 6. Restore the archive

```bash
tar -xzf openclaw-backup.tar.gz -C "$HOME"
```

### 7. Fix permissions if needed

```bash
chmod -R u+rwX ~/.openclaw
```

### 8. Start and verify

```bash
openclaw gateway start
openclaw status
```

## Windows restore steps

These steps are meant for restoring OpenClaw onto Windows.

### 1. Install prerequisites

Install:
- Node.js
- GitHub CLI (`gh`) if you want automatic latest-release downloads
- Git for Windows or another environment that gives you `tar`, if your Windows build does not already include it
- PowerShell (already included on modern Windows)

Authenticate GitHub CLI if you want automatic downloads:

```powershell
gh auth login
```

### 2. Install OpenClaw

Open PowerShell and run:

```powershell
npm install -g openclaw
```

### 3. Stop OpenClaw before restoring

If OpenClaw is running, stop it before extracting the backup.

You can use the helper scripts below, which attempt to stop matching OpenClaw processes safely.

### 4. Download the backup archive

Manual:

```text
C:\Users\YourName\Downloads\openclaw-backup.tar.gz
```

Automatic:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\restore-latest-windows.ps1
```

### 5. Back up the current machine state

In PowerShell:

```powershell
if (Test-Path "$HOME\.openclaw") {
  Move-Item "$HOME\.openclaw" "$HOME\.openclaw.before-restore-$(Get-Date -Format yyyyMMdd-HHmmss)"
}
```

### 6. Restore the archive

```powershell
tar -xzf C:\path\to\openclaw-backup.tar.gz -C $HOME
```

### 7. Start and verify

```powershell
openclaw status
```

If needed:

```powershell
openclaw gateway start
```

## Clean restore checklist

If you want the least messy migration path on a new computer:

1. Install Node.js
2. Install OpenClaw
3. Install/authenticate GitHub CLI if you want automatic latest-release downloads
4. Do **not** configure a lot of new data yet
5. Stop OpenClaw
6. Restore the backup archive
7. Fix ownership/permissions if needed
8. Start OpenClaw
9. Verify with `openclaw status`

## Files in this repo for restore

Manual/local-archive restore:
- `scripts/restore-linux.sh`
- `scripts/restore-macos.sh`
- `scripts/restore-windows.ps1`

Automatic latest-release download + restore:
- `scripts/restore-latest-linux.sh`
- `scripts/restore-latest-macos.sh`
- `scripts/restore-latest-windows.ps1`

## Notes

- Backups are created in UTC.
- The repo keeps only the latest backup file in `backups/`.
- Releases may still preserve older restore points as attached assets.
- Automatic latest-release scripts intentionally use GitHub releases, not the tracked `backups/` file, because release assets are a better place for larger archives.
- If OpenClaw changes its internal storage layout in the future, restore steps may need slight adjustment.
- If something goes wrong, restore your saved `.openclaw.before-restore-*` backup folder.
