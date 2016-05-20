function shopt () {} #needed to be able to load up nvidia's .bash_profile
function setenv () {export $1=$2} # make setenv like tcsh
# source ~/.bash_profile
autoload -U compinit

compinit 
function path_remove {
setopt autopushd
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
export PERL_CPANM_HOME=$XDG_CACHE_HOME/cpanm #cpanm
export ELINKS_CONFDIR=$XDG_CONFIG_HOME/elinks #elinks





export HISTSIZE=1000
export SAVEHIST=1000
export MANPAGER=less
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt bang_hist # enable ! history expanstion
setopt extended_glob nomatch
#cd opts
setopt autocd
setopt auto_pushd



bindkey -v # vim bindings

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"


# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

GENCOMPL_FPATH=$HOME/.zsh/completion # zsh-competion-generator path

source ~/.zgen/zgen.zsh
#check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"
    # zgen oh-my-zsh
    zgen oh-my-zsh lib/git.zsh
    zgen oh-my-zsh lib/completion.zsh
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/cpanm
    zgen oh-my-zsh plugins/extract
    zgen oh-my-zsh plugins/vi-mode
    # zgen oh-my-zsh plugins/mosh
    zgen load RobSis/zsh-completion-generator
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-completions
    zgen load zsh-users/zsh-history-substring-search
    zgen load Tarrasch/zsh-autoenv

    # antigen theme gnzh
    #TODO make match non dev version
    zgen load $ZDOTDIR/gitster.zsh-theme

    zgen save
fi
# ZSH_CUSTOM=$HOME/.zsh/plugins/

fpath=( /home/eash/.zsh/completion/ $fpath )



# User configuration

path=($HOME/bin /usr/local/bin $PATH)
setopt prompt_subst

setopt shwordsplit

# source $HOME/.zsh/functions.zsh
source $ZDOTDIR/aliases.zsh

source $HOME/perl5/perlbrew/etc/bashrc >&/dev/null


precmd() {
    if [[ -n $TMUX ]]; then
        for name in `tmux ls -F '#{session_name}'`; do
            tmux setenv -g -t $name DISPLAY $DISPLAY #set display for all sessions
        done 
        export `tmux show-environment DISPLAY`;
    fi;
}

parts=(${(s:.:)HOST})
for i in {${#parts}..1}; do
    profile=${(j:.:)${parts[$i,${#parts}]}}
    file=$ZSH_CUSTOM/profiles/$profile
    if [ -f $file ]; then
        source $file
    fi
done



zstyle ':vcs_info:*' enable git
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
# LINUX_BREW_PATH=`/usr/bin/readlink -e $HOME/.linuxbrew/bin`
# export PATH="$LINUX_BREW_PATH:$PATH"
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
s=`hostname -d`
a=("${(s/./)s}")
export DOMAIN=$a[1];
if [ $DOMAIN = 'nvidia' ]; then
    echo "sourcing nvidia"
    source $ZDOTDIR/nvidia.zsh
    echo "end sourcing nvidia"
fi
if [ -e $HOME/.config/nvim/bundle/neoman.vim/scripts/neovim.zsh ]; then
    source $HOME/.config/nvim/bundle/neoman.vim/scripts/neovim.zsh
    alias man=nman
fi
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
unset P4CLIENT
eval "$(fasd --init auto)"
if [ -z "$TMUX" ]; then
    # Create a new session if it doesn't exist
    # tmux attach -d || tmux new
fi



