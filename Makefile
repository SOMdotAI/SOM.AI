.PHONY: contracts agent

contracts:
	cd contracts && npm i && npm run compile

agent:
	cd agent && python -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt && python run.py
