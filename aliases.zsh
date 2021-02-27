# -------------------------------------------------------------------
# use nocorrect alias to prevent auto correct from "fixing" these
# -------------------------------------------------------------------
#alias foobar='nocorrect foobar'
#alias g8='nocorrect g8'

# -------------------------------------------------------------------
# directory movement
# -------------------------------------------------------------------
alias ..='cd ..'
alias 'bk=cd $OLDPWD'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# # Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

alias d='dirs -v | head -10'
#
# -------------------------------------------------------------------
# directory information
# -------------------------------------------------------------------
alias lh='ls -d .*' # show hidden files/directories only

if [[ $IS_MAC -eq 1 ]]; then
   alias ls='ls -GFh' # Colorize output, add file type indicator, and put sizes in human readable format
   alias ll='ls -GFhl' # Same as above, but in long listing format
   alias l='ls -GFha' #same as above, show all files
   alias la='ls -GFhal' #same as above, show all files, long listing format
   alias lad='ls -GFhalt' #same as above, sort by date
else
   alias ls='ls -Fh --color=auto' # Colorize output, add file type indicator, and put sizes in human readable format
   alias ll='ls -Fhl --color=auto' # Same as above, but in long listing format
   alias l='ls -Fha --color=auto' #same as above, show all files
   alias la='ls -Fhal --color=auto' #same as above, show all files, long listing format
   alias lad='ls -Fhalt --color=auto' #same as above, sort by date
fi
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias 'dus=du -sckx * | sort -nr' #directories sorted by size

alias 'wordy=wc -w * | sort | tail -n10' # sort files in current directory by the number of words they contain
alias 'filecount=find . -type f | wc -l' # number of files (not directories)

# -------------------------------------------------------------------
# Mac only
# -------------------------------------------------------------------
if [[ $IS_MAC -eq 1 ]]; then
	 #JWZ's resize perl script
	 alias jwz-resize='export PERL5LIB="/usr/local/lib/perl5/site_perl":$PERL5LIB; resize.pl'
    alias ql='qlmanage -p 2>/dev/null' # OS X Quick Look
    alias oo='open .' # open current directory in OS X Finder
    alias 'today=calendar -A 0 -f /usr/share/calendar/calendar.mark | sort'
    alias 'mailsize=du -hs ~/Library/mail'
    alias 'smart=diskutil info disk0 | grep SMART' # display SMART status of hard drive
    # alias to show all Mac App store apps
    alias apps='mdfind "kMDItemAppStoreHasReceipt=1"'
    # reset Address Book permissions in Mountain Lion (and later presumably)
    alias resetaddressbook='tccutil reset AddressBook'
	 #brew related
    alias refreshbrew='brew outdated | while read cask; do brew upgrade $cask; done' # refresh brew by upgrading all outdated casks
	 alias brews='brew list -1'
	 alias bubo='brew update && brew outdated'
	 alias bubc='brew upgrade && brew cleanup'
	 alias bubu='bubo && bubc'
    #
    # rebuild Launch Services to remove duplicate entries on Open With menu
    alias rebuildopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.fram ework/Support/lsregister -kill -r -domain local -domain system -domain user'
    alias restartspotlight='sudo ps aux | grep Spotlight\.app | grep -v grep | awk '{print $2}' | xargs kill -9'
    alias rebuildkc='sudo rm -r /System/Library/Caches/com.apple.kext.caches && sudo touch /System/Library/Extensions && sudo kextcache -update-volume /'
	 #
	 # kill HUP macos dns
	 alias hupdns='sudo killall -HUP mDNSResponder'
fi

alias whatsmyip='dig +short myip.opendns.com @resolver1.opendns.com'
alias wakehack='wakeonlan 1c:1b:0d:0b:28:50'
# -------------------------------------------------------------------
# database
# -------------------------------------------------------------------
#alias 'psqlstart=/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start'
#alias 'psqlstop=/usr/local/pgsql/bin/pg_ctl stop'
alias mysql='mysql -u root'
alias mysqladmin='mysqladmin -u root'

# -------------------------------------------------------------------
# Git
# -------------------------------------------------------------------
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gpl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'
alias gta='git tag -a -m'
alias gf='git reflog'
alias gv='git log --pretty=format:'%s' | cut -d " " -f 1 | sort | uniq -c | sort -nr'

# gsh shows the number of commits for the current repos for all developers
alias gsh="git shortlog | grep -E '^[ ]+\w+' | wc -l"

# gu shows a list of all developers and the number of commits they've made
alias gu="git shortlog | grep -E '^[^ ]'"

# -------------------------------------------------------------------
# Node
# -------------------------------------------------------------------
#alias npm=pnpm
#alias npx=pnpx

# -------------------------------------------------------------------
# Misc
# -------------------------------------------------------------------
# make sure vim runs if I accidentally type "vi"
alias vi=vim
#list whats inside packed file
alias -s zip="unzip -l"
alias -s rar="unrar l"
alias -s tar="tar tf"
alias -s tar.gz="echo "
# alias -s ace="unace l"
#
alias 'ttop=top -ocpu -R -F -s 2 -n30' # fancy top
alias 'rm=rm -i' # make rm command (potentially) less destructive
alias md='mkdir -p'
alias rd=rmdir

# cat file with colorized output
alias ccat=colorize_via_pygmentize

# Force tmux to use 256 colors
# alias tmux='TERM=screen-256color-bce tmux'

# alias to cat this file to display
alias valiases='vim ~/.zsh/aliases.zsh && source ~/.zsh/aliases.zsh'
alias acat='< ~/.zsh/aliases.zsh'
alias fcat='< ~/.zsh/functions.zsh'
alias sz='source ~/.zshrc'
#
alias grep='grep --color=auto'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

# Command line head / tail shortcuts
alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history -i 1'
alias hist='history -i -50'
alias hgrep="fc -El 0 | grep"
alias update-history='fc -R'
alias sortnr='sort -n -r'
alias unexport='unset'

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

