#allows use of modules  https://wiki.nvidia.com/engit/index.php/UnixSupport-Environment_Management:Modules
# time to complete.
# source /home/utils/modules-tcl/init/zsh
#source /home/utils/modules-3.2.6/Modules/3.2.6/init/zsh
unalias which 2&> /dev/null #remove the which alias that is an nvidia alias
export EDITOR="nvim"
unset LESS

#disable time reserved word
disable -r time
REDHAT_RELEASE=`cut -d ' ' -f 3 /etc/redhat-release`


#{{{ man pages shortcutes & settings
alias -- fmman='man -M ${FM_ROOT}/doc/fm/man'
alias -- synman='man -M $SYNOPSYS/doc/syn/man'
export MANPATH='/usr/local/lsf/man:/home/utils/man:/usr/man:/home/eash/man:/usr/share/man:/home/tools/synopsys/syn_2010.12-SP5/doc/syn/man:/home/tools/synopsys/pt_2009.06-SP3/doc/syn/man:/home/xl_98/tools.sun4/man/man1:/home/xl_98/tools.sun4/man/man5'
#}}}

alias pwd='pwd -P'

p4_filelog () { p4 filelog -l $* | more }
su () { /bin/su $*; tup }


export PERLBREW_ROOT=/home/utils/perl5/perlbrew

rm_client ()
{
    /home/eash/scripts/unlock_client.pl --client $1
    p4 -c $1 revert -k //...
    p4 changes -c $1 -s pending | cut -d" " -f2 |xargs -n1 p4 -c $1 change -d
    p4 client -d $1 
}

path=(
.
/home/utils/make-4.2.1/bin/
/usr/local/lsf/bin
/home/utils/tmux-2.8/bin
/home/nv/bin
/home/nv/utils/crucible/1.0/bin
/home/utils/ruby-2.2.2/bin
/home/nv/utils/hwmeth/bin
/home/nv/utils/quasar/bin
/home/utils/Python-3.4.2/bin
/home/utils/gawk-4.1.0/bin
/home/utils/bin/
/home/autosubmit/bin
$path
/home/utils/the_silver_searcher-0.32.0/bin
)

export LSF_SERVERDIR=/usr/local/lsf/etc


#{{{perlforce w/ crucible wrapper 
function p4() {
PERL5LIB=''
cmd=/home/nv/utils/crucible/1.0/bin/p4

if [[ $1 == "sync" ]]
then 
    shift argv # remove the sync  command
    cmd="$cmd -q sync "
    # if [[ $1 != "-k" ]]
    # then
    #     cmd="$cmd --parallel=threads=10"
    # fi
elif [[ $1 == "reconcile" || $1 == 'status' || $1 == 'clean' ]]
then
    cmd="$cmd $1 -I"
    if [[ -d $2  ]]
    then
        fd --hidden '' $2 | xargs $cmd
        return
    elif  [[ -f $2 ]]
    then
        $cmd $2
        return
    elif [[ $2 ]]
    then
        fd --hidden "^$2\$" | xargs $cmd
        return
    else
        p4root=`p4_root`
        fd --hidden `$p4root` | xargs $cmd 
        return
    fi
    return
elif [[ $1 == "restore" ]]
then
    cmd="p4 unshelve -s $2 -c $2"
    $cmd
    return
elif [[ $1 == "commit" ]]
then
    shift argv # remove the sync  command
    cmd="$cmd submit"
elif [[ $1 == "ss" ]] # submit shelve
then
    p4 shelve -d -c $2 && p4 submit -c $2
    return
elif [[ $1 == "ds" ]] #deletes shelve and changelist
then
    p4 shelve -d -c $2 && p4 changelist -d $2 
    return
elif [[ $1 == "move" ]]
then 
    p4 integrate $2 $3 && p4 delete $2;
    return
elif [[ $1 == "flush" ]] then
    shift argv
    cmd="$cmd -q"
elif [[ $1 == "shelved" ]] then
    cmd="$cmd changes -u $USER -s shelved"
fi

echo Executing: $cmd "$@"
command $cmd "$@"
}

#}}}
export P4PORT='p4hw:2001'
export P4CONFIG='.p4config'
export P4DIFF='nvim -d'
export P4IGNORE='.p4ignore'
export P4EDITOR="nvr --remote-wait -s +'set bufhidden=delete'"


export MCLIBDIR='/home/tools/synopsys/syn_2010.12-SP5/mc/tech'


#navigate nvidia tree {{{
d_tests(){ cd `depth_ea`/diag/tests}
testgen(){ cd `depth_ea`/diag/testgen}
tot() {cd `depth_ea`}
#}}}

unset SSH_ASKPASS
# compdef _gnu_generic automate_any.pl

#p4 completion #{{{
zstyle ':vcs_info:*' enable git git-p4 p4
zstyle ':vcs_info:p4*:*' use-server 1;
zstyle ':completion:*:p4-*:changes' changes -u $USER
zstyle ':completion:*:p4-add:*:all-files' all-files
#}}}

alias dzil='PERL5LIB=`/home/eash/scripts/perlcustomlib` dzil'

alias hwmeth="cd ~/scratch/script_dev/dev/inf/hwmeth/mainline"
alias quasar="cd ~/scratch/script_dev/dev/inf/quasar/mainline"

# {{{Brew env 
export HOMEBREW_CACHE='/tmp/homebrew_eash'
# }}}
# export PYENV_ROOT=/home/eash/.linuxbrew/var/pyenv

#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

#flexclone eval alias #{{{
function make_flexclone() #{{{
{
    ssh build-test@fclone-test-svm "volume clone create -flexclone $1 -type RW -parent-volume build_master_test -junction-active true -foreground true -space-guarantee none -junction-path /vol/buildclone/$1"
} #}}}

function delete_flexclone #{{{
{
    ssh build-test@fclone-test-svm "volume unmount $1"
    ssh build-test@fclone-test-svm "volume offline $1"
    ssh build-test@fclone-test-svm "volume delete $1"
} #}}}
#}}}

export PIP_CERT='/home/eash/DigiCertHighAssuranceEVRootCA.crt'
export SSL_CERT_FILE=$HOME/cacert.pem
#path=($HOME/scripts $PATH)
LINUX_BREW_PATH=$HOME/.linuxbrew
# LINUX_BREW_PATH=`/usr/bin/readlink -e $XDG_DATA_HOME/linuxbrew/$REDHAT_RELEASE/`
# path=($LINUX_BREW_PATH/bin $path)
export MANPATH="$LINUX_BREW_PATH/bin:$MANPATH"
function brew ()
{
    PATH=$LINUX_BREW_PATH/bin:/bin:/usr/bin $LINUX_BREW_PATH/bin/brew $*
    # PATH=/home/eash/scratch/.linuxbrew/bin:$PATH /home/eash/scratch/.linuxbrew/bin/brew $*
}
export PATH
#
#vim: set fdm=marker:

