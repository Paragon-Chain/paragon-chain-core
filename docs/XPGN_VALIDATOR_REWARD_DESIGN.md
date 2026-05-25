# XPGN Validator Reward Design Gate

Status: planning gate / no implementation approval yet
Repo: `paragon-chain-core`

## Purpose

This document defines the required control, accounting, and implementation gates before Paragon L1 activates validator rewards that touch XPGN supply.

It is intentionally conservative. XPGN is already live on BNB Chain, so Paragon L1 validator rewards must preserve existing holder rights, the 550M global hard cap, and the unminted validator reserve invariant.

## Current canonical baseline

Canonical supply and custody facts are recorded in:

- `docs/XPGN_CANONICAL_SUPPLY_RECORD.md`

Current verified baseline from BNB Chain reads:

```text
XPGN contract:                 0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A
network:                       BNB Chain
global cap:                    550,000,000 XPGN
current totalSupply:           67,000,000 XPGN
validator reserve cap:         160,000,000 XPGN
validatorMinted():             0 XPGN
validatorMintingEnabled():     false
VALIDATOR_MINTER_ROLE holder:  0xFE1648A6C58D790CDf01e35B8d538163355A540A
```

Paragon custody mapping:

```text
0xFE1648A6C58D790CDf01e35B8d538163355A540A = Validator Rewards Safe
Validator Rewards Safe control = Admin Safe multisig
Admin Safe = 0xFA8f82560959fB5597ADDc763570edB234899857
Admin Timelock = 0xcc88881ee4F0fb3477B02979a325eDD91d306F72
No DAO currently
```

## Non-negotiable invariants

The validator reward system must preserve:

1. `totalSupply <= 550,000,000 XPGN` globally.
2. Validator reserve minting must never exceed `160,000,000 XPGN`.
3. Current baseline remains `validatorMinted() == 0` until approved activation.
4. Current baseline remains `validatorMintingEnabled() == false` until approved activation.
5. BNB Chain XPGN remains the live canonical holder asset unless an approved migration/bridge decision supersedes it.
6. No L1-native reward emission may create unbacked or duplicate XPGN supply.
7. Public RPC/fullnode/indexer/archive workloads must not be treated as validator reward entitlement by default.
8. Reward logic must be auditable, rate-limited, and reversible before mainnet activation.

## Design decision still required

Paragon L1 must choose one of these reward representation models before implementation.

### Option A — BNB canonical mint + L1 accounting

Validator rewards are accounted on Paragon L1, but actual XPGN minting occurs through the BNB Chain XPGN contract under the existing Validator Rewards Safe path.

Benefits:

- Preserves BNB Chain XPGN as the single canonical ERC-20 supply source.
- Avoids duplicate native supply during early L1 rollout.
- Keeps validator reserve minting aligned with existing `validatorMinted()` counter.

Risks / costs:

- Requires secure cross-chain reward claim or distribution process.
- Requires operational procedures around the Validator Rewards Safe.
- Slower UX if rewards settle externally.

### Option B — Bridged XPGN reward settlement

Validator rewards are minted or released on BNB Chain, bridged to Paragon L1, then distributed or claimed on L1.

Benefits:

- Keeps ERC-20 supply canonical while allowing L1 user experience.
- Makes L1 reward balances usable inside Paragon L1 apps.

Risks / costs:

- Bridge security becomes critical infrastructure.
- Requires strict lock/mint or burn/release accounting.
- Bridge failure can affect validator reward confidence.

### Option C — Native L1 XPGN with hard migration accounting

Paragon L1 introduces native XPGN and reconciles with BNB Chain supply through an approved migration or canonical bridge model.

Benefits:

- Best long-term L1-native UX.
- Simplifies validator reward distribution after migration is complete.

Risks / costs:

- Highest security and accounting risk.
- Requires formal migration rules, replay protection, canonical supply proofs, and holder communication.
- Must prevent duplicate live claims across BNB Chain and L1.

## Recommended sequencing

Recommended baseline-first path:

1. Keep validator reserve unminted while L1 localnet/devnet baseline is validated.
2. Document and verify the Validator Rewards Safe operational control path.
3. Decide XPGN representation model: BNB canonical, bridged, or native migrated.
4. Implement reward accounting in simulation/devnet without live mint authority.
5. Add cap/rate/epoch invariant tests before any mint pathway exists.
6. Add governance/admin runbook for enabling validator minting.
7. Run a testnet reward epoch using non-value-bearing test token or disabled mint mode.
8. Require explicit approval before enabling any production validator reward minting.

## Required implementation gates

Before source code that can affect XPGN validator rewards is merged:

- [ ] Confirm selected XPGN representation model.
- [ ] Verify Admin Safe multisig control over Validator Rewards Safe operationally.
- [ ] Verify whether Admin Timelock controls role changes or activation flows for validator minting.
- [ ] Record deployment transaction hash and exact verified source artifact hash for XPGN.
- [ ] Map reward dripper and farm controller roles outside the token contract.
- [ ] Define validator eligibility rules.
- [ ] Define reward epoch length.
- [ ] Define emission schedule and maximum rate.
- [ ] Define slashing / downtime interaction, if any.
- [ ] Define unclaimed reward handling.
- [ ] Define emergency pause and rollback procedures.
- [ ] Define monitoring alerts for unexpected supply, role, or pause-state changes.
- [ ] Add tests proving validator reward accounting cannot exceed the 160M reserve.
- [ ] Add tests proving global supply cannot exceed 550M equivalent across all representations.

## Validator eligibility boundaries

Initial validator reward eligibility should be limited to actual consensus validators, not infrastructure-adjacent services.

Not automatically eligible:

- public RPC nodes
- fullnodes not participating in consensus
- indexers
- explorers
- archive nodes
- community-hosted API mirrors

These may deserve separate infrastructure incentives later, but they should not silently consume validator reserve unless explicitly approved.

## Safety architecture requirements

Any reward system should include:

- epoch-based accounting rather than continuous unrestricted minting
- deterministic reward calculation from chain state
- explicit cap checks against remaining validator reserve
- emergency pause support
- audit logs / events for every reward allocation
- independent monitoring of BNB Chain token state
- no private-key hot wallet dependency for automated mainnet minting unless explicitly approved
- no automatic role escalation from L1 contracts into BNB Chain token admin paths

## Monitoring requirements

Minimum external monitors before activation:

```text
XPGN totalSupply
XPGN cap
validatorMinted()
validatorMintingEnabled()
paused()
VALIDATOR_MINTER_ROLE members
DEFAULT_ADMIN_ROLE members
Validator Rewards Safe transaction history
Admin Timelock queue/execution events
```

Alerts should fire on:

- unexpected validator minting enablement
- any validator mint amount while L1 reward activation is not approved
- role holder change
- pause/unpause change
- admin role change
- supply/counter invariant mismatch
- Validator Rewards Safe transaction not initiated through approved process

## Current recommendation

Do not implement production validator minting yet.

Proceed with:

1. L1 baseline validation.
2. devnet-only reward accounting simulation.
3. custody/control verification.
4. explicit XPGN representation decision.
5. invariant tests and monitoring before activation.

This keeps the live XPGN token safe while allowing Paragon L1 engineering to progress.
