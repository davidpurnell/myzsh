# autossh then start/resume tmux session
#
function tmux-test() {
    THEID=$USER-$(awk 'BEGIN { srand(); do r = rand()*32000; while ( r < 20000 ); printf("%d\n",r)  }')
    THEID=$1-$2-$(date +"%m%d%y-%H%M%S")
    echo $THEID
    #ssh -YX -p ${3:-22} $1@$2 -t "TERM=xterm-256color LANG=$LANG tmux new-session -s $1 || tmux attach-session -t $1"
}
function tmux-connect() {
    #ssh -YX -p ${3:-22} $1@$2 -t "TERM=xterm-256color LANG=$LANG tmux new -A $1"
    if [ $4 ]; then
	    echo "attaching remote session: $4"
       ssh  -p ${3:-22} $1@$2 -t "tmux attach-session -t $4"
    else
       THEID=$1-$(echo $2 | awk -F. '{print $1}')-$(date +"%m%d%y-%H%M%S")
	    echo "starting new remote session: $THEID"
       ssh  -p ${3:-22} $1@$2 -t "tmux -u new-session -s $THEID"
    fi
}
function rtmux {
  case "$2" in
    "") autossh -M 0 $1 -t "if tmux -qu has; then tmux -qu attach; else EDITOR=vim tmux -qu new; fi";;
    *) autossh -M 0 $1 -t "if tmux -qu has -t $2; then tmux -qu attach -t $2; else EDITOR=vim tmux -qu new -s $2; fi";;
  esac
}
#
# highlights file content based on the filename extension.
colorize_via_pygmentize() {
    if [ ! -x "$(which pygmentize)" ]; then
        echo "package \'pygmentize\' is not installed!"
        return -1
    fi

    if [ $# -eq 0 ]; then
        pygmentize -g $@
    fi

    for FNAME in $@
    do
        filename=$(basename "$FNAME")
        lexer=`pygmentize -N \"$filename\"`
        if [ "Z$lexer" != "Ztext" ]; then
            pygmentize -l $lexer "$FNAME"
        else
            pygmentize -g "$FNAME"
        fi
    done
}
# -------------------------------------------------------------------
# change date only with exiftool
# -------------------------------------------------------------------
change_date() {
	if [ -n "$1" ] && [ -n "$2" ]
    then
		  exiftool -m $3 -overwrite_original -echo "changing dates..." '-DateTimeOriginal<'"$1"' ${DateTimeOriginal;s/.* //}' '-CreateDate<i'"$1"' ${CreateDate;s/.* //}' '-ModifyDate<'"$1"' ${ModifyDate;s/.* //}' $2
		  exiftool -m $3 -overwrite_original -echo "adding CreateDate as needed..." '-CreateDate='"$1"' 12:00:00' -if '(not $createdate)' $2
		  exiftool -m $3 -overwrite_original -echo "adding ModifyDate as needed..." '-ModifyDate='"$1"' 12:00:00' -if '(not $modifydate)' $2
		  exiftool -m $3 -overwrite_original -echo "adding DateTimeOriginal as needed..." '-DateTimeOriginal<CreateDate' -if '(not $datetimeoriginal)' $2
    else
        echo "usage: YEAR:MONTH:DAY <filespec>\n"
        echo "add -r to process subdirectories\n"
    fi
}
# -------------------------------------------------------------------
# compressed file expander 
# (from https://github.com/myfreeweb/zshuery/blob/master/zshuery.sh)
# -------------------------------------------------------------------
ex() {
    if [[ -f $1 ]]; then
        case $1 in
          *.tar.bz2) tar xvjf $1;;
          *.tar.gz) tar xvzf $1;;
          *.tar.xz) tar xvJf $1;;
          *.tar.lzma) tar --lzma xvf $1;;
          *.bz2) bunzip $1;;
          *.rar) unrar $1;;
          *.gz) gunzip $1;;
          *.tar) tar xvf $1;;
          *.tbz2) tar xvjf $1;;
          *.tgz) tar xvzf $1;;
          *.zip) unzip $1;;
          *.Z) uncompress $1;;
          *.7z) 7z x $1;;
          *.dmg) hdiutul mount $1;; # mount OS X disk images
          *) echo "'$1' cannot be extracted via >ex<";;
    esac
    else
        echo "'$1' is not a valid file"
    fi
}

