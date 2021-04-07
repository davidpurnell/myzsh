autoload colors; colors

# The variables are wrapped in \%\{\%\}. This should be the case for every
# variable that does not contain space.
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
  eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
  eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
  eval PR_BG_$COLOR='%{$bg_no_bold[${(L)COLOR}]%}'
  eval PR_BG_BOLD_$COLOR='%{$bg_bold[${(L)COLOR}]%}'
done

eval PR_RESET='%{$reset_color%}'

export CLICOLOR=1
if [[ $IS_MAC -eq 1 ]]; then
   export LSCOLORS=exfxcxdxbxegedabagacad
fi

export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export ZLS_COLORS=$LS_COLORS

# Enable color in grep
#
# removed deprecated GREP_OPTIONS variable
export GREP_COLOR='3;33'
export GREP_COLORS='3;33'

