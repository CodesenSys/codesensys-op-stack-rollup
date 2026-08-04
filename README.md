# CodesenSys OP Stack Rollup

Enterprise-focused OP Stack Layer 2 infrastructure deployed against Ethereum Sepolia.

This repository contains the deployment artifacts, runtime configuration, Docker services, operational scripts, and technical evidence for a custom OP Stack rollup operated by CodesenSys.

The network provides the infrastructure layer for the enterprise reference applications maintained in:

https://github.com/CodesenSys/codesensys-enterprise-op-stack

## Network configuration

| Property | Value |
|---|---|
| L1 settlement network | Ethereum Sepolia |
| L1 chain ID | `11155111` |
| L2 chain ID | `3399647` |
| Native gas asset | ETH |
| Block time | 2 seconds |
| Execution client | `op-reth v2.4.1` |
| Rollup node | `op-node v1.19.3` |
| Batch submitter | `op-batcher v1.16.8` |
| State proposer | `op-proposer v1.16.3` |
| Data availability | Ethereum calldata |
| Dispute-game model | Permissioned |
| Interop | Disabled |

## Architecture

```text
                     Enterprise Users
                             │
                             ▼
                 Enterprise Applications
                             │
                             ▼
                  CodesenSys L2 JSON-RPC
                             │
                             ▼
                        op-reth
                  L2 Execution Engine
                             │
                  Authenticated Engine API
                             │
                             ▼
                         op-node
          Sequencing, derivation and rollup control
                    │                  │
                    │                  └──────────────┐
                    ▼                                 ▼
                op-batcher                      op-proposer
          Publishes L2 data to L1        Publishes L2 state claims
                    │                                 │
                    ▼                                 ▼
            Ethereum Sepolia              DisputeGameFactory
                    │                                 │
                    └──────────────┬──────────────────┘
                                   ▼
                       OP Stack L1 Contracts
```

## Infrastructure components

### `op-deployer`

Deploys and configures the OP Stack L1 contracts, chain intent, genesis state, rollup configuration, and network-specific artifacts.

Relevant files:

```text
deployer/.deployer/intent.toml
deployer/output/deploy-config.json
deployer/output/genesis.json
deployer/output/l1-addresses.json
deployer/output/rollup.json
```

### `op-reth`

Provides the L2 execution environment.

Responsibilities include:

- executing L2 transactions;
- maintaining L2 state;
- exposing HTTP and WebSocket JSON-RPC;
- exposing the authenticated Engine API to `op-node`;
- storing the canonical L2 execution database.

### `op-node`

Operates the rollup consensus layer.

Responsibilities include:

- producing unsafe L2 blocks as the sequencer;
- deriving safe L2 blocks from Ethereum data;
- processing L1 deposits;
- tracking safe and finalized L2 heads;
- coordinating block production with `op-reth`;
- exposing the Optimism rollup RPC.

### `op-batcher`

Compresses L2 block data and publishes batches to Ethereum Sepolia.

This converts locally sequenced L2 blocks into data that independent rollup nodes can derive from L1.

### `op-proposer`

Publishes L2 state claims through the deployed `DisputeGameFactory`.

The current chain uses permissioned dispute game type `1` with an initial bond configured on Ethereum Sepolia.

## Transaction lifecycle

```text
User submits L2 transaction
            │
            ▼
         op-reth
 Executes the transaction
            │
            ▼
         op-node
 Sequences the L2 block
            │
            ▼
       Unsafe L2 head
            │
            ▼
       op-batcher
 Publishes compressed data
            │
            ▼
    Ethereum Sepolia
            │
            ▼
    Safe L2 derivation
            │
            ▼
       L1 finalization
            │
            ▼
   Finalized L2 state
            │
            ▼
      op-proposer
 Creates a dispute game
```

## L1 to L2 deposits

The network supports deposits through its deployed `OptimismPortal`.

Verified flow:

```text
Sepolia account
      │
      ▼
OptimismPortal.depositTransaction
      │
      ▼
TransactionDeposited event on L1
      │
      ▼
op-node derivation pipeline
      │
      ▼
Deposited transaction executed on L2
      │
      ▼
Recipient receives L2 ETH
```

A Sepolia deposit was successfully derived into the L2 and credited to the administrative deployment account.

## Core L1 contracts

The complete address set is stored in:

```text
deployer/output/l1-addresses.json
```

| Contract | Address |
|---|---|
| Optimism Portal | `0xb8c1a0787c9805008e60de1212c00922acf0d204` |
| System Config | `0xf3119f68feeab32ff35b8a6acbfb83265b9ba750` |
| Standard Bridge | `0x63217bcc87e6456e37c1bb4a3d608778e893b976` |
| Cross-Domain Messenger | `0xb3085264059a5a670ee026c33ccceb876832b903` |
| Dispute Game Factory | `0xb22096a934ae1182e11d3a2271cd9607b74e0de1` |

## Enterprise applications

The following enterprise reference applications are deployed on chain `3399647`.

| Contract | Address |
|---|---|
| `HealthRecordAccessControl` | `0x4E949Ac98442Ec2F127e61b74C24837227Aac0f0` |
| `SupplyChainProvenance` | `0x75AcB6eA506f5bDA66e2242dbd0139c78768193f` |

