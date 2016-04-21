#allows use of modules  https://wiki.nvidia.com/engit/index.php/UnixSupport-Environment_Management:Modules
# time to complete.
#source /home/utils/modules-tcl/init/zsh
unalias which 2&> /dev/null #remove the which alias that is an nvidia alias
export EDITOR="nvim"

REDHAT_RELEASE=`cut -d ' ' -f 3 /etc/redhat-release`


#{{{ man pages shortcutes & settings
alias -- fmman='man -M ${FM_ROOT}/doc/fm/man'
alias -- synman='man -M $SYNOPSYS/doc/syn/man'
export MANPATH='/usr/local/lsf/man:/home/utils/man:/usr/man:/home/eash/man:/usr/share/man:/home/tools/synopsys/syn_2010.12-SP5/doc/syn/man:/home/tools/synopsys/pt_2009.06-SP3/doc/syn/man:/home/xl_98/tools.sun4/man/man1:/home/xl_98/tools.sun4/man/man5'
#}}}
alias perltidy='/home/utils/perl-5.16/5.16.2-nothreads-64/bin/perltidy'

alias pwd='pwd -P'

p4_filelog () { p4 filelog -l $* | more }
su () { /bin/su $*; tup }

rm_client ()
{
    /home/eash/scripts/unlock_client.pl --client $1
    p4 -c $1 revert -k //...
    p4 changes -c $1 -s pending | cut -d" " -f2 |xargs -n1 p4 -c $1 change -d
    p4 client -d $1 
}

#module load ruby
#module load tmux
#module load vim

path=(/home/utils/ruby-2.2.2/bin
/home/nv/utils/hwmeth/bin
/home/nv/utils/quasar/bin
/home/utils/Python-3.4.2/bin
/home/utils/xclip-0.11/bin
$path
)
# path_prepend /home/utils/Python-3.4.2/bin
# path_prepend  /home/utils/xclip-0.11/bin
#
# PATH="/home/utils/ruby-2.2.2/bin:$PATH";
# PATH="$HOME/usr/local/bin:$PATH"
# PATH+=':/home/nv/utils/hwmeth/bin:/home/nv/utils/quasar/bin'
# PATH='/home/utils/xdg-utils-1.0.2/bin
# path_prepend /home/utils/Python-3.4.2/bin
# path_prepend  /home/utils/xclip-0.11/bin
# path_remove /home/gnu/bin
# source ~/perl5/perlbrew/etc/bashrc

#{{{perlforce w/ crucible wrapper 
function p4() {
PERL5LIB=''
cmd=/home/nv/utils/crucible/1.0/bin/p4

if [[ $1 == "sync" ]]
then 
    shift argv # remove the sync  command
    cmd="$cmd -q sync"
    # if [[ $1 != "-k" ]]
    # then
    #     cmd="$cmd --parallel=threads=10"
    # fi
elif [[ $1 == "commit" ]]
then
    shift argv # remove the sync  command
    cmd="$cmd submit"
elif [[ $1 == "flush" ]]
then
    cmd="$cmd -q"
fi
#echo Executing: $cmd $@
$cmd $@
}
# alias -- p4='/home/nv/utils/crucible/1.0/bin/p4 -d `/bin/pwd`'
alias -- p4_diff='p4_xdiff -d'
alias -- p4_log='p4_filelog'
#}}}

export P4PORT='p4hw:2001'
export P4CONFIG='.p4config'
export P4DIFF='nvim -d'


export MCLIBDIR='/home/tools/synopsys/syn_2010.12-SP5/mc/tech'

# function vim ()
# {
#     nvim
#     # OLD_PERL=$PERLBREW_PERL 
#     # OLD_LIB=$PERLBREW_LIB
#     # perlbrew use 5.16.2-nothreads-64@vim  >&/dev/null
#     # /home/utils/vim-7.4/bin/vim $*
#     # perlbrew use $OLD_PERL  >& /dev/null
# }
#
#navigate nvidia tree {{{
d_tests(){ cd `depth_ea`/diag/tests}
testgen(){ cd `depth_ea`/diag/testgen}
tot() {cd `depth_ea`}
#}}}

unset SSH_ASKPASS
# compdef _gnu_generic automate_any.pl

#p4 completion
zstyle ':completion:*:p4-*:changes' changes -u $USER
zstyle ':completion:*:p4-add:*:all-files' all-files

alias dzil='PERL5LIB=`/home/eash/scripts/perlcustomlib` dzil'

alias hwmeth="cd ~/scratch/script_dev/dev/inf/hwmeth/mainline"
alias quasar="cd ~/scratch/script_dev/dev/inf/quasar/mainline"


#alias vim="vim -X" # no x connections

export SSL_CERT_FILE="$HOME/usr/local/etc/openssl/ca-cert.pem"
# vim: set fdm=marker:

# {{{Brew env 
export HOMEBREW_CACHE='/tmp/homebrew_eash'
# }}}
# export PYENV_ROOT=/home/eash/.linuxbrew/var/pyenv

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# source $HOME/scripts/hub-linux-386-2.2.1/etc/hub.zsh_completion

#flexclone eval alias
function make_flexclone()
{
    ssh build-test@fclone-test-svm "volume clone create -flexclone $1 -type RW -parent-volume build_master_test -junction-active true -foreground true -space-guarantee none -junction-path /vol/buildclone/$1"
}

function delete_flexclone
{
    ssh build-test@fclone-test-svm "volume unmount $1"
    ssh build-test@fclone-test-svm "volume offline $1"
    ssh build-test@fclone-test-svm "volume delete $1"
}
export PIP_CERT='/home/eash/DigiCertHighAssuranceEVRootCA.crt'
path_prepend /home/eash/scripts
LINUX_BREW_PATH=`/usr/bin/readlink -e $XDG_DATA_HOME/linuxbrew/$REDHAT_RELEASE/bin`
PATH="$LINUX_BREW_PATH:$PATH"
export PATH
# vim: set fdm=marker:
