# Paragon Genesis Artifact Flow

Status: draft implementation gate  
Repo: `paragon-chain-core`

## Objective

Define the safe process for producing, verifying, storing, and using Paragon genesis artifacts across localnet, devnet, testnet, and mainnet.

Genesis artifacts establish network identity, authority, chain ID, initial state, and token/economic configuration. They must be reproducible and controlled.

## Genesis artifact classes

### Localnet genesis

Purpose:

- local developer testing
- disposable state
- rapid reset

Policy:

- may use temporary directories
- may use deterministic seeds for testing
- must not use production authority keys
- may retain upstream defaults until Paragon-specific localnet profile exists

### Devnet genesis

Purpose:

- internal and semi-public network testing
- frequent reset allowed with notice

Policy:

- must use a Paragon devnet chain ID
- must have documented reset process
- must use devnet-only authority material
- must publish current waypoint/genesis hash internally

### Testnet genesis

Purpose:

- public testing and ecosystem integration

Policy:

- must use stable Paragon testnet chain ID
- must have documented genesis hash/waypoint
- must have published validator onboarding docs
- must not be reset silently
- must use testnet-only authority material

### Mainnet genesis

Purpose:

- production Paragon L1 launch

Policy:

- must use final Paragon mainnet chain ID
- must be produced through an approved ceremony
- must include checksum records
- must document authority addresses and custody model
- must never include secrets in repository

## Required genesis metadata

Each genesis package should record:

- network name
- chain ID
- git commit
- build command
- framework/package version
- genesis generation command
- authority addresses
- validator set source
- token allocation source
- waypoint
- genesis hash/checksum
- artifact paths
- signer/approver record
- timestamp

## Artifact handling rules

- Do not commit private keys or secrets.
- Do not mix devnet/testnet/mainnet authority material.
- Do not reuse disposable localnet keys for public networks.
- Store checksums with artifacts.
- Keep generated artifacts versioned by network and date/build.
- Public artifacts should be publishable without exposing secrets.

## Safe workflow

1. Decide network profile.
2. Confirm chain ID.
3. Confirm authority model.
4. Confirm XPGN/token parameters.
5. Confirm validator set source.
6. Generate artifacts from locked source/build.
7. Record checksums and metadata.
8. Verify node boots from artifacts.
9. Verify REST/metrics readiness.
10. Store artifact metadata and runbook updates.

## Approval gates

Approval is required before generating or changing:

- public devnet genesis
- public testnet genesis
- mainnet genesis
- authority ownership
- treasury/mint authority
- chain IDs
- genesis allocations
- validator set for public networks

## Validation checklist

For each generated genesis profile:

- build succeeds
- chain ID matches policy
- waypoint recorded
- REST API reaches ready state
- metrics endpoint works
- faucet status matches policy
- validator identity matches expected source
- no secrets are in git diff
- restart behavior is tested
- reset/rollback instructions exist

## Open implementation work

The exact Paragon genesis generation command path still needs source inventory and validation.

Next engineering task:

1. Map current upstream Aptos genesis generation code paths.
2. Identify where localnet `ChainId: 4` is selected.
3. Identify clean Paragon network profile hooks.
4. Add deterministic devnet/testnet artifact scripts after approval.