Application source code, tests, deployment metadata, and transaction evidence are maintained in:

https://github.com/CodesenSys/codesensys-enterprise-op-stack

## Repository structure

```text
.
├── deployer/
│   ├── .deployer/
│   │   ├── intent.toml
│   │   └── deployment-summary.txt
│   ├── address/public/
│   │   └── role-addresses.env
│   └── output/
│       ├── deploy-config.json
│       ├── genesis.json
│       ├── l1-addresses.json
│       └── rollup.json
├── docs/
│   └── evidence/
│       ├── network-summary.md
│       ├── batcher-proof.md
│       └── proposer-proof.md
├── scripts/
│   ├── prepare-sequencer-config.sh
│   ├── start-sequencer.sh
│   ├── stop-sequencer.sh
│   ├── start-batcher.sh
│   ├── stop-batcher.sh
│   ├── start-proposer.sh
│   ├── stop-proposer.sh
│   └── health-check.sh
├── sequencer/
│   └── docker-compose.yml
├── .env.example
└── .gitignore
```

## Prerequisites

- Docker and Docker Compose
- Foundry `cast`
- `jq`
- `curl`
- OpenSSL
- Sepolia execution RPC
- Sepolia Beacon API
- funded Sepolia operational accounts

Private keys, RPC credentials, encrypted keystores, JWT secrets, deployment state, databases, and logs are excluded from Git.

## Environment configuration

```bash
cp .env.example .env
```

Populate:

```text
L1_RPC_URL
L1_BEACON_URL
L2_CHAIN_ID
L2_RPC_URL
```

Operational private keys are requested through hidden terminal prompts and must not be stored in `.env`.

## Prepare runtime configuration

```bash
./scripts/prepare-sequencer-config.sh
```

Generate the local Engine API JWT secret:

```bash
mkdir -p sequencer/jwt
openssl rand -hex 32 > sequencer/jwt/jwt.txt
chmod 600 sequencer/jwt/jwt.txt
```

## Start the execution engine and sequencer

```bash
./scripts/start-sequencer.sh
```

The script:

1. loads the L1 RPC configuration;
2. requests the unsafe-block-signer key securely;
3. verifies the expected signer address;
4. validates Docker Compose;
5. starts `op-reth` and `op-node`;
6. removes the private key from the script environment.

## Start the batch submitter

```bash
./scripts/start-batcher.sh
```

The batcher consumes Sepolia ETH while publishing L2 data. Run it only when batch publication is required.

## Start the state proposer

```bash
./scripts/start-proposer.sh
```

The proposer requires sufficient Sepolia ETH for transaction fees and the configured dispute-game bond.

## Health checks

```bash
./scripts/health-check.sh
```

Manual checks:

```bash
cast chain-id --rpc-url http://127.0.0.1:8545
cast block-number --rpc-url http://127.0.0.1:8545
```

Expected chain ID:

```text
3399647
```

Rollup synchronization:

```bash
curl -sS \
  -H 'Content-Type: application/json' \
  --data '{"jsonrpc":"2.0","method":"optimism_syncStatus","params":[],"id":1}' \
  http://127.0.0.1:8547 | jq .
```

## Stop services

```bash
./scripts/stop-proposer.sh
./scripts/stop-batcher.sh
./scripts/stop-sequencer.sh
```

Runtime databases remain preserved.

## Operational evidence

| Capability | Evidence |
|---|---|
| Network configuration and L1 contracts | `docs/evidence/network-summary.md` |
| L2 batch publication and safe derivation | `docs/evidence/batcher-proof.md` |
| State proposal and dispute-game creation | `docs/evidence/proposer-proof.md` |
| Enterprise application deployment | Enterprise application repository |

Verified capabilities include:

- OP Stack L1 contract deployment;
- custom L2 genesis generation;
- L2 transaction execution;
- sequencer block production;
- calldata batch publication;
- safe and finalized L2 derivation;
- L1-to-L2 deposits;
- output-root proposal;
- permissioned dispute-game creation;
- enterprise smart-contract deployment.

## Security model

The repository separates operational responsibilities across dedicated accounts:

- administrative treasury;
- unsafe block signer;
- batch submitter;
- state proposer.

Additional controls include:

- private-key verification before startup;
- hidden terminal prompts;
- local-only RPC port bindings;
- Engine API JWT authentication;
- ignored keystores and runtime data;
- explicit public role-address records;
- application-level role enforcement.

## Scope and production considerations

This is a persistent, single-machine Sepolia reference deployment.

A production deployment would additionally require:

- redundant sequencers and execution nodes;
- public RPC gateways and rate limiting;
- managed secret storage or remote signers;
- multisignature governance;
- monitoring, alerting, and incident response;
- automated backups;
- infrastructure-as-code;
- challenger infrastructure;
- disaster-recovery procedures;
- formal operational runbooks.

## Repository ecosystem

```text
codesensys-op-stack-rollup
        │
        ├── deploys the OP Stack infrastructure
        ├── operates sequencing and derivation
        ├── publishes batches to Ethereum
        └── publishes L2 state claims
                 │
                 ▼
codesensys-enterprise-op-stack
        │
        ├── healthcare access governance
        └── supply-chain provenance
```

## License

MIT
