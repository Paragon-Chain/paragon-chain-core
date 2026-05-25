# Paragon Phase 1 Implementation Map

> **For Hermes:** Use `subagent-driven-development` for implementation work derived from this map. Keep changes incremental, branch-based, and reviewable.

**Goal:** Identify the safest first implementation surfaces for converting this Aptos-derived codebase into a Paragon Chain baseline without touching consensus-critical logic.

**Architecture:** Phase 1 should establish Paragon identity, deterministic local/devnet bootstrap, and a clear framework/genesis customization path before any runtime, consensus, storage, crypto, or VM-core modifications. Prefer configuration, generated genesis artifacts, localnet runbooks, and framework-level Move surfaces over Rust protocol changes.

**Tech Stack:** Rust workspace, Aptos node/CLI, Move framework packages, genesis builder, localnet/testnet tooling, Docker compose where needed.

---

## Operational Rules

- Work from `~/repos/paragon-chain-core` on Shinobi, not the VPS.
- Use `paragonmod-engineer` for GitHub operations.
- Never commit directly to `main`; use `agent/<task>` branches and PRs.
- Keep Phase 1 doc/config changes reversible and minimal.
- Treat this as a high-security L1 repository.
- If a change may affect consensus, validator safety, cryptography, execution safety, storage integrity, gas metering, or protocol compatibility, stop and request explicit approval.

## Approval-Gated Zones

Do not edit these without explicit approval:

- `consensus/`
- `consensus/safety-rules/`
- `consensus/safety_rules/`
- `consensus/src/round_manager.rs`
- `crates/aptos-crypto/`
- `secure/`
- `keyless/`
- signature verification logic
- key generation or derivation
- gas metering
- database schema
- network protocol messages
- `third_party/move/move-vm/`
- `aptos-move/aptos-vm/`
- MoveVM execution core
- Aptos VM execution core
- validator safety logic
- Byzantine fault tolerance logic

## Current Repo Signals

Existing Paragon planning documents already point in the right direction:

- `docs/PARAGON_FORK_ROADMAP.md`
  - Phase 1 target: Paragon naming, deterministic genesis, local/devnet bootstrap.
  - Avoid speculative runtime research before baseline devnet stability.
- `docs/CHAIN_CUSTOMIZATION_MAP.md`
  - First customization surfaces: genesis, framework, configuration, local run scripts.
  - Safe decision rule: prefer Move framework or genesis/config before Rust core changes.

This file turns those roadmap notes into a concrete codebase map for agent work.

---

## 1. Chain Identity Surface

### Important files

- `types/src/chain_id.rs`
  - Defines `ChainId` wrapper and named-chain parsing.
  - Existing named chains include `mainnet`, `testnet`, `devnet`, and testing/local semantics via upstream Aptos types.
- `config/src/config/*`
  - Many sanitizers branch on `ChainId::mainnet()` and `ChainId::testnet()`.
  - Non-mainnet/testnet IDs often avoid long-lived network behavior.
- `crates/aptos/src/common/init.rs`
  - CLI network selection for `devnet`, `testnet`, `mainnet`, `local`, `custom`.
- `crates/aptos/src/node/mod.rs`
  - CLI node commands and chain-name parsing help text.

### Recommended Phase 1 approach

Start with a Paragon local/devnet identity that does **not** pretend to be Aptos mainnet/testnet.

- Use a custom numeric chain ID for Paragon local/devnet in generated configs first.
- Document Paragon network naming before adding named-chain code.
- Avoid changing mainnet/testnet behavior until localnet bootstrap is stable.
- Avoid changing consensus or network protocol messages.

### Open decision

Choose reserved Paragon chain IDs:

- `paragon-local`: suggested temporary local ID, e.g. `250` or another explicit nonzero `u8`.
- `paragon-devnet`: suggested separate devnet ID.
- `paragon-testnet`: optional later.
- `paragon-mainnet`: only after launch planning.

`ChainId` is currently `u8`, so valid values are `1..=255`; `0` is reserved/invalid.

---

## 2. Genesis And Bootstrap Surface

### Important files

- `crates/aptos-genesis/src/config.rs`
  - `Layout` contains target `chain_id` and genesis-related on-chain config defaults.
  - Validator configuration and genesis join behavior live here.
