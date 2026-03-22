# Linux Restore Guide

This guide explains how to restore an OpenClaw backup on Linux.

## Quick options

### Restore from a local backup file

```bash
bash scripts/restore-linux.sh /path/to/openclaw-backup.tar.gz
```

### Download the latest release asset automatically, then restore

```bash
bash scripts/restore-latest-linux.sh
```

## Requirements

Install basic tools:

```bash
sudo apt update
sudo apt install -y curl git tar
```

Install Node.js first if it is not already present.

If you want automatic latest-release downloads, install GitHub CLI and authenticate:

```bash
sudo apt install -y gh
gh auth login
```

## Manual restore steps

### 1. Install OpenClaw

```bash
npm install -g openclaw
```

If your npm global bin path is custom, make sure it is in your `PATH`.

### 2. Stop OpenClaw before restoring

```bash
pkill -x openclaw-gateway || true
```

If you use a service manager, stop it there instead.

### 3. Download the backup archive

Manual example:

```bash
wget -O openclaw-backup.tar.gz "PASTE_RELEASE_ASSET_URL_HERE"
```

Or use the automatic script:

```bash
bash scripts/restore-latest-linux.sh
```

### 4. Back up the current machine state

```bash
mv ~/.openclaw ~/.openclaw.before-restore-$(date +%Y%m%d-%H%M%S) 2>/dev/null || true
```

### 5. Restore the archive

```bash
tar -xzf openclaw-backup.tar.gz -C "$HOME"
```

### 6. Fix ownership and permissions

```bash
chown -R "$USER":"$(id -gn)" ~/.openclaw
chmod -R u+rwX ~/.openclaw
```

### 7. Start and verify

```bash
openclaw gateway start
openclaw status
```

## Included scripts

- `scripts/restore-linux.sh`
- `scripts/restore-latest-linux.sh`

## Notes

- The `restore-latest-linux.sh` script uses GitHub CLI (`gh`) to download the newest `.tar.gz` asset from the latest release.
- Because the repository is private, `gh auth login` is required first.
- If something goes wrong, restore your saved `~/.openclaw.before-restore-*` folder.
