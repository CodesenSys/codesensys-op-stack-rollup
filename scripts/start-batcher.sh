#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPECTED_ADDRESS="0x5AD8be46F988E996d2aDa2E0C21738936C439963"

if [[ ! -f "$ROOT_DIR/.env" ]]; then
  echo "Missing $ROOT_DIR/.env"
  exit 1
fi

set -a
source "$ROOT_DIR/.env"
set +a

if [[ -z "${L1_RPC_URL:-}" ]]; then
  echo "L1_RPC_URL must be configured."
  exit 1
fi

read -rs -p "Enter batcher private key: " BATCHER_PRIVATE_KEY
echo
export BATCHER_PRIVATE_KEY

DERIVED_ADDRESS="$(
  cast wallet address --private-key "$BATCHER_PRIVATE_KEY"
)"

if [[ "${DERIVED_ADDRESS,,}" != "${EXPECTED_ADDRESS,,}" ]]; then
  unset BATCHER_PRIVATE_KEY
  echo "The supplied key does not match the configured batcher address."
  exit 1
fi

cd "$ROOT_DIR/sequencer"

docker compose up -d --no-deps op-batcher
docker compose ps op-batcher

unset BATCHER_PRIVATE_KEY
