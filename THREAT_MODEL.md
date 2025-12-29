# SOM.AI Threat Model (Draft)

## Assets
- Treasury funds
- Fee streams
- Execution routes
- Configuration authority

## Adversaries
- MEV searchers / sandwichers
- Oracle manipulators
- Malicious governance/config operator
- Exploit developers targeting approvals/reentrancy

## Key risks
### 1) Sandwiching buybacks
**Risk:** predictable buybacks can be sandwiched.
**Mitigations:** randomized execution windows, max slippage, TWAP routing, private relays where available.

### 2) Oracle manipulation
**Risk:** if policy depends on price oracles, attacker manipulates short windows.
**Mitigations:** medianization, longer windows, multiple sources, sanity bounds.

### 3) Treasury drain
**Risk:** approvals, reentrancy, route injection.
**Mitigations:** route allow-list, minimal approvals, pull patterns, reentrancy guards.

### 4) Policy/config abuse
**Risk:** thresholds changed to force spending.
**Mitigations:** timelock, multi-sig, config hashing, emergency pause.

## Notes
This document should evolve alongside the contracts and agent policy.
