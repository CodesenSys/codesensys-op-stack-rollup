#!/usr/bin/env bash
set -euo pipefail

L2_RPC_URL="${L2_RPC_URL:-http://127.0.0.1:8545}"
OP_NODE_RPC_URL="${OP_NODE_RPC_URL:-http://127.0.0.1:8547}"

echo "CodesenSys OP Stack health check"
echo "--------------------------------"

CHAIN_ID="$(cast chain-id --rpc-url "$L2_RPC_URL")"
BLOCK_NUMBER="$(cast block-number --rpc-url "$L2_RPC_URL")"
CLIENT="$(cast client --rpc-url "$L2_RPC_URL")"

printf 'Execution client: %s\n' "$CLIENT"
printf 'L2 chain ID:     %s\n' "$CHAIN_ID"
printf 'L2 block height: %s\n' "$BLOCK_NUMBER"

if [[ "$CHAIN_ID" != "3399647" ]]; then
  echo "Unexpected L2 chain ID."
  exit 1
fi

SYNC_STATUS="$(
  curl -fsS \
    -H 'Content-Type: application/json' \
    --data '{"jsonrpc":"2.0","method":"optimism_syncStatus","params":[],"id":1}' \
    "$OP_NODE_RPC_URL"
)"

echo "$SYNC_STATUS" | jq '{
  unsafe_l2: .result.unsafe_l2.number,
  safe_l2: .result.safe_l2.number,
  finalized_l2: .result.finalized_l2.number,
  current_l1: .result.current_l1.number
}'
