# taken from Powerlevel10K zsh theme
function prompt-length() {
  emulate -L zsh
  local -i x y=${#1} m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ))
    done
    while (( y > x + 1 )); do
      (( m = x + (y - x) / 2 ))
      (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
    done
  fi
  echo $x
}
#pull repo info for CWD
function git_prompt() {
    tgtdir="${1:-$PWD}"

    $(git \
        -C "$tgtdir" \
        --no-optional-locks \
        status \
        --porcelain=v2 \
        --branch \
        2>/dev/null \
    | awk '
        /^# branch\.oid/ { sha=$3 }
        /^# branch\.head/ { branch=$3 }
        /^# branch\.upstream/ { upstream=$3 }
        /^# branch\.ab/ {
            a = $3 != "+0" ? $3 : ""
            b = $4 != "-0" ? $4 : ""
        }
        /^\?/ {
            ucount++
            untracked=ucount
        }
        /^[0-9] [A-Z]. / {
            scount++
            staged=scount 
        }
        /^[0-9] .[A-Z] / {
            mcount++
            modified=mcount 
        }
        /^u UU/ { conflicts="UU" }
        END {
            print (\
                "declare git_sha="sha,
                "git_branch="branch,
                "git_ahead="a,
                "git_behind="b,
                "git_untracked="untracked,
                "git_modified="modified,
                "git_staged="staged,
                "git_conflicts="conflicts)
            }
    ')
    if [[ $git_branch ]]; then
      #local git_info="${PR_RESET}${git_sha:0:12} <${PR_YELLOW}${git_branch}${PR_RESET}>"
      local git_info="<${PR_YELLOW}${git_branch}${PR_RESET}>"
      if [[ $git_ahead||\
            $git_behind||\
            $git_untracked||\
            $git_modified||\
            $git_staged||\
            $git_conflicts ]]; then
        git_info+=" ${PR_GREEN}[${PR_MAGENTA}${git_ahead/\+/"↑"}"
        git_info+="${PR_CYAN}${git_behind/"-"/"↓"}"
        if [[ $git_untracked ]] git_info+="${PR_BOLD_RED}…${git_untracked}"
        if [[ $git_modified ]] git_info+="${PR_BOLD_YELLOW}+${git_modified}"
        if [[ $git_staged ]] git_info+="${PR_BOLD_GREEN}●${git_staged}"
        git_info+="${PR_RED}${git_conflicts}${PR_GREEN}]${PR_RESET}"
      else 
        git_info+=" ${PR_GREEN}[${PR_GREEN}✔${PR_GREEN}]${PR_RESET}"
      fi
    fi
    echo $git_info
}
function construct_prompt() {
    #construct date and time
    local d="%D{%-e}"
    case $d in
        1?) d=${d}th ;;
        *1) d=${d}st ;;
        *2) d=${d}nd ;;
        *3) d=${d}rd ;;
        *)  d=${d}th ;;
    esac
    meridiem=${(%):-%D{%p}}
    local date_time=" ${PR_RED}%D{%b} ${d} %D{%-l:%M}${meridiem:l}${PR_RESET} "
    #construct git info
    local git_info=$(git_prompt)
    #construct user styling (privileged or not)
    if [[ $UID -eq 0 ]]; then
        local user_host="${PR_BOLD_RED}${USER:u}"
    else
        local user_host="${PR_GREEN}${USER}"
    fi
    #user or user@host
    if is_remote; then
        user_host+="@${HOST}"
    fi
    user_host+="${PR_RESET} "

    local left_bookend="${PR_BOLD_GREEN}╭─${PR_RESET}"
    local prompt_symbol="%(!.${PR_BOLD_RED}#.${PR_GREEN}$)${PR_RESET} "
    local right_bookend="${PR_BOLD_GREEN}─╮${PR_RESET}"
    local lower_bookend="\n${PR_BOLD_GREEN}╰─${PR_RESET}"
    # some widths
    local columns=$(($COLUMNS -1)) #ZLE_RPROMPT_INDENT defaults to 1
    local bookend_w="2"
    local datetime_w=$(prompt-length $date_time)
    local userhost_w=$(prompt-length $user_host)
    local git_w=$(prompt-length $git_info)
    local pwd_available_w=$(($columns - $bookend_w*2 - $datetime_w - $userhost_w - 2))
    local pwd="${PR_BOLD_BLUE}%${pwd_available_w}<...<%~%<<${PR_RESET} "
    local pwd_w=$(prompt-length $pwd)
    local full_pwd_w=$(prompt-length "%~ ")

    # sizing premises
    local large_w=$(($bookend_w*2 + $datetime_w + $userhost_w + $pwd_w + $git_w))
    local medium_w=$(($bookend_w*2 + $datetime_w + $userhost_w + $pwd_w))
    local small_w=$(($bookend_w*2 + $datetime_w + $userhost_w))

    # build the prompt
    if (( $git_w > 0 && $columns < $large_w )); then
        #we have git but not enough room to display it
        unset git_info
        git_w=0
    fi
    if (( $columns <= $medium_w )); then
        #no more room for the working directory
        unset pwd
        pwd_w=0
    fi
    if (( $columns <= $small_w )); then
        #no more room for user host
        unset user_host
        userhost_w=0
    fi
    local pad_w=$(($columns - $bookend_w*2 - $datetime_w - $userhost_w - $pwd_w - $git_w))
    local pad=${PR_BOLD_GREEN}${(pl.$pad_w..─.)}${PR_RESET}
    #echo "pad length: "$pad_w

    local left_prompt=${left_bookend}${date_time}${user_host}${pwd}${pad}${git_info}${right_bookend}
    local left_prompt2="%(!.${PR_BOLD_RED}#.${PR_GREEN}$)${PR_RESET} "

    if (( $columns <= 40 )); then
        #simple prompt on egregiously skinny terminals
        echo ${prompt_symbol}
    else
        echo " "
        echo ${left_prompt}${lower_bookend}${prompt_symbol}
    fi
}

