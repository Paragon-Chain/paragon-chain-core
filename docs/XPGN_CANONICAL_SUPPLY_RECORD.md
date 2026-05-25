# XPGN Canonical Supply Record

Status: verified BNB Chain source / live supply invariant recorded
Repo: `paragon-chain-core`

## Purpose

This document is the required source-of-truth record before Paragon L1 implements native XPGN, bridged XPGN, migration logic, validator rewards, or supply-sensitive genesis behavior.

It intentionally separates Paragon-provided custody facts from independently verified deployed-contract facts.

## Planning facts already provided

- XPGN TGE launched with Paragon DEX on 2026-05-08.
- XPGN is an already-launched ecosystem asset.
- Declared hard cap: 550,000,000 XPGN.
- Launch seed mint: 202,020 XPGN.
- Validator / chain reserve bucket: 160,000,000 XPGN.
- Validator / chain reserve is intended for Paragon L1 validator economics.
- Validator reserve is unminted and is intended to mint only when Paragon L1 starts validator rewards.
- There is no DAO currently.

## Canonical contract records

- launch chain / network: `BNB Chain`
- deployed XPGN ERC-20 contract address: `0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A`
- explorer URL: `https://bscscan.com/token/0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A`
- verified source URL: `https://bscscan.com/token/0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A#code`
- BscScan verification status: `Exact Match`
- contract name: `XPGNToken`
- compiler: `Solidity v0.8.27+commit.40a35a09`
- optimizer: `enabled, 200 runs`
- EVM version: `paris`
- deployer / constructor `daoMultisig`: `0x1Ab5F2d39154233cf469382Bb5c286E38Ad64F96`
- constructor `validatorRewards` / Validator Rewards Safe: `0xFE1648A6C58D790CDf01e35B8d538163355A540A`
- constructor `_teamVesting`: `0xc15Ec7880cf3b238e37c7f1f6cBEB2caa580AEa1`
- constructor `_advisorVesting`: `0xAC609E8D3eB7142482460cd7FFCEB588B0846392`
- constructor `genesisRecipient`: `0x27ead72500b893161209Ff1297C1bB41E7B72B0c`

Constructor args from BscScan decoded view:

```text
daoMultisig:       0x1Ab5F2d39154233cf469382Bb5c286E38Ad64F96
validatorRewards:  0xFE1648A6C58D790CDf01e35B8d538163355A540A
_teamVesting:      0xc15Ec7880cf3b238e37c7f1f6cBEB2caa580AEa1
_advisorVesting:   0xAC609E8D3eB7142482460cd7FFCEB588B0846392
genesisRecipient:  0x27ead72500b893161209Ff1297C1bB41E7B72B0c
```

## Paragon-provided custody / operations addresses

Provided by Paragon on 2026-05-25:

- team vesting: `0xc15Ec7880cf3b238e37c7f1f6cBEB2caa580AEa1`
- advisor vesting: `0xAC609E8D3eB7142482460cd7FFCEB588B0846392`
- genesis reserve: `0x27ead72500b893161209Ff1297C1bB41E7B72B0c`
- reward dripper: `0x4DC07BB6cd804341D0B22Ac9c5087D81844eC827`
- validator rewards safe: `0xFE1648A6C58D790CDf01e35B8d538163355A540A` — controlled by Admin Safe multisig
- farm controller: `0xe78c441A963Dc0E5c9Bcc7b55c4f3D0B82085e6b`
- admin safe: `0xFA8f82560959fB5597ADDc763570edB234899857`
- admin timelock: `0xcc88881ee4F0fb3477B02979a325eDD91d306F72`
- treasury safe: `0x1f7132ae2E16c702BCCEef4aA11F2B804f4E5383`

Operational note: Paragon states the admin safe acts as multisig for the timelock. Paragon also states the Validator Rewards Safe `0xFE1648A6C58D790CDf01e35B8d538163355A540A` is controlled by the Admin Safe multisig. Direct XPGN role reads show the token admin roles are currently held by the timelock address `0xcc88881ee4F0fb3477B02979a325eDD91d306F72`, while `VALIDATOR_MINTER_ROLE` is held by the Validator Rewards Safe.

## Contract feature verification

Verified source and ABI show the deployed token includes:

- ERC-20 token name/symbol: `XPGN Token` / `XPGN`
- 18 decimals through ERC-20 behavior
- global hard cap via `ERC20Capped`
- EIP-2612 permit support via `ERC20Permit`
- vote checkpointing via `ERC20Votes`
- role-based bucket minting through `AccessControlEnumerable`
- emergency transfer pause through `Pausable`
- enforced TEAM and ADVISOR vesting recipients
- validator minting enable/disable gate

