# Keybindings separated for clarity
bindkey -s '^o' '^uy\n'
bindkey '^ ' autosuggest-accept
bindkey ' ' magic-space

# HOME/END keys
bindkey '^[[H' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# PageUp/PageDown and vi-mode bindings
bindkey -M vicmd '^S' sudo-command-line
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' down-line-or-history
