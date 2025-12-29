import argparse
from policy.engine import PolicyEngine
from observation.market import MarketObserver

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", default="configs/devnet.yml")
    args = ap.parse_args()

    obs = MarketObserver(args.config)
    policy = PolicyEngine(args.config)

    state = obs.snapshot()
    decision = policy.evaluate(state)

    print("STATE:", state)
    print("DECISION:", decision)

if __name__ == "__main__":
    main()
