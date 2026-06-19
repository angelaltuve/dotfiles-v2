#!/usr/bin/env zsh

# Instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
[[ ! -f ~/.config/zsh/zvm.zsh ]] || source ~/.config/zsh/zvm.zsh

# Zinit bootstrap
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode

# Plugins that should load early
zinit light zsh-users/zsh-completions

# Completions initialization (Done ONCE)
fpath+=("$XDG_DATA_HOME/zsh/completions")
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION
zmodload zsh/complist

# Load snippets asynchronously
zinit wait lucid for \
  OMZP::git \
  OMZP::git-extras \
  k4rthik/git-cal \
  OMZP::sudo \
  OMZP::archlinux \
  OMZP::eza \
  OMZP::gpg-agent \
  OMZP::history \
  OMZP::fancy-ctrl-z \
  OMZP::fzf \
  OMZP::zoxide \
  OMZP::mise

# Core functionality plugins (Order is important)
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

zinit cdreplay -q

zle_highlight+=(paste:none)

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

HISTSIZE=5000
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

setopt interactive_comments
setopt noflowcontrol
setopt prompt_subst
setopt nolisttypes
setopt extendedglob
setopt nobeep
setopt notify
setopt longlistjobs
setopt multios

[ -f "$HOME/.config/shell/functions.zsh" ] && source "$HOME/.config/shell/functions.zsh"
[ -f "$HOME/.config/shell/keybindings.zsh" ] && source "$HOME/.config/shell/keybindings.zsh"
[ -f "$HOME/.config/shell/alias.zsh" ] && source "$HOME/.config/shell/alias.zsh"

[ -n "$KITTY_INSTALLATION_DIR" ] && source "$KITTY_INSTALLATION_DIR/shell-integration/zsh/kitty.zsh"
