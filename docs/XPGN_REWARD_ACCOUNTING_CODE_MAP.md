# XPGN Reward Accounting Code Map

Status: source-map and implementation plan / no production minting approval
Repo: `paragon-chain-core`

## Purpose

This document maps the current Aptos-derived staking, genesis, reward, and test surfaces relevant to the XPGN validator reward accounting simulation.

It is the bridge between the design docs and source edits. The goal is to identify the safest minimal implementation path before modifying Move or Rust code.

Canonical context:

- `docs/XPGN_CANONICAL_SUPPLY_RECORD.md`
- `docs/XPGN_VALIDATOR_REWARD_DESIGN.md`
- `docs/XPGN_L1_REPRESENTATION_OPTIONS.md`
- `docs/XPGN_REWARD_ACCOUNTING_SIMULATION_SPEC.md`

## Safety conclusion

The current Aptos-derived framework already mints staking rewards directly into stake pools through `aptos_framework::stake` using `MintCapability<AptosCoin>`.

For XPGN simulation, the safest first path is **not** to alter this production reward mint path.

Recommended first implementation target:

```text
add a separate simulation-only accounting module/resource path
```

The simulation should observe or mirror validator/epoch state, but it should not call `coin::mint`, should not receive `MintCapability`, and should not modify `AptosCoin` supply behavior.

## Relevant Move framework files

### `aptos-move/framework/aptos-framework/sources/stake.move`

Primary staking and validator-set logic.

Important structures:

```text
StakePool
ValidatorConfig
ValidatorInfo
ValidatorSet
ValidatorPerformance
AptosCoinCapabilities
DistributeRewards / DistributeRewardsEvent
```

Important functions:

```text
on_new_epoch()
update_stake_pool()
calculate_rewards_amount()
distribute_rewards()
is_current_epoch_validator()
get_current_epoch_voting_power()
get_current_epoch_proposal_counts()
```

Key findings:

- `on_new_epoch()` is the current epoch transition hook.
- `on_new_epoch()` iterates active and pending-inactive validators and calls `update_stake_pool()`.
- `update_stake_pool()` calculates transaction fees and staking rewards for active/pending-inactive stake.
- `distribute_rewards()` mints `AptosCoin` rewards using `AptosCoinCapabilities`.
- `calculate_rewards_amount()` is performance-weighted and stake-weighted:

```text
stake_amount * rewards_rate * successful_proposals
/ rewards_rate_denominator / total_proposals
```

Critical source behavior:

```text
stake.move::distribute_rewards()
  -> borrows AptosCoinCapabilities
  -> coin::mint(rewards_amount, mint_cap)
  -> coin::merge(stake, rewards)
```

Do not modify this path for first XPGN simulation unless explicitly approved.

### `aptos-move/framework/aptos-framework/sources/configs/staking_config.move`

Staking and reward-rate configuration.

Important structures/functions:

```text
StakingConfig
StakingRewardsConfig
initialize()
initialize_rewards()
reward_rate()
get_reward_rate()
calculate_and_save_latest_epoch_rewards_rate()
update_rewards_rate()
update_rewards_config()
validate_rewards_config()
```

Key findings:

- Existing reward config is expressed as `rewards_rate` / `rewards_rate_denominator`.
- Existing reward config is tied to Aptos staking reward issuance, not XPGN reserve accounting.
- Governance/framework signer can update reward configs.
- The first XPGN simulation should not overload these fields unless Paragon deliberately wants XPGN simulation to mirror native stake rewards.

Recommended use:

- Reference existing config style and validation patterns.
- Create separate simulation config if needed.
- Avoid changing existing staking reward config semantics in the first phase.

### `aptos-move/framework/aptos-framework/sources/genesis.move`

Genesis initialization and initial validator creation.

Important functions:

```text
initialize()
initialize_aptos_coin()
initialize_core_resources_and_aptos_coin()
create_initialize_validators_with_commission()
create_initialize_validator()
initialize_validator()
```

Key findings:

- `initialize()` accepts staking parameters including reward rate and epoch interval.
- `initialize_aptos_coin()` gives `stake` the `MintCapability<AptosCoin>` so it can mint rewards.
- `create_initialize_validators_with_commission()` destroys the framework mint capability after initial validator setup, then calls `stake::on_new_epoch()`.

Critical source behavior:

```text
genesis.move::initialize_aptos_coin()
  -> aptos_coin::initialize()
  -> stake::store_aptos_coin_mint_cap(aptos_framework, mint_cap)
```

Do not introduce XPGN production supply behavior into genesis during simulation phase.

### `aptos-move/framework/aptos-framework/sources/aptos_coin.move`

Native Aptos coin mint capability management.

Important functions:

```text
initialize()
destroy_mint_cap()
mint()
delegate_mint_capability()
claim_mint_capability()
```

Key findings:

