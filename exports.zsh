if [[ $IS_MAC -eq 1 ]]; then
	#use MAMP's php if it's installed
	MAMP_LATEST_PHP="/Applications/MAMP/bin/php/`ls /Applications/MAMP/bin/php/ | sort -n | tail -1`/bin:"
   export PATH=$MAMP_LATEST_PHP$PATH:~/Applications:~/Library/Python/3.7/bin:/usr/local/opt/mysql-client/bin
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

