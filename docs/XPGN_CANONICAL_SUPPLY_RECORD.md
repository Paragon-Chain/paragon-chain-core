# XPGN Canonical Supply Record

Status: pending canonical verification  
Repo: `paragon-chain-core`

## Purpose

This document is the required source-of-truth record before Paragon L1 implements native XPGN, bridged XPGN, migration logic, validator rewards, or supply-sensitive genesis behavior.

It intentionally separates user-provided planning facts from independently verified deployed-contract facts.

## Planning facts already provided

- XPGN TGE launched with Paragon DEX on 2026-05-08.
- XPGN is an already-launched ecosystem asset.
- Declared hard cap: 550,000,000 XPGN.
- Launch seed mint: 202,020 XPGN.
- Validator / chain reserve bucket: 160,000,000 XPGN.
- Validator / chain reserve is intended for Paragon L1 validator economics.
- Validator reserve is treated as unminted/set aside until an approved L1 distribution path exists.

## Canonical contract records

Pending required inputs:

- launch chain / network: `TBD`
- deployed XPGN ERC-20 contract address: `TBD`
- verified source URL: `TBD`
- constructor arguments URL or record: `TBD`
- deployment transaction hash: `TBD`
- deployer address: `TBD`
- current admin / DAO multisig address: `TBD`
- validator rewards/distributor contract address: `TBD`
- team vesting address: `TBD`
- advisor vesting address: `TBD`
- genesis recipient address: `TBD`

Do not fill these from chat text alone. Use canonical explorer, repository, and transaction records.

## Contract feature expectations

The deployed source is expected to include:

- ERC-20 token name/symbol: XPGN Token / XPGN
- 18 decimals through ERC-20 default behavior
- global hard cap via `ERC20Capped`
- EIP-2612 permit support via `ERC20Permit`
- vote checkpointing via `ERC20Votes`
- role-based bucket minting through `AccessControlEnumerable`
- emergency transfer pause through `Pausable`
- enforced TEAM and ADVISOR vesting recipients
- validator minting enable/disable gate

Implementation warning:

Chat-copied Solidity source can be formatting-corrupted. The verified deployed source is authoritative.

## Bucket cap record

Expected bucket caps:

- genesis: 10,000,000 XPGN
- farming: 150,000,000 XPGN
- validator / chain reserve: 160,000,000 XPGN
- ecosystem: 55,000,000 XPGN
- treasury: 40,000,000 XPGN
- team: 55,000,000 XPGN
- advisor: 10,000,000 XPGN
- supplemental: 70,000,000 XPGN

Expected sum of bucket caps: 550,000,000 XPGN.

## Live supply verification checklist

Before L1 implementation, record live values from direct contract reads:

- `totalSupply()`
- `cap()`
- `genesisMinted()`
- `farmingMinted()`
- `validatorMinted()`
- `ecosystemMinted()`
- `treasuryMinted()`
- `teamMinted()`
- `advisorMinted()`
- `supplementalMinted()`
- `validatorMintingEnabled()`
- `teamVesting()`
- `advisorVesting()`
- `getAdmin()`

Also verify role holders for every mint role and `DEFAULT_ADMIN_ROLE`.

## Supply reconciliation format

When canonical data is available, fill this section:

```text
network: TBD
contract: TBD
block number: TBD
snapshot timestamp: TBD
totalSupply: TBD
global cap remaining: TBD
validatorMinted: TBD
validator bucket remaining: TBD
validatorMintingEnabled: TBD
supply invariant status: TBD
```

Required invariant:

```text
genesisMinted
+ farmingMinted
+ validatorMinted
+ ecosystemMinted
+ treasuryMinted
+ teamMinted
+ advisorMinted
+ supplementalMinted
== totalSupply
```

If the invariant cannot be checked directly, document why and do not proceed to value-bearing L1 integration.

## L1 implementation gate

No Paragon L1 bridge, migration, native-XPGN mint path, validator reward distributor, or genesis supply mapping is approved until this document has canonical records and a checked supply invariant.
