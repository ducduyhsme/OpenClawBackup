#!/usr/bin/env bash
set -euo pipefail

ARCHIVE_PATH="${1:-}"

if [[ -z "$ARCHIVE_PATH" ]]; then
  echo "Usage: $0 /path/to/openclaw-backup.tar.gz"
  exit 1
fi

if [[ ! -f "$ARCHIVE_PATH" ]]; then
  echo "Archive not found: $ARCHIVE_PATH"
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is required. Install Node.js first."
  exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
  echo "tar is required."
  exit 1
fi

export PATH="$HOME/.npm-global/bin:$PATH"

if ! command -v openclaw >/dev/null 2>&1; then
  echo "Installing OpenClaw..."
  npm install -g openclaw
fi

echo "Stopping running OpenClaw processes if present..."
pkill -x openclaw-gateway 2>/dev/null || true

STAMP="$(date +%Y%m%d-%H%M%S)"
if [[ -d "$HOME/.openclaw" ]]; then
  echo "Backing up existing ~/.openclaw to ~/.openclaw.before-restore-$STAMP"
  mv "$HOME/.openclaw" "$HOME/.openclaw.before-restore-$STAMP"
fi

echo "Restoring archive into $HOME..."
tar -xzf "$ARCHIVE_PATH" -C "$HOME"

if [[ -d "$HOME/.openclaw" ]]; then
  chmod -R u+rwX "$HOME/.openclaw" 2>/dev/null || true
fi

echo "Restore complete."
echo "You can now run: openclaw status"
echo "If needed, start it with: openclaw gateway start"
