# Paragon Benchmark Plan

Status: initial benchmark strategy  
Repo: `paragon-chain-core`

## Objective

Create a reproducible benchmark path for Paragon L1 so performance work is evidence-driven and hardware requirements stay realistic.

## Rules

1. No TPS claim without reproducible methodology.
2. No optimization merge without before/after measurement.
3. No validator hardware recommendation without resource data.
4. No public testnet performance claim based only on localnet.
5. No deep protocol change without rollback and security review.

## Benchmark metadata required

Every benchmark report must include:

- repo branch
- git commit
- build command
- Rust version
- OS/kernel
- machine profile
- CPU model
- RAM
- disk type
- network profile
- node count
- chain ID/profile
- genesis artifact source
- workload generator
- transaction mix
- duration
- warmup period
- p50/p95/p99 latency
- throughput
- error rate
- CPU/memory/disk/network utilization
- logs or failure summary

## Benchmark stages

### Stage 1: Build and localnet readiness

Purpose: ensure the binary and localnet path work.

Commands already validated:

```bash
cargo check --workspace --locked
cargo build -p aptos --locked
./target/debug/aptos node run-localnet --help
```

Smoke command:

```bash
./target/debug/aptos node run-localnet \
  --test-dir /tmp/paragon-localnet-smoke \
  --force-restart \
  --assume-yes \
  --no-faucet \
  --no-txn-stream \
  --ready-server-listen-port 18070
```

Ready check:

```bash
curl -fsS http://127.0.0.1:18070/
```

### Stage 2: Local transaction functionality

Purpose: verify account creation, funding, transfer, and balance query.

Measure:

- transaction success/failure
- latency
- REST API behavior
- logs

### Stage 3: Single-node load

Purpose: find early local bottlenecks.

Measure:

- sustained TPS
- p50/p95/p99 latency
- CPU
- memory
- disk I/O
- state growth
- failed transactions

### Stage 4: Multi-node private devnet

Purpose: test validator networking, consensus behavior, state sync, and recovery.

Measure:

- commit/finality latency
- peer connectivity
- consensus progress
- validator CPU/memory
- network traffic
- node restart recovery
- state sync catch-up

### Stage 5: Public RPC/fullnode load

Purpose: isolate public traffic from validators.

Measure:

- REST latency
- request throughput
- rate limit behavior
- fullnode CPU/memory
- validator impact from public traffic
- error rate

### Stage 6: Indexer/explorer load

Purpose: ensure analytics workloads do not harm consensus.

Measure:

- processor lag
- database load
- transaction stream behavior
- fullnode impact
- explorer query latency

## Transaction mix categories

Benchmarking should include multiple transaction types:

- simple account funding
- XPGN transfer once integrated
- account creation
- package publish/module interaction where relevant
- read-heavy RPC workload
- mixed read/write workload

Do not report a single synthetic transaction type as general network capacity.

## Resource thresholds

Initial thresholds should be discovered, not guessed.

Record when any node hits:

- CPU saturation
- memory pressure
- disk I/O saturation
- network saturation
- excessive log errors
- state sync lag
- transaction failure spike

## Output format

Benchmark reports should use:

```text
Benchmark: <name>
Date:
Branch:
Commit:
Hardware:
Node profile:
Command:
Workload:
Duration:
Results:
- TPS:
- latency p50/p95/p99:
- CPU:
- memory:
- disk I/O:
- network I/O:
- error rate:
Findings:
Bottlenecks:
Recommended next step:
Security/ops risk:
```

## First implementation target

The next practical benchmark task is a reproducible local transaction benchmark after the deterministic localnet runbook and XPGN strategy are in place.

Do not jump directly to public TPS claims.