PROMPT='$(construct_prompt)'
RPROMPT="%(?.${PR_GREEN}〈${PR_RESET}.${PR_RED}%? ❌)${PR_BOLD_GREEN}─╯${PR_RESET}"
SPROMPT="Correct ${PR_RED}%R${PR_RESET} to ${PR_GREEN}%r${PR_RESET} [(y)es (n)o (a)bort (e)dit]? "

# from https://github.com/IsaacElenbaas/dotfiles
# rewriting my busy prompt to a simpler version so that 
# terminal scrollback history is not visually polluted
_printfPrepare() {
	1="${1//\\/\\\\\\\\}"
	1="${1//\%/%%%%}"
	printf -- "$1"
}
preexec() {
	printf "\033[2A\033[2K\033[1B"
	0="$(_printfPrepare $1)"
	(
		0="${0//\$/\\$}"
		0="${0//\`/\\\`}"
		# middle bit is last line of final prompt with %(!.#.$) swapped for %1~
		print -P -- "${PR_GREEN}〉${PR_RED}%D{%F %k:%M:%S} ${PR_BOLD_BLUE}%1~${PR_RESET}" "${0//\\/\\\\}""${PR_GREEN}〈 ${PR_WHITE}%!${PR_RESET}\033[0K"
	)
}
# from https://stackoverflow.com/questions/30169090/zsh-behavior-on-enter
# preexec doesn't run if you just hit enter so running it on enter to always
# have the simplified prompt in terminal scrollback history
my-accept-line () {
    # check if the buffer does not contain any words
    if [ ${#${(z)BUFFER}} -eq 0 ]; then
        #move to column 0 so that the output does not start next to the prompt
        printf "\033[0G"
        preexec
    fi
    # in any case run the `accept-line' widget
    zle accept-line
}
# create a widget from `my-accept-line' with the same name
zle -N my-accept-line
# rebind Enter, usually this is `^M'
bindkey '^M' my-accept-line