alias ls='ls --color=auto -h'
alias grep='grep --color=auto'
alias dir='ls -lA'
alias dirs="dirs -v"
alias dc='cd'

alias -- vnc_setup='vncserver -geometry 5012x960 -randr 5012x980,3840x1080,1280x1024,1680x1050,1920x1200,1040x1050'
alias s_zsh='zgen reset;source $ZDOTDIR/.zshrc'

alias re_alias='source $ZDOTDIR/aliases.zsh'

#open with
alias -s vh=$EDITOR
alias -s vs=$EDITOP 
alias -s log=$EDITOR
alias -s out=$EDITOR
alias -s pm=$EDITOR

#git aliases
alias root='cd `~/scripts/get_root.pl`'
alias -- tmux='tmux -2'
function nv_ccolab () {
    p4 shelve -rc $2 && ccollab --no-browser addchangelist $1 $2
}


alias c='clear'
alias td='todo.sh'

alias p4diff='p4 diff -f `p4 status -m |cut -d" " -f1 |fzf'
compdef td='todo.sh'


alias master="git checkout master"

function psgrep (){
    ps -U $USER -u $USER|grep $1
}

alias deny='/home/nv/utils/restrict_task/latest/bin/restrict_task.pl -nodispatch -deny nvgpu_restrict_standsim' 
alias approve='/home/nv/utils/restrict_task/latest/bin/restrict_task.pl -nodispatch -approve nvgpu_restrict_standsim' 
alias restrict_report='/home/nv/utils/quasar/bin/stand_sim_restrict_report.pl'

#{{{ Perl aliases
alias carp='PERL5OPT="-MCarp::Always"'

# }}}
#NVIDIA ALIASES
#{{{  restrict aliases
function mk_restrict () {
    make totutil -- restrict --diff $1 && approve $1 
}
function t_restrict () {
    totutil restrict --diff -a $1
}
function t_restrict_no_diff () {
    totutil restrict -a $1 
}
alias run_restrict='zargs -r --verbose -n1 --max-procs 4 -- `restrict_report --csv |tail -n +2 |cut -f1 -d,` -- t_restrict_no_diff'

#}}}

#{{{clones 
alias axclone="/home/nv/utils/axclone/RELEASE/bin/axclone.pl"
# delete clones
alias del_clones="axclone -list |grep eash |cut -f3 -d' ' |grep eash| xargs --max-procs=4 -t -n1 -r /home/nv/utils/axclone/RELEASE/bin/axclone.pl -delete -clone"
# alias del_clones='zargs --verbose -n1 -- `axclone -list |grep eash |cut -f3 -d" "` -- /home/nv/utils/axclone/RELEASE/bin/axclone.pl -delete -clone'

#}}}
alias cucumber='/home/utils/ruby-1.9.3-p448-yaml/bin/cucumber'
alias crystal=/home/nv/utils/crystal_cli/current/bin/crystal
alias cat='bat'
function nvr () {
    if [[ $TMUX ]] 
    then
        local pane_id=$(tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep nvim|cut -f1 -d' '|head -n1)
        if [[ $pane_id ]]
        then
            tmux select-pane -t $pane_id
        fi
    fi

  /home/eash/.local/bin/nvr -s $@
}
alias e='nvr'

alias cdg='cd `golden_cl get --path`'

function make_tree() {
    perl -I/home/autosubmit/bin -MAS::API -MData::Printer -e 'my $api=AS::API->new; my $commands=$api->task("nvgpu_build_treemake_golden",["attributes"])->{attributes}->{Commands};foreach my $cmd (@$commands) {print $cmd,"\n";system($cmd);}'
}
function ea(){
p4 -c $1 -q edit -k //...
p4 -c $1 -q reopen //...
p4 -c $1 -q revert -k //...
p4 client -d $1
}
