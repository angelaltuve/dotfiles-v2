#!/usr/bin/env zsh

# --- Default Apps ---
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="browser"
export OPENER="xdg-open"
export PAGER="less"
export MANPAGER="nvim +Man!"

# --- XDG Dirs ---
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"

# --- App Configs ---
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export INPUTRC="$XDG_CONFIG_HOME/shell/inputrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export MBSYNCRC="$XDG_CONFIG_HOME/mbsync/config"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/default/config"
export LYNX_CFG="$XDG_CONFIG_HOME/lynx/lynx.cfg"
export LYNX_LSS="$XDG_CONFIG_HOME/lynx/lynx.lss"
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export W3M_DIR="$XDG_CONFIG_HOME/w3m"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_DATA_DIR="$XDG_DATA_HOME/jupyter"

export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export KHARD_CONFIG="$XDG_CONFIG_HOME/khard/khard.conf"

export NVM_DIR="$XDG_DATA_HOME/nvm"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export UNISON="$XDG_DATA_HOME/unison"
export LEIN_HOME="$XDG_DATA_HOME/lein"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export XCOMPOSEFILE="$XDG_CONFIG_HOME/XCompose"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export OLLAMA_MODELS=$XDG_DATA_HOME/ollama/models
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export SQLITE_HISTORY=$XDG_STATE_HOME/sqlite_history

# Ensure essential Zsh directories exist
mkdir -p "$XDG_STATE_HOME/zsh"
mkdir -p "$XDG_CACHE_HOME/zsh"

export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30%"
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort"

# --- Bemenu --- 
export DMENU="bemenu"
export BEMENU_OPTS="-n -c -s -i \
  -W 0.3 -H 26 -B 2 -l 10 \
  -p '▲' -P '' --ch 16 --scrollbar always \
  --fn 'Berkeley Mono 11' \
  --nb '#1e1e2e' --nf '#cdd6f4' \
  --ab '#1e1e2e' --af '#cdd6f4' \
  --hb '#cba6f7' --hf '#1e1e2e' \
  --sb '#cba6f7' --sf '#1e1e2e' \
  --fb '#1e1e2e' --ff '#cba6f7' \
  --fbb '#1e1e2e' --fbf '#cba6f7' \
  --tb '#1e1e2e' --tf '#f38ba8' \
  --scb '#313244' --scf '#cba6f7' \
  --bdr '#cba6f7'"


# --- Qt ---
export QT_QPA_PLATFORMTHEME="gtk3"

# --- PATH ---
typeset -U path PATH
path=(
  "$XDG_DATA_HOME/mise/shims"
  "$HOME/.local/bin"
  "$HOME/.local/share/npm/bin"
  "$HOME/.local/share/cargo/bin"
  "$HOME/.local/share/go/bin"
  "$HOME/Applications"
  $path
)
export PATH
