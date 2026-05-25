# XPGN L1 Representation Options

Status: architecture decision support / no production implementation approval yet
Repo: `paragon-chain-core`

## Purpose

Paragon L1 must decide how XPGN is represented before implementing bridge, migration, native coin, genesis allocation, or validator reward logic.

XPGN is already live on BNB Chain. The L1 design must therefore avoid duplicate supply, preserve current holder rights, and maintain the 550M global cap.

Canonical baseline documents:

- `docs/XPGN_CANONICAL_SUPPLY_RECORD.md`
- `docs/XPGN_VALIDATOR_REWARD_DESIGN.md`
- `docs/XPGN_TOKEN_INTEGRATION_STRATEGY.md`
- `docs/XPGN_L1_REPRESENTATION_DECISION.md`

## Current XPGN baseline

```text
Canonical live asset:          BNB Chain XPGN ERC-20
Contract:                      0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A
Global cap:                    550,000,000 XPGN
Current totalSupply:           67,000,000 XPGN
Validator reserve cap:         160,000,000 XPGN
validatorMinted():             0 XPGN
validatorMintingEnabled():     false
Validator Rewards Safe:        0xFE1648A6C58D790CDf01e35B8d538163355A540A
Validator Rewards Safe control: Admin Safe multisig
DAO:                           none currently
```

## Decision criteria

Any XPGN L1 representation must satisfy:

1. No duplicate claim on the same economic XPGN.
2. No path to exceed 550M global equivalent supply.
3. No path to exceed the 160M validator reserve.
4. Existing BNB Chain holder balances remain valid unless an explicit migration is approved.
5. Validator rewards remain disabled for production until the reward control path is verified.
6. Admin/timelock/safe control paths are documented before activation.
7. Testnet/devnet can progress without touching live mint authority.
8. Rollback and emergency pause behavior is explicit.

## Option A — BNB canonical XPGN + L1 accounting simulation

### Model

BNB Chain XPGN remains the only canonical live value-bearing XPGN asset.

Paragon L1 tracks validator reward accounting internally during devnet/testnet, but does not mint or bridge production XPGN. Reward balances are simulated or recorded as non-transferable accounting until an activation decision is made.

### What exists on L1

- reward accounting module
- validator eligibility records
- epoch reward calculation
- cap/rate invariant checks
- optional non-value-bearing test token for devnet UX

### What does not exist yet

- production XPGN native coin
- production wrapped XPGN
- live BNB Chain minting automation
- user-facing migration claims
- production bridge mint/release

### Benefits

- Safest immediate engineering path.
- Allows L1 validator reward logic to be tested without supply risk.
- Keeps BNB Chain token as the single canonical supply source.
- Avoids bridge/security complexity during baseline L1 work.
- Allows invariant tests to be written before value-bearing paths exist.

### Risks / limitations

- Devnet reward balances are not real XPGN.
- Validator reward UX is incomplete until a settlement model is chosen.
- Requires later integration work for bridge/migration/native representation.

### Best use

Recommended for:

```text
localnet -> devnet -> early testnet
```

This should be the default first implementation path.

## Option B — BNB canonical mint + manual/controlled reward settlement

### Model

Validator rewards are calculated on Paragon L1, then settled on BNB Chain through the existing XPGN contract and Validator Rewards Safe process.

L1 produces deterministic reward outputs. The Validator Rewards Safe performs controlled mint/distribution actions after review/approval.

### Benefits

- Preserves BNB Chain as canonical source of supply.
- Uses the deployed `validatorMinted()` counter for real reserve accounting.
- Avoids launching a bridge before required.
- Allows human/multisig review before production distribution.

### Risks / limitations

- Operationally slower.
- Requires careful reconciliation between L1 accounting and BNB Chain mints.
- Manual processes introduce execution risk if not runbooked and monitored.
- Validator reward claim UX may be weaker at first.

### Required controls

- signed reward epoch reports
- multisig/timelock approval process
- mint amount cap check before execution
- post-mint reconciliation report
- monitors for `validatorMinted()`, `totalSupply`, roles, and safe transactions

### Best use

Recommended for first limited production reward activation if Paragon wants minimal bridge risk.

## Option C — Bridged XPGN on Paragon L1

### Model

BNB Chain XPGN remains canonical, but users and validators can bridge XPGN into Paragon L1 as a wrapped or canonical-representation asset.

A bridge locks/burns XPGN on BNB Chain and mints/releases an equivalent representation on Paragon L1, depending on bridge design.

### Benefits

- Better L1 UX than BNB-only settlement.
- Lets Paragon apps use XPGN directly on L1.
- Can preserve BNB Chain as canonical supply if bridge accounting is correct.

### Risks / limitations

- Bridge becomes critical security infrastructure.
- Bridge compromise can create unbacked XPGN representation.
- Requires robust relayer, proof, emergency pause, replay protection, and monitoring.
- More complex than needed for early devnet/testnet reward simulation.

