# XPGN Reward Accounting Simulation Spec

Status: implementation-facing simulation spec / no production minting approval
Repo: `paragon-chain-core`

## Purpose

This spec defines the first safe engineering target for Paragon L1 validator rewards:

```text
BNB canonical XPGN + L1 accounting simulation
```

The goal is to build and test deterministic validator reward accounting without creating any production path that can mint, bridge, migrate, or transfer live XPGN.

Canonical context:

- `docs/XPGN_CANONICAL_SUPPLY_RECORD.md`
- `docs/XPGN_VALIDATOR_REWARD_DESIGN.md`
- `docs/XPGN_L1_REPRESENTATION_OPTIONS.md`

## Current production safety baseline

```text
Live XPGN chain:              BNB Chain
Live XPGN contract:           0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A
Global cap:                   550,000,000 XPGN
Validator reserve cap:        160,000,000 XPGN
Current validatorMinted():    0 XPGN
validatorMintingEnabled():    false
Validator Rewards Safe:       0xFE1648A6C58D790CDf01e35B8d538163355A540A
Validator Rewards Safe owner: Admin Safe multisig, per Paragon custody records
```

Simulation code must treat the production mint path as unavailable.

## Non-goals

This phase must not implement:

- production BNB Chain minting
- production BNB Chain transaction signing
- production bridge mint/release
- production native L1 XPGN
- holder migration
- claimable live XPGN rewards
- automated Validator Rewards Safe execution
- validator reward activation on mainnet

## Simulation objectives

The simulation should prove that Paragon L1 can calculate validator rewards safely before any value-bearing XPGN path exists.

Required properties:

1. deterministic reward calculation from chain/accounting state
2. explicit validator eligibility input
3. epoch-based accounting
4. configurable reward schedule
5. hard cap against the 160M validator reserve
6. no production mint side effects
7. testable accounting invariants
8. exportable reward epoch reports for future settlement design

## Core concepts

### Validator identity

A validator reward record should identify the validator independently from public RPC, indexer, or archive infrastructure.

Minimum fields:

```text
validator_address
operator_address, if distinct
consensus_public_key or validator identity key, if available
reward_destination, devnet/testnet only at this phase
status: active | inactive | jailed | removed
```

Exact field names should match the Paragon/Aptos-derived validator data model once the code location is selected.

### Epoch

Rewards should accrue per epoch, not continuously.

Minimum epoch fields:

```text
epoch_number
epoch_start_height or timestamp
epoch_end_height or timestamp
eligible_validator_count
total_epoch_reward
per_validator_records
cumulative_simulated_rewards
remaining_validator_reserve
```

### Reward ledger

The simulation ledger records calculated rewards only.

It must not imply live claimability.

Recommended terminology:

```text
simulated_validator_rewards
```

Avoid names like:

```text
claimable_xpgn
minted_xpgn
native_xpgn_balance
```

until a production representation decision is approved.

## Reward formula placeholder

Initial formula should be deliberately simple and configurable:

```text
epoch_reward_total = configured_epoch_emission
eligible_validator_reward = epoch_reward_total / eligible_validator_count
```

Later formula extensions may include:

- stake weighting
- uptime weighting
- performance weighting
- commission / delegator split
- slashing penalties
- bootstrap validator incentives
- capped early validator bonuses

Do not add complex economics until baseline invariants and tests exist.

## Cap invariant

The simulation must enforce:

```text
cumulative_simulated_validator_rewards <= 160,000,000 XPGN
```

Any epoch that would exceed the reserve must fail or clamp according to explicit policy.

Recommended initial policy:

```text
fail closed
```

Meaning the epoch reward calculation should reject the epoch if it would exceed the configured validator reserve.

## Unit precision

Use integer base units matching ERC-20 decimals:

```text
1 XPGN = 10^18 base units
validator_reserve_cap = 160,000,000 * 10^18
```

Avoid floating-point arithmetic.

All reward calculations should use integer math with explicit rounding policy.

