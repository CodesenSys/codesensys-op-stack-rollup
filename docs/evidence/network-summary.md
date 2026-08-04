# CodesenSys OP Stack Rollup — Network Summary

## Network identity

| Property | Value |
|---|---|
| Network | CodesenSys Enterprise OP Stack |
| L1 settlement network | Ethereum Sepolia |
| L1 chain ID | 11155111 |
| L2 chain ID | 3399647 |
| Native gas asset | ETH |
| Execution client | op-reth v2.4.1 |
| Rollup node | op-node v1.19.3 |
| Block production | Local sequencer |
| Data availability | Ethereum |
| Interoperability mode | Disabled |

## Genesis

| Property | Value |
|---|---|
| L1 starting block | 11409124 |
| L1 starting block hash | `0xf0803878f5efa382b66583865d6bf19a4f0fcf6209d2f880c76d26f59afd3de9` |
| L2 genesis hash | `0x3fe2ffbbfb3480f401ee3b340395e8ecee9b3884722480b83834ef9f56f18fcf` |
| Genesis allocation accounts | 2341 |
| L2 gas limit | 60000000 |

## Core L1 contracts

| Contract | Sepolia address |
|---|---|
| Optimism Portal | `0xb8c1a0787c9805008e60de1212c00922acf0d204` |
| System Config | `0xf3119f68feeab32ff35b8a6acbfb83265b9ba750` |
| Standard Bridge | `0x63217bcc87e6456e37c1bb4a3d608778e893b976` |
| Cross-Domain Messenger | `0xb3085264059a5a670ee026c33ccceb876832b903` |
| Dispute Game Factory | `0xb22096a934ae1182e11d3a2271cd9607b74e0de1` |
| Anchor State Registry | `0xe35d9905e21e56a4a93678d8f1151da9aa074d08` |

## Operational roles

Only public addresses are documented here.

| Role | Address |
|---|---|
| Admin and treasury | `0xA8fc0E1E3Ad1E47B707a549C94Ec5989e75F3Cb5` |
| Unsafe block signer | `0x0b818B214C0237784DaA00aD272487109194544b` |
| Batcher | `0x5AD8be46F988E996d2aDa2E0C21738936C439963` |
| Proposer | `0xc4cC8488a09324f3A4ba280B33D4916F2acD82c7` |

## Operating scope

The repository demonstrates:

- deployment of an OP Stack L2 against Ethereum Sepolia;
- custom chain ID and genesis configuration;
- dedicated administrative and runtime roles;
- `op-reth` execution;
- `op-node` sequencing and derivation;
- authenticated Engine API communication using JWT;
- `op-batcher` publication of compressed L2 data to Sepolia;
- safe and finalized L2 progression;
- `op-proposer` state claims;
- permissioned dispute-game creation;
- L1-to-L2 ETH deposits;
- locally bound JSON-RPC endpoints.

The current deployment is a persistent single-machine Sepolia reference environment.

Production deployment would additionally require:

- a public RPC gateway and rate limiting;
- challenger infrastructure;
- redundant execution and rollup nodes;
- multisignature governance;
- managed secret storage;
- monitoring, alerting, and incident response;
- automated backups and disaster recovery.
