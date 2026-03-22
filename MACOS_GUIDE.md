# macOS Restore Guide

This guide explains how to restore an OpenClaw backup on macOS.

## Quick options

### Restore from a local backup file

```bash
bash scripts/restore-macos.sh /path/to/openclaw-backup.tar.gz
```

### Download the latest release asset automatically, then restore

```bash
bash scripts/restore-latest-macos.sh
```

## Requirements

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

## Manual restore steps

### 1. Install OpenClaw

```bash
npm install -g openclaw
```

### 2. Stop OpenClaw before restoring

```bash
pkill -x openclaw-gateway || true
```

### 3. Download the backup archive

Manual: download the `.tar.gz` backup from this repo or from a release asset.

Automatic:

```bash
bash scripts/restore-latest-macos.sh
```

### 4. Back up the current machine state

```bash
mv ~/.openclaw ~/.openclaw.before-restore-$(date +%Y%m%d-%H%M%S) 2>/dev/null || true
```

### 5. Restore the archive

```bash
tar -xzf openclaw-backup.tar.gz -C "$HOME"
```

### 6. Fix permissions if needed

```bash
chmod -R u+rwX ~/.openclaw
```

### 7. Start and verify

```bash
openclaw gateway start
openclaw status
```

## Included scripts

- `scripts/restore-macos.sh`
- `scripts/restore-latest-macos.sh`

## Notes

- The `restore-latest-macos.sh` script uses GitHub CLI (`gh`) to download the newest `.tar.gz` asset from the latest release.
- Because the repository is private, `gh auth login` is required first.
- If something goes wrong, restore your saved `~/.openclaw.before-restore-*` folder.
