local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"

function VCS_INFO_get_data_p4(){
# XXX: This soooo needs to be cached
setopt localoptions extendedglob
local p4base a b
local -A p4info
local -A hook_com
${vcs_comm[cmd]} info | while IFS=: read a b; do p4info[${a// /_}]="${b## #}"; done
p4base=${vcs_comm[basedir]}

# We'll use the client name as the branch; close enough.
local p4branch change
# We'll use the latest change number to which the hierarchy from
# here down is synced as the revision.
# I suppose the following might be slow on a tortuous client view.
if zstyle -t ":vcs_info:${vcs}:${usercontext}:${rrn}" get-revison; then
  change="${${$(${vcs_comm[cmd]} changes -m 1 ...\#have)##Change }%% *}"
  zstyle -s ":vcs_info:${vcs}:${usercontext}:${rrn}" branchformat p4branch || p4branch="%b:%r"
  else
    zstyle -s ":vcs_info:${vcs}:${usercontext}:${rrn}" branchformat p4branch || p4branch="%b"
fi
# zstyle -s ":vcs_info:${vcs}:${usercontext}:${rrn}" branchformat p4branch || p4branch="%b:4"
hook_com=( branch "${p4info[Client_name]}" revision "${change}" )
if VCS_INFO_hook 'set-branch-format' "${p4branch}"; then
    zformat -f p4branch "${p4branch}" "b:${hook_com[branch]}" "r:${hook_com[revision]}"
else
    p4branch=${hook_com[branch-replace]}
fi
hook_com=()
VCS_INFO_formats '' "${p4branch}" "${p4base}" '' '' "$change" ''
return 0
}

VCS_INFO_detect_p4() {
  local serverport p4where

  if zstyle -t ":vcs_info:p4:${usercontext}:${rrn}" use-server; then
      echo 'use-server enabled'
    # Use "p4 where" to decide whether the path is under the
    # client workspace.
    if (( ${#vcs_info_p4_dead_servers} )); then
      # See if the server is in the list of defunct servers
      VCS_INFO_p4_get_server
      [[ -n $vcs_info_p4_dead_servers[$serverport] ]] && return 1
    fi
    if p4where="$(${vcs_comm[cmd]} where 2>&1)"; then
      return 0
    fi
    if [[ $p4where = *"Connect to server failed"* ]]; then
      # If the connection failed, mark the server as defunct.
      # Otherwise it worked but we weren't within a client.
      typeset -gA vcs_info_p4_dead_servers
      [[ -z $serverport ]] && VCS_INFO_p4_get_server
      vcs_info_p4_dead_servers[$serverport]=1
    fi
    return 1
  else
      echo 'use-server not enabled'
    [[ -n ${P4CONFIG} ]] || return 1
    VCS_INFO_check_com ${vcs_comm[cmd]} || return 1
    vcs_comm[detect_need_file]="${P4CONFIG}"
    VCS_INFO_bydir_detect .
    return $?
  fi
}

zstyle ':vcs_info:p4*' formats '%F{5}[%F{2}%b%F{5}]%f %S'

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX$(parse_git_dirty)"
}

function get_pwd_p4(){
  p4_root=`p4 info | grep 'Client root:' | cut -d ' ' -f 3-   |tr -d '\n'`
  # while [[ $git_root != / && ! -e $git_root/.git ]]; do
  #   git_root=$git_root:h
  # done
  # echo $git_root
  # return
  # if [[ $p4_root = / ]]; then
  #   unset p4_root
  #     return=%~
  # else
    parent=${p4_root%\/*}
    echo $parent
    prompt_short_dir=${PWD#$parent/}
    if [[ $parent == $prompt_shoft_dir ]]; then
        echo ' equal'
    else
        echo 'not equal'
    fi;

  # fi
  echo $prompt_short_dir
}
function get_pwd(){
  git_root=$PWD
  while [[ $git_root != / && ! -e $git_root/.git ]]; do
    git_root=$git_root:h
  done
  if [[ $git_root = / ]]; then
    unset git_root
    # check for p4 client
    prompt_short_dir=%~
  else
    parent=${git_root%\/*}
    prompt_short_dir=${PWD#$parent/}
  fi
  echo $prompt_short_dir
}

PROMPT='$ret_status %{$fg[white]%}$(get_pwd) $(git_prompt_info)%{$reset_color%}%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✓%{$reset_color%}"

#ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}[git:"
#ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}+%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
