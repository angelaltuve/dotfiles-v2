#!/usr/bin/env bash
set -euo pipefail

# Usa zoxide para seleccionar un directorio y abre una sesión de Kitty ahí
dir=$(zoxide query -l | fzf --prompt="Zoxide session > " --height=40%)
if [[ -n "$dir" ]]; then
  name=$(basename "$dir")
  kitty @ launch --type=tab --tab-title="$name" --cwd="$dir"
fi
