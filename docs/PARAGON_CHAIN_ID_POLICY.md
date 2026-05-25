# Paragon Chain ID Policy

Status: draft policy / implementation gate  
Repo: `paragon-chain-core`

## Purpose

This document defines how Paragon should handle chain IDs across localnet, devnet, testnet, and mainnet.

Chain ID decisions affect signing domains, replay resistance, client configuration, wallets, indexers, faucets, explorers, and operational safety. They must be explicit and documented before any public network launch.

## Current verified baseline

The current Aptos-derived localnet baseline boots successfully and reports:

```text
ChainId: 4
```

This is treated as an upstream/localnet default observed during baseline validation. It is not a final Paragon network identity.

## Policy principles

1. Every Paragon network class must have a clearly assigned chain ID.
2. Mainnet chain ID must be final before any mainnet genesis ceremony.
3. Public testnet chain ID must not collide with localnet, devnet, upstream Aptos networks, or any previously published Paragon public network.
4. Devnet chain IDs may change only with explicit reset notices.
5. Localnet may retain the upstream default until Paragon-specific localnet scripts are introduced.
6. Chain ID changes must be paired with regenerated genesis artifacts and client configuration updates.
7. Chain ID values must be documented in one canonical location and referenced from runbooks.

## Proposed network classes

### Localnet

Purpose: single-node developer testing.

Current baseline:

```text
ChainId: 4
```

Policy:

- Acceptable for short-lived local developer networks.
- Not acceptable as Paragon public devnet, testnet, or mainnet identity.
- May be replaced later by a Paragon-specific localnet ID once deterministic localnet bootstrap scripts are added.

### Devnet

Purpose: internal and semi-public testing with frequent resets.

Policy:

- Must use a Paragon-specific non-mainnet chain ID.
- Must be allowed to reset with clear announcements.
- Must not be reused for testnet or mainnet.
- Must publish reset history once external users are invited.

### Testnet

Purpose: public pre-mainnet testing, integrations, wallets, explorers, validators, and app teams.

Policy:

- Must use a stable Paragon-specific testnet chain ID.
- Must not be silently reset.
- Reset requires versioned announcement and updated genesis package.
- Chain ID must be fixed before external validator onboarding.

### Mainnet

Purpose: production Paragon L1.

Policy:

- Must use a final Paragon-specific mainnet chain ID.
- Must never be reused after genesis.
- Must be embedded into final genesis artifacts and client defaults.
- Must be part of the genesis ceremony checklist.

## Required approval gate

Changing chain ID behavior is approval-gated because it affects replay resistance and network identity.

Approval is required before modifying:

- Genesis chain ID selection.
- CLI defaults for Paragon networks.
- Framework constants related to network identity.
- Wallet/client network presets.
- Public devnet, testnet, or mainnet genesis artifacts.

## Implementation checklist

Before changing code or genesis defaults:

1. Inventory current upstream chain ID references.
2. Identify the source of `ChainId: 4` in localnet genesis/config generation.
3. Decide Paragon network IDs for devnet, testnet, and mainnet.
4. Add a canonical network registry document or config file.
5. Generate fresh genesis artifacts for each non-local network.
6. Verify signing/client behavior against the selected chain ID.
7. Update runbooks, faucet configuration, indexer configuration, explorer configuration, and wallet/app docs.

## Validation checklist

For each network profile:

```bash
./target/debug/aptos node run-localnet --help
```

Then boot the selected profile and record:

- Chain ID
- Genesis hash / waypoint
- REST API endpoint
- Metrics endpoint
- Faucet status
- Validator identity source
- Genesis artifact path

No public network should be announced until this checklist is complete and reproducible.

## Open decision

Final Paragon chain ID assignments are not made in this document. They require explicit project approval before implementation.
