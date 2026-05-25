# Paragon Research Radar

Status: operating system for continuous technical awareness  
Repo: `paragon-chain-core`

## Objective

Keep Hermes and Paragon engineering continuously aware of important blockchain performance, security, infrastructure, and Move/Aptos ecosystem developments.

Research is not automatically action. Research becomes action only after relevance, security, benchmark, and rollback analysis.

## Research scope

### L1 performance

Track:

- Aptos performance engineering
- Block-STM and parallel execution
- MoveVM execution performance
- Sui/Mysten execution and object-model research
- Solana/Firedancer validator/networking optimizations
- Monad parallel execution design
- Sei v2 performance architecture
- HotStuff/Jolteon/BFT consensus developments
- mempool design
- state sync and snapshots
- pruning and storage compaction
- validator hardware benchmarks
- RPC scalability patterns

### Security

Track:

- Move smart contract vulnerabilities
- L1 consensus/security postmortems
- validator compromise incidents
- bridge exploit postmortems
- RPC abuse and DDoS patterns
- supply-chain attacks
- signing/key custody failures
- governance and upgrade failures
- wallet drainer/phishing infrastructure

Sources to monitor include credible engineering and security organizations such as Aptos, Mysten/Sui, Solana/Firedancer, Monad, Sei, Trail of Bits, Zellic, OtterSec, MoveBit, Certora, Paradigm, a16z crypto, and major exploit postmortems.

### Infrastructure

Track:

- sentry node topologies
- DDoS-resistant public RPC design
- validator observability
- Prometheus/Grafana alerting patterns
- snapshot distribution
- low-cost high-availability node operations
- secure Linux validator hardening
- WireGuard/private network operations

## Research evaluation framework

For every notable item, Hermes should ask:

1. What changed?
2. Is it relevant to Paragon L1?
3. Does it affect performance, security, cost, or developer experience?
4. Does it require consensus, VM, gas, storage, networking, or key-handling changes?
5. Can it be tested on localnet/devnet first?
6. What benchmark would prove benefit?
7. What new attack surface does it introduce?
8. What hardware impact does it have?
9. What rollback exists?
10. Should Paragon act now, track, or ignore?

## Output format

Recurring research summaries should use this shape:

```text
Paragon L1 Research Radar — YYYY-MM-DD

High-priority findings:
- finding
  - relevance:
  - risk:
  - recommended action:

Watchlist:
- item
  - why it matters:

Security alerts:
- alert
  - impact:
  - mitigation:

Benchmark ideas:
- benchmark
  - what it proves:

Docs/skills to update:
- file or skill
  - reason:
```

## Action categories

### Act

Use when:

- a security issue affects Paragon assumptions
- a low-risk operational improvement is clear
- a benchmark should be added soon
- documentation is outdated

### Track

Use when:

- the idea is relevant but immature
- implementation risk is high
- no benchmark path exists yet
- dependency maturity is uncertain

### Ignore

Use when:

- not applicable to Aptos/Move/Paragon
- marketing without technical substance
- requires centralizing validator hardware without clear benefit
- introduces unacceptable security risk

## Safety rule

Hermes must not recommend protocol changes solely because another chain claims performance improvements.

A recommendation must include:

- Paragon relevance
- risk class
- benchmark plan
- rollback plan
- approval-gated surfaces touched

## Recurring operation

The Research Radar should run on a scheduled basis and deliver a concise internal summary to Paragon operators.

Recommended schedule:

- weekly during stable phases
- every 2-3 days during active L1 architecture/build phases
- immediate manual run after major industry incidents or major Aptos/Move releases
