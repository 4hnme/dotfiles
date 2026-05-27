hook global ModuleLoaded tmux %{

    define-command tmux-split-vertical -override %{
        evaluate-commands %{
            execute-keys '"tZ'
            tmux-terminal-horizontal kak -c %val{session} -e "tmux-client-use-mark"
            execute-keys ":<esc>"
        }
    }

    define-command tmux-split-horizontal -override %{
        evaluate-commands %{
            execute-keys '"tZ'
            tmux-terminal-vertical kak -c %val{session} -e "tmux-client-use-mark"
            execute-keys ":<esc>"
        }
    }

    define-command -hidden tmux-client-use-mark -override %{
        execute-keys '"tz'
        execute-keys ":<esc>"
    }
}
