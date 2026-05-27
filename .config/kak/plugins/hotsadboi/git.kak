# taken from https://discuss.kakoune.com/t/useful-user-modes/730/3

map global user -docstring "Enable Git keymap mode for next key" g ": enter-user-mode<space>git<ret>"

declare-user-mode git
map global git -docstring "blame - Show what revision and author last modified each line of the current file" b ': repl-new tig blame -C "+%val{cursor_line}" -- "%val{buffile}"<ret>'
map global git -docstring "commit - Record changes to the repository" c ": git commit<ret>"
map global git -docstring "diff - Show changes between HEAD and working tree" d ": git diff<ret>"
map global git -docstring "git - Explore the repository history" g ": repl-new tig<ret>"
# map global git -docstring "github - Copy canonical GitHub URL to system clipboard" h ": github-url<ret>"
map global git -docstring "log - Show commit logs for the current file" l ': repl-new tig log -- "%val{buffile}"<ret>'
map global git -docstring "prompt - Run a free-form Git command prompt" p ":repl-new tig "
map global git -docstring "status - Show the working tree status" s ": repl-new tig status<ret>"
map global git -docstring "staged - Show staged changes" t ": git diff --staged<ret>"
map global git -docstring "write - Write and stage the current file" w ": write<ret>: git add<ret>: git update-diff<ret>"
