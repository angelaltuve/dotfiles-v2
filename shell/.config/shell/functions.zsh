#!/usr/bin/env zsh
# ==============================================================================
# Shell Functions
# ==============================================================================

# === Yazi Helper ===
# Change directory to the one selected in yazi upon exit
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# === Zoxide Integration ===
# Custom cd wrapper using zoxide with interactive fallback
_zoxide_cd() {
  if (( $# == 0 )); then
    builtin cd
  elif [[ "$1" == "-" ]]; then
    builtin cd -
  elif [[ -d $1 ]]; then
    builtin cd "$1"
  else
    \z "$@"
  fi
}
compdef _cd _zoxide_cd

# === Open in Background ===
# Open file or URL with xdg-open in the background, suppressing output
_xdg_open_bg() {
  xdg-open "$@" &>/dev/null &
}

# === Jitsi Link Generator ===
# Generate a random Jitsi Meet URL, copy it to clipboard and print it
_jitsi_link() {
  local url
  url=$(printf "https://meet.jit.si/%s" "$(uuidgen)")
  printf "%s" "$url" | wl-copy
  printf "%s\n" "$url"
}

# === SCP with FZF ===
# Securely copy files modified within the last 2 weeks using fzf preview
_scp_fzf() {
  if (( $# == 0 )); then
    echo "Usage: sff <dest> (e.g. sff host:/tmp/)"; return 1
  fi
  local file
  file=$(fd . ~ --type f --changed-within 2w | fzf --preview 'bat --style=numbers --color=always {}')
  [[ -n $file ]] && scp "$file" "$1"
}

# === Edit Script ===
# Find and edit a custom user script from ~/.local/bin/ using fzf
_edit_script() {
  local c
  c=$(fd . "$HOME/.local/bin/" --type f --exact-depth 1 | fzf --height 40% --reverse) || return
  [[ -n $c ]] && ${EDITOR:-nvim} "$HOME/.local/bin/$c"
}

# === Video Conversion ===
# Convert a video to H.264 MP4 format with high-quality settings using ffmpeg
_convert_video() {
  if (( $# < 2 )); then
    echo "Usage: convi <input> <output>"; return 1
  fi
  ffmpeg -i "$1" -c:v libx264 -crf 25 -c:a aac -b:a 128k "$2"
}
