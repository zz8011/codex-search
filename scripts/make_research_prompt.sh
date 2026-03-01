#!/usr/bin/env bash
set -euo pipefail
TOPIC="${1:?usage: make_research_prompt.sh <topic> [out_dir] [slug]}"
OUT_DIR="${2:-reports}"
SLUG="${3:-research_$(date +%F_%H%M)}"
REPORT_PATH="${OUT_DIR}/${SLUG}.md"
EVIDENCE_PATH="${OUT_DIR}/${SLUG}.evidence.json"

cat <<PROMPT
Produce a web-backed research deliverable for topic: ${TOPIC}
Requirements:

1. Create report at ${REPORT_PATH}
2. Create evidence JSON at ${EVIDENCE_PATH}
3. Use >=12 sources and >=2 independent sources per key claim
4. Print:
FINAL_REPORT_READY
REPORT_PATH=${REPORT_PATH}
EVIDENCE_PATH=${EVIDENCE_PATH}
PROMPT
