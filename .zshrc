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


export HISTSIZE=100000
export SAVEHIST=100000
# export P4EDITOR="nvr --remote-wait"
if (($+commands[direnv])); then
    export MANPAGER="nvim -c 'set ft=man' -"
fi

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
source "$HOME/.config/zsh/zplugin/bin/zplugin.zsh"
autoload -Uz compinit
compinit

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
# zplugin light zdarma/fast-syntax-highlighting
zplugin light zsh-users/zsh-autosuggestions
# zplugin light zsh-users/zsh-completions
zplugin light zsh-users/zsh-history-substring-search

# FZF
zinit ice lucid wait'0b' from"gh-r" as"program"
zinit light junegunn/fzf-bin
# FZF BYNARY AND TMUX HELPER SCRIPT
zinit ice lucid wait'0c' as"command" pick"bin/fzf-tmux"
zinit light junegunn/fzf
# BIND MULTIPLE WIDGETS USING FZF
zinit ice lucid wait'0c' multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
zinit light junegunn/fzf
# FZF-TAB
zinit ice wait"1" lucid
zinit light Aloxaf/fzf-tab

# BAT
zinit ice from"gh-r" as"program" mv"bat* -> bat" pick"bat/bat" atload"alias cat=bat"
zinit light sharkdp/bat
# RIPGREP
zinit ice from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
zinit light BurntSushi/ripgrep
# NEOVIM
zinit ice from"gh-r" as"program" bpick"*appimage*" mv"nvim* -> nvim" pick"nvim"
zinit light neovim/neovim
# FD
zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

if [[ -e ~/.pyenv ]]; then
    zplugin snippet $HOME/.pyenv/completions/pyenv.zsh
fi
# zplugin load Tarrasch/zsh-autoenv
if [ $DOMAIN = 'nvidia' ]; then
    zplugin load _local/nvidia
    echo "end sourcing nvidia"
fi
if (($+commands[fasd])); then
    zplugin snippet "OMZ::plugins/fasd/fasd.plugin.zsh"
fi

# antigen theme gnzh
#TODO make match non dev version
# zplugin snippet  $HOME/perl5/perlbrew/etc/bashrc 
zplugin ice depth=1; zplugin light romkatv/powerlevel10k

#fpath=( /home/eash/.zsh/completion/ $fpath )



# turbo mode
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestionsid for \
 blockf \
    zsh-users/zsh-completions
# run the following command to add new completions
# zplugin creinstall %HOME/.zsh/completion

zplugin cdreplay 

# User configuration

# path=($HOME/bin /usr/local/bin $PATH)
path=($HOME/bin /usr/local/bin $path)
setopt prompt_subst

export PROMPT='$(print_prompt.pl)%%'
setopt shwordsplit

source $ZDOTDIR/aliases.zsh


precmd() {
    if [[ -n $TMUX ]]; then
        eval `tmux showenv -s`
        unset SSH_ASKPASS
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


if (($+commands[fd])); then
# export FZF_DEFAULT_COMMAND='ag -g ""'
    export FZF_DEFAULT_COMMAND='fd --type file'
fi

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

#{{{ poetry
path=($HOME/.poetry/bin $path)
#}}}

#To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
