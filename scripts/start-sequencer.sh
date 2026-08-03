#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ ! -f "$ROOT_DIR/.env" ]]; then
  echo "Missing $ROOT_DIR/.env"
  echo "Create it from .env.example and add your private RPC endpoints."
  exit 1
fi

set -a
source "$ROOT_DIR/.env"
set +a

if [[ -z "${L1_RPC_URL:-}" || -z "${L1_BEACON_URL:-}" ]]; then
  echo "L1_RPC_URL and L1_BEACON_URL must be configured."
  exit 1
fi

if [[ -z "${SEQUENCER_PRIVATE_KEY:-}" ]]; then
  read -rs -p "Enter unsafe-block-signer private key: " SEQUENCER_PRIVATE_KEY
  echo
  export SEQUENCER_PRIVATE_KEY
fi

DERIVED_ADDRESS="$(cast wallet address --private-key "$SEQUENCER_PRIVATE_KEY")"
EXPECTED_ADDRESS="0x0b818B214C0237784DaA00aD272487109194544b"

if [[ "${DERIVED_ADDRESS,,}" != "${EXPECTED_ADDRESS,,}" ]]; then
  unset SEQUENCER_PRIVATE_KEY
  echo "The supplied key does not match the configured unsafe block signer."
  exit 1
fi

cd "$ROOT_DIR/sequencer"
docker compose config --quiet
docker compose up -d op-reth op-node

echo
echo "Sequencer services started."
docker compose ps

unset SEQUENCER_PRIVATE_KEY
