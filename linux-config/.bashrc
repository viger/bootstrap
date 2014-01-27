# .bashrc
function parse_git_branch_and_add_brackets {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}
PS1="\e[01;33m\A \e[01;35m\u\e[01;30m@\e[01;32m\h\[\e[00m [\e[01;34m\W\e[0m]\[\033[0;32m\]\$(parse_git_branch_and_add_brackets) \[\033[0m\]\$ "

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
alias tmux="tmux -2"
