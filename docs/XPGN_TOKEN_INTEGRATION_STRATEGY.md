# XPGN Token Integration Strategy

Status: draft strategy / implementation gate  
Repo: `paragon-chain-core`

## Purpose

This document defines the safe baseline strategy for integrating XPGN into the Paragon Aptos-derived L1.

The objective is to avoid premature runtime or consensus changes. Token integration should start from framework, genesis, configuration, and operational surfaces unless there is a reviewed reason to modify core execution logic.

## Baseline position

The current repository baseline has passed:

```bash
cargo check --workspace --locked
cargo build -p aptos --locked
```

A localnet smoke run also booted successfully using the existing upstream-derived localnet path.

No XPGN-specific protocol changes are validated yet.


## Existing XPGN launch context

As of the current Paragon L1 planning baseline:

- XPGN TGE has already occurred with the Paragon DEX launch on 2026-05-08.
- The current deployment is on BNB Chain at `0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A`.
- Direct BNB Chain RPC reads confirmed token name `XPGN Token`, symbol `XPGN`, 18 decimals, cap `550,000,000 XPGN`, and current total supply `67,000,000 XPGN` at block `100420021`.
- The existing XPGN token is expected to be an ERC-20 governance token using OpenZeppelin-style `ERC20Capped`, `ERC20Permit`, `ERC20Votes`, role-based mint buckets, and pausable transfers; verified deployed source remains authoritative.
- The declared hard cap is 550,000,000 XPGN with 18 decimals.
- The launch seed mint was 202,020 XPGN for initial DEX seed liquidity.
- The validator / chain reserve bucket is 160,000,000 XPGN and is intended for Paragon L1 validator economics.
- The validator reserve is unminted and is intended to mint only when Paragon L1 starts validator rewards.
- The ERC-20 contract/source and deployed addresses must be verified from canonical chain explorer / repository records before any bridge, migration, genesis, or validator reward implementation depends on them.

Planning implication:

Paragon L1 must treat XPGN as an already-launched ecosystem asset, not as a greenfield token. The L1 design needs an explicit relationship between the existing ERC-20 supply/buckets and any native L1 representation.

## Strategy principles

1. Prefer framework/genesis configuration over Rust runtime changes.
2. Preserve AptosVM and MoveVM behavior unless a specific Paragon requirement demands otherwise.
3. Keep token metadata, mint authority, treasury, and distribution policy explicit.
4. Separate localnet/devnet testing from public testnet/mainnet genesis decisions.
5. Treat key handling, mint authority, treasury controls, gas denomination, and genesis ownership as security-critical.
6. Do not alter consensus, crypto, gas metering, storage schema, network protocol messages, or validator safety without explicit approval.

## Integration layers

### Layer 1: Documentation and policy

Before code changes:

- Define token name, symbol, decimals, and display conventions.
- Define whether XPGN is the native gas token, a framework coin/fungible asset, or both through Aptos-native mechanisms.
- Define how the existing ERC-20 XPGN supply and bucketed mint authority map to L1-native accounting.
- Define the validator reserve path for the 160,000,000 XPGN validator / chain reserve bucket.
- Define genesis allocation categories.
- Define treasury/admin custody and signing policy. There is no DAO currently, so L1 launch must define an explicit interim custody/governance model before value-bearing changes.
- Define mint/burn/freeze authority model.
- Define upgrade/governance ownership.

### Layer 2: Localnet/devnet genesis composition

Initial implementation should target deterministic localnet/devnet genesis outputs.

Deliverables:

- Reproducible genesis build command.
- Explicit chain ID per network profile.
- Explicit XPGN launch-state assumptions, including existing ERC-20 supply, deployed-contract verification, and validator reserve accounting.
- Explicit root/treasury authority handling.
- Deterministic account addresses for testing where appropriate.
- Reset procedure for devnet.

### Layer 3: Framework-level XPGN representation

Preferred first technical path:

- Use Aptos framework-native token/coin/fungible asset patterns where possible.
- Brand and configure XPGN through framework/genesis surfaces.
- Avoid modifying VM execution semantics.
- Avoid storage schema divergence.