- This module controls native `AptosCoin` mint capability storage and delegation.
- It is value-bearing token infrastructure.

Do not reuse this as an XPGN implementation surface during simulation.

### `aptos-move/framework/aptos-framework/sources/staking_contract.move`

Staking contract / commission and distribution logic.

Important functions:

```text
request_commission()
unlock_rewards()
distribute()
distribute_internal()
```

Key findings:

- This module handles commission and stake-pool distribution behavior after rewards accumulate.
- It depends on the stake pool reward model.
- It is not the safest first place for XPGN reserve accounting because it is downstream of native stake rewards.

Use for later commission/delegator analysis only.

### `aptos-move/framework/aptos-framework/sources/delegation_pool.move`

Delegated staking and operator commission accounting.

Important functions:

```text
initialize_delegation_pool()
update_commission_percentage()
calculate_stake_pool_drift()
end_aptos_epoch()
```

Key findings:

- This module maps stake-pool rewards into delegation-pool accounting.
- It is complex and reward-sensitive.
- It should not be touched in the first simulation implementation unless delegation-aware XPGN reward splitting is explicitly required.

## Relevant Rust files

### `crates/aptos-genesis/src/config.rs`

Genesis layout config.

Important fields:

```text
epoch_duration_secs
min_stake
max_stake
required_proposer_stake
rewards_apy_percentage
voting_power_increase_limit
total_supply
```

Key findings:

- `rewards_apy_percentage` currently describes native stake reward percentage.
- Default layout uses `rewards_apy_percentage: 10`.
- Do not repurpose this for XPGN validator reserve emissions in the first phase.

### `crates/aptos-genesis/src/builder.rs`

Local/test genesis builder.

Important structures:

```text
GenesisConfiguration
Builder
InitGenesisConfigFn
InitGenesisStakeFn
```

Key findings:

- Local builder defaults to test settings including `rewards_apy_percentage: 10`.
- This is useful for localnet/devnet configuration hooks later.
- Avoid introducing live XPGN assumptions here during the simulation phase.

### `crates/aptos/src/stake/mod.rs`

CLI surface for staking operations.

Important functions/commands:

```text
DistributeVestedCoins
RequestCommission
staking_contract_distribute
staking_contract_request_commission
```

Key findings:

- This is operational CLI for existing stake/vesting flows.
- It is not required for first simulation implementation.
- Future reward epoch report tooling may live elsewhere rather than inside this CLI module.

## Existing test locations

Current relevant tests are embedded in Move modules and Rust/e2e files.

Observed locations:

```text
aptos-move/framework/aptos-framework/sources/stake.move
aptos-move/framework/aptos-framework/sources/configs/staking_config.move
aptos-move/framework/aptos-framework/sources/staking_contract.move
aptos-move/framework/aptos-framework/sources/delegation_pool.move
aptos-move/framework/aptos-framework/tests/aptos_coin_tests.move
crates/aptos/src/genesis/tests.rs
crates/aptos/e2e/cases/stake.py
```

Important existing stake tests in `stake.move`:

```text
test_validator_rewards_are_performance_based
test_validator_rewards_rate_decrease_over_time
test_rewards_calculation
test_active_validator_can_withdraw_all_stake_and_rewards_at_once
```

Recommended first simulation tests should be separate from native reward tests to avoid conflating XPGN reserve simulation with AptosCoin staking rewards.

## Recommended new Move module approach

Create a new simulation-only module rather than modifying `stake.move` reward minting.

Candidate file:

```text
aptos-move/framework/aptos-framework/sources/paragon_xpgn_rewards.move
```

Alternative names:

```text
xpgn_reward_simulation.move
paragon_validator_rewards.move
```

Recommended name:

```text
paragon_xpgn_rewards.move
```

Reason:

- explicit Paragon namespace
- explicit XPGN scope
- can start simulation-only and later evolve under approval
- avoids overloading upstream Aptos `stake` semantics

## Proposed simulation module responsibilities

The first module should own only simulation resources and pure/accounting functions:

```text
SimulationConfig
SimulationState
ValidatorRewardRecord
EpochRewardReportEvent or equivalent event type
initialize_for_test_or_genesis_disabled()
configure_simulation()
calculate_equal_share_epoch_rewards()
record_simulated_epoch_rewards()
remaining_validator_reserve()
cumulative_simulated_rewards()
```

Hard exclusions:

```text
no Coin<XPGN>
no AptosCoin minting
no MintCapability
no BNB Chain transaction logic
no bridge logic
no holder migration logic
```

## Proposed resource model

Initial resources under `@aptos_framework`:

```text
struct XPGNRewardSimulationConfig has key {
    validator_reserve_cap_base_units: u128,
    epoch_emission_base_units: u128,
    max_epoch_emission_base_units: u128,
    min_eligible_validators: u64,
    reward_enabled_for_simulation: bool,
    production_minting_enabled: bool,
}

struct XPGNRewardSimulationState has key {
    cumulative_simulated_rewards_base_units: u128,
    last_epoch: u64,
    remainder_base_units: u128,
}
```

