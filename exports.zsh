if [[ $IS_MAC -eq 1 ]]; then
	MAMP_LATEST_PHP=`ls /Applications/MAMP/bin/php/ | sort -n | tail -1`
	export PATH=/Applications/MAMP/bin/php/${MAMP_LATEST_PHP}/bin:$PATH:~/Applications:~/Library/Python/3.7/bin:/usr/local/opt/mysql-client/bin
	export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
	export EDITOR='code'
else
	if [[ $UID -eq 0 ]]; then
		export PATH=$PATH:/usr/local/bin
	fi
fi

export TERM=xterm-256color
export LESS='--ignore-case --raw-control-chars'
export PAGER='less'

