#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SOURCE_DIR="$ROOT_DIR/deployer/output"
TARGET_DIR="$ROOT_DIR/sequencer/config"

REQUIRED_FILES=(
  genesis.json
  rollup.json
  l1-addresses.json
)

mkdir -p "$TARGET_DIR"

for FILE in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "$SOURCE_DIR/$FILE" ]]; then
    echo "Missing required deployment artifact: $SOURCE_DIR/$FILE"
    exit 1
  fi

  cp "$SOURCE_DIR/$FILE" "$TARGET_DIR/$FILE"
done

chmod 644 "$TARGET_DIR"/*.json

echo "Sequencer configuration prepared:"
ls -lh "$TARGET_DIR"
