function precmd {
	if is_remote; then
    # we're on a remote system
    # put user@host with parentdir/currentdir in title and tab bars
    echo -ne "\e]0;${USER}@${HOST} $PWD:h:t/$PWD:t\a"
	else
    # we're local
    # put parentdir/currentdir in title and tab bars
    echo -ne "\e]0;$PWD:h:t/$PWD:t\a"
	fi
}

#function preexec {
  #
#}