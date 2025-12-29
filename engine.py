import yaml
from dataclasses import dataclass

@dataclass
class Decision:
    kind: str
    reason: str = ""
    amount: float = 0.0
    min_out: float = 0.0

class PolicyEngine:
    def __init__(self, config_path: str):
        with open(config_path, "r", encoding="utf-8") as f:
            self.cfg = yaml.safe_load(f)

    def evaluate(self, state: dict) -> Decision:
        p = self.cfg["policy"]

        # Safety first
        if state["cooldown_ok"] is False:
            return Decision(kind="noop", reason="cooldown")

        if state["volatility"] >= p["volatility_max"]:
            return Decision(kind="noop", reason="volatility_guard")

        if state["volume_1h"] >= p["volume_1h_min"]:
            # spend is proportional to volume but clamped
            amt = min(max(state["treasury"] * p["buyback_pct_of_treasury"], p["buyback_min"]), p["buyback_max"])
            return Decision(kind="buyback", amount=amt, min_out=amt*(1.0-p["slippage_bps"]/10000.0))

        return Decision(kind="noop", reason="conditions_not_met")
