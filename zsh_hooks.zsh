function precmd {
	if is_remote; then
    #we're on a remote system
    echo -ne "\e]0;${USER}@${HOST} $PWD:h:t/$PWD:t\a"
	else
    #we're local
    echo -ne "\e]0;$PWD:h:t/$PWD:t\a"
	fi
  # vcs_info
  # Put the string "hostname::/full/directory/path" in the title bar:
  #echo -ne "\e]0;$(whoami)@$(hostname):${PWD/#$HOME/~}\a"

  # Put the parentdir/currentdir in the tab
  #echo -ne "\e]1;$PWD:h:t/$PWD:t\a"
}

#function set_running_app {
  #printf "\e]1; $PWD:t:$(history $HISTCMD | cut -b7- ) \a"
#}

#function preexec {
  #set_running_app
#}

#function postexec {
  #set_running_app
#}
