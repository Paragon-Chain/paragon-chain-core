# Paragon Validator Infrastructure Strategy

Status: strategic baseline  
Repo: `paragon-chain-core`

## Objective

Design Paragon validator and node infrastructure so the network can be fast, secure, and cost-efficient without requiring every operator to run massive bare-metal infrastructure.

## Core principle

Validators should validate. Public traffic, indexing, analytics, archive storage, dashboards, faucets, and heavy RPC should be isolated away from validator-critical paths.

## Recommended node roles

### Validator node

Purpose:

- participate in consensus
- execute blocks
- maintain validator identity and safety state

Should have:

- hardened Linux
- private network access where possible
- restricted inbound ports
- no public RPC exposure by default
- key isolation
- metrics export to trusted monitoring only
- reliable NVMe
- stable bandwidth
- backup and recovery runbook

Should not run:

- public RPC
- explorer backend
- heavy indexer
- archive workload
- faucet
- unrelated services

### Sentry/fullnode

Purpose:

- absorb network traffic
- protect validator exposure
- serve peer/network edge functions
- provide safer path for public or semi-public connectivity

Should have:

- stricter firewall policy
- replaceable stateless-ish operations where possible
- monitoring and auto-restart
- DDoS-aware hosting if public

### Public RPC node

Purpose:

- serve applications, wallets, bots, users, and ecosystem reads/writes

Should have:

- rate limiting
- request logging/metrics
- abuse detection
- load balancing
- TLS termination upstream
- no validator keys
- no admin port exposure

### Indexer node

Purpose:

- explorer data
- analytics
- app-specific queries
- historical transaction processing

Should be isolated because indexing can be CPU/storage/database heavy.

### Archive node

Purpose:

- long-term state/history retention
- debugging and forensics
- explorer/indexer backfill

Archive requirements may be higher, but archive operation should not be mandatory for every validator.

## Hardware direction

### Initial validator target

Paragon should aim for moderate high-quality validator hardware:

- modern multi-core CPU
- strong single-core performance
- NVMe SSD
- sufficient RAM headroom
- stable network
- reliable power/uptime

Exact specs must be decided from benchmarks, not guessed.

### Avoid

- designing around giant bare-metal-only validators from day one
- making public RPC mandatory on validators
- forcing all validators to keep full archive history
- running database-heavy indexers on validator hosts
- colocating many unrelated services with validator processes

## Network architecture

Preferred production shape:

```text
Public users/apps
  -> Load balancer / edge protection
  -> Public RPC fullnodes
  -> Paragon network

Validators
  -> private or restricted network paths
  -> sentry/fullnode layer where applicable
  -> monitoring and alerting

Indexers/explorers
  -> dedicated fullnode or transaction stream source
  -> separate database/storage
```

## Security controls

Minimum validator controls:

- SSH key-only auth
- no password login
- firewall default deny
- admin ports loopback/private only
- no public validator REST/admin exposure
- least-privilege service user
- systemd service isolation where practical
- regular OS security updates
- log rotation
- metrics collection
- alerting on process down, peer loss, disk pressure, memory pressure, high error rate

## Observability requirements

Every validator/fullnode profile should expose controlled metrics for:

- process liveness
- peer count
- consensus progress
- block height/version progress
- transaction throughput
- finality/commit latency where available
- CPU/memory/disk/network
- restart count
- storage growth
- error logs

## Cost-control strategy

To avoid excessive infrastructure costs:

1. Keep validators minimal and dedicated.
2. Scale public RPC horizontally with fullnodes.
3. Keep indexers separate and independently scalable.
4. Use pruning/snapshot strategy once validated.
5. Use devnet/testnet benchmarks to set realistic hardware recommendations.
6. Avoid premature high-availability complexity before workload exists.

## Devnet infrastructure goal

Before public testnet, build a private devnet with:

- at least multi-node validator topology
- separate public RPC fullnode
- separate monitoring stack
- reset runbook
- genesis artifact record
- chain ID record
- basic load test
- restart/recovery test

## Public testnet infrastructure goal

Before public testnet:

- public RPC endpoint should be isolated from validators
- faucet must be rate-limited
- indexer/explorer must be separate
- validator onboarding docs must exist
- status dashboard must exist
- incident escalation path must exist

## Mainnet infrastructure goal

Before mainnet:

- validator key ceremony documented
- production firewall policy documented
- upgrade process rehearsed
- rollback/incident process rehearsed
- monitoring alerts tested
- public RPC protection tested
- snapshot/recovery process tested
