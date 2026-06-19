y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

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

_xdg_open_bg() {
  xdg-open "$@" &>/dev/null &
}

_jitsi_link() {
  local url
  url=$(printf "https://meet.jit.si/%s" "$(uuidgen)")
  printf "%s" "$url" | wl-copy
  printf "%s\n" "$url"
}

_scp_fzf() {
  if (( $# == 0 )); then
    echo "Usage: sff <dest> (e.g. sff host:/tmp/)"; return 1
  fi
  local file
  file=$(fd . ~ --type f --changed-within 2w | fzf --preview 'bat --style=numbers --color=always {}')
  [[ -n $file ]] && scp "$file" "$1"
}

_edit_script() {
  local c
  c=$(fd . "$HOME/.local/bin/" --type f --exact-depth 1 | fzf --height 40% --reverse) || return
  [[ -n $c ]] && ${EDITOR:-nvim} "$HOME/.local/bin/$c"
}

_convert_video() {
  if (( $# < 2 )); then
    echo "Usage: convi <input> <output>"; return 1
  fi
  ffmpeg -i "$1" -c:v libx264 -crf 25 -c:a aac -b:a 128k "$2"
}

ssh() {
  if [[ $# -eq 1 ]]; then
    local conn="$1"
    local host="${conn#*@}"
    if rg -q -U "^#.*Features:.*mosh.*\nHost ${host}" "$HOME/.ssh/config" 2>/dev/null; then
      echo "connecting with mosh ..."
      command mosh "$conn"
    else
      echo "connecting with ssh ..."
      command ssh "$conn"
    fi
  else
    command ssh "$@"
  fi
}

gpush() {
  local branch
  branch=$(git symbolic-ref --quiet HEAD 2>/dev/null | sed 's|refs/heads/||')
  [[ -z "$branch" ]] && echo "Not a git repo" && return 1
  git remote | xargs -I R git push R "$branch"
}

ghcoi() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: ghcoi <issue-number>"
    return 1
  fi
  local title
  title=$(gh issue view "$1" --json title 2>/dev/null | jq -r '.title' \
    | iconv -t ascii//TRANSLIT 2>/dev/null \
    | sed -E 's/[^a-zA-Z0-9]+/-/g' \
    | sed -E 's/^-+|-+$//g' \
    | tr '[:upper:]' '[:lower:]')
  [[ -z "$title" ]] && echo "Failed to get issue title" && return 1
  git checkout -b "$1-$title"
}

gtd() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: gtd <tag-name>"
    return 1
  fi
  git tag -d "$1"
  git remote | while read -r remote; do
    git push --delete "$remote" "$1" 2>/dev/null
  done
}

git-find-modified-repos() {
  find . -type d -name '.git' | while read -r dir; do
    repo=$(dirname "$dir")
    repostatus=$(git -C "$repo" status -s)
    [[ -n "$repostatus" ]] && echo "$repo"
  done
}

video-to-gif() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: video-to-gif <input> <output> [fps=10]"
    return 1
  fi
  local fps="${3:-10}"
  ffmpeg -i "$1" \
    -filter_complex "[0:v]setpts=0.5*PTS,fps=$fps,scale=800:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 "$2"
}

ytrip() {
  yt-dlp -f bestaudio --extract-audio --audio-format mp3 \
    --audio-quality 0 --yes-playlist --add-metadata "$1"
}

listen() {
  local url="${1:?Usage: listen <url>}"
  [[ "$1" = "to" ]] && url="$2"
  mpv --quiet --no-video "$url"
}

encrypt() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: encrypt <filename>"
    return 1
  fi
  if [[ "$1" =~ \.age$ ]]; then
    echo "Already an age file"
    return 1
  fi
  cat "$1" | age -r "$(pass show age/key 2>/dev/null)" -o "$1.age"
}

decrypt() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: decrypt <filename.age>"
    return 1
  fi
  if [[ ! "$1" =~ \.age$ ]]; then
    echo "Not an age file"
    return 1
  fi
  local tmpfile=$(mktemp)
  {
    pass show age/identity > "$tmpfile" 2>/dev/null
    age -d -i "$tmpfile" "$1" > "${1%.age}"
  } always {
    rm -f "$tmpfile"
  }
}

update-tools() {
  echo "Updating Rust tools ..."
  cargo install-update -a -g 2>/dev/null || cargo install cargo-update && cargo install-update -a -g
  echo "Updating Go tools ..."
  [[ -d "$GOPATH/bin" ]] && ls -1 "$GOPATH/bin" | while read -r bin; do
    go version -m "$GOPATH/bin/$bin" 2>/dev/null \
      | grep '^[[:space:]]path' | awk '{print $2}' \
      | grep '^github.com' | sort -u \
      | xargs -I{} go install {}@latest
  done
  echo "Updating gh extensions ..."
  gh extension upgrade --all 2>/dev/null
  echo "Updating tldr ..."
  tldr --update 2>/dev/null
  echo "Done"
}

encode64() {
  if [[ $# -eq 0 ]]; then
    cat | base64
  else
    printf '%s' "$1" | base64
  fi
}

decode64() {
  if [[ $# -eq 0 ]]; then
    cat | base64 --decode
  else
    printf '%s' "$1" | base64 --decode
  fi
}

encodefile64() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: encodefile64 <filename>"
  else
    base64 "$1" > "$1".txt
    echo "Saved as $1.txt"
  fi
}
