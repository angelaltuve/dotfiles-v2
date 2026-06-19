# editor
alias vim='nvim'
alias vimdiff='nvim -d'

[ -f "$MBSYNCRC" ] && alias mbsync='mbsync -c $MBSYNCRC'

for command in mount umount sv pacman updatedb su shutdown poweroff reboot; do
  alias $command="sudo $command"
done; unset command

# nav
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias cd='_zoxide_cd'
alias open='_xdg_open_bg'
alias jitsi-link='_jitsi_link'

# fzf
if [[ "$TERM" == "xterm-kitty" ]]; then
  alias ff="fzf --preview 'case \$(file --mime-type -b {}) in image/*) kitty icat --clear --transfer-mode=memory --stdin=no --place=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES}@0x0 {} ;; *) bat --style=numbers --color=always {} ;; esac'"
else
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
fi
alias eff='$EDITOR "$(ff)"'
alias preview='fzf --preview="bat {} --color=always"'
alias sff='_scp_fzf'
alias se='_edit_script'

# file
alias cp='cp -iv --reflink=auto'
alias mv='mv -iv'
alias rm='rm -Iv'
alias ln='ln -v'
alias rmdir='rmdir -v'
alias mkdir='mkdir -v'
alias shred='shred -zf'
alias dd='dd status=progress'
alias df='df -h'
alias free='free -h'
alias chmod='chmod -c'
alias chown='chown -c'
alias lsb='lsblk -o NAME,FSTYPE,SIZE,FSUSED,MOUNTPOINTS,UUID'
alias lsbc='lsblk | bat -l conf -p'
alias freec='free -h | bat -l cpuinfo -p'
alias sensors='sensors | bat -l cpuinfo -p'
alias rcp='rsync -v --progress'
alias rmv='rsync -v --progress --remove-source-files'
alias compress='tar -czf'
alias untar='tar -xvzf'
alias stow='stow -v'

# proc
alias psa='ps auxf'
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='psmem | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='pscpu | head -10'

# net
alias ip='ip -color=auto'
alias wget="wget -c --user-agent 'noleak'"
alias ping='ping -c 5'
alias ports='ss -tulanp'
alias my-ip="curl http://ipecho.net/plain; echo"
alias findme='curl https://am.i.mullvad.net/json'
alias tb='nc termbin.com 9999'
alias tbc='tb | wl-copy'

# media
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'
alias yt='yt-dlp --embed-metadata -i'
alias yta='yt -x -f bestaudio/best'
alias ytt='yt --skip-download --write-thumbnail'
alias yta-m4a='yt -x -f "ba[ext=m4a]"'
alias yta-flac='yt -x --audio-format flac'
alias yta-mp3='yt -x --audio-format mp3'
alias yta-aac='yt -x --audio-format aac'
alias yta-best='yt -x --audio-format best'
alias convi='_convert_video'

# display
alias diff='diff -Nuar --color=auto'
alias grep='grep --color=auto'

# sys
alias dl='sudo dmsetup ls'
alias cupsd='sudo cupsd -f'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias update-fc='sudo fc-cache -fv'
alias update-all='~/.local/bin/update-all'
alias gpgrestart='gpgconf --kill gpg-agent && gpg-agent --daemon'
alias reload='source ~/.zshenv'
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort -h | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort -h | tail -3000 | nl"

# jupyter
alias jda='cd /home/angel/Documents/jupyter_notebooks/EDA_Heart && poetry run jupyter-lab'
alias jda-colab='cd /home/angel/Documents/jupyter_notebooks/EDA_Heart && poetry run jupyter-lab --NotebookApp.allow_origin="https://colab.research.google.com" --NotebookApp.allow_credentials=True --port=8888 --NotebookApp.port_retries=0 --no-browser'

alias oc='firejail --profile=opencode --whitelist=$(pwd) opencode'
alias lg='lazygit'
alias bt='btop'
alias top='btop'
alias tm='tmux'
alias tma='tmux attach -t'
alias tml='tmux list-sessions'
alias tl='timew summary'
alias calc='qalc'
alias du='dust'
alias trash='trash-put'
alias tt='ttyper'

# suffix / global
alias -s json=bat
alias -s md=bat
alias -s txt=bat
alias -s log=bat
alias -s go='$EDITOR'
alias -s rs='$EDITOR'
alias -s py='$EDITOR'
alias -s js='$EDITOR'
alias -s ts='$EDITOR'
alias -s html=xdg-open
alias -g J='| jq'
alias -g C='| wl-copy'
