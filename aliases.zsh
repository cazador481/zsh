alias ls='ls --color=auto -h'
alias grep='grep --color=auto'
alias dir='ls -lA'
alias dc='cd'

alias -- vnc_setup='vncserver -geometry 5012x960 -randr 5012x980,3840x1080,1280x1024,1680x1050,1920x1200,1040x1050'
alias s_zsh='zgen reset;source $ZDOTDIR/.zshrc'

#open with
alias -s vh=$EDITOR
alias -s vs=$EDITOP 
alias -s log=$EDITOR
alias -s out=$EDITOR
alias -s pm=$EDITOR

#git aliases
alias root='cd $(git rev-parse --show-cdup || echo ".")'
alias -- tmux='tmux -2'
function nv_ccolab () {
    p4 shelve -rc $2 && ccollab --no-browser addchangelist $1 $2
}


alias c='clear'
alias td='todo.sh'
compdef td='todo.sh'
