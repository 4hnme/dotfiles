hook global BufCreate .*[.](kdl) %{
    set-option buffer filetype kdl
}

hook global WinSetOption filetype=kdl %{
    require-module kdl

    hook window ModeChange pop:insert:.* -group kdl-trim-indent kdl-trim-indent
    hook window InsertChar .* -group kdl-indent kdl-indent-on-char
    hook window InsertChar \n -group kdl-indent kdl-indent-on-new-line
    set-option buffer comment_line '//'

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window kdl-.+ }
}

hook -group kdl-highlight global WinSetOption filetype=kdl %{
    add-highlighter window/kdl ref kdl
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/kdl }
}

provide-module kdl %(
    add-highlighter shared/kdl regions
    add-highlighter shared/kdl/code default-region group
    add-highlighter shared/kdl/code/ regex '(^|;|\{)\h*([\w-\+]+)' 2:function
    add-highlighter shared/kdl/code/ regex '(=|\+)=?' 1:operator
    add-highlighter shared/kdl/string region '"' (?<!\\)(\\\\)*" fill string

    add-highlighter shared/kdl/line_comment region '//' '\n' fill comment
    add-highlighter shared/kdl/node_comment region -recurse '\{' '/-[\w-]+.*\{' '\}' fill comment

    define-command -hidden kdl-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden kdl-indent-on-char %<
        evaluate-commands -draft -itersel %<
            # align closer token to its opener when alone on a line
            try %< execute-keys -draft <a-h> <a-k> ^\h+[\]}]$ <ret> m <a-S> 1<a-&> >
        >
    >

    define-command -hidden kdl-indent-on-new-line %<
        evaluate-commands -draft -itersel %<
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            # filter previous line
            try %{ execute-keys -draft k : kdl-trim-indent <ret> }
            # indent after lines ending with opener token
            try %< execute-keys -draft k x <a-k> [[{]\h*$ <ret> j <a-gt> >
            # deindent closer token(s) when after cursor
            try %< execute-keys -draft x <a-k> ^\h*[}\]] <ret> gh / [}\]] <ret> m <a-S> 1<a-&> >
        >
    >
)
