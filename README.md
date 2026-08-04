# CodesenSys OP Stack Rollup

A reproducible OP Stack L2 infrastructure showcase deployed against Ethereum Sepolia.

This repository demonstrates the deployment and operation of a custom OP Stack rollup using:

- `op-deployer`
- `op-reth`
- `op-node`
- Docker Compose
- Ethereum Sepolia as the settlement and data-availability layer

## Network

| Property | Value |
|---|---|
| L1 network | Ethereum Sepolia |
| L1 chain ID | `11155111` |
| L2 chain ID | `3399647` |
| Native gas asset | ETH |
| Execution client | `op-reth v2.4.1` |
| Rollup node | `op-node v1.19.3` |
| Block time | 2 seconds |
| Interop | Disabled |

## Architecture

```text
Enterprise Applications
          |
          v
   CodesenSys L2 RPC
          |
          v
       op-reth
  Execution Engine
          |
   Authenticated Engine API
          |
          v
       op-node
 Rollup and Sequencer Node
          |
          +----------------------+
          |                      |
          v                      v
 Sepolia Execution RPC    Sepolia Beacon API
          |
          v
 OP Stack L1 Contracts
          |
          v
   Ethereum Sepolia
```

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
│       └── network-summary.md
├── scripts/
│   ├── prepare-sequencer-config.sh
│   ├── start-sequencer.sh
│   ├── stop-sequencer.sh
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
- Access to a Sepolia execution RPC
- Access to a Sepolia Beacon API
- The configured unsafe-block-signer private key

Private keys, encrypted keystores, RPC credentials, JWT secrets, deployment state, runtime databases, and logs are intentionally excluded from Git.

## Prepare the environment

```bash
cp .env.example .env
```

Populate the private execution and Beacon endpoints in `.env`.

Do not store the sequencer private key in `.env`. The startup script requests it through a hidden terminal prompt.

## Prepare sequencer configuration

```bash
./scripts/prepare-sequencer-config.sh
```

This copies the canonical deployment artifacts into the local sequencer configuration directory.

Generate a local Engine API JWT secret:

```bash
mkdir -p sequencer/jwt
openssl rand -hex 32 > sequencer/jwt/jwt.txt
chmod 600 sequencer/jwt/jwt.txt
```

## Start the network

```bash
./scripts/start-sequencer.sh
```

The script:

1. loads the private L1 endpoints;
2. requests the unsafe-block-signer key securely;
3. verifies the derived signer address;
4. validates Docker Compose;
5. starts `op-reth` and `op-node`;
6. clears the signer key from the script environment.

## Health check

```bash
./scripts/health-check.sh
```

Expected L2 chain ID:

```text
3399647
```

## Stop the network

```bash
./scripts/stop-sequencer.sh
```

This stops the services without deleting runtime databases.

## Core L1 contracts

The deployed Sepolia contract addresses are recorded in:

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

## Current scope

This repository demonstrates a single-machine testnet sequencer and OP Stack deployment.

It does not yet include:

- a public RPC gateway;
- `op-batcher`;
- `op-proposer`;
- `op-challenger`;
- multisignature governance;
- monitoring and alerting;
- production secret management;
- high-availability infrastructure.

These components are required before treating the system as production-grade infrastructure.

## Related repository

Enterprise application contracts intended for this L2 are maintained separately:

```text
CodesenSys/codesensys-enterprise-op-stack
```

## License

MIT

## Verified Operational Milestones

The CodesenSys OP Stack rollup has successfully completed the following infrastructure milestones:

- ✅ OP Stack L1 contracts deployed to Ethereum Sepolia
- ✅ Custom L2 genesis and rollup configuration generated
- ✅ `op-reth` execution engine operational
- ✅ `op-node` sequencer operational
- ✅ L2 block production verified on chain ID `3399647`
- ✅ `op-batcher` published compressed L2 batches to Ethereum Sepolia
- ✅ Batch transaction successfully mined on L1
- ✅ Safe L2 derivation verified
- ✅ Finalized L2 progression verified

### Evidence

Operational evidence for the batch publication milestone is available at:

`docs/evidence/batcher-proof.md`

### Next Milestones

- Deploy and configure `op-proposer`
- Verify L2 output proposal publication
- Deploy enterprise smart contracts to the CodesenSys L2
- Demonstrate complete enterprise application workflow on the rollup


## Proposer and Dispute Game Milestone

The rollup has successfully completed its first L2 state proposal.

### Verified

- ✅ `op-proposer v1.16.3` connected to the deployed DisputeGameFactory
- ✅ Permissioned dispute game (Game Type 1)
- ✅ Output root submitted to Ethereum Sepolia
- ✅ Proposal transaction mined successfully
- ✅ Dispute-game bond posted
- ✅ First dispute game created successfully
- ✅ Permissioned fault-proof pipeline verified

See:

- `docs/evidence/proposer-proof.md`

