# Local Development Runbook

This runbook documents the working local development environment for `paragon-chain-core`.

## Environment

Current verified environment:

- Host runtime: WSL/Linux
- Repo path: `/home/zevebe/.openclaw/workspace/paragon-chain-core`
- Rust toolchain: `1.93.1`
- pnpm: `8.15.9`
- Local OpenSSL: `~/.local/openssl`
- Local LLVM/Clang/libclang: `~/.local/llvm14-sysroot` and wrapper binaries in `~/.local/llvm14-bin`
- Local Debian-package sysroot: `~/.local/sysroot`
- Build environment helper: `~/.local/bin/paragon-chain-env`

This setup is intentionally user-local because the current runtime does not have sudo/elevated access.

## Fresh Shell Setup

Always start build work with:

```bash
source ~/.local/bin/paragon-chain-env
cd /home/zevebe/.openclaw/workspace/paragon-chain-core
ulimit -s 65532
```

The env script should export:

- cargo/rust paths,
- LLVM/Clang paths,
- `LIBCLANG_PATH`,
- OpenSSL paths,
- pkg-config/sysroot paths,
- cargo fetch/build stability variables.

## Fast Sanity Checks

```bash
rustc -Vv
cargo -Vv
pnpm --version
clang --version
pkg-config --cflags --libs libudev
pkg-config --cflags --libs libdw
./target/debug/aptos-node --version
```

Expected node version output at the current baseline:

```text
Aptos Node 0.0.0-main
```

## Dependency Install Check

```bash
pnpm install --frozen-lockfile
cargo metadata --no-deps --format-version 1
```

## Reliable Rust Check

Use this before opening PRs that touch Rust, Move, config, or genesis-related code:

```bash
source ~/.local/bin/paragon-chain-env
cd /home/zevebe/.openclaw/workspace/paragon-chain-core
ulimit -s 65532
CARGO_BUILD_JOBS=1 \
CARGO_INCREMENTAL=0 \
RUST_MIN_STACK=67108864 \
cargo check -p aptos-node --locked
```

## Reliable Debug Build

```bash
source ~/.local/bin/paragon-chain-env
cd /home/zevebe/.openclaw/workspace/paragon-chain-core
ulimit -s 65532
CARGO_BUILD_JOBS=1 \
CARGO_INCREMENTAL=0 \
RUST_MIN_STACK=67108864 \
cargo build -p aptos-node --locked
```

Verify the binary:

```bash
./target/debug/aptos-node --version
```

## Known Problems And Fixes

### Cargo fetch/libgit2 instability

Symptom: cargo fetch/check/build crashes while fetching git dependencies.

Fix:

```bash
export CARGO_NET_GIT_FETCH_WITH_CLI=true
```

This is included in `~/.local/bin/paragon-chain-env`.

### Missing OpenSSL

Symptom: `openssl-sys` cannot find OpenSSL.

Fix: confirm the local OpenSSL exports are set:

```bash
echo "$OPENSSL_DIR"
echo "$OPENSSL_LIB_DIR"
echo "$OPENSSL_INCLUDE_DIR"
```

Expected base path:

```text
/home/zevebe/.local/openssl
```

### Missing libclang / RocksDB bindgen failure

Symptom: `librocksdb-sys` fails with `Unable to find libclang`.

Fix: confirm `LIBCLANG_PATH` points to local LLVM 14 runtime:

```bash
echo "$LIBCLANG_PATH"
ls "$LIBCLANG_PATH"/libclang*.so*
```

### Missing libudev/libdw/libelf at link time

Symptom: final link fails with missing `-ludev`, `-ldw`, or `-lelf`.

Fix: confirm local sysroot libraries exist and pkg-config resolves them:

```bash
ls ~/.local/sysroot/usr/lib/x86_64-linux-gnu/libudev.so*
ls ~/.local/sysroot/usr/lib/x86_64-linux-gnu/libdw.so*
ls ~/.local/sysroot/usr/lib/x86_64-linux-gnu/libelf.so*
pkg-config --libs libudev
pkg-config --libs libdw
```

### rustc incremental ICE/segfault

Symptom: rustc panics or segfaults in random crates.

Fix:

```bash
rm -rf target/debug/incremental
export CARGO_INCREMENTAL=0
export RUST_MIN_STACK=67108864
ulimit -s 65532
```

### lld final link crash

Symptom: `ld.lld` segfaults during final `aptos-node` link.

Fix: document the failure, then retry with the gcc linker fallback if needed:

```bash
RUSTFLAGS='--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes -L native=/home/zevebe/.local/sysroot/usr/lib/x86_64-linux-gnu -L native=/home/zevebe/.local/openssl/lib64' \
cargo build -p aptos-node --locked \
  --config 'target.x86_64-unknown-linux-gnu.linker="gcc"'
```

## Git Workflow

1. Start from `main`.
2. Create a small engineering branch.
3. Make one logical change.
4. Run the smallest meaningful verification.
5. Commit.
6. Open PR.

Example:

```bash
git checkout main
git pull --ff-only
git checkout -b eng/local-dev-runbook
# edit docs
git status --short
cargo check -p aptos-node --locked
git add <files>
git commit -m "docs: add local development runbook"
gh pr create --fill
```

## Cost Discipline

Do not use expensive model calls for normal build loops. Use local tools for:

- file search,
- compilation,
- tests,
- logs,
- mechanical edits.

Reserve GPT-class review for:

- architecture/security decisions,
- final PR closeout,
- unclear build failures after local investigation,
- public-facing technical docs that need high confidence.