Implementation warning:

Verified deployed source is authoritative. Chat-copied Solidity source must not be used for value-bearing implementation decisions.

## Bucket cap record

Live cap reads:

- genesis: 10,000,000 XPGN
- farming: 150,000,000 XPGN
- validator / chain reserve: 160,000,000 XPGN
- ecosystem: 55,000,000 XPGN
- treasury: 40,000,000 XPGN
- team: 55,000,000 XPGN
- advisor: 10,000,000 XPGN
- supplemental: 70,000,000 XPGN

Sum of bucket caps: 550,000,000 XPGN.

## Live supply reconciliation

Direct `eth_call` reads from BNB Chain RPC on 2026-05-25 at block `100425724`:

```text
network: BNB Chain
contract: 0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A
block number: 100425724
name: XPGN Token
symbol: XPGN
decimals: 18
totalSupply: 67,000,000 XPGN
cap: 550,000,000 XPGN
global cap remaining: 483,000,000 XPGN
paused: false
validatorMintingEnabled: false
```

Bucket minted counters:

```text
genesisMinted:       2,000,000 XPGN
farmingMinted:       0 XPGN
validatorMinted:     0 XPGN
ecosystemMinted:     0 XPGN
treasuryMinted:      0 XPGN
teamMinted:          55,000,000 XPGN
advisorMinted:       10,000,000 XPGN
supplementalMinted:  0 XPGN
```

Supply invariant:

```text
bucket minted sum: 67,000,000 XPGN
totalSupply:       67,000,000 XPGN
invariant:         PASS
validator reserve: UNMINTED
```

Important distinction:

- Launch seed mint was 202,020 XPGN.
- Current `genesisMinted()` counter is 2,000,000 XPGN.
- Therefore additional genesis-bucket minting occurred after the seed mint, while the total supply invariant remains valid.

## Current role holders

Direct `AccessControlEnumerable` reads from BNB Chain RPC on 2026-05-25 at block `100425724`:

```text
DEFAULT_ADMIN_ROLE:
  0xcc88881ee4f0fb3477b02979a325edd91d306f72

GENESIS_MINTER_ROLE:
  0xcc88881ee4f0fb3477b02979a325edd91d306f72

FARMING_MINTER_ROLE:
  0xcc88881ee4f0fb3477b02979a325edd91d306f72

VALIDATOR_MINTER_ROLE:
  0xfe1648a6c58d790cdf01e35b8d538163355a540a

ECOSYSTEM_MINTER_ROLE:
  0xcc88881ee4f0fb3477b02979a325edd91d306f72

TREASURY_MINTER_ROLE:
  0xcc88881ee4f0fb3477b02979a325edd91d306f72

TEAM_MINTER_ROLE:
  0xcc88881ee4f0fb3477b02979a325edd91d306f72

ADVISOR_MINTER_ROLE:
  0xcc88881ee4f0fb3477b02979a325edd91d306f72

SUPPLEMENTAL_MINTER_ROLE:
  0xcc88881ee4f0fb3477b02979a325edd91d306f72
```

## Current key balances

Direct `balanceOf` reads from BNB Chain RPC on 2026-05-25 at block `100425724`:

```text
team vesting:     55,000,000 XPGN
advisor vesting:  10,000,000 XPGN
genesis reserve:  974,558 XPGN
reward dripper:   469,855.729166666666165066 XPGN
farm controller:  38,574.592382028910508494 XPGN
admin safe:       0 XPGN
admin timelock:   0 XPGN
treasury safe:    149.378645232591760535 XPGN
```

## L1 implementation gate

Before any bridge, migration, genesis, validator reward, or native-XPGN implementation:

1. Treat BNB Chain XPGN as the live canonical holder asset.
2. Preserve the 550M global hard-cap accounting.
3. Do not mint the 160M validator reserve until the approved Paragon L1 validator rewards path exists.
4. Use `validatorMinted() == 0` and `validatorMintingEnabled() == false` as the current baseline.
5. Explicitly model the admin timelock and pre-DAO custody path.
6. Treat `0xFE1648...540A` as the current Validator Rewards Safe and `VALIDATOR_MINTER_ROLE` holder, controlled by the Admin Safe multisig per Paragon-provided custody information.
7. Do not rely on the operational `reward dripper` address as the validator minter unless role ownership is changed or separately verified.

## Open items

- Record deployment transaction hash.
- Record exact source artifact hash or verified source export.
- Verify the admin safe / timelock relationship operationally.
- Verify the Admin Safe multisig control path for the Validator Rewards Safe `0xFE1648A6C58D790CDf01e35B8d538163355A540A` operationally.
- Map the reward dripper and farm controller contract roles outside the XPGN token.
