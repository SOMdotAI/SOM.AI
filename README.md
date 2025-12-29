# SOM.AI — Autonomous Intelligence Flywheel
<p align="center">
  <img src="somai.png" alt="SOM.AI" width="980" />
</p>

<p align="center">
  <b>Volume → Observation → Decision → Execution → Redistribution → Volume</b><br/>
  Deterministic. Transparent. Autonomous.
</p>

<p align="center">
  <a href="#quickstart">Quickstart</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#flywheel-model">Flywheel Model</a> •
  <a href="#agent-policy-engine">Agent Policy Engine</a> •
  <a href="#on-chain-contracts">On-Chain Contracts</a> •
  <a href="#security--safety">Security</a> •
  <a href="#faq">FAQ</a>
</p>

> **Note:** Add your banner image as `assets/somai.png` after unzip/clone.  
> (This repo references it in the README + social previews.)

---

## What is SOM.AI?
**SOM.AI** is a **systems-first** memecoin primitive: an **AI-driven value flywheel** that observes market activity and executes deterministic on-chain actions (buybacks / redistribution / burns) under strict safety constraints.

The point is not “AI hype.” The point is an **autonomous loop**:
- Market activity increases available execution budget
- The agent executes programmatic value actions
- Actions are logged & observable
- The loop reinforces itself

---

## Quickstart
### 1) Prereqs
- Node 18+
- pnpm or npm
- Foundry or Hardhat (repo includes a Hardhat config)
- Python 3.10+ (optional: for the agent runner)

### 2) Install
```bash
git clone <YOUR_REPO_URL>
cd SOMAI_repo

# contracts
cd contracts
npm i
npm run test
```

### 3) Run agent simulator (off-chain)
```bash
cd agent
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python run.py --config configs/devnet.yml
```

### 4) Run dashboard (optional)
```bash
cd dashboard
npm i
npm run dev
```

---

## Architecture
SOM.AI is split into two planes:

### A) On-Chain Execution Plane (truth + value)
Responsible for:
- fee capture
- treasury accounting
- buyback execution routing
- redistribution distribution
- immutable event logs

### B) Off-Chain Intelligence Plane (policy + scheduling)
Responsible for:
- observation (volume, volatility, liquidity depth)
- deterministic policy evaluation
- action scheduling & pacing
- generating human-readable “agent logs”

**Design choice:** The “AI” is not a black box.
The system is *deterministic-by-default* with auditable thresholds.

---

## Flywheel Model
### Terminology
- **Volume velocity:** change in volume over rolling windows (5m/1h/24h)
- **Volatility:** rolling stddev of price returns
- **Liquidity depth:** estimated slippage at a reference trade size
- **Execution budget:** amount of treasury allowed to deploy in a window
- **Cooldown:** minimum time between actions

### Core loop
1. Observe market state S(t)
2. Evaluate policy P(S(t)) → action A(t) or no-op
3. Enforce safety constraints C(A(t))
4. Execute on-chain E(A(t)) → emits events
5. Update dashboard / logs

### Example policy
- If 1h volume exceeds threshold AND volatility below max:
  - perform buyback of size proportional to volume
- Else if volatility high:
  - pause buybacks, accumulate budget
- Else:
  - no-op

---

## Agent Policy Engine
The agent is intentionally **boring**: thresholds, pacing, caps.

### Policy evaluation
```python
def evaluate(state):
    if state.volume_1h > V1H and state.volatility < VOL_MAX and state.cooldown_ok:
        amt = clamp(state.treasury_balance * BUYBACK_PCT, MIN_BB, MAX_BB)
        return Buyback(amount=amt, route="amm")
    if state.volatility >= VOL_MAX:
        return NoOp(reason="volatility_guard")
    return NoOp(reason="conditions_not_met")
```

### Constraint layer (non-negotiable)
- **Treasury floor**: never spend below a configured minimum
- **Max per-epoch spend**: cap budget in any time window
- **Cooldown**: enforce spacing to prevent cascading buys
- **Slippage guard**: refuse routes that exceed slippage tolerance

### Auditability goals
- Every decision is reproducible given:
  - state snapshot
  - config file
  - policy version hash

---

## On-Chain Contracts
The contracts are designed as composable modules.

### Contracts overview
- `FlywheelTreasury.sol` — treasury accounting, budget epochs, floor
- `FlywheelExecutor.sol` — executes buybacks through approved routes
- `FlywheelDistributor.sol` — redistribution module (optional)
- `FlywheelToken.sol` — ERC20 w/ fee hooks (chain-dependent)
- `interfaces/` — clean boundaries
- `libraries/` — math + guards

### Event-driven transparency
Contracts emit events that the dashboard/agent listens to:
- `ObservationRecorded(...)`
- `PolicyDecision(...)`
- `BuybackExecuted(...)`
- `RedistributionExecuted(...)`

---

## Repository Layout
```text
assets/                     # put somai.png here
contracts/                  # solidity + tests
agent/                      # observation + policy + scheduler
dashboard/                  # optional dashboard (frontend scaffold)
docs/                       # specs + diagrams + threat model
.github/                    # workflows, templates
```

---

## Security & Safety
### Threat model (high level)
- MEV sandwiching buybacks
- oracle manipulation (if using oracles)
- treasury drain via reentrancy / approvals
- policy abuse (bad configs)

### Mitigations
- cooldown + max spend caps
- route allow-list
- minOut + slippage checks
- multi-sig / timelock for config changes (recommended)
- “kill switch” pause

See: `docs/THREAT_MODEL.md`

---

## FAQ
**Is this “real AI”?**  
It’s a deterministic agent with optional LLM narration. The “intelligence” is **automation + policy**.

**Does it guarantee profit?**  
No. It’s a market primitive. The loop enforces execution rules; markets decide outcomes.

---

## License
MIT. See `LICENSE`.
