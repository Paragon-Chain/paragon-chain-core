# XPGN L1 Representation Decision

Status: draft decision framework / not approved for implementation
Repo: `paragon-chain-core`

## Purpose

Define how the already-launched BNB Chain XPGN token should relate to Paragon L1 before any bridge, migration, native asset, genesis, or validator reward code is implemented.

This document is intentionally a decision gate. It does not approve value-bearing implementation.

## Known current state

- XPGN TGE launched with Paragon DEX on 2026-05-08.
- Current deployment is on BNB Chain at `0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A`.
- Direct BNB Chain RPC reads confirmed:
  - name: `XPGN Token`
  - symbol: `XPGN`
  - decimals: `18`
  - cap: `550,000,000 XPGN`
  - current total supply: `67,000,000 XPGN` at block `100420021`
- The 160,000,000 XPGN validator / chain reserve is unminted.
- The validator reserve should only mint when Paragon L1 starts validator rewards.
- There is no DAO currently.
- Verified deployed source, constructor arguments, role holders, and bucket counter reads are recorded in `docs/XPGN_CANONICAL_SUPPLY_RECORD.md`.

## Non-negotiable supply rules

1. Do not double-count existing BNB Chain circulating supply.
2. Do not mint validator reserve before the approved Paragon L1 validator reward path exists.
3. Do not create a second uncontrolled canonical XPGN supply.
4. Do not implement bridge or migration code until source, roles, admin custody, and bucket counters are verified.
5. Any L1 representation must prove how total canonical supply remains within the 550M hard cap.

## Decision options

### Option A — BNB Chain remains canonical; L1 uses bridged XPGN

Existing BNB Chain XPGN remains the canonical token. Paragon L1 receives XPGN through a bridge/lock/mint representation.

Pros:

- Preserves the live deployed token as canonical.
- Avoids forced user migration at L1 launch.
- Simple public story: existing XPGN continues to exist.

Risks:

- Bridge becomes a high-value security target.
- Validator reward distribution depends on bridge/distributor custody.
- Requires strong pause/rollback and monitoring.

Required before implementation:

- Verified source and role holders from `docs/XPGN_CANONICAL_SUPPLY_RECORD.md`.
- Bridge architecture and threat model.
- Custody model for validator reserve minting.
- Emergency pause and bridge halt procedure.

### Option B — Native L1 XPGN becomes canonical through migration

Users migrate BNB Chain XPGN into native Paragon L1 XPGN through a controlled burn/lock/claim mechanism.

Pros:

- Cleaner long-term L1-native economics.
- Validator rewards can be native to the chain.
- Reduces long-term dependence on BNB Chain once migration completes.

Risks:

- Higher migration complexity and user-support burden.
- Requires strict proof that migrated supply equals locked/burned BNB supply.
- Mistakes are value-bearing and hard to reverse.

Required before implementation:

- Migration contract design.
- Snapshot/lock/burn proof rules.
- Claim lifecycle and deadline policy.
- Audited supply invariant tooling.

### Option C — Dual representation with explicit canonical accounting

BNB Chain XPGN and L1 XPGN both exist, but accounting rules define which supply is canonical, bridged, locked, claimable, or reward-reserved.

Pros:

- Flexible launch path.
- Can support phased migration.
- Validator rewards can start once L1 reward controls are approved.

Risks:

- Harder for users, wallets, explorers, and exchanges to understand.
- Higher chance of supply-accounting mistakes.
- Requires excellent public documentation.

Required before implementation:

- Clear token status labels.
- Supply dashboard / reconciliation process.
- Bridge and migration boundaries.
- Wallet/explorer/indexer coordination.

## Current recommended planning direction

Use Option C as the planning model during devnet/testnet, but do not approve mainnet implementation yet.

Practical interpretation:

- Treat BNB Chain XPGN as the live canonical asset for current holders.
- Design Paragon L1 XPGN accounting so it can support a native asset, bridged asset, or migration path without changing consensus/VM behavior.
- Keep the 160M validator reserve unminted until Paragon L1 validator rewards start and the mint/distribution authority path is approved.
- Define a temporary admin/custody model before value-bearing operations because no DAO exists currently.

## Next required deliverables

1. Complete `docs/XPGN_CANONICAL_SUPPLY_RECORD.md` with verified source, deployment, role, and bucket-counter data.
2. Draft `docs/XPGN_VALIDATOR_REWARD_DESIGN.md`.
3. Draft bridge/migration threat model if Paragon chooses bridge or phased migration.
4. Define custody/governance path for pre-DAO authority control.
5. Add localnet/devnet-only tests for supply accounting before any public network use.

## Approval gate

No code changes for bridge, migration, native XPGN minting, validator reward distribution, or mainnet genesis supply mapping are approved by this document.
