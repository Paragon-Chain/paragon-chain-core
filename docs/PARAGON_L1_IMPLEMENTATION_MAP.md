# Paragon L1 Implementation Map

Status: draft execution map / approval-gated  
Repo: `paragon-chain-core`

## Purpose

This document converts the approved Paragon L1 baseline strategy into the next implementation sequence.

The goal is to advance Paragon L1 toward deterministic localnet/devnet, XPGN-aware genesis planning, validator economics, and Move ownership without premature changes to consensus, cryptography, VM execution, gas metering, storage schema, network protocol messages, key handling, or validator-safety code.

## Current validated baseline

Validated before this implementation map:

```bash
cargo check --workspace --locked
cargo build -p aptos --locked
```

A disposable localnet smoke test also booted successfully and returned a ready `NodeApi` endpoint.

Current docs baseline includes:

- `PARAGON_L1_FINAL_GOAL.md`
- `PARAGON_PERFORMANCE_STRATEGY.md`
- `PARAGON_VALIDATOR_INFRA_STRATEGY.md`
- `PARAGON_SECURITY_MODEL.md`
- `PARAGON_RESEARCH_RADAR.md`
- `PARAGON_BENCHMARK_PLAN.md`
- `PARAGON_GENESIS_ARTIFACT_FLOW.md`
- `PARAGON_MOVE_MODULE_OWNERSHIP.md`
- `PARAGON_CHAIN_ID_POLICY.md`
- `PARAGON_LOCALNET_RUNBOOK.md`
- `XPGN_TOKEN_INTEGRATION_STRATEGY.md`

## XPGN facts to preserve

Planning facts:

- XPGN TGE launched with Paragon DEX on 2026-05-08.
- XPGN is an already-launched ecosystem asset, not a greenfield L1 token.
- Existing XPGN hard cap: 550,000,000 XPGN.
- Initial DEX seed mint: 202,020 XPGN.
- Validator / chain reserve bucket: 160,000,000 XPGN.
- The validator reserve is treated as unminted/set aside until an approved L1 validator rewards path exists.

Implementation rule:

Do not implement native L1 XPGN, bridge logic, migration logic, or validator rewards until deployed contract addresses, verified source, role holders, minted supply, and remaining bucket capacities are independently verified from canonical records.

## Phase 1 — Source-of-truth verification

Objective: establish canonical XPGN facts before code depends on them.

Tasks:

1. Identify the deployed XPGN ERC-20 contract address and network.
2. Verify the deployed source code and constructor arguments from canonical explorer/repository records.
3. Record current role holders for:
   - default admin
   - genesis minter
   - farming minter
   - validator minter
   - ecosystem minter
   - treasury minter
   - team minter
   - advisor minter
   - supplemental minter
4. Verify current bucket usage:
   - `genesisMinted`
   - `farmingMinted`
   - `validatorMinted`
   - `ecosystemMinted`
   - `treasuryMinted`
   - `teamMinted`
   - `advisorMinted`
   - `supplementalMinted`
5. Verify whether validator minting is currently enabled or disabled.
6. Record current total supply.
7. Produce a supply reconciliation note.

Deliverable:

- `docs/XPGN_CANONICAL_SUPPLY_RECORD.md`

Approval gate:

No L1-native XPGN implementation before this phase is complete.

## Phase 2 — L1 XPGN design decision

Objective: choose how existing XPGN maps into Paragon L1.

Decision options:

1. Canonical bridge path
2. Native migration path
3. Dual representation path

Required analysis for each option:

- user risk
- supply integrity
- bridge/security assumptions
- operational complexity
- validator rewards compatibility
- wallet/explorer/indexer implications
- emergency pause/rollback model
- audit requirements

Deliverable:

- `docs/XPGN_L1_REPRESENTATION_DECISION.md`

Approval gate:

No Move module or genesis implementation before the chosen path is approved.

## Phase 3 — Deterministic Paragon localnet profile

Objective: create a reproducible Paragon-branded localnet/devnet path without protocol-risk changes.

Tasks:

1. Identify existing localnet genesis/config entry points.
2. Define a Paragon localnet profile using disposable authority material.
3. Add explicit localnet metadata:
   - network name
   - localnet chain ID policy
   - token display assumptions
   - REST/metrics/admin ports
   - waypoint/genesis hash output
4. Add a repeatable smoke-test command.
5. Add a cleanup/reset command.

Deliverable:

- updated `docs/PARAGON_LOCALNET_RUNBOOK.md`
- optional scripts under `scripts/` only if they are deterministic and secret-free

Approval gate:

Localnet profile must pass smoke test before devnet profile work begins.

## Phase 4 — Genesis artifact pipeline

Objective: define and test reproducible genesis artifact generation.

Tasks:

1. Locate genesis builder commands and required config files.
2. Produce localnet genesis artifacts from a clean directory.
3. Record checksums, waypoint, chain ID, and git commit.
4. Ensure no secrets or production keys are committed.
5. Define artifact storage rules.

Deliverable:

- updated `docs/PARAGON_GENESIS_ARTIFACT_FLOW.md`
- localnet-only generated artifact procedure

Approval gate:

Human approval before any persistent devnet/testnet authority material exists.

## Phase 5 — Move ownership and validator rewards design

Objective: define ownership boundaries before Move implementation.

Tasks:

1. Inventory Aptos framework modules related to coin/fungible asset/gas/staking/rewards.
2. Identify whether validator rewards can be represented through existing framework patterns.
3. Define owner accounts and upgrade policy for any Paragon-specific package.
4. Define validator reward distributor interface at the design level.
5. Model the 160M XPGN validator reserve supply path.

Deliverables:

- updated `docs/PARAGON_MOVE_MODULE_OWNERSHIP.md`
- `docs/PARAGON_VALIDATOR_REWARD_DESIGN.md`

Approval gate:

No validator reward code before design review.

## Phase 6 — Benchmarks before performance claims

Objective: make every speed claim measurable.

Tasks:

1. Establish baseline single-node/localnet metrics.
2. Establish multi-validator local benchmark.
3. Establish resource-constrained validator profile benchmark.
4. Measure transaction latency, finality, CPU, memory, disk I/O, state growth, and recovery time.
5. Compare against configuration changes before protocol changes.

Deliverable:

- benchmark results under `docs/benchmarks/` or a dedicated benchmark report path

Approval gate:

No public performance claim without reproducible benchmark metadata.

## Protocol-risk approval gates

The following require explicit approval, benchmark justification, security analysis, and rollback plan:

- consensus changes
- cryptography/key-handling changes
- VM/AptosVM/MoveVM execution changes
- gas metering or fee-market changes
- storage schema changes
- network protocol message changes
- validator safety changes
- mainnet genesis authority changes
- bridge/migration logic handling real XPGN value

## Immediate next engineering action

Recommended next action after this map:

1. Create `docs/XPGN_CANONICAL_SUPPLY_RECORD.md` from verified deployed-contract data.
2. Inventory genesis/config entry points in the repo.
3. Draft the deterministic Paragon localnet profile plan.

Do not touch consensus/runtime internals for this phase.
