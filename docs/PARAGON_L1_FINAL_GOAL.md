# Paragon L1 Final Goal

Status: strategic baseline / implementation compass  
Repo: `paragon-chain-core`

## Mission

Paragon L1 should become a fast, secure, cost-efficient, AI-aware blockchain network that can support the Paragon Protocol ecosystem without requiring every participant to operate massive bare-metal infrastructure.

The target is not raw benchmark theater. The target is durable production performance:

- low latency under realistic load
- high throughput without validator centralization
- secure Move-based execution
- deterministic genesis and upgrade flows
- resilient validator/fullnode operations
- isolated public RPC and indexer surfaces
- strong monitoring and incident response
- continuous research-driven improvement

## Core design position

Paragon should preserve the proven Aptos-derived performance and security foundation first, then optimize around it with evidence.

The initial engineering posture is:

1. Keep the L1 core stable.
2. Verify builds and localnet/devnet deterministically.
3. Document chain identity, genesis, XPGN, validator, and security policy.
4. Benchmark the baseline before claims or deep changes.
5. Tune configuration, networking, storage, and operations before touching consensus or VM internals.
6. Treat consensus, crypto, VM, gas, storage, key handling, and validator safety as approval-gated zones.

## Final network qualities

### Performance

Paragon should be fast because of:

- parallel execution where safely inherited from the Aptos-derived stack
- efficient validator networking
- tuned mempool and state sync behavior
- sane pruning and storage policy
- separated public RPC, indexer, archive, and validator roles
- measured bottleneck removal
- reproducible benchmark methodology

Paragon should not rely on:

- every validator running excessive hardware
- unmeasured protocol rewrites
- public RPC load on validator-critical nodes
- marketing TPS claims without reproducible evidence

### Security

Paragon should be secure because of:

- conservative protocol change policy
- deterministic genesis artifacts
- explicit chain IDs
- Move framework review discipline
- isolated validator keys
- private/sentry topology for validators
- public RPC rate limiting and DDoS posture
- monitored upgrades and rollback plans
- security review before testnet/mainnet launches

### Accessibility

Paragon should support multiple infrastructure profiles:

- validator profile: secure, reliable, moderate high-quality infrastructure
- fullnode profile: horizontally scalable public network access
- indexer profile: analytics and explorer workload outside consensus path
- archive profile: optional heavier state retention nodes
- developer profile: reproducible localnet/devnet workflows

The validator path must avoid unnecessary hardware escalation unless benchmarks prove it is required.

## Non-goals

The first credible Paragon L1 path does not require:

- rewriting consensus immediately
- replacing AptosVM/MoveVM internals immediately
- custom cryptography
- custom storage schemas before measurement
- giant validator hardware as a default assumption
- public speed claims before reproducible benchmarks
- mainnet parameters before devnet/testnet evidence

## Decision gates

A change is high-risk and approval-gated if it affects:

- consensus protocol
- validator safety
- cryptographic primitives or signing domains
- key generation, custody, or derivation
- AptosVM / MoveVM execution semantics
- gas metering or fee-market behavior
- storage schema or state integrity
- network protocol messages
- genesis ownership, authority, or economics

## Definition of credible readiness

Paragon is not ready for public testnet until it has:

1. Reproducible build and CLI validation.
2. Deterministic localnet runbook.
3. Chain ID policy.
4. Genesis artifact flow.
5. XPGN token strategy.
6. Move module ownership policy.
7. Validator/fullnode deployment runbooks.
8. Benchmark baseline.
9. Monitoring stack.
10. Incident response and reset policy.

Paragon is not ready for mainnet until public testnet has demonstrated:

1. stable validator operations
2. predictable performance under load
3. successful upgrades or controlled upgrade rehearsals
4. mature RPC/indexer operations
5. external review of genesis/token/security assumptions
6. clear authority/key ceremony
7. documented recovery and rollback processes

## Operating principle

Fast chains fail when speed outruns safety. Secure chains fail when caution prevents iteration.

Paragon should use a third path: evidence-driven speed with security gates.
