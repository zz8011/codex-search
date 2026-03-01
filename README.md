# codex-search

A small Codex CLI wrapper for search and research tasks with four execution modes:

- `auto`: route by prompt keywords
- `fast`: one-shot run (no context carry-over)
- `balanced`: temporary session per task
- `deep`: persistent session for long-running work

## Files

- `SKILL.md`: skill description and quick usage
- `scripts/install_codex_search.sh`: installs `acpx` and creates `~/.local/bin/codex-search`
- `scripts/make_research_prompt.sh`: generates a standardized research prompt
- `references/research-report-template.md`: report template
- `references/evidence-template.json`: evidence template

## Install

```bash
bash scripts/install_codex_search.sh
```

After install, make sure `~/.local/bin` is in your `PATH`.

## Usage

```bash
codex-search "Search topic and provide sources" "$PWD"
codex-search --mode fast "Search: topic with links" "$PWD"
codex-search --mode deep "Deep task ... FINAL_REPORT_READY" "$PWD"
```

## Prompt Generator

```bash
bash scripts/make_research_prompt.sh "LLM coding agent benchmarks"
```

Example output fields:

- `FINAL_REPORT_READY`
- `REPORT_PATH=...`
- `EVIDENCE_PATH=...`
