# Paragon Chain Core

Aptos-derived layer 1 chain core for the Paragon ecosystem.

This repository is the sovereign chain foundation for Paragon Chain. It starts from an `aptos-core` fork and is intended to evolve into the canonical node, runtime, validator, genesis, and framework repository for the Paragon L1.

## What This Repository Owns

`paragon-chain-core` is where Paragon will own the parts of the system that cannot be delivered as Move packages alone.

That includes:

- the validator and fullnode binary
- genesis and network bootstrapping
- framework-level Move integration for chain-native modules
- chain configuration and gas schedule customization
- staking, validator, fee-routing, and treasury behavior that must be enforced at chain level
- runtime and execution changes required for long-term Paragon-specific architecture

## What This Repository Does Not Replace

This repository is not the same thing as the higher-level protocol repositories.

Use separate repos for:

- protocol contracts and EVM-side systems
- subgraphs and indexing
- app frontends
- Move application packages that should be versioned separately from the chain client

## Foundation

Paragon Chain is being built as an **Aptos-derived MoveVM chain**, not just an application deployed on Aptos.

That means this repository will ultimately be responsible for:

- validator network identity
- chain genesis
- native token and gas behavior
- Move framework release composition
- consensus, mempool, execution, and storage decisions where Paragon diverges from upstream Aptos

## Immediate Goal

The first goal is not to redesign all of Aptos at once.

The first goal is to create a clean Paragon fork that can:

- compile successfully
- run a local Paragon devnet
- expose Paragon naming and chain identity instead of Aptos branding
- define the minimal chain-native features needed for XPGN, staking, fee routing, and governance bootstrapping

## Repository Areas

| Area | Purpose |
| --- | --- |
| `aptos-node/` | Node binary entrypoint and runtime wiring |
| `aptos-move/framework/` | Core Move framework packages and chain-native modules |
| `aptos-move/vm-genesis/` | Genesis building and framework publishing logic |
| `config/` | Validator, node, and network configuration surfaces |
| `consensus/` | Consensus behavior and validator coordination |
| `execution/` | Block execution pipeline and runtime integration |
| `mempool/` | Transaction admission and propagation behavior |
| `storage/` | State storage and long-term data-layer customization |
| `sdk/` | Client and integration support for Paragon chain consumers |

## Paragon Scope

The whitepaper direction suggests three layers of work:

1. **Fork and identity layer**
   Paragon naming, binaries, genesis, token naming, devnet, validator tooling.

2. **Framework and economics layer**
   XPGN-native gas and staking flows, DAO rails, treasury routing, AI/RWA/L2 registry modules.

3. **Advanced chain differentiation layer**
   Future execution, settlement, and modularity features that go beyond standard upstream Aptos behavior.

## First Implementation Track

The first implementation track for this repo is documented in:

- [Paragon Fork Roadmap](./docs/PARAGON_FORK_ROADMAP.md)
- [Chain Customization Map](./docs/CHAIN_CUSTOMIZATION_MAP.md)

## Upstream Relationship

This repository starts from `aptos-core` and should stay explicit about where Paragon diverges from upstream.

Best practice for the fork:

- keep upstream sync manageable
- isolate Paragon-specific changes clearly
- document every runtime-level divergence
- avoid mixing speculative research work into the first devnet milestone

## Current Status

- foundation cloned from `aptos-core`
- Paragon fork planning documentation in progress
- next step: establish the first Paragon devnet and chain identity baseline
