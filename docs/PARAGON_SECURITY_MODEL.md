# Paragon Security Model

Status: strategic baseline  
Repo: `paragon-chain-core`

## Objective

Define the security posture Paragon L1 must maintain while building a fast Aptos-derived chain.

Security is not a later audit step. Security is part of chain design, validator operations, genesis, token authority, upgrades, RPC exposure, and community operations.

## Security assumptions

- Public crypto infrastructure is hostile.
- Validators and RPC endpoints will be probed continuously.
- Discord, Telegram, X, and support channels will be targeted by impersonators and phishing.
- RPC endpoints will be abused if unprotected.
- Faucet endpoints will be abused if unprotected.
- Supply-chain attacks are realistic.
- Any exposed key, seed, token, or admin API should be considered compromised.

## Critical assets

- validator private keys
- genesis authority keys
- root/treasury/mint authority keys
- upgrade authority keys
- RPC and infra credentials
- GitHub organization/repository access
- CI/CD credentials
- Discord/Telegram admin accounts
- public domain/DNS ownership
- release artifacts and genesis packages

## Approval-gated engineering surfaces

Explicit approval and review are required before modifying:

- consensus protocol
- validator safety logic
- cryptographic primitives
- signing domains
- key generation, custody, or derivation
- AptosVM / MoveVM execution semantics
- gas metering and fee-market logic
- storage schema and state integrity code
- network protocol messages
- genesis authority/economics
- mainnet/testnet genesis artifacts

## Validator security model

Validators should:

- run dedicated services only
- avoid public REST/admin exposure
- isolate keys
- use restricted firewall rules
- use least-privilege service users
- keep admin access restricted
- export metrics only to trusted monitoring
- have recovery procedures
- avoid running explorer/indexer/public RPC workloads locally

## RPC security model

Public RPC must be treated as hostile-facing infrastructure.

Required controls:

- rate limiting
- request size limits
- abuse monitoring
- logging and alerting
- load balancing
- DDoS-aware edge where practical
- no validator private keys
- no admin endpoints exposed
- separation from validator nodes

## Faucet security model

Faucets are abuse targets.

Required controls for public devnet/testnet faucet:

- rate limits
- wallet/account request limits
- IP/behavioral throttling
- monitoring
- clear reset policy
- no mainnet authority material
- disposable/devnet-only keys

## Genesis security model

Genesis is a high-risk process.

Required controls:

- deterministic artifact generation
- documented chain ID
- documented waypoint/genesis hash
- documented authority addresses
- documented token allocation categories
- reproducible build commands
- artifact checksum record
- signer approval record
- no secrets committed to repository

## XPGN security model

XPGN integration must define:

- token representation path
- decimals
- mint authority
- burn authority if any
- freeze authority if any
- treasury custody
- genesis allocations
- upgrade ownership
- emergency authority policy

Do not deploy public token authority flows until these are documented and reviewed.

## Upgrade security model

Every upgrade path should include:

- exact artifact/version
- compatibility notes
- rollback plan where possible
- operator instructions
- monitoring plan
- failure criteria
- communication plan

## Supply-chain security

Required practices:

- use locked dependencies where possible
- review dependency changes
- keep build environment documented
- verify release artifacts
- protect GitHub branch rules
- avoid secrets in CI logs
- restrict repo/admin permissions

## Community security

Public users must be protected from:

- fake airdrops
- fake support DMs
- impersonators
- wallet drainers
- phishing domains
- malicious links
- fake bridge/explorer/RPC links

Public support agents should never ask for:

- seed phrases
- private keys
- wallet passwords
- 2FA codes
- remote wallet access

## Incident response principles

Contain first, investigate second, communicate third.

Incident flow:

1. Identify severity.
2. Contain exposure.
3. Preserve evidence.
4. Notify internal owners privately.
5. Decide public communication if users are affected.
6. Patch or mitigate.
7. Document root cause.
8. Add detection to prevent recurrence.

## Minimum pre-testnet security checklist

- chain ID policy complete
- genesis artifact flow complete
- XPGN authority policy complete
- validator firewall policy complete
- RPC exposure policy complete
- faucet abuse policy complete
- monitoring and alerting active
- incident response runbook complete
- GitHub branch protection reviewed
- no secrets in repository

## Minimum pre-mainnet security checklist

- external review/audit plan complete
- genesis ceremony complete
- authority custody documented
- validator onboarding reviewed
- public RPC hardening tested
- upgrade rehearsal complete
- incident response rehearsal complete
- release artifact verification complete
