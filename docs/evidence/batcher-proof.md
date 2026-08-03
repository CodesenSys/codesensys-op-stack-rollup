# CodesenSys OP Stack – End-to-End Batch Publication Proof

## Environment

- L1: Ethereum Sepolia
- L2 Chain ID: 3399647
- Execution Client: op-reth v2.4.1
- Rollup Node: op-node v1.19.3
- Batcher: op-batcher v1.16.8

---

## Batch Transaction

Transaction Hash:

0x1ef4939d525cf2a3694acb027f78694adac25607802c7b08e961dc579244af1f

Included in Sepolia Block:

11412725

Status:

SUCCESS

Batch Inbox:

0x00b25C9F1D97b525Eaad68A3594867649C24A06C

Gas Used:

1019490

---

## Rollup Synchronization

Unsafe L2:

3131

Safe L2:

2105

Finalized L2:

1625

Current L1:

11413057

Head L1:

11413061

---

## Verification

The following pipeline has been verified successfully:

User Transaction
        ↓
Sequencer
        ↓
L2 Block Production
        ↓
Channel Compression
        ↓
Batch Submission
        ↓
Ethereum Sepolia
        ↓
Batch Derivation
        ↓
Safe L2
        ↓
Finalized L2

Result:

✓ End-to-end OP Stack rollup lifecycle successfully verified.
