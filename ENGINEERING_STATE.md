# Engineering State

This file is the durable handoff point for Paragon L1 engineering work. Keep it current before stopping, switching tasks, or opening a PR.

## Current Branch

- Branch: `eng/local-dev-runbook`
- Objective: document the working WSL/local development baseline and engineering boundaries before Paragon identity/devnet work begins.
- Owner: Paragon engineering agent using the `paragonmod-engineer` GitHub account.

## Current Baseline

- Repo path: `/home/zevebe/.openclaw/workspace/paragon-chain-core`
- Runtime environment: WSL/Linux, not native Windows.
- Rust: `1.93.1`
- pnpm: `8.15.9`
- Local OpenSSL: `~/.local/openssl`
- Local LLVM/Clang/libclang: under `~/.local/llvm14-sysroot`, exposed through `~/.local/llvm14-bin`
- Local native sysroot: `~/.local/sysroot`
- Build env script: `~/.local/bin/paragon-chain-env`

## Verified Commands

Run from a fresh shell:

```bash
source ~/.local/bin/paragon-chain-env
cd /home/zevebe/.openclaw/workspace/paragon-chain-core
ulimit -s 65532
cargo metadata --no-deps --format-version 1
cargo check -p aptos-node --locked
CARGO_BUILD_JOBS=1 CARGO_INCREMENTAL=0 RUST_MIN_STACK=67108864 cargo build -p aptos-node --locked
./target/debug/aptos-node --version
```

Last known binary verification:

```text
Aptos Node 0.0.0-main
```

## Known Local Build Notes

- `CARGO_NET_GIT_FETCH_WITH_CLI=true` is required to avoid cargo/libgit2 fetch instability.
- `LIBCLANG_PATH` must point at the local LLVM 14 libclang runtime.
- `CARGO_BUILD_JOBS=1` is slower but stable in this WSL environment.
- `CARGO_INCREMENTAL=0` avoids rustc incremental ICE/segfault behavior seen during early setup.
- `RUST_MIN_STACK=67108864` and `ulimit -s 65532` avoid stack-related compiler crashes.
- RocksDB builds successfully through clang++ after local LLVM/libclang setup.
- If `ld.lld` crashes during final linking, retry with gcc linker fallback after documenting the failure.

## Active Blockers

None for local build baseline.

## Next Task After This PR

Start `eng/paragon-identity-baseline`:

1. audit chain-facing Aptos names,
2. define Paragon localnet/devnet/testnet names,
3. map genesis and localnet bootstrap commands,
4. avoid risky Rust crate renames unless required.

## Recovery Rule

Before stopping work, update this file with:

- branch,
- objective,
- files changed,
- commands run,
- blocker if any,
- exact next command to resume.