### Required controls

- formal bridge design
- lock/mint or burn/release accounting proof
- replay protection
- chain ID/domain separation
- bridge pause
- withdrawal rate limits
- supply reconciliation monitor
- bridge contract audits before mainnet value

### Best use

Recommended only after L1 baseline and reward accounting are stable.

## Option D — Native L1 XPGN with migration

### Model

Paragon L1 introduces native XPGN as the long-term canonical token. BNB Chain holders migrate or bridge into native L1 XPGN under a formal migration plan.

### Benefits

- Best long-term L1-native UX.
- Simplifies L1 gas/rewards/apps once migration is complete.
- Aligns XPGN directly with Paragon L1 economics.

### Risks / limitations

- Highest accounting and user-communication risk.
- Requires migration contract/proof design.
- Must prevent duplicate claims across BNB Chain and L1.
- Requires clear handling of unclaimed BNB Chain balances.
- Requires strong public comms and support readiness.

### Required controls

- formal migration spec
- snapshot or continuous proof strategy
- replay protection
- claim windows or indefinite claim policy
- source-chain balance lock/burn model
- support plan for user mistakes
- auditor review
- public runbook

### Best use

Recommended only after:

```text
stable devnet/testnet + bridge/migration design + audits + public migration plan
```

## Comparative recommendation

### Immediate engineering path

Use:

```text
Option A — BNB canonical XPGN + L1 accounting simulation
```

Why:

- no live minting
- no bridge risk
- no native migration risk
- lets validator reward logic be developed safely
- keeps supply invariants testable from day one

### First production reward path, if needed before bridge

Use:

```text
Option B — BNB canonical mint + manual/controlled reward settlement
```

Why:

- uses existing deployed XPGN contract
- preserves the current cap and validator bucket accounting
- keeps multisig approval in the loop
- avoids premature bridge complexity

### Long-term UX path

Evaluate later:

```text
Option C — Bridged XPGN
Option D — Native L1 XPGN migration
```

These should not be implemented until baseline L1, reward accounting, custody verification, and monitoring are mature.

## Recommended phase plan

### Phase 1 — No-value localnet/devnet simulation

Build only:

- validator set accounting
- epoch reward calculation
- reward cap invariant tests
- disabled-mint reward ledger
- test-only token or mock reward asset if needed

Do not build:

- production bridge
- production native XPGN
- live mint automation
- holder migration

Exit criteria:

- validator rewards can be simulated deterministically
- total simulated validator rewards cannot exceed 160M
- tests cover cap, rate, epoch, and eligibility edge cases
- no code path can touch production BNB Chain minting

### Phase 2 — Controlled settlement design

Design, but do not yet activate:

- reward epoch report format
- Validator Rewards Safe execution runbook
- reconciliation process
- supply monitor
- role monitor
- emergency stop procedure

Exit criteria:

- a dry-run report can be generated from L1 state
- independent reconciliation against expected mint amount passes
- multisig/timelock control path is verified

### Phase 3 — Testnet bridge or settlement pilot

Choose one:

- BNB canonical controlled settlement on test flow
- test bridge with non-value-bearing token
- native test token migration rehearsal

Exit criteria:

- all state transitions are observable
- pause/rollback behavior is tested
- no duplicate claim path exists
- monitoring alerts work

### Phase 4 — Mainnet activation decision

Require explicit approval before any production activation.

Approval package should include:

- selected representation model
- security review
- monitoring dashboard
- emergency runbook
- validator eligibility spec
- emission schedule
- user/support communication plan

## Implementation guardrails for code changes

Until a final representation decision is approved:

- Do not introduce production native XPGN as L1 gas token.
- Do not implement production bridge mint/release.
- Do not implement automated BNB Chain validator minting.
- Do not hardcode private custody assumptions into runtime code.
- Do not conflate validator rewards with RPC/fullnode/indexer incentives.
- Keep all reward logic behind devnet/testnet feature gates or disabled production paths.

Allowed now:

- docs
- reward accounting interfaces
- mock/test token flows
- invariant tests
- simulation CLI/report tooling
- monitoring specs
- runbooks

## Open questions

1. Should XPGN become the Paragon L1 gas token at genesis, or later after migration?
2. Should early mainnet validator rewards settle on BNB Chain before bridge maturity?
3. Should bridge infrastructure be Paragon-operated, third-party, or hybrid?
4. Should unclaimed migration balances remain claimable indefinitely?
5. Should validator reward emissions start immediately at L1 mainnet, or only after a stability period?
6. Should public RPC/indexer operators receive a separate incentive bucket outside validator reserve?

## Current decision

For engineering now:

```text
Selected working path: Option A
BNB canonical XPGN + L1 accounting simulation
```

This is not a final production tokenomics decision. It is the safest implementation path for baseline L1 engineering.
