# taken from https://codeberg.org/straypetal71/twos.kak

define-command -docstring '
Register default auto-pairings.
' twos-register-defaults %{
    twos-asymmetric-pair global paren ( )
    twos-asymmetric-pair global brace { }
    twos-asymmetric-pair global bracket [ ]
    twos-symmetric-pair global quote "'"
    twos-symmetric-pair global dquote '"'
    twos-symmetric-pair global grave `
    remove-hooks global 'twos-pad-(?:quote|dquote|grave)'
}


# *****************
# REGISTERING PAIRS

define-command -docstring '
Register a pairing of two different characters (usually brackets).
Arguments: <scope> <name> <left> <right>
' twos-asymmetric-pair -params 4 %{
    twos-asymmetric-pair-register %arg{1} %arg{2} "\Q%arg{3}\E" "\Q%arg{4}\E" "%%☽%arg{3}☽ %%☽%arg{4}☽ %%☽\Q%arg{3}\E☽ %%☽\Q%arg{4}\E☽"
}

define-command -docstring '
Register a pairing of a single character (usually quotes).
Arguments: <scope> <name> <char>
' twos-symmetric-pair -params 3 %{
    twos-symmetric-pair-register %arg{1} %arg{2} "\Q%arg{3}\E" "%%☽%arg{3}☽ %%☽\Q%arg{3}\E☽"
}

define-command -hidden twos-asymmetric-pair-register -params 5 %{
    # args: 1 scope, 2 name, 3 left_regex, 4 right_regex, 5 hook_args
    hook -group "twos-ins-left-%arg{2}" %arg{1} InsertChar %arg{3} "twos-on-ins-left %arg{5}"
    hook -group "twos-ins-right-%arg{2}" %arg{1} InsertChar %arg{4} "twos-on-ins-right %arg{5}"
    hook -group "twos-del-%arg{2}" %arg{1} InsertDelete %arg{3} "twos-on-del-left %arg{5}"
    hook -group "twos-expand-%arg{2}" %arg{1} InsertChar '\n' "twos-on-newline-asymmetric %arg{5}"
    hook -group "twos-pad-%arg{2}" %arg{1} InsertChar ' ' "twos-on-space-asymmetric %arg{5}"
}

define-command -hidden twos-symmetric-pair-register -params 4 %{
    # args: 1 scope, 2 name, 3 char_regex, 4 hook_args
    hook -group "twos-ins-%arg{2}" %arg{1} InsertChar %arg{3} "twos-on-ins-symmetric %arg{4}"
    hook -group "twos-del-%arg{2}" %arg{1} InsertDelete %arg{3} "twos-on-del-symmetric %arg{4}"
    hook -group "twos-expand-%arg{2}" %arg{1} InsertChar '\n' "twos-on-newline-symmetric %arg{4}"
    hook -group "twos-pad-%arg{2}" %arg{1} InsertChar ' ' "twos-on-space-symmetric %arg{4}"
}


# **************************************************
# ASYMMETRIC PAIRS
# args: 1 left, 2 right, 3 left_regex, 4 right_regex

define-command -hidden twos-on-ins-left -params 4 %{
    try %{
        twos-check 'h' "%opt{twos_condition}; %opt{twos_complete_condition}"
        execute-keys -draft ";Hyp;r%arg{2}hd"
    }
}

define-command -hidden twos-on-ins-right -params 4 %{
    try %{
        twos-check 'h' "%opt{twos_condition}; %opt{twos_exit_condition}"
        execute-keys -draft ";<a-k>%arg{4}<ret>d"
    }
}

define-command -hidden twos-on-del-left -params 4 %{
    try %{
        twos-check ';' "%opt{twos_condition}; %opt{twos_del_empty_condition}"
        execute-keys -draft ";<a-k>%arg{4}<ret>d"
    }
}

define-command -hidden twos-on-newline-asymmetric -params 4 %{
    twos-expand %arg{3} %arg{4}
}

define-command -hidden twos-on-space-asymmetric -params 4 %{
    twos-pad %arg{3} %arg{4}
}


# **************************
# SYMMETRIC PAIRS
# args: 1 char, 2 char_regex

define-command -hidden twos-on-ins-symmetric -params 2 %{
    try %{
        twos-check 'h' "%opt{twos_condition}"
        try %{
            twos-check 'h' "%opt{twos_complete_multi_condition}"
            evaluate-commands -save-regs '^' %{
                execute-keys -draft -save-regs '"/' "<a-h>s%arg{2}+.\z<ret>" 'ypZhd'
                try %{ execute-keys -draft "z<a-:><a-l>s\A%arg{2}+<ret>d" }
            }
        } catch %{
            twos-check 'h' "%opt{twos_exit_condition}"
            execute-keys -draft ";<a-k>%arg{2}<ret>d"
        } catch %{
            twos-check 'h' "%opt{twos_complete_condition}"
            execute-keys -draft ";Hyp;r%arg{1}hd"
        }
    }
}

define-command -hidden twos-on-del-symmetric -params 2 %{
    try %{
        twos-check ';' "%opt{twos_condition}; %opt{twos_del_empty_condition}"
        execute-keys -draft ";<a-k>%arg{2}<ret>d"
    }
}

define-command -hidden twos-on-newline-symmetric -params 2 %{
    twos-expand %arg{2} %arg{2}
}

define-command -hidden twos-on-space-symmetric -params 2 %{
    twos-pad %arg{2} %arg{2}
}


# **********
# CONDITIONS

define-command -hidden twos-check -params 2 %{
    evaluate-commands -draft -- 'execute-keys %arg{1};' %arg{2}
}

declare-option str twos_condition twos-default-condition
declare-option str twos_complete_condition twos-default-complete-condition
declare-option str twos_exit_condition twos-default-exit-condition
declare-option str twos_del_empty_condition twos-default-del-empty-condition
declare-option str twos_complete_multi_condition twos-default-complete-multi-condition

define-command -hidden twos-default-condition %{
    twos-not-backslash-escaped
}

define-command -hidden twos-default-complete-condition %{
    twos-not-apostrophe
    twos-not-char-literal
}

define-command -hidden twos-default-exit-condition %{}

define-command -hidden twos-default-del-empty-condition %{}

define-command -hidden twos-default-complete-multi-condition %{
    execute-keys -draft '<a-h><a-k>(?:''{3}|"{3}|``)\z<ret>'
}


# *******
# HELPERS

define-command -hidden twos-expand -params 2 %{
    try %{ execute-keys -draft ";<a-k>%arg{2}<ret>kgl<a-k>%arg{1}<ret>" 'j<a-o>Gidp2K<a-&>j<a-gt>' }
}

define-command -hidden twos-pad -params 2 %{
    try %{ execute-keys -draft ";2H<a-k>%arg{1} %arg{2}<ret>" 'Lyphd' }
}

define-command -hidden twos-not-backslash-escaped %{
    execute-keys -draft '<a-h><a-k>(?<lt>!\\)(?:\\\\)*.\z<ret>'
}

define-command -hidden twos-not-apostrophe %{
    execute-keys -draft "H<a-K>\w'<ret>"
}

define-command -hidden twos-not-char-literal %{
    execute-keys -draft "H<a-:>L<a-K>'.'<ret>"
}

twos-register-defaults
