# Paragon Performance Strategy

Status: strategic baseline  
Repo: `paragon-chain-core`

## Objective

Make Paragon L1 fast under realistic production conditions without forcing unnecessary bare-metal requirements or weakening protocol safety.

Performance work must be benchmark-led. No optimization should be treated as real until it is measured against a reproducible baseline.

## Performance priorities

In order:

1. Reproducibility
2. Correctness
3. Security
4. Latency
5. Throughput
6. Cost efficiency
7. Operator simplicity

Throughput is not allowed to override correctness or validator safety.

## Optimization order

### Phase 1: Baseline measurement

Measure current inherited baseline before modifying performance-sensitive code.

Required metrics:

- localnet boot time
- transaction submission latency
- transaction finality latency
- sustained TPS under controlled workload
- peak TPS under bounded stress
- CPU usage
- memory usage
- disk I/O
- network I/O
- state growth
- restart/recovery time
- REST API latency
- validator log error rate

### Phase 2: Safe configuration tuning

First optimization surface:

- validator config
- mempool config
- consensus timeout parameters only with review
- state sync behavior
- pruning settings
- RocksDB/storage tuning
- RPC limits
- metrics sampling
- transaction stream/indexer separation

This phase should avoid modifying consensus or VM internals.

### Phase 3: Topology optimization

Separate critical roles:

- validators validate and participate in consensus
- sentry/fullnodes absorb public network traffic
- RPC nodes serve clients
- indexers process analytics/explorer load
- archive nodes retain historical state when needed

Public RPC and heavy indexing should not compete with validator-critical resources.

### Phase 4: Framework/genesis optimization

Optimize token and chain setup through safer surfaces:

- XPGN genesis configuration
- chain ID profiles
- Move module ownership
- account/treasury initialization
- faucet/devnet policies
- localnet/devnet deterministic profiles

### Phase 5: Deep protocol optimization

Only after evidence shows a real bottleneck.

Approval-gated areas:

- consensus protocol
- AptosVM / MoveVM execution
- gas metering
- storage schema
- networking protocol messages
- cryptography or signing domains

## Hardware philosophy

Paragon should support moderate high-quality validator hardware rather than requiring extreme servers by default.

Preferred validator characteristics:

- reliable CPU with strong single-core performance
- NVMe storage
- sufficient memory headroom
- stable bandwidth
- hardened Linux host
- private key isolation
- monitoring and alerting

Avoid designing around:

- validator public RPC exposure
- validators running archive workloads
- validators running heavy analytics/indexers
- every validator needing top-end bare metal

## Benchmark principle

Every performance claim must include:

- git commit / branch
- build command
- hardware profile
- chain profile
- workload generator
- transaction mix
- duration
- latency distribution
- resource utilization
- failure/error rate
- reproducibility instructions

## Practical first benchmarks

### Localnet smoke benchmark

Goal: verify node boots, REST API becomes ready, and basic transactions work.

### Single-node load benchmark

Goal: identify basic bottlenecks without network complexity.

Measure:

- TPS
- latency p50/p95/p99
- CPU
- memory
- disk I/O
- transaction failure rate

### Private multi-node devnet benchmark

Goal: measure consensus/network behavior with realistic validator separation.

Measure:

- finality latency
- validator CPU/memory
- network traffic
- consensus round behavior
- state sync recovery
- node restart recovery

### Public RPC benchmark

Goal: protect validators from public read/write pressure.

Measure:

- REST latency
- rate limit effectiveness
- fullnode CPU/memory
- error rates
- DDoS sensitivity

## Research themes to track

Hermes should continuously monitor:

- Block-STM and parallel execution improvements
- Aptos performance engineering
- MoveVM security and performance updates
- Sui/Mysten object execution research
- Solana/Firedancer networking and validator optimization
- Monad parallel execution approaches
- Sei v2 design decisions
- HotStuff/Jolteon/BFT consensus improvements
- state sync, pruning, and snapshot distribution
- validator hardware benchmarks
- fee-market and gas mechanism design

Research should be converted into Paragon action only when it passes:

1. relevance test
2. security review
3. benchmark plan
4. rollback plan
5. hardware impact assessment

## Anti-patterns

Do not:

- chase TPS numbers without transaction mix clarity
- benchmark on unrealistic hardware then imply broad validator accessibility
- expose validators to public RPC pressure
- tune away safety margins blindly
- modify consensus because another chain published a blog post
- treat localnet TPS as mainnet performance
- ship performance changes without observability
