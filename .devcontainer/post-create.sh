#!/usr/bin/env bash
# Runs once when the codespace / dev container is created.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

python -m pip install --upgrade pip
python -m pip install pre-commit nbstripout jupyterlab ipykernel python-dotenv

# Commit-time safety net: strip notebook outputs and block obvious secrets.
pre-commit install --install-hooks

# Belt and braces: also register nbstripout as a git filter, so notebook
# outputs never reach a commit even if someone runs `git commit --no-verify`.
nbstripout --install

# Load a local .env (git-ignored) into every new shell, for anyone not using
# Codespaces secrets. Codespaces secrets are already in the environment.
WORKSPACE="$(pwd)"
if ! grep -q "harness-engineering .env loader" ~/.bashrc 2>/dev/null; then
  cat >> ~/.bashrc <<RC

# harness-engineering .env loader
if [ -f "$WORKSPACE/.env" ]; then set -a; . "$WORKSPACE/.env"; set +a; fi
RC
fi

if [ -z "${ANTHROPIC_API_KEY:-}" ] && [ ! -f .env ]; then
  echo
  echo "NOTE: ANTHROPIC_API_KEY is not set. Add it as a Codespaces secret"
  echo "      (see .devcontainer/README.md) or copy .env.example to .env."
fi