- `crates/aptos-genesis/src/builder.rs`
  - Builds local validator genesis artifacts.
  - Writes `genesis.blob` into node config.
- `aptos-move/vm-genesis/src/lib.rs`
  - Encodes genesis transaction/change set.
  - Publishes framework at genesis.
  - Initializes on-chain configs and genesis accounts.
- `config/src/config/execution_config.rs`
  - Handles `genesis.blob` file location, BCS decoding, writing, and waypoint injection.
- `config/README.md`
  - Explains config generation and genesis blob handling.

### Recommended Phase 1 approach

Use the existing genesis builder path first.

Safe first steps:

1. Generate Paragon localnet configs using the upstream local validator/testnet tooling.
2. Confirm the generated `genesis.blob` uses the selected Paragon chain ID.
3. Document generated artifact paths and commands.
4. Only after local bootstrap works, decide whether to add Paragon-specific wrappers or CLI aliases.

Do **not** modify `aptos-move/vm-genesis/src/lib.rs` until the config-driven route is fully understood and insufficient.

---

## 3. Local Devnet / Localnet Surface

### Important files

- `crates/aptos/src/node/local_testnet/mod.rs`
  - Localnet command implementation.
  - Default folder: `.aptos/testnet`.
  - Supports local node/faucet/indexer-related options.
- `crates/aptos/src/node/mod.rs`
  - Exposes localnet command; `run-local-testnet` remains an alias.
- `aptos-node/src/lib.rs`
  - Supports single-validator testnet mode and optional genesis framework path.
- `docker/compose/validator-testnet/docker-compose.yaml`
  - Single validator test network with faucet path.
- `docker/compose/README.md`
  - Docker compose local validator-testnet instructions.
- `testsuite/indexer_grpc_local.py`
  - Local docker compose validator-testnet harness.

### Recommended Phase 1 approach

First validation target should be a local single-validator Paragon baseline.

Preferred command family to validate:

```bash
cargo build -p aptos
./target/debug/aptos node run-localnet --help
./target/debug/aptos node run-localnet --assume-yes
```

If upstream naming remains visible in CLI output, document it first; rename later in a separate PR.

For Docker-based smoke tests, inspect and adapt only after the native localnet path is understood:

```bash
cd docker/compose/validator-testnet
docker compose up -d
```

Do not run destructive cleanup commands against persistent data without explicit confirmation.

---

## 4. Framework And Move Package Surface

### Important files

- `aptos-move/framework/`
  - Root for framework packages and release tooling.
- `aptos-move/framework/aptos-framework/Move.toml`
  - Core framework package manifest.
- `aptos-move/framework/src/aptos.rs`
  - Release target handling: `head`, `devnet`, `testnet`, `mainnet`.
- `aptos-move/framework/src/main.rs`
  - Framework release tooling CLI.
- `aptos-move/framework/cached-packages/`
  - Generated/cached release bundles used by Rust code.
- `aptos-move/framework/README.md`
  - Framework documentation entrypoint.

### Recommended Phase 1 approach

Do not immediately rename `aptos_framework` internals or alter gas/staking code.

Safer sequence:

1. Build and test the existing framework unchanged.
2. Identify where Paragon-specific Move modules should live.
3. Decide whether early Paragon modules belong in:
   - `aptos-move/framework/aptos-framework/sources/`, if truly chain-native; or
   - a separate Paragon Move workspace first, if still experimental.
4. If framework packages change, rebuild cached packages and review generated files.

Required verification for framework changes:

```bash
cargo test -p aptos-framework
cargo build -p aptos-cached-packages
git status aptos-move/framework/cached-packages/
```

---

## 5. Token / XPGN Surface

### Important files

- `aptos-move/framework/aptos-framework/sources/aptos_coin.move`
- `aptos-move/framework/aptos-framework/doc/aptos_coin.md`
- `aptos-move/framework/cached-packages/src/aptos_stdlib.rs`
- `aptos-move/vm-genesis/src/lib.rs`

### Current assessment

XPGN is a core Paragon economic surface, but direct replacement of `AptosCoin` is not a safe first edit. Coin identity touches framework APIs, genesis initialization, staking/reward flows, tests, SDK assumptions, and user-facing CLI behavior.

### Recommended Phase 1 approach

Start with a written token strategy before code changes:

- Determine whether XPGN should be:
  - a renamed canonical gas coin replacing `AptosCoin` semantics; or
  - a Paragon-native asset layered on top while preserving upstream gas coin internals during early bootstrap.
- Identify all framework, genesis, SDK, and CLI references before editing.
- Do not change gas metering or VM internals in Phase 1.

Safe initial artifact:

```text
docs/XPGN_TOKEN_INTEGRATION_STRATEGY.md
```

---

## 6. Config And Network Seed Surface

### Important files

- `config/src/config/config_optimizer.rs`
  - Contains Aptos testnet seed peers and mainnet/testnet optimization behavior.
- `config/src/config/execution_config.rs`
  - Contains mainnet/testnet genesis waypoint injection.
- `config/src/config/state_sync_config.rs`
  - Contains testnet/mainnet bootstrapping mode behavior.
- `config/src/config/base_config.rs`
  - Contains waypoint and node config behavior.

### Recommended Phase 1 approach

Do not connect Paragon nodes to upstream Aptos seed peers by accident.

For Paragon local/devnet:

- Use custom chain IDs that do not trigger upstream testnet/mainnet optimization paths.
- Ensure generated configs contain Paragon-owned seed peers only when moving beyond localnet.
- Document all default external endpoints that still reference `aptoslabs.com`.

---

## 7. Documentation And Naming Surface

### Important files

- `README.md`
- `docs/PARAGON_FORK_ROADMAP.md`
- `docs/CHAIN_CUSTOMIZATION_MAP.md`
- `agents.md`
- `CLAUDE.md`
- `SECURITY.md`
- `CONTRIBUTING.md`

### Recommended Phase 1 approach

A doc-first baseline is appropriate before source changes.

Initial doc PRs should:

- state the Paragon repo purpose clearly;
- document local setup and Shinobi build workflow;
- record safe vs approval-gated zones;
- list exact localnet commands once verified;
- avoid overstating completed chain functionality.

---

## Proposed Phase 1 Work Plan

### Task 1: Verify local CLI build

**Objective:** Confirm the Aptos/Paragon CLI builds on Shinobi without source changes.

**Files:** None.

**Commands:**

```bash
cd ~/repos/paragon-chain-core
git checkout main
git pull --ff-only
cargo build -p aptos
./target/debug/aptos node run-localnet --help
```

**Expected:** CLI builds; localnet help displays available options.

### Task 2: Capture localnet runbook

**Objective:** Create a Paragon localnet runbook from verified commands.

**Files:**

- Create: `docs/PARAGON_LOCALNET_RUNBOOK.md`

**Commands to verify before documenting:**

```bash
./target/debug/aptos node run-localnet --assume-yes
```

**Expected:** Single-validator localnet starts and exposes REST/faucet endpoints.

### Task 3: Define Paragon chain ID policy

**Objective:** Reserve local/dev/test/main chain IDs and document rationale.

**Files:**

- Create: `docs/PARAGON_CHAIN_ID_POLICY.md`

**Notes:** `ChainId` is a `u8`; `0` is invalid/reserved. Use non-mainnet/testnet values for local/dev until production policy is final.

### Task 4: Map XPGN integration

**Objective:** Identify all gas/staking/token references before modifying framework code.

**Files:**

- Create: `docs/XPGN_TOKEN_INTEGRATION_STRATEGY.md`

**Do not edit:** gas metering, MoveVM, AptosVM, staking logic, or genesis code in this task.

### Task 5: Decide Paragon Move module location

**Objective:** Decide whether first Paragon Move modules start in-core or in a separate Move workspace.

**Files:**

- Modify: `docs/CHAIN_CUSTOMIZATION_MAP.md`
- Optional create: `docs/PARAGON_MOVE_MODULE_OWNERSHIP.md`

**Decision rule:** Experimental modules should start outside core. Chain-native modules promoted into genesis/framework need explicit review.

---

## Immediate Next Safe Action

Run a build-only validation on Shinobi:

```bash
cd ~/repos/paragon-chain-core
git checkout main
git pull --ff-only
git checkout -b agent/verify-localnet-baseline
cargo build -p aptos
./target/debug/aptos node run-localnet --help
```

If successful, write `docs/PARAGON_LOCALNET_RUNBOOK.md` with exact verified commands and endpoints.

Do **not** start changing framework, genesis, consensus, crypto, storage, or VM code until the localnet baseline is reproducible and reviewed.
