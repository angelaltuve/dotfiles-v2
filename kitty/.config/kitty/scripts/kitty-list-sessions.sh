#!/usr/bin/env bash
set -euo pipefail

kitty @ ls 2>/dev/null | jq -r '
  .[]?.tabs[]?.windows[]?
  | select(.session_name != null and .session_name != "")
  | .session_name
' | sort -u | fzf --prompt="Switch to session > " --height=40% | while read -r name; do
  kitty @ goto_session "$name"
done
