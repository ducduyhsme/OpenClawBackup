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

## Restore OpenClaw on another computer

These steps are meant for moving or recovering OpenClaw onto a different Linux machine.

### 1. Install prerequisites

Install Node.js and any basic tools you need:

```bash
sudo apt update
sudo apt install -y curl git tar
```

If Node.js is not installed yet, install it first using your preferred method.

### 2. Install OpenClaw

Install OpenClaw on the target machine before restoring the backup:

```bash
npm install -g openclaw
```

If your setup uses a custom npm global path, make sure that path is in your `PATH`.

### 3. Stop OpenClaw before restoring

If OpenClaw is already running, stop it first so files are not overwritten while in use.

Examples:

```bash
pkill -x openclaw-gateway || true
pkill -f "openclaw.*gateway" || true
```

Or stop it using whatever service manager you normally use.

### 4. Download the backup archive

Get the latest backup from this repository or from the latest GitHub release asset.

Example using `wget` after copying the asset URL:

```bash
wget -O openclaw-backup.tar.gz "PASTE_RELEASE_ASSET_URL_HERE"
```

Or if you already cloned the repo:

```bash
cp "backups/<backup-file>.tar.gz" ./openclaw-backup.tar.gz
```

### 5. Make a safety backup of the current machine

If the target machine already has OpenClaw data, back it up first:

```bash
mv ~/.openclaw ~/.openclaw.before-restore-$(date +%Y%m%d-%H%M%S) 2>/dev/null || true
```

### 6. Restore the archive into your home directory

Extract the archive so that `.openclaw` returns to your home folder:

```bash
tar -xzf openclaw-backup.tar.gz -C "$HOME"
```

After extraction, you should have:

```bash
$HOME/.openclaw
```

### 7. Fix ownership and permissions

If the backup came from another machine or another user, fix ownership:

```bash
chown -R "$USER":"$USER" ~/.openclaw
chmod -R u+rwX ~/.openclaw
```

### 8. Start OpenClaw again

Start OpenClaw the same way you normally do on that machine.

If you use the gateway directly:

```bash
openclaw gateway start
```

If your setup uses another launcher, service, or supervisor, use that instead.

### 9. Verify the restore worked

Check that OpenClaw can see the restored data:

```bash
openclaw status
```

Then confirm that things like these are present again:
- your configured skills
- your memory/workspace files
- your sessions or related state
- your local settings

## Clean restore checklist

If you want the least messy migration path on a new computer:

1. Install Node.js
2. Install OpenClaw
3. Do **not** configure a lot of new data yet
4. Stop OpenClaw
5. Restore the backup archive
6. Fix ownership
7. Start OpenClaw
8. Verify with `openclaw status`

## Notes

- Backups are created in UTC.
- The repo keeps only the latest backup file in `backups/`.
- Releases may still preserve older restore points as attached assets.
- If OpenClaw changes its internal storage layout in the future, restore steps may need slight adjustment.
- If something goes wrong, restore your saved `~/.openclaw.before-restore-*` folder.