### Layer 4: Client, API, and ecosystem defaults

After genesis/framework behavior is validated:

- Update CLI network presets.
- Update faucet defaults for devnet/testnet only.
- Update explorer/indexer labels.
- Update wallet/app integration docs.
- Update public RPC and chain metadata.

### Layer 5: Public network readiness

Before public testnet:

- Freeze testnet chain ID.
- Publish genesis hash/waypoint.
- Publish RPC, faucet, explorer, and validator onboarding docs.
- Validate indexer and API behavior.
- Validate account creation, funding, transfers, gas accounting, and event indexing.

Before mainnet:

- Freeze mainnet chain ID.
- Freeze genesis artifacts.
- Complete treasury and authority key ceremony.
- Complete rollback/incident response plan.
- Complete external review for token and genesis configuration.

## Approval-gated surfaces

Explicit approval is required before changes to:

- Consensus protocol.
- Cryptographic primitives or signing domains.
- AptosVM / MoveVM execution semantics.
- Gas metering logic.
- Storage schema.
- Network protocol messages.
- Validator safety rules.
- Key generation or custody logic.
- Mainnet genesis artifacts.

## Recommended next implementation sequence

1. Inventory current upstream coin, fungible asset, genesis, and chain ID code paths.
2. Identify the minimal framework/genesis changes required to represent XPGN.
3. Create a deterministic localnet profile using XPGN branding/configuration.
4. Run localnet smoke tests:
   - Node boots.
   - REST API is ready.
   - Faucet behavior is correct for devnet/localnet.
   - Account funding works.
   - XPGN transfer works.
   - Gas accounting displays correctly.
5. Create devnet genesis package and reset runbook.
6. Only then evaluate whether any deeper Rust changes are required.

## Minimum test matrix

For each network profile that includes XPGN:

- Build CLI: `cargo build -p aptos --locked`
- Boot localnet/devnet profile.
- Verify readiness endpoint.
- Create account.
- Fund account through faucet or genesis allocation.
- Submit transfer transaction.
- Query balance.
- Query transaction by hash/version.
- Confirm indexer sees account and transaction data if indexer is enabled.
- Restart node and verify state continuity where expected.

## Non-goals for the first pass

The first XPGN integration pass should not:

- Rewrite core consensus.
- Replace MoveVM/AptosVM internals.
- Change cryptographic primitives.
- Introduce custom gas metering without review.
- Ship public mainnet parameters.
- Publish production keys or authority material.

## Open decisions

These require project approval before implementation:

- Final XPGN decimals.
- Whether XPGN is represented through Aptos Coin, Fungible Asset, or another framework-native path.
- Genesis allocation model.
- Treasury and mint authority custody.
- Devnet/testnet/mainnet chain IDs.
- Upgrade authority model.

## ERC-20 to L1 decision gate

Before implementation, Paragon must choose and document one of these paths:

1. **Canonical bridge path** — existing ERC-20 XPGN remains canonical on its launch chain, and Paragon L1 represents bridged/locked XPGN through a controlled bridge/minter model.
2. **Native migration path** — users migrate ERC-20 XPGN to native L1 XPGN through a burn/lock/proof/redeem process with strict supply reconciliation.
3. **Dual representation path** — ERC-20 and native L1 XPGN coexist with explicit accounting, bridge limits, and user-facing risk disclosures.

No path is approved until the team has:

- verified deployed contract addresses and source code from canonical records
- reconciled minted supply and remaining bucket capacity
- documented mint authority holders and role-admin controls
- defined validator reward distributor custody or approved L1-start mint authority path
- specified bridge/migration security assumptions
- tested supply invariants on localnet/devnet
- prepared rollback or pause procedures

## Contract-source caution

The Solidity source used for planning should be checked against the verified deployed source. If source is copied through chat or markdown, formatting can corrupt operators or line breaks. The verified deployed source, constructor args, role holders, and chain-explorer records are authoritative for implementation.
