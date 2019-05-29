if [[ $IS_MAC -eq 1 ]]; then
	export PATH=$PATH:~/Applications:~/Library/Python/3.7/bin:/usr/local/opt/mysql@5.6/bin
	export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
	export EDITOR='subl -w'
else
	if [[ $UID -eq 0 ]]; then
		export PATH=$PATH:/usr/local/bin
	fi
fi

export TERM=xterm-256color
export LESS='--ignore-case --raw-control-chars'
export PAGER='less'

