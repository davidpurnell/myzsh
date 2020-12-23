# checks (stolen from zshuery)
if [[ $(uname) = 'Linux' ]]; then
    IS_LINUX=1
fi

if [[ $(uname) = 'Darwin' ]]; then
    IS_MAC=1
fi

# source the things
#
source ~/.zsh/colors.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/history.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zaw/zaw.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/zsh_hooks.zsh

# fzf completions
#
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# placeholder for local and/or sensitive configs...
#
[ -f ~/.zsh/local.zsh ] && source ~/.zsh/local.zsh
