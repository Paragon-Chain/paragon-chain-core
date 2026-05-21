# Paragon L1 Build-to-Testnet Plan

This repo should move toward testnet in controlled phases:

1. local development baseline,
2. Paragon identity baseline,
3. deterministic localnet genesis,
4. XPGN/economics specification,
5. private multi-node devnet,
6. security hardening,
7. public testnet candidate,
8. public testnet.

The detailed private operating plan is currently maintained in the workspace-level `PARAGON_L1_TESTNET_PLAN.md`. Repo-facing docs should contain only durable engineering guidance that is safe to keep with the source tree.

## Strategy

- Prefer framework Move, genesis, and config changes before Rust runtime divergence.
- Avoid consensus/storage/execution changes until a healthy Paragon localnet/devnet exists.
- Keep all changes small and reviewable.
- Preserve the upstream Aptos relationship clearly.
- Do not mix public Discord agent behavior with private engineering workflows.

## Immediate Sequence

1. Merge local dev runbook.
2. Create `eng/paragon-identity-baseline`.
3. Audit chain-facing Aptos naming.
4. Define Paragon localnet/devnet/testnet identity.
5. Map genesis and framework release paths.
6. Build a localnet bootstrap runbook.
