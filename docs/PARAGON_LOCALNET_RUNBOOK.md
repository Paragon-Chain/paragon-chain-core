# Paragon Localnet Runbook

Status: verified baseline  
Repo: `paragon-chain-core`  
Host used for validation: Shinobi  
Branch at validation time: `agent/phase-1-implementation-map`  
Baseline source HEAD at validation time: `bdbdeb1e3e`

## Purpose

This runbook documents the currently verified local development flow for the Paragon Aptos-derived L1 baseline before any protocol-risk changes are made.

The goal is to preserve a known-good build and localnet boot path so future chain ID, genesis, framework, token, validator, or runtime changes can be measured against a stable baseline.

## Verified baseline

The following gates passed from the locked dependency graph:

```bash
cargo check --workspace --locked
cargo build -p aptos --locked
./target/debug/aptos node run-localnet --help
```

A smoke localnet was also booted successfully with a temporary test directory and no faucet or transaction stream:

```bash
TEST_DIR=/tmp/paragon-localnet-smoke
rm -rf "$TEST_DIR"
./target/debug/aptos node run-localnet \
  --test-dir "$TEST_DIR" \
  --force-restart \
  --assume-yes \
  --no-faucet \
  --no-txn-stream \
  --ready-server-listen-port 18070
```

Observed readiness response:

```json
{"ready":[{"NodeApi":"http://127.0.0.1:8080/"}],"not_ready":[]}
```

Observed generated localnet values from the smoke run:

```text
Test dir: /tmp/paragon-localnet-smoke
ChainId: 4
REST API endpoint: http://127.0.0.1:8080
Metrics endpoint: http://127.0.0.1:9101/metrics
Admin service: http://127.0.0.1:9102/
Ready endpoint: http://127.0.0.1:18070/
```

Important: the observed `ChainId: 4` is the current upstream/localnet default. It is a baseline observation, not a final Paragon chain ID decision.

## Host dependency baseline

On Ubuntu noble, this Aptos-derived workspace required the following host development packages to pass the current Rust build gates:

```bash
sudo apt-get install -y \
  clang \
  lld \
  pkg-config \
  libssl-dev \
  cmake \
  build-essential \
  libudev-dev \
  libdw-dev
```

Dependency notes:

- Missing `libudev.pc` maps to `libudev-dev`.
- Missing `libdw.pc` maps to `libdw-dev`.
- These were host build dependency issues, not source defects.

## Standard Shinobi validation commands

Use Shinobi for heavy Rust builds instead of the Hermes VPS/gateway host.

```bash
ssh -o BatchMode=yes shinobi@10.50.0.10 'set -euo pipefail; \
  export PATH="$HOME/.cargo/bin:$HOME/.local/node/current/bin:$HOME/.local/bin:$PATH"; \
  [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"; \
  cd /home/shinobi/repos/paragon-chain-core; \
  cargo check --workspace --locked'
```

```bash
ssh -o BatchMode=yes shinobi@10.50.0.10 'set -euo pipefail; \
  export PATH="$HOME/.cargo/bin:$HOME/.local/node/current/bin:$HOME/.local/bin:$PATH"; \
  [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"; \
  cd /home/shinobi/repos/paragon-chain-core; \
  cargo build -p aptos --locked'
```

## Basic localnet commands

From the repo root after building the CLI:

```bash
./target/debug/aptos node run-localnet \
  --test-dir /tmp/paragon-localnet-dev \
  --force-restart \
  --assume-yes
```

For a lighter smoke test without faucet or transaction stream:

```bash
./target/debug/aptos node run-localnet \
  --test-dir /tmp/paragon-localnet-smoke \
  --force-restart \
  --assume-yes \
  --no-faucet \
  --no-txn-stream \
  --ready-server-listen-port 18070
```

Readiness check:

```bash
curl -fsS http://127.0.0.1:18070/
```

Expected ready shape:

```json
{"ready":[{"NodeApi":"http://127.0.0.1:8080/"}],"not_ready":[]}
```

## Default local service ports

- REST API: `8080`
- Faucet: `8081` unless `--no-faucet` is used
- Transaction stream gRPC: `50051` unless `--no-txn-stream` is used
- Ready server: `8070` by default, overrideable with `--ready-server-listen-port`
- Metrics: `9101`
- Admin service: `9102`
- Fullnode network: `6181`

## Safety rules

- Do not bind localnet services publicly unless there is a specific reviewed reason.
- Default to loopback binding for development.
- Treat `--force-restart` as destructive for the selected `--test-dir` only.
- Use temporary test directories for smoke runs.
- Do not place secrets, production keys, or persistent validator material under temporary localnet directories.
- Keep consensus, crypto, VM, gas metering, storage schema, network protocol messages, key handling, and validator safety changes approval-gated.

## Next validation gates

Before devnet or public testing:

1. Decide and document Paragon chain ID policy.
2. Decide and document genesis ownership and signing process.
3. Decide XPGN token integration strategy.
4. Produce deterministic localnet/devnet bootstrap scripts.
5. Add health checks for REST API, metrics, and validator liveness.
6. Add explicit rollback/reset procedure for devnet state.
