autoload -U zargs

#exports DOMAIN
typeset -gU path
# s=`hostname -d`
s=`domainname| tr '[:upper:]' '[:lower:]'`
a=("${(s/./)s}")
export DOMAIN=$a[1];

path=($HOME/.linuxbrew/sbin $path)
path=($HOME/.linuxbrew/bin $path)
path=($HOME/scripts $path)

function shopt () {} #needed to be able to load up nvidia's .bash_profile
function setenv () {export $1=$2} # make setenv like tcsh
# source ~/.bash_profile
function path_remove {
cleanpath=$(echo $PATH |
tr ':' '\n' |
awk '{a[$0]++;if (a[$0]==1){b[max+1]=$0;max++}}END{for (x = 1; x <= max; x++) { print b[x] } }' |
grep -v $1 |
tr '\n' ':' |
sed -e 's/:$//')

export PATH=$cleanpath
}

function path_append ()  {
    path+=$1
}

function path_prepend {
    path=($1 $path)
}


#set XDG directories
export HISTFILE=$XDG_CACHE_HOME/zsh/histfile
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
mkdir -p $ZSH_CACHE_DIR # TODO  make conditional
export PERL_CPANM_HOME=$XDG_CACHE_HOME/cpanm #cpanm
export ELINKS_CONFDIR=$XDG_CONFIG_HOME/elinks #elinks


export HISTSIZE=1000
export SAVEHIST=1000
export P4EDITOR="nvr --remote-wait"
export MANPAGER="nvim -c 'set ft=man' -"

setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt bang_hist # enable ! history expansion
setopt extended_glob nomatch
#cd opts
setopt autocd
setopt auto_pushd
setopt autopushd

setopt NO_BEEP



bindkey -v # vim bindings

### Added by Zplugin's installer
typeset -A ZPLGM
ZPLGM[HOME_DIR]="$ZDOTDIR/zplugin"
ZPLGM[BIN_DIR]="$ZDOTDIR/zplugin/bin"
source '/home/eash/.config/zsh/zplugin/bin/zplugin.zsh'
autoload -Uz compinit
compinit
### End of Zplugin's installer chunk

#check if there's no init script
# if ! zgen saved; then
    # echo "Creating a zgen save"
    # zgen oh-my-zsh
    zplugin snippet 'http://github.com/robbyrussell/oh-my-zsh/raw/master/lib/git.zsh'
    # zgen oh-my-zsh lib/git.zsh
    zplugin snippet 'http://github.com/robbyrussell/oh-my-zsh/raw/master/lib/completion.zsh'

    # zgen oh-my-zsh lib/completion.zsh
    # zgen oh-my-zsh plugins/brew
    # zplugin load  robbyrussell/oh-my-zsh/plugins/brew
    # zgen oh-my-zsh plugins/git
    # zgen oh-my-zsh plugins/cpanm
    # zgen oh-my-zsh plugins/extract
    # zgen oh-my-zsh plugins/vi-mode
    zplugin snippet 'https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/plugins/vi-mode/vi-mode.plugin.zsh'
    # zgen oh-my-zsh plugins/mosh
    # zplugin load RobSis/zsh-completion-generator
    zplugin load zsh-users/zsh-syntax-highlighting
    zplugin light zsh-users/zsh-autosuggestions
    zplugin light zsh-users/zsh-completions
    zplugin load zsh-users/zsh-history-substring-search.git
    zplugin snippet ~/.linuxbrew/opt/fzf/shell/key-bindings.zsh
    zplugin snippet ~/.linuxbrew/opt/fzf/shell/completion.zsh

    zplugin snippet $HOME/.pyenv/completions/pyenv.zsh
    # zplugin load Tarrasch/zsh-autoenv
    if [ $DOMAIN = 'nvidia' ]; then
        zplugin load _local/nvidia
        echo "end sourcing nvidia"
    fi
    zplugin snippet "OMZ::plugins/fasd/fasd.plugin.zsh"

    # antigen theme gnzh
    #TODO make match non dev version
    # zgen load $ZDOTDIR/gitster.zsh-theme
   zplugin snippet  $HOME/perl5/perlbrew/etc/bashrc 

    # zgen save
# fi
# ZSH_CUSTOM=$HOME/.zsh/plugins/

#fpath=( /home/eash/.zsh/completion/ $fpath )


zplugin cdreplay 

# run the following command to add new completions
# zplugin creinstall %HOME/.zsh/completion


# User configuration

# path=($HOME/bin /usr/local/bin $PATH)
path=($HOME/bin /usr/local/bin $path)
# export PATH=$path
setopt prompt_subst

export PROMPT='$(print_prompt.pl)%%'
setopt shwordsplit

# source $HOME/.zsh/functions.zsh
source $ZDOTDIR/aliases.zsh


precmd() {
    if [[ -n $TMUX ]]; then
        eval `tmux showenv -s`
        # if dummy=$(tmux show-environment DISPLAY 2>/dev/null|grep '-') ; then
        #     unset DISPLAY
        # else
        #     export `tmux show-environment DISPLAY`;
        #
        #     for name in `tmux ls -F '#{session_name}'`; do
        #         tmux setenv -g -t $name DISPLAY $DISPLAY #set display for all sessions
        #     done 
        # fi
        #
        # eval `tmux showenv -s SSH_CLIENT 2>/dev/null`
        # for name in `tmux ls -F '#{session_name}'`; do
        #         tmux setenv -g -t $name SSH_CLIENT "$SSH_CLIENT" #set display for all sessions
        # done
        #
        # eval `tmux showenv -s SSH_CONNECTION 2>/dev/null`
        # for name in `tmux ls -F '#{session_name}'`; do
        #         tmux setenv -g -t $name SSH_CONNECTION "$SSH_CONNECTION"
        # done
    fi;
}

if [[ -n $TMUX ]]; then
export NVIM_LISTEN_ADDRESS=/tmp/nvim_eash_`tmux display -p "#{window_id}"`

fi;

#zstyle ':vcs_info:*' enable git
zstyle 'completion:*' use-cache on
zstyle 'completion:*' cache-path $ZSH_CACHE_DIR
# RPROMPT='${vcs_info_msg_0_}%# '
#
# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind UP and DOWN arrow keys (compatibility fallback
# for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#
# # bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
#
# # bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


unsetopt xtrace
unset P4CLIENT

#help
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-svn
autoload -Uz run-help-svk
unalias run-help 2>/dev/null
alias help=run-help


# export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_COMMAND='fd --type file'

#{{{ pyenv

path=($HOME/.pyenv/shims $HOME/.local/bin $path)
export PYENV_SHELL=zsh
command pyenv rehash 2>/dev/null
pyenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")";;
  *)
    command pyenv "$command" "$@";;
  esac
}
#}}}


#{{{ cursor change
zle-keymap-select () {
    if [ "$TERM" = "xterm-256color" ]; then
        if [ $KEYMAP = vicmd ]; then
            # the command mode for vi
            echo -ne "\e[2 q"
        else
            # the insert mode for vi
            echo -ne "\e[5 q"
        fi
    fi
}
#}}}
export KEYTIMEOUT=1 # reduces latency when presing esc
