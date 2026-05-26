#!/usr/bin/env zsh

# --- PATH ---
path+=(
  "$HOME/.local/share/npm/bin"
  "$HOME/Applications"
  "$HOME/.local/share/cargo/bin"
  "$HOME/.local/bin"
)

# --- Default Apps ---
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="browser"
export OPENER="xdg-open"
export PAGER="less"
export MANPAGER="nvim +Man!"

# --- XDG Dirs ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

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
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export UNISON="$XDG_DATA_HOME/unison"
export LEIN_HOME="$XDG_DATA_HOME/lein"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
export XCOMPOSEFILE="$XDG_CONFIG_HOME/XCompose"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export OLLAMA_MODELS=$XDG_DATA_HOME/ollama/models

# Ensure the XDG state directory for zsh history exists
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"

export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"

export NOTMUCH_PROFILE="01"

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30%"
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort"

# --- SSH (KeePassXC) ---
export SSH_AUTH_SOCK="/tmp/ssh-agent.sock"

# --- Qt ---
export QT_QPA_PLATFORMTHEME="gtk3"
