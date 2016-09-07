export XDG_BASE=$HOME
export XDG_DATA_HOME=$XDG_BASE/.local
export XDG_CONFIG_HOME=$XDG_BASE/.config
export XDG_CACHE_HOME=$XDG_BASE/.cache
export XDG_RUNTIME_DIR="/tmp/runtime-$(whoami)"
mkdir -p $XDG_RUNTIME_DIR
chmod 0700 $XDG_RUNTIME_DIR
export ZDOTDIR=$XDG_BASE/.config/zsh
