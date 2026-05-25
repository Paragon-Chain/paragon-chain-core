module aptos_framework::paragon_xpgn_rewards {
    use std::signer;

    /// Simulation-only accounting state for future XPGN validator rewards.
    ///
    /// This module intentionally does not mint, bridge, or distribute real XPGN.
    /// It models reserve drawdown and epoch accounting before any integration with
    /// staking, genesis, native coin, bridge, or validator reward logic.
    struct RewardSimulation has key {
        validator_reserve_base_units: u128,
        epoch_reward_budget_base_units: u128,
        last_recorded_epoch: u64,
        cumulative_simulated_rewards_base_units: u128,
        remainder_base_units: u128,
    }

    const ENOT_FRAMEWORK: u64 = 0x10000;
    const EVALIDATOR_RESERVE_EXCEEDED: u64 = 0x10001;
    const EZERO_VALIDATORS: u64 = 0x10002;
    const ENON_INCREASING_EPOCH: u64 = 0x10003;
    const ESIMULATION_ALREADY_INITIALIZED: u64 = 0x10004;

    #[test_only]
    public fun initialize_for_test(
        aptos_framework: &signer,
        validator_reserve_base_units: u128,
        epoch_reward_budget_base_units: u128,
        initial_epoch: u64,
    ) {
        let framework = signer::address_of(aptos_framework);
        assert!(framework == @aptos_framework, ENOT_FRAMEWORK);
        assert!(!exists<RewardSimulation>(framework), ESIMULATION_ALREADY_INITIALIZED);

        move_to(aptos_framework, RewardSimulation {
            validator_reserve_base_units,
            epoch_reward_budget_base_units,
            last_recorded_epoch: initial_epoch,
            cumulative_simulated_rewards_base_units: 0,
            remainder_base_units: 0,
        });
    }

    #[test_only]
    public fun record_equal_share_epoch_rewards(
        aptos_framework: &signer,
        epoch: u64,
        validator_count: u64,
    ): u128 acquires RewardSimulation {
        let framework = signer::address_of(aptos_framework);
        assert!(framework == @aptos_framework, ENOT_FRAMEWORK);
        assert!(validator_count > 0, EZERO_VALIDATORS);

        let simulation = borrow_global_mut<RewardSimulation>(framework);
        assert!(epoch > simulation.last_recorded_epoch, ENON_INCREASING_EPOCH);

        let validator_count_base_units = (validator_count as u128);
        let per_validator = simulation.epoch_reward_budget_base_units / validator_count_base_units;
        let distributed = per_validator * validator_count_base_units;
        let new_cumulative = simulation.cumulative_simulated_rewards_base_units + distributed;

        assert!(
            new_cumulative <= simulation.validator_reserve_base_units,
            EVALIDATOR_RESERVE_EXCEEDED
        );

        simulation.last_recorded_epoch = epoch;
        simulation.cumulative_simulated_rewards_base_units = new_cumulative;
        simulation.remainder_base_units = simulation.epoch_reward_budget_base_units - distributed;

        per_validator
    }

    #[test_only]
    public fun cumulative_simulated_rewards(): u128 acquires RewardSimulation {
        borrow_global<RewardSimulation>(@aptos_framework).cumulative_simulated_rewards_base_units
    }

    #[test_only]
    public fun remaining_validator_reserve(): u128 acquires RewardSimulation {
        let simulation = borrow_global<RewardSimulation>(@aptos_framework);
        simulation.validator_reserve_base_units - simulation.cumulative_simulated_rewards_base_units
    }

    #[test_only]
    public fun remainder_base_units(): u128 acquires RewardSimulation {
        borrow_global<RewardSimulation>(@aptos_framework).remainder_base_units
    }
}
