hook global BufCreate .*[.](jsonc) %{
    set-option buffer filetype jsonc
}

hook global WinSetOption filetype=jsonc %{
    require-module jsonc

    hook window ModeChange pop:insert:.* -group jsonc-trim-indent jsonc-trim-indent
    hook window InsertChar .* -group jsonc-indent jsonc-indent-on-char
    hook window InsertChar \n -group jsonc-indent jsonc-indent-on-new-line
    set-option buffer comment_line '//'
    set-option buffer comment_block_begin '/*'
    set-option buffer comment_block_end '*/'

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window jsonc-.+ }
}

hook -group jsonc-highlight global WinSetOption filetype=jsonc %{
    add-highlighter window/jsonc ref jsonc
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/jsonc }
}

provide-module jsonc %(
    add-highlighter shared/jsonc regions
    add-highlighter shared/jsonc/code default-region group
    add-highlighter shared/jsonc/string region '"' (?<!\\)(\\\\)*" fill string

    add-highlighter shared/jsonc/line_comment region '//' '\n' fill comment
    add-highlighter shared/jsonc/block_comment region '/\*' '\*/' fill comment

    add-highlighter shared/jsonc/code/ regex \b(true|false|null|\d+(?:\.\d+)?(?:[eE][+-]?\d*)?)\b 0:value

    define-command -hidden jsonc-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden jsonc-indent-on-char %<
        evaluate-commands -draft -itersel %<
            # align closer token to its opener when alone on a line
            try %< execute-keys -draft <a-h> <a-k> ^\h+[\]}]$ <ret> m <a-S> 1<a-&> >
        >
    >

    define-command -hidden jsonc-indent-on-new-line %<
        evaluate-commands -draft -itersel %<
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            # filter previous line
            try %{ execute-keys -draft k : jsonc-trim-indent <ret> }
            # indent after lines ending with opener token
            try %< execute-keys -draft k x <a-k> [[{]\h*$ <ret> j <a-gt> >
            # deindent closer token(s) when after cursor
            try %< execute-keys -draft x <a-k> ^\h*[}\]] <ret> gh / [}\]] <ret> m <a-S> 1<a-&> >
        >
    >
)
