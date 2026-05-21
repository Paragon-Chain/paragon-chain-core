# Testnet Readiness Checklist

This checklist tracks the path from local development to public Paragon testnet.

## Current Status

- Local WSL build environment: ready.
- `cargo check -p aptos-node --locked`: passing.
- `cargo build -p aptos-node --locked`: produced `target/debug/aptos-node`.
- Node binary smoke test: `./target/debug/aptos-node --version` returns `Aptos Node 0.0.0-main`.

## Phase Gates

### 1. Local Baseline

- [x] Repo cloned.
- [x] GitHub bot access confirmed.
- [x] Rust/pnpm/native dependencies installed.
- [x] Local aptos-node check passes.
- [x] Local aptos-node debug binary builds.
- [ ] Local dev runbook merged.

### 2. Paragon Identity Baseline

- [ ] Define chain-facing naming policy.
- [ ] Define localnet/devnet/testnet names.
- [ ] Decide chain ID strategy.
- [ ] Rename safe chain-facing docs/config/help text.
- [ ] Avoid risky crate-level renames unless required.

### 3. Localnet Bootstrap

- [ ] Map genesis entrypoints.
- [ ] Map framework release composition.
- [ ] Generate local validator keys.
- [ ] Generate genesis/waypoint.
- [ ] Boot single-validator localnet.
- [ ] Verify node health/API.
- [ ] Restart from saved state.

### 4. Economics Specification

- [ ] Decide XPGN gas/staking strategy.
- [ ] Define supply/decimals.
- [ ] Define validator staking requirements.
- [ ] Define treasury fee split.
- [ ] Define governance/upgrade authority holders.
- [ ] Document implementation surface.

### 5. Private Multi-node Devnet

- [ ] Boot 1 validator + 1 fullnode.
- [ ] Boot multi-validator network.
- [ ] Submit transactions.
- [ ] Verify consensus/state sync.
- [ ] Add smoke tests.
- [ ] Add monitoring/logging basics.

### 6. Public Testnet Candidate

- [ ] Choose cloud provider and budget.
- [ ] Choose validator/fullnode topology.
- [ ] Define key ceremony.
- [ ] Define faucet/RPC limits.
- [ ] Create deployment runbook.
- [ ] Run 24–72h private soak.
- [ ] Publish limited public docs.

## Open Decisions Needed

- Target testnet timeline.
- Cloud provider and monthly budget ceiling.
- Initial validator count.
- External validators yes/no.
- XPGN supply, decimals, gas, staking, and treasury direction.
- Governance/upgrade key holders for devnet/testnet.
- Faucet/explorer/indexer/wallet support required on day one yes/no.
