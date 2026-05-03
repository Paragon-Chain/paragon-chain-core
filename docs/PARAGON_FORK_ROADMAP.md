# Paragon Fork Roadmap

This roadmap is the practical conversion path from a raw `aptos-core` fork into a real Paragon Chain L1 repository.

## Phase 0: Fork Hygiene

Goal: make the repository a clean Paragon-owned workspace before deep runtime work begins.

### Outcomes

- create Paragon-specific root documentation
- preserve clear awareness of upstream Aptos origins
- define which changes belong in this repo versus future Move or app repos
- prepare the repo for a Paragon GitHub remote and branch strategy

### Deliverables

- Paragon README
- chain customization map
- devnet/bootstrap roadmap
- clear naming strategy for binaries, chain ID, token references, and docs

## Phase 1: Identity And Devnet Baseline

Goal: produce a locally runnable Paragon chain baseline with Paragon naming and deterministic genesis.

### Focus areas

- rename chain-facing identity where appropriate
- define Paragon chain ID and network naming
- create Paragon devnet / local testnet configs
- stand up validator and fullnode startup flow
- confirm the fork compiles and boots successfully under Paragon-specific configuration

### Expected outputs

- documented local run instructions
- Paragon genesis flow
- initial validator set for local/devnet testing
- base token naming strategy for XPGN integration

## Phase 2: Framework And Economics Layer

Goal: introduce the first chain-native Paragon behaviors that require more than an app-level Move package.

### Focus areas

- XPGN as the canonical gas and staking asset
- validator and staking economics review
- fee-routing hooks for treasury logic
- genesis-time publishing of Paragon-specific framework modules
- governance and capability layout for long-term chain operation

### Likely implementation surfaces

- `aptos-move/framework/`
- `aptos-move/vm-genesis/`
- gas schedule and on-chain config paths
- validator / stake module review and extension points

## Phase 3: Paragon Move Framework Modules

Goal: publish the first Paragon-native framework-level Move modules that align with the whitepaper.

### Candidate modules

- XPGN framework integration
- treasury routing primitives
- DAO / governance helpers
- RWA registry primitives
- AI computation and settlement manager primitives
- modular L2 registration and settlement registry primitives

### Note

Some of these may ultimately live in a separate `paragon-move` repo during development and only be pulled into `paragon-chain-core` when promoted to framework or genesis-level status.

## Phase 4: Advanced Chain Differentiation

Goal: evaluate and implement the features that truly require divergence from standard Aptos behavior.

### Examples

- custom execution or fee-market behavior
- chain-level support for modular settlement features
- storage or data-model enhancements
- native support for future Paragon-specific runtime features described in the whitepaper

### Caution

This phase should happen only after the Paragon fork has a healthy baseline devnet and clear framework ownership.

## What To Avoid Early

- trying to implement every whitepaper feature in the first milestone
- mixing speculative runtime research into basic devnet setup
- hard-forking consensus or storage before identity and genesis are stable
- embedding app-level product code directly into core runtime code without a clear boundary

## Immediate Next Tasks

1. create the Paragon GitHub remote for this fork
2. define chain naming and local network identity
3. identify the exact files used for genesis and framework release composition
4. document the first local devnet runbook
5. decide which Paragon Move modules belong in-core vs in a separate Move workspace
