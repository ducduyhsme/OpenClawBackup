#!/usr/bin/env bash
set -euo pipefail

REPO="ducduyhsme/OpenClawBackup"
WORKDIR="${TMPDIR:-/tmp}/openclaw-restore-$$"
ARCHIVE_PATH="$WORKDIR/openclaw-backup.tar.gz"

cleanup() {
  rm -rf "$WORKDIR"
}
trap cleanup EXIT

mkdir -p "$WORKDIR"

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) is required for automatic download."
  echo "Install it first: brew install gh"
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI is not authenticated. Run: gh auth login"
  exit 1
fi

echo "Finding latest release asset in $REPO..."
ASSET_NAME="$(gh release view --repo "$REPO" --json assets --jq '.assets[] | select(.name | endswith(".tar.gz")) | .name' | head -n 1)"

if [[ -z "$ASSET_NAME" ]]; then
  echo "No .tar.gz asset found in the latest release."
  exit 1
fi

echo "Downloading $ASSET_NAME ..."
gh release download --repo "$REPO" --pattern "$ASSET_NAME" --dir "$WORKDIR"

DOWNLOADED="$(find "$WORKDIR" -maxdepth 1 -type f -name '*.tar.gz' | head -n 1)"
if [[ -z "$DOWNLOADED" ]]; then
  echo "Download failed: no archive found in $WORKDIR"
  exit 1
fi

mv "$DOWNLOADED" "$ARCHIVE_PATH"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$SCRIPT_DIR/restore-macos.sh" "$ARCHIVE_PATH"
