#!/usr/bin/env zsh

# Prompt: instant Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Prompt config
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Plugin manager (zinit) bootstrap
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
# Load Powerlevel10k via zinit
zinit ice depth=1; zinit light romkatv/powerlevel10k
## Modal editing
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode

# Load completions early (required by some zinit helpers)
autoload -Uz compinit && compinit -C
zmodload zsh/complist

# Zinit snippets and plugins (deferred for faster startup)
## Git helpers
zinit ice lucid wait; zinit snippet OMZP::git
zinit ice lucid wait; zinit snippet OMZP::git-extras
zinit ice lucid wait; zinit light k4rthik/git-cal

## Linux / package helpers
zinit ice lucid wait; zinit snippet OMZP::sudo
zinit ice lucid wait; zinit snippet OMZP::archlinux
zinit ice lucid wait; zinit snippet OMZP::eza

## Common utilities
zinit ice lucid wait; zinit snippet OMZP::history
zinit ice lucid wait; zinit snippet OMZP::fancy-ctrl-z

# FZF and related (load with lucid+wait)
zinit ice lucid wait
zinit snippet OMZP::fzf
zinit snippet OMZP::zoxide
zinit snippet OMZP::mise

## Completion/UX plugins (deferred)
zinit ice lucid wait
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-completions

# zinit helpers
zinit cdreplay -q

# UI tweak
zle_highlight+=(paste:none)

# Completions: configs
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# History
HISTSIZE=5000
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
SAVEHIST="$HISTSIZE"
HISTDUP=erase
setopt sharehistory
setopt extended_history
setopt incappendhistory
setopt histreduceblanks
setopt histignorespace
setopt histignorealldups
setopt hist_find_no_dups
setopt hist_save_no_dups
setopt hist_verify

# Shell options
setopt interactive_comments
setopt noflowcontrol
setopt prompt_subst
setopt nolisttypes
setopt extendedglob
setopt nobeep
setopt notify
setopt longlistjobs
setopt multios


# Load custom 
[ -f "$HOME/.config/shell/functions.zsh" ] && source "$HOME/.config/shell/functions.zsh"
[ -f "$HOME/.config/shell/keybindings.zsh" ] && source "$HOME/.config/shell/keybindings.zsh"
[ -f "$HOME/.config/shell/aliasrc" ] && source "$HOME/.config/shell/aliasrc"