# -------------------------------------------------------------------
# any function from http://onethingwell.org/post/14669173541/any
# search for running processes
# -------------------------------------------------------------------
any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any " >&2 ; return 1
    else
        ps xauwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
    fi
}

# -------------------------------------------------------------------
# display a neatly formatted path
# -------------------------------------------------------------------
path() {
  echo $PATH | tr ":" "\n" | \
    awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
           sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
           sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
           sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
           sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
           print }"
}

# -------------------------------------------------------------------
# Mac specific functions
# -------------------------------------------------------------------
if [[ $IS_MAC -eq 1 ]]; then

    # view man pages in Preview
    pman() { ps=`mktemp -t manpageXXXX`.ps ; man -t $@ > "$ps" ; open "$ps" ; }

    # function to show interface IP assignments
    ips() { foo=`/Users/mark/bin/getip.py; /Users/mark/bin/getip.py en0; /Users/mark/bin/getip.py en1`; echo $foo; } 

    # notify function - http://hints.macworld.com/article.php?story=20120831112030251
    notify() { automator -D title=$1 -D subtitle=$2 -D message=$3 ~/Library/Workflows/DisplayNotification.wflow }

	 function pfd() {
  	 	 osascript 2>/dev/null <<EOF
    	 	 tell application "Finder"
      	 	 return POSIX path of (target of window 1 as alias)
    	 	 end tell
EOF
	 }

	 function pfs() {
  	 	 osascript 2>/dev/null <<EOF
    	 	 set output to ""
    	 	 tell application "Finder" to set the_selection to selection
    	 	 set item_count to count the_selection
    	 	 repeat with item_index from 1 to count the_selection
      	 	 if item_index is less than item_count then set the_delimiter to "\n"
      	 	 if item_index is item_count then set the_delimiter to ""
      	 	 set output to output & ((item item_index of the_selection as alias)'s POSIX path) & the_delimiter
    	 	 end repeat
EOF
	 }

	 function cdf() {
  	 	cd "$(pfd)"
	 }

	 function pushdf() {
  	 	pushd "$(pfd)"
	 }
	 # mount Clover's EFI partition
	 function mefi() {
  	 	diskutil list | /usr/bin/grep 512 | awk '{system("sudo diskutil mount /dev/"$5"s1 && open /Volumes/EFI")}'
	 }
	 function mefi2() {
		vuuid=`diskutil info / | grep "Part of Whole:" | awk '{print $4}'`
		physdev=`diskutil apfs list $vuuid | grep "APFS Physical Store" | awk '{print $6}' | rev | cut -c 3- | rev`
		sudo diskutil mount /dev/"$physdev"s1 && open /Volumes/EFI

	 }
fi

# -------------------------------------------------------------------
# nice mount (http://catonmat.net/blog/another-ten-one-liners-from-commandlingfu-explained)
# displays mounted drive information in a nicely formatted manner
# -------------------------------------------------------------------
function nicemount() { (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2="";1') | column -t ; }

# -------------------------------------------------------------------
# myIP address
# -------------------------------------------------------------------
function myip() {
  ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
  ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

# -------------------------------------------------------------------
# (s)ave or (i)nsert a directory.
# -------------------------------------------------------------------
s() { pwd > ~/.save_dir ; }
i() { cd "$(cat ~/.save_dir)" ; }

# -------------------------------------------------------------------
# console function
# -------------------------------------------------------------------
function console () {
  if [[ $# > 0 ]]; then
    query=$(echo "$*"|tr -s ' ' '|')
    tail -f /var/log/system.log|grep -i --color=auto -E "$query"
  else
    tail -f /var/log/system.log
  fi
}

# -------------------------------------------------------------------
# shell function to define words
# http://vikros.tumblr.com/post/23750050330/cute-little-function-time
# -------------------------------------------------------------------
givedef() {
  if [[ $# -ge 2 ]] then
    echo "givedef: too many arguments" >&2
    return 1
  else
    curl "dict://dict.org/d:$1"
  fi
}

#colorized man pages
#
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;40;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		PAGER="${commands[less]:-$PAGER}" \
		_NROFF_U=1 \
		PATH="$HOME/bin:$PATH" \
			man "$@"
}

