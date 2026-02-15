#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CANDIDATE_PATHS=(
  "${SCRIPT_DIR}/.secrets/github-pat"
  "${HOME}/.codex/.secrets/github-pat"
  "${HOME}/.config/home-manager/codex/.secrets/github-pat"
)

TOKEN_PATH=""
for candidate in "${CANDIDATE_PATHS[@]}"; do
  if [[ -f "${candidate}" ]]; then
    TOKEN_PATH="${candidate}"
    break
  fi
done

if [[ -z "${TOKEN_PATH}" ]]; then
  echo "GitHub PAT not found in any known location" >&2
  printf 'Checked:\n' >&2
  printf '  %s\n' "${CANDIDATE_PATHS[@]}" >&2
  exit 1
fi

TOKEN="$(<"${TOKEN_PATH}")"

exec mcp-proxy --transport streamablehttp \
  -H Authorization "Bearer ${TOKEN}" \
  https://api.githubcopilot.com/mcp/
