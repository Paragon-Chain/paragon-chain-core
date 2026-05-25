# Paragon Move Module Ownership

Status: draft ownership strategy  
Repo: `paragon-chain-core`

## Objective

Define where Paragon-specific Move modules should live, who owns them, how they are upgraded, and which modules belong in genesis/framework versus separate application workspaces.

## Core principle

Keep the L1 core minimal and secure. Put only chain-critical modules into framework/genesis. Keep application-level modules separate unless they are required for network identity, XPGN, or protocol operation.

## Module classes

### Core framework modules

Purpose:

- chain-critical logic
- token/gas representation if required at framework level
- genesis-required behavior
- validator/network economics where applicable

Policy:

- high review requirement
- upgrade-gated
- security-critical
- included in genesis only when necessary

### Paragon protocol modules

Purpose:

- Paragon-specific DeFi/app/protocol behavior
- DEX, farms, liquidity, incentives, app-layer mechanics

Policy:

- should generally live outside core L1 framework unless required for genesis
- should have separate package ownership and tests
- should be upgradeable only according to documented authority policy

### Experimental modules

Purpose:

- devnet/testnet experiments
- research prototypes
- benchmarking

Policy:

- never silently promoted to mainnet framework
- must be clearly labeled
- must not hold production authority


## XPGN-specific ownership constraints

XPGN is already launched as an ERC-20 ecosystem asset. Any Paragon L1 Move module that represents native XPGN, bridged XPGN, validator rewards, or supply reconciliation is security-critical.

Required ownership decisions before implementation:

- who controls the L1 XPGN module publishing account
- whether native XPGN is canonical, bridged, migrated, or dual-represented
- who controls validator reward distribution for the 160,000,000 XPGN validator / chain reserve bucket
- whether validator rewards are minted, bridged, locked/unlocked, or distributed through a treasury/reward module
- which emergency pause/upgrade authority exists during devnet, testnet, and mainnet
- how L1 accounting prevents exceeding the existing 550,000,000 XPGN hard-cap assumptions

## Ownership questions to decide

For each Move package/module:

1. Is it required for genesis?
2. Is it required for native XPGN/gas behavior?
3. Is it chain-critical or app-level?
4. Who owns the publishing account?
5. Who controls upgrades?
6. Can it be disabled or migrated?
7. What happens if it has a bug?
8. What test coverage exists?
9. Does it require external audit?
10. Does it create treasury or mint risk?

## Recommended structure

### Framework/genesis path

Use only for:

- required network identity behavior
- XPGN representation if required as native chain asset
- core account/authority setup
- validator/economic primitives if needed

### Separate Paragon Move workspace

Use for:

- DEX modules
- farms
- liquidity programs
- rewards/incentives
- app-specific modules
- experimental protocol features

This keeps chain-core smaller and reduces risk when app-layer code changes.

## Upgrade policy

Each package must define:

- owner address
- upgrade authority
- upgrade process
- emergency process
- test requirements
- audit/review requirements
- compatibility expectations

Mainnet framework upgrades must require stricter governance/approval than devnet/testnet app package upgrades.

## Security requirements

Before public deployment, modules involving any of the following require review:

- treasury movement
- mint/burn authority
- freeze/admin authority
- user funds
- liquidity pools
- oracle inputs
- permissioned roles
- upgrade authority
- account abstraction or signer logic

## Testing requirements

Minimum tests for each production Move package:

- unit tests
- negative authorization tests
- upgrade/migration tests if upgradeable
- event emission tests where applicable
- invariant tests for balances/supply if token-related
- integration tests against localnet/devnet where practical

## XPGN-specific note

XPGN representation must be decided before implementation:

- Aptos Coin path
- Fungible Asset path
- hybrid/compatibility approach
- gas denomination implications
- wallet/explorer/indexer implications

Do not implement XPGN authority logic until decimals, mint authority, treasury custody, and upgrade policy are approved.

## Open implementation work

1. Inventory current Aptos framework package layout.
2. Identify candidate Paragon-specific modules.
3. Decide which modules belong in genesis/framework.
4. Create separate Paragon Move workspace plan if needed.
5. Define authority and upgrade model.
6. Add tests before production module integration.
