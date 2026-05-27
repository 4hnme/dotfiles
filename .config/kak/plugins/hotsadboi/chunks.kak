declare-option -hidden str-list eak_string_list
define-command -hidden -params 0 eak-check-strings nop
define-command -hidden -params 2 eak-is-same %{
    set-option window eak_string_list %arg(1)
    set-option -remove window eak_string_list %arg(2)
    eak-check-strings %opt(eak_string_list)
}

define-command -hidden -params .. eak-type %{
    # Execute a key sequence with hooks. Eak keeps hooks active as much as
    # possible, as plugins may depend on them for working properly.
    execute-keys -with-hooks %arg{@}
}

define-command -hidden -params 1 eak-flip %{
    # Arg = requested direction, L or R
    try %{
        eak-is-same %arg(1) L
        eak-type <a-:><a-semicolon>
    } \
    catch %{
        eak-type <a-:>
    }
}

define-command -hidden eak-select-chunk-fd %{
    try %{
        eak-flip R
        try %{
            eak-contains-frontier
            eak-type 1 s \A .*? ([^\W_]) <ret>
        } \
        catch %{
            eak-type <?> [^\W_] <ret>
        }
        eak-type <semicolon>
        eak-grow-chunk-left
        eak-grow-chunk-right
    }
}

define-command -hidden eak-contains-frontier %{
    evaluate-commands -draft %{
        try %{ execute-keys <a-k> [^A-Z][A-Z] <ret> } \
        catch %{ execute-keys <a-k> ([^\W_][\W_])|([\W_][^\W_]) <ret> }
    }
}

define-command -hidden eak-grow-chunk-left %{
    try %{
        eak-flip R
        # If not at line start ...
        execute-keys -draft <a-K> ^\A <ret>
        eak-flip L
        # or on 2nd char of a transition,
        execute-keys -draft H <a-K> \A ([^A-Z][A-Z] | [\W_][^\W_]) <ret>
        # find transition/newline on the left, and adjust cursor.
        eak-type <a-?> ([^A-Z][A-Z] | [\W_][^\W_] | \n[^\n]) <ret> L
    }
}

define-command -hidden eak-grow-chunk-right %{
    try %{
        eak-flip R
        # If not at line end ...
        execute-keys -draft L <a-K> \n \z <ret>
        # or on 1st char of a transition,
        execute-keys -draft L <a-K> ([^A-Z][A-Z] | [^\W_][\W_]) \z <ret>
        # find transition/newline on the right, and adjust cursor.
        eak-type <?> ([^A-Z][A-Z] | [^\W_][\W_] | [^\n]\n ) <ret> H
    }
}

define-command -hidden eak-select-chunk-bd %{
    try %{
        eak-flip R
        try %{
            eak-contains-frontier
            eak-type 1 s \A .* ([^\W_]) <ret>
        } \
        catch %{
            eak-type <a-?> [^\W_] <ret>
        }
        eak-type <semicolon>
        eak-grow-chunk-left
        eak-grow-chunk-right
    }
}

define-command -hidden eak-extend-chunk-fd %{
    try %{
        eak-flip R
        eak-type <?> [^\W_] <ret>
        eak-grow-chunk-right
    }
}

define-command -hidden eak-extend-chunk-bd %{
    try %{
        eak-flip L
        eak-type <a-?> [^\W_] <ret>
        eak-grow-chunk-left
    }
}

