# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


if [ -d /etc/bash_completion.d ]; then
  for f in /etc/bash_completion.d/*; do
    source $f
  done
fi

# User specific aliases and functions
alias authzhe800='bundle exec rake editor:create_admin username=chenziwei'
alias puall='~/pull_master_develop.sh'

alias tmux="tmux -2"