Move language note:

- Confirm `u128` support and framework conventions before coding.
- If a target Move version or serialization path makes `u128` inconvenient, use two `u64` fields or explicit decimal/base-unit representation after review.

## Proposed first reward calculation

Equal-share placeholder:

```text
epoch_reward_total = configured_epoch_emission
eligible_reward = epoch_reward_total / eligible_validator_count
remainder = epoch_reward_total % eligible_validator_count
```

Fail-closed cap check:

```text
cumulative_simulated_rewards + epoch_reward_total <= 160_000_000 * 10^18
```

If not true:

```text
abort
```

## Integration strategy with current staking code

### Phase 1: standalone simulation tests only

Do not call the new module from `stake::on_new_epoch()` yet.

Add tests that pass synthetic validators/eligibility counts into the simulation module.

Benefits:

- lowest risk
- no epoch transition side effects
- no consensus/staking behavior changes
- can validate reserve math first

### Phase 2: devnet-only hook proposal

After standalone tests pass, optionally add a feature-gated call from epoch transition code.

Candidate hook:

```text
stake.move::on_new_epoch()
```

But only if:

- simulation config exists
- simulation is enabled
- production minting remains false
- no coin minting occurs
- tests prove epoch transition behavior is unchanged when disabled

### Phase 3: report/export tooling

Add deterministic epoch report generation once the simulation ledger is stable.

Potential locations:

```text
Move events emitted by paragon_xpgn_rewards.move
Rust CLI/report command outside consensus-critical path
```

## Files not to touch in first implementation

Avoid modifying these in the first code pass unless strictly necessary:

```text
aptos-move/framework/aptos-framework/sources/aptos_coin.move
aptos-move/framework/aptos-framework/sources/coin.move
aptos-move/framework/aptos-framework/sources/fungible_asset.move
aptos-move/framework/aptos-framework/sources/transaction_fee.move
aptos-move/framework/aptos-framework/sources/genesis.move
crates/aptos-genesis/src/config.rs
crates/aptos-genesis/src/builder.rs
```

Reason:

These touch native coin, genesis, or value-bearing framework behavior. They are not required for simulation math.

## Minimal source-edit plan

### Step 1 — Add simulation module skeleton

Add:

```text
aptos-move/framework/aptos-framework/sources/paragon_xpgn_rewards.move
```

Include:

- constants for `XPGN_DECIMALS`, `VALIDATOR_RESERVE_CAP_XPGN`, and base-unit cap
- config/state resources
- initialization function for tests/devnet only
- pure calculation helpers
- cap assertion helper

### Step 2 — Add tests inside the module or a dedicated Move test file

Preferred initial tests:

```text
test_equal_share_rewards
test_remainder_tracking
test_reserve_cap_exact
test_reserve_cap_exceeded_aborts
test_zero_validators_aborts
test_simulation_disabled_records_nothing
test_production_minting_flag_must_be_false
test_epoch_ordering
```

### Step 3 — Run targeted Move tests

Run the smallest relevant framework test command available in this repo.

Candidate commands to verify before use:

```text
cargo test -p aptos-framework
cargo test -p aptos-framework -- paragon_xpgn
./scripts/dev_setup.sh or framework test runner, if repo uses one
```

Do not assume command correctness; inspect repo test scripts/Cargo package names before execution.

### Step 4 — Only after tests pass, consider disabled epoch hook

If needed, add a disabled-by-default simulation hook in `stake.move::on_new_epoch()`.

Required test:

```text
when simulation is disabled, existing stake reward tests produce unchanged behavior
```

## Risks and mitigations

### Risk: accidental native supply change

Mitigation:

- no `MintCapability`
- no `coin::mint`
- no edits to `aptos_coin.move`
- no genesis mint-cap changes

### Risk: consensus/epoch side effects

Mitigation:

- standalone module first
- no hook into `on_new_epoch()` until tests pass
- disabled-by-default if hook is ever added

### Risk: confusing simulated rewards with claimable XPGN

Mitigation:

- use names containing `simulation` or `simulated`
- no claim/withdraw/mint terminology
- docs and events must say simulated/non-value-bearing

### Risk: overflow or decimal mistakes

Mitigation:

- integer-only math
- base units
- explicit cap constants
- test exact cap and cap overflow
- test division remainders

## Current recommendation

Proceed with code only after this map is reviewed.

First implementation should be:

```text
standalone paragon_xpgn_rewards.move simulation module + tests
```

Do not yet modify:

```text
stake.move::on_new_epoch()
genesis.move
aptos_coin.move
coin.move
Rust genesis config
```

This preserves the Aptos-derived staking baseline while giving Paragon a safe place to develop XPGN validator reward accounting.
