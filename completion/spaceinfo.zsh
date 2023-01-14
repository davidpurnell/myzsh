#compdef spaceinfo
local context state state_descr line
_spaceinfo_commandname=$words[1]
typeset -A opt_args

_spaceinfo() {
    integer ret=1
    local -a args
    args+=(
        '--active-display[ ]'
        '--total-displays[ ]'
        '--active-space[ ]'
        '--first-space[ ]'
        '--last-space[ ]'
        '--total-spaces[ ]'
        '-d[Restrict total spaces info to a specific display number]:d:'
        '-v[Verbose output]'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S $args[@] && ret=0

    return ret
}


_custom_completion() {
    local completions=("${(@f)$($*)}")
    _describe '' completions
}

_spaceinfo
