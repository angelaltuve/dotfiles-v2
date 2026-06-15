bindkey -s '^o' '^uy\n'
bindkey '^ ' autosuggest-accept
bindkey ' ' magic-space

bindkey '^[[H' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

bindkey -M vicmd '^S' sudo-command-line
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' down-line-or-history

__bemenu() { BEMENU_BACKEND=curses bemenu-run; zle redisplay }
zle -N __bemenu
bindkey '\e ' __bemenu
