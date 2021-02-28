#
autoload -U colors && colors # Enable colors in prompt

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"
GIT_PROMPT_PREFIX="%{$fg[green]%} [%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}u%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}d%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}s%{$reset_color%}"
 
# Show Git branch/tag, or name-rev if on detached head
function parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}
 
# Show different symbols as appropriate for various Git repository states
function parse_git_state() {
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""
 
  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi
 
  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi
 
  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi
 
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi
 
  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi
 
  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi
 
  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}
 
# If inside a Git repository, print its branch and state
function git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "<%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$reset_color>$(parse_git_state)"
}

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local timedate=""
local timedate='%{$fg[red]%} %D{%b %e %k:%M:%S} %{$reset_color%}'

if [[ $UID -eq 0 ]]; then
    local user_host='%{$terminfo[bold]$fg[red]%}%n@%m%{$reset_color%}'
    local user_prompt_char='%{$terminfo[bold]$fg[red]%}#%{$reset_color%}'
else
    local user_host='%{$terminfo[bold]$fg[green]%}%n@%m%{$reset_color%}'
    local user_prompt_char='%{$terminfo[bold]$fg[green]%}$%{$reset_color%}'
fi

#local current_dir='%{$terminfo[bold]$fg[blue]%} %10<..<%/ %{$reset_color%}'
local git_branch='$(git_prompt_string)%{$reset_color%}'

# calculate prompt length based on terminal window size
function myPromptWidth() {
  local PROMPT_PERCENT_OF_LINE=30
  echo $(( ${COLUMNS:-80} * $PROMPT_PERCENT_OF_LINE / 100 ))
}
local width_part='$(myPromptWidth)'

PROMPT="╭─${timedate} ${user_host} %{$terminfo[bold]$fg[blue]%}%${width_part}<...<%~%<<%{$reset_color%} ${git_branch}
╰─${user_prompt_char} "
RPS1="${return_code}"

export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "

