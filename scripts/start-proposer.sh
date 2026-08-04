#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPECTED_ADDRESS="0xc4cC8488a09324f3A4ba280B33D4916F2acD82c7"

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

read -rs -p "Enter proposer private key: " PROPOSER_PRIVATE_KEY
echo
export PROPOSER_PRIVATE_KEY

DERIVED_ADDRESS="$(
  cast wallet address --private-key "$PROPOSER_PRIVATE_KEY"
)"

if [[ "${DERIVED_ADDRESS,,}" != "${EXPECTED_ADDRESS,,}" ]]; then
  unset PROPOSER_PRIVATE_KEY
  echo "The supplied key does not match the configured proposer address."
  exit 1
fi

cd "$ROOT_DIR/sequencer"

docker compose up -d --no-deps op-proposer
docker compose ps op-proposer

unset PROPOSER_PRIVATE_KEY
