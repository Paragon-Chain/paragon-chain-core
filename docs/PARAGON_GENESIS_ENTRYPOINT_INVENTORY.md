# Paragon Genesis Entrypoint Inventory

Status: initial repo inventory  
Repo: `paragon-chain-core`

## Purpose

Identify the existing Aptos-derived genesis/localnet/config surfaces Paragon should use before considering protocol-risk changes.

This inventory supports deterministic localnet/devnet planning and XPGN-aware genesis design.

## Primary CLI genesis surface

File:

```text
crates/aptos/src/genesis/mod.rs
```

Observed command enum:

```text
GenesisTool
- GenerateAdminWriteSet
- GenerateGenesis
- GetPoolAddresses
- GenerateKeys
- GenerateLayoutTemplate
- SetupGit
- SetValidatorConfiguration
```

Key behavior:

- `GenerateGenesis` writes `genesis.blob` and `waypoint.txt`.
- Non-mainnet mode calls `fetch_genesis_info(...)`.
- Mainnet mode calls `fetch_mainnet_genesis_info(...)`.
- Mainnet path requires `layout.root_key` to be absent.
- Mainnet path validates `layout.total_supply` against account balances.
- Validator config is loaded from owner/operator files referenced by layout users.

Paragon implication:

Use this path for genesis artifact generation first. Do not build a custom genesis generator until the existing CLI path is fully understood and tested.

## Genesis layout configuration

File:

```text
crates/aptos-genesis/src/config.rs
```

Important `Layout` fields:

```text
root_key
users
chain_id
allow_new_validators
epoch_duration_secs
is_test
min_stake
min_voting_threshold
max_stake
recurring_lockup_duration_secs
required_proposer_stake
rewards_apy_percentage
voting_duration_secs
voting_power_increase_limit
total_supply
employee_vesting_start
employee_vesting_period_duration
on_chain_consensus_config
on_chain_execution_config
jwk_consensus_config_override
initial_jwks
keyless_groth16_vk_override
randomness_config_override
chunky_dkg_config_override
initial_features_override
```

Default observations:

- default `chain_id` uses `ChainId::test()`
- default `is_test` is `true`
- default `allow_new_validators` is `false`
- default `rewards_apy_percentage` is `10`

Paragon implication:

Paragon chain IDs, staking limits, validator set policy, rewards assumptions, and execution/consensus config must be explicit per network profile. Upstream defaults are observations, not final Paragon policy.

## Validator configuration surface

File:

```text
crates/aptos-genesis/src/config.rs
```

Important `ValidatorConfiguration` fields:

```text
owner_account_address
owner_account_public_key
operator_account_address
operator_account_public_key
voter_account_address
voter_account_public_key
consensus_public_key
proof_of_possession
validator_network_public_key
validator_host
full_node_network_public_key
full_node_host
stake_amount
commission_percentage
join_during_genesis
```

Paragon implication:

Validator onboarding must separate owner, operator, voter, consensus, validator-network, and fullnode-network material. Production keys must never be generated or stored through casual localnet scripts.

## Localnet surface

Files:

```text
crates/aptos-localnet/src/lib.rs
crates/aptos-localnet/src/docker.rs
crates/aptos-localnet/src/health_checker.rs
crates/aptos-localnet/src/indexer_api.rs
crates/aptos/src/node/mod.rs
```

Observed behavior:

- CLI node tooling exposes `RunLocalnet` under `NodeTool`.
- Existing localnet smoke test successfully started a disposable node and ready endpoint.
- Localnet can be used to validate current binary behavior before Paragon-specific profiles are added.

Paragon implication:

Paragon localnet should be added as a deterministic profile around existing localnet behavior, not a rewrite of node startup.

## Framework genesis modules

Files:

```text
aptos-move/framework/aptos-framework/sources/genesis.move
aptos-move/framework/aptos-framework/sources/chain_id.move
aptos-move/framework/aptos-framework/sources/validator_consensus_info.move
aptos-move/vm-genesis/src/lib.rs
aptos-move/vm-genesis/src/genesis_context.rs
```

Paragon implication:

These are protocol-sensitive. Read and document before modifying. Changes here affect genesis state and should be approval-gated.

## Terraform / Helm genesis surfaces

Files:

```text
terraform/helm/genesis/README.md
terraform/helm/genesis/files/genesis.sh
terraform/helm/genesis/templates/genesis.yaml
terraform/aptos-node-testnet/gcp/genesis.tf
terraform/helm/aptos-node/files/test-data/genesis.blob
terraform/helm/aptos-node/files/test-data/waypoint.txt
```

Paragon implication:

Useful later for public testnet deployment automation, but not the first source of truth for local deterministic genesis design.

## Recommended next action

1. Generate a non-production layout template using the current CLI.
2. Inspect required git layout files and validator config structure.
3. Draft a Paragon localnet/devnet genesis profile with explicit chain ID and XPGN assumptions.
4. Smoke-test artifact generation into a temporary directory.
5. Record generated hashes/checksums without committing secrets or generated private material.

## Approval gates

Do not modify these without explicit review:

- framework genesis modules
- chain ID Move module
- VM genesis library
- consensus/execution config defaults
- validator key handling
- mainnet genesis flow