Recommended initial rounding policy:

- divide rewards using integer floor division
- accumulate remainder in an epoch-level remainder field
- do not silently mint/distribute remainder

## Eligibility rules

Initial eligibility should be minimal:

A validator is eligible for an epoch only if:

1. it is in the active validator set for that epoch
2. it is not jailed/suspended/removed
3. it meets minimum uptime/performance criteria if such data is already available
4. it is not a public RPC/fullnode/indexer-only operator

If uptime/performance data is not available yet, the first simulation can use active set membership only and mark performance weighting as future work.

## Configuration inputs

Simulation config should include:

```text
validator_reserve_cap_base_units
initial_cumulative_simulated_rewards_base_units
epoch_emission_base_units
max_epoch_emission_base_units
min_eligible_validators
reward_enabled_for_simulation
production_minting_enabled = false
```

Hard guard:

```text
production_minting_enabled must remain false in this phase
```

## Disabled production mint guard

Any code introduced during this phase must have no reachable production mint path.

Acceptable:

```text
calculate_rewards()
record_simulated_rewards()
export_epoch_report()
assert_caps()
```

Not acceptable:

```text
mint_xpgn()
send_bnb_transaction()
call_validator_rewards_safe()
bridge_mint()
create_native_xpgn_coin()
```

## Epoch report format

The simulation should be able to export a deterministic report for each epoch.

Minimum report fields:

```text
chain_id
epoch_number
validator_set_hash
reward_formula_version
epoch_reward_total_base_units
validator_reserve_cap_base_units
cumulative_before_base_units
cumulative_after_base_units
remaining_reserve_base_units
records:
  - validator_address
    eligibility_status
    reward_base_units
    exclusion_reason, if excluded
report_hash
```

The report hash should eventually support controlled settlement review, but in this phase it is only for deterministic testing and auditability.

## Required tests before implementation is considered complete

### Cap tests

- total simulated rewards can equal but not exceed 160M XPGN
- epoch that would exceed 160M fails closed
- cumulative value persists correctly across epochs
- zero remaining reserve prevents additional rewards

### Eligibility tests

- inactive validators receive zero
- jailed/suspended validators receive zero
- removed validators receive zero
- RPC/fullnode/indexer-only entries are not treated as validators
- active validators receive expected equal-share rewards in simple mode

### Precision tests

- integer division remainder is tracked
- no floating point arithmetic is used
- base-unit conversion is exact for whole XPGN values
- odd reward totals across multiple validators do not inflate supply

### Configuration tests

- simulation disabled means no rewards are recorded
- production minting flag cannot be enabled in this phase
- invalid reserve cap fails configuration validation
- epoch emission above max fails configuration validation
- zero eligible validators fails closed or records zero emission explicitly

### Report tests

- same inputs produce same report hash
- changed validator set changes report hash
- changed reward formula version changes report hash
- excluded validators include exclusion reason

## Suggested codebase mapping task

Before code edits, inspect the Aptos-derived reward/staking structure and identify the safest integration point.

Candidate areas to inspect:

```text
aptos-move/framework/aptos-framework/sources/
aptos-move/framework/aptos-framework/sources/stake.move
aptos-move/framework/aptos-framework/sources/validator_set.move
crates/aptos-genesis/
crates/aptos-config/
crates/aptos-framework/
```

Final placement should prefer minimal deviation from upstream Aptos structure.

## Implementation approach recommendation

Start with docs and tests before runtime behavior:

1. inventory existing staking/reward modules
2. identify current Aptos reward accounting behavior
3. create Paragon-specific simulation design note tied to actual file paths
4. add tests for cap/epoch/accounting behavior
5. only then add minimal simulation code

## Approval gate

This spec approves only simulation design and code exploration.

It does not approve:

- production token launch changes
- native L1 XPGN
- bridge contracts
- migration contracts
- live validator reward minting
- changes to BNB Chain XPGN roles

Any of those require explicit approval and a separate security review.
