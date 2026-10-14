# Codespaces / dev container

Opening this repo in GitHub Codespaces (or VS Code "Reopen in Container") gives you:

- Python 3.12 with `pip`, `pytest`, Jupyter and the VS Code Python, Jupyter and Ruff extensions
- Node LTS and the Claude Code CLI + VS Code extension (needed for the *Configure Claude Code* project)
- Git hooks that run on every commit (via [pre-commit](https://pre-commit.com)):
  - **nbstripout** clears notebook outputs and execution counts, so a printed key or response never lands in git
  - blocks committing `.env` files, private keys and anything that looks like an Anthropic API key (`sk-ant-...`)
- nbstripout is also registered as a git filter, so notebook outputs are stripped even with `git commit --no-verify`

## Add your API key (do this once)

Your key is stored by GitHub, encrypted, and injected into the codespace as an environment variable. It is never written to the repo.

1. Go to **GitHub → Settings → Codespaces → Secrets** (<https://github.com/settings/codespaces>) and click **New secret**.
2. Name: `ANTHROPIC_API_KEY`. Value: your key from <https://console.anthropic.com/settings/keys>.
3. Under **Repository access**, select this fork (`cd15315-Claude-AI-Engineer-Harness-Engineering`).
4. Optional: add `CLAUDE_MODEL` the same way to override the default model.
5. If a codespace is already running, rebuild or restart it so it picks up the secret.

When you create a codespace, GitHub also offers to set these on the "Advanced options" page, because they are declared in `devcontainer.json`.

Check it worked from a terminal in the codespace:

```bash
python -c "import os; print('key set' if os.environ.get('ANTHROPIC_API_KEY') else 'key missing')"
```

### Not using Codespaces?

Copy `.env.example` to `.env` and fill it in. `.env` is git-ignored and the pre-commit hook refuses to commit it. Shells in the dev container load it automatically; elsewhere run `set -a; . .env; set +a`.

## Running the exercises

Each exercise is its own package. From the exercise folder:

```bash
cd "<project>/<exercise>/starter"
python -m venv .venv && source .venv/bin/activate
pip install -e ".[dev]"
pytest -q   # or the scoped verify command in the exercise README
```

## Running the hooks by hand

```bash
pre-commit run --all-files
```

If a commit is rejected because nbstripout changed a notebook, `git add` the notebook again and recommit.
