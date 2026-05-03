# Chain Customization Map

This document maps the first major Paragon customization surfaces inside the Aptos fork.

## Identity And Branding

### Likely areas

- root README and docs
- CLI help text and naming references
- network / chain ID configuration
- docker, scripts, and local run helpers

### Goal

Make the fork operate as Paragon Chain rather than as a generic Aptos checkout.

## Genesis And Network Bootstrap

### Primary areas

- `aptos-move/vm-genesis/`
- `config/`
- `aptos-node/`
- local testnet / devnet scripts and configs

### Goal

Control:

- genesis transaction composition
- initial validator set
- network identity
- framework package publication at genesis
- base chain bootstrapping for Paragon environments

## Move Framework Layer

### Primary areas

- `aptos-move/framework/`
- `aptos-move/aptos-release-builder/`
- `aptos-move/package-builder/`

### Goal

Define what becomes chain-native Move functionality for Paragon, including:

- XPGN integration
- governance primitives
- treasury routing primitives
- future RWA / AI / L2 registry modules where chain-level ownership is required

## Gas, Fees, And Economics

### Primary areas

- `aptos-move/aptos-gas-schedule/`
- `aptos-move/aptos-gas-meter/`
- on-chain config and framework governance modules
- stake / validator reward logic in framework modules

### Goal

Model:

- XPGN-denominated gas behavior
- fee collection and distribution
- validator economics
- treasury allocation pathways when chain-level handling is required

## Validator And Staking Behavior

### Primary areas

- framework staking modules
- validator configuration flow
- consensus and node config only where necessary

### Goal

Support Paragon-specific validator onboarding, reward routing, and long-term governance coordination without prematurely rewriting upstream consensus behavior.

## Execution And Runtime Extensions

### Primary areas

- `execution/`
- `aptos-move/block-executor/`
- `aptos-move/aptos-vm/`
- `mempool/`
- `storage/`

### Goal

Reserve these areas for features that truly require runtime-level divergence, such as:

- deeper execution customizations
- advanced settlement models
- future whitepaper-level innovations that cannot be expressed in framework Move alone

## Recommended Boundary Rule

Before changing Rust core code, ask:

1. can this be implemented as a Move framework module?
2. can this be handled at genesis or config level instead?
3. does this need to affect consensus, execution, storage, or networking globally?

If the answer to `1` or `2` is yes, prefer those first.

## First Code Targets

For the first real implementation pass, the safest starting targets are:

- `aptos-move/framework/`
- `aptos-move/vm-genesis/`
- `config/`
- selected local run scripts

These will let Paragon establish:

- chain identity
- genesis ownership
- XPGN strategy
- validator baseline
- framework-level upgrade path

before touching riskier subsystems such as consensus and storage.
