#[test_only]
module aptos_framework::paragon_xpgn_rewards_tests {
    use aptos_framework::paragon_xpgn_rewards;

    const EASSERT: u64 = 0;

    #[test(aptos_framework = @aptos_framework)]
    fun test_equal_share_rewards_are_recorded(aptos_framework: &signer) {
        paragon_xpgn_rewards::initialize_for_test(aptos_framework, 1000, 300, 0);
        let per_validator = paragon_xpgn_rewards::record_equal_share_epoch_rewards(aptos_framework, 1, 3);
        assert!(per_validator == 100, EASSERT);
        assert!(paragon_xpgn_rewards::cumulative_simulated_rewards() == 300, EASSERT);
        assert!(paragon_xpgn_rewards::remaining_validator_reserve() == 700, EASSERT);
        assert!(paragon_xpgn_rewards::remainder_base_units() == 0, EASSERT);
    }

    #[test(aptos_framework = @aptos_framework)]
    fun test_remainder_is_tracked_without_over_minting(aptos_framework: &signer) {
        paragon_xpgn_rewards::initialize_for_test(aptos_framework, 1000, 100, 0);
        let per_validator = paragon_xpgn_rewards::record_equal_share_epoch_rewards(aptos_framework, 1, 6);
        assert!(per_validator == 16, EASSERT);
        assert!(paragon_xpgn_rewards::cumulative_simulated_rewards() == 96, EASSERT);
        assert!(paragon_xpgn_rewards::remainder_base_units() == 4, EASSERT);
        assert!(paragon_xpgn_rewards::remaining_validator_reserve() == 904, EASSERT);
    }

    #[test(aptos_framework = @aptos_framework)]
    fun test_reserve_cap_exact_is_allowed(aptos_framework: &signer) {
        paragon_xpgn_rewards::initialize_for_test(aptos_framework, 300, 300, 0);
        let per_validator = paragon_xpgn_rewards::record_equal_share_epoch_rewards(aptos_framework, 1, 3);
        assert!(per_validator == 100, EASSERT);
        assert!(paragon_xpgn_rewards::remaining_validator_reserve() == 0, EASSERT);
    }

    #[test(aptos_framework = @aptos_framework)]
    #[expected_failure(abort_code = 0x10001, location = aptos_framework::paragon_xpgn_rewards)]
    fun test_reserve_cap_exceeded_aborts(aptos_framework: &signer) {
        paragon_xpgn_rewards::initialize_for_test(aptos_framework, 299, 300, 0);
        paragon_xpgn_rewards::record_equal_share_epoch_rewards(aptos_framework, 1, 3);
    }

    #[test(aptos_framework = @aptos_framework)]
    #[expected_failure(abort_code = 0x10002, location = aptos_framework::paragon_xpgn_rewards)]
    fun test_zero_validators_aborts(aptos_framework: &signer) {
        paragon_xpgn_rewards::initialize_for_test(aptos_framework, 1000, 300, 0);
        paragon_xpgn_rewards::record_equal_share_epoch_rewards(aptos_framework, 1, 0);
    }

    #[test(aptos_framework = @aptos_framework)]
    #[expected_failure(abort_code = 0x10003, location = aptos_framework::paragon_xpgn_rewards)]
    fun test_epoch_must_increase(aptos_framework: &signer) {
        paragon_xpgn_rewards::initialize_for_test(aptos_framework, 1000, 300, 0);
        paragon_xpgn_rewards::record_equal_share_epoch_rewards(aptos_framework, 2, 3);
        paragon_xpgn_rewards::record_equal_share_epoch_rewards(aptos_framework, 2, 3);
    }
}
