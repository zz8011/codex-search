#!/usr/bin/env bash
set -euo pipefail

if ! command -v npm >/dev/null 2>&1; then
if [ -x "$HOME/.nvm/versions/node/v24.13.1/bin/npm" ]; then
export PATH="$HOME/.nvm/versions/node/v24.13.1/bin:$PATH"
fi
fi
command -v npm >/dev/null 2>&1 || { echo "npm not found" >&2; exit 127; }

mkdir -p "$HOME/.openclaw/extensions/acpx"
cd "$HOME/.openclaw/extensions/acpx"
[ -f package.json ] || npm init -y >/dev/null
npm install --omit=dev --save-exact acpx@0.1.13

mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/codex-search" <<'WRAPPER'
#!/usr/bin/env bash
set -euo pipefail

MODE="auto"
if [ "${1:-}" = "--mode" ]; then
MODE="${2:-auto}"
shift 2
fi

PROMPT="${1:?usage: codex-search [--mode auto|fast|balanced|deep] "<prompt>" [cwd]}"
CWD="${2:-$PWD}"

pick_acpx() {
if [ -x "$HOME/.openclaw/extensions/acpx/node_modules/.bin/acpx" ]; then
echo "$HOME/.openclaw/extensions/acpx/node_modules/.bin/acpx"
elif command -v acpx >/dev/null 2>&1; then
command -v acpx
else
echo ""
fi
}
ACPX_CMD="$(pick_acpx)"

run_exec() {
if [ -n "$ACPX_CMD" ]; then
"$ACPX_CMD" codex exec "$PROMPT"
else
npx -y acpx codex exec "$PROMPT"
fi
}
supports_session() { [ -n "$ACPX_CMD" ] && "$ACPX_CMD" codex --help 2>/dev/null | grep -q -- "-s"; }

if [ "$MODE" = "auto" ]; then
if echo "$PROMPT" | grep -Eqi 'FINAL_REPORT_READY|深度|交叉验证|evidence|json|报告'; then
MODE="deep"
elif echo "$PROMPT" | grep -Eqi '搜索|查一下|查找|search|source|来源|链接'; then
MODE="fast"
else
MODE="balanced"
fi
fi

cd "$CWD"

case "$MODE" in
fast)
run_exec
;;
balanced)
if supports_session; then
SESSION="oc-codex-once-$(date +%s)-$RANDOM"
"$ACPX_CMD" codex sessions new --name "$SESSION" >/dev/null 2>&1  true
"$ACPX_CMD" codex -s "$SESSION" "$PROMPT"
"$ACPX_CMD" codex sessions close "$SESSION" >/dev/null 2>&1  true
else
run_exec
fi
;;
deep)
if supports_session; then
SESSION="${CODEX_SESSION_NAME:-oc-codex-deep-main}"
"$ACPX_CMD" codex sessions show "$SESSION" >/dev/null 2>&1  
"$ACPX_CMD" codex sessions new --name "$SESSION" >/dev/null 2>&1  true
"$ACPX_CMD" codex -s "$SESSION" "$PROMPT"
else
run_exec
fi
;;
*)
echo "invalid mode: $MODE" >&2
exit 2
;;
esac
WRAPPER

chmod +x "$HOME/.local/bin/codex-search"
echo "installed: $HOME/.local/bin/codex-search"
