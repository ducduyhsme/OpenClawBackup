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

## Restore guides

Platform-specific restore instructions live in separate guide files:

- [Linux restore guide](./LINUX_GUIDE.md)
- [macOS restore guide](./MACOS_GUIDE.md)
- [Windows 11 restore guide](./WINDOWS_11_GUIDE.md)

## Script layout

Scripts are now grouped by platform:

- `scripts/linux/`
- `scripts/macos/`
- `scripts/windows/`

## Restore scripts included in this repo

### Linux

- `scripts/linux/restore-linux.sh`
- `scripts/linux/restore-latest-linux.sh`

### macOS

- `scripts/macos/restore-macos.sh`
- `scripts/macos/restore-latest-macos.sh`

### Windows 11

- `scripts/windows/restore-windows.ps1`
- `scripts/windows/restore-latest-windows.ps1`

## Fastest commands

### Linux

Restore from a local archive:

```bash
bash scripts/linux/restore-linux.sh /path/to/openclaw-backup.tar.gz
```

Download latest release asset automatically, then restore:

```bash
bash scripts/linux/restore-latest-linux.sh
```

### macOS

Restore from a local archive:

```bash
bash scripts/macos/restore-macos.sh /path/to/openclaw-backup.tar.gz
```

Download latest release asset automatically, then restore:

```bash
bash scripts/macos/restore-latest-macos.sh
```

### Windows 11

Restore from a local archive:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\restore-windows.ps1 -ArchivePath C:\path\to\openclaw-backup.tar.gz
```

Download latest release asset automatically, then restore:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\restore-latest-windows.ps1
```

## Notes

- Backups are created in UTC.
- The repo keeps only the latest backup file in `backups/`.
- Releases may still preserve older restore points as attached assets.
- Automatic latest-release scripts intentionally use GitHub releases, not the tracked `backups/` file, because release assets are a better place for larger archives.
- Because the repository is private, auto-download scripts require `gh auth login` first.
