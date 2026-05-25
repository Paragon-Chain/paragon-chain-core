# XPGN Canonical Supply Record

Status: partial canonical record captured / supply invariant pending
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
- Validator reserve is unminted and is intended to mint only when Paragon L1 starts validator rewards.

## Canonical contract records

Known / pending required inputs:

- launch chain / network: `BNB Chain`
- deployed XPGN ERC-20 contract address: `0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A`
- explorer URL: `https://bscscan.com/token/0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A`
- verified source URL: `TBD — verify from canonical explorer/source repository before implementation`
- constructor arguments URL or record: `TBD`
- deployment transaction hash: `TBD`
- deployer address: `TBD`
- current admin / DAO multisig address: `none currently; admin/custody model must be separately documented before L1 value-bearing work`
- validator rewards/distributor contract address: `not deployed / TBD; validator reserve is unminted until Paragon L1 validator rewards start`
- team vesting address: `TBD`
- advisor vesting address: `TBD`
- genesis recipient address: `TBD`

Network and contract address were provided by Paragon and partially checked by direct BNB Chain RPC reads. Source, constructor args, deployer, role holders, bucket counters, and custody records still require canonical explorer/repository verification.

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

Partial live read captured from BNB Chain RPC on 2026-05-25. Values are direct `eth_call` reads at the listed block; full bucket invariant remains pending.

```text
network: BNB Chain
contract: 0x130A2eB49C8143EfA4547a10EbEA48BCf10a729A
block number: 100420021
snapshot timestamp: 2026-05-25T21:30:35Z
name: XPGN Token
symbol: XPGN
decimals: 18
totalSupply: 67,000,000 XPGN
cap: 550,000,000 XPGN
global cap remaining: 483,000,000 XPGN
validatorMinted: expected 0 XPGN / pending direct bucket read
validator bucket remaining: expected 160,000,000 XPGN / pending direct bucket read
validatorMintingEnabled: pending direct contract read
DAO/admin multisig: none currently / custody model pending
supply invariant status: pending bucket counter reads
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

No Paragon L1 bridge, migration, native-XPGN mint path, validator reward distributor, or genesis supply mapping is approved until this document has verified source/role/custody records and a checked supply invariant. The known BNB Chain address and live total supply are sufficient for planning, not for value-bearing implementation.
