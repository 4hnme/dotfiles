# plugin manager
source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload

plug "occivink/kakoune-buffer-switcher" config %{
    map global space a ':buffer-switcher<ret>' -docstring 'buffer switcher'
    # putting it here because of disabled tabs plugin
    # set-option global modelinefmt '{{context_info}} │ {StatusLineInfo}%val{bufname}{StatusLine} │ %val{cursor_line}:%val{cursor_char_column} │ %val{client}@[%val{session}] │ {{mode_info}}'
    set-option global modelinefmt '{{context_info}} | {StatusLineInfo}%val{bufname}{StatusLine} | %val{cursor_line}:%val{cursor_char_column} | %val{client}@[%val{session}] | {{mode_info}}'
    map global normal <a-q> ':delete-buffer<ret>'
    map global normal <a-Q> ':delete-buffer!<ret>'
    set-face global BufferSwitcherCurrent "%opt{c_green},default+b"
}

plug "insipx/kak-crosshairs" config %{
    set-face global crosshairs_line "default,%opt{c_dark}"
    cursorline
}

# plug "andreyorst/tagbar.kak"
plug "andreyorst/tagbar.kak" defer "tagbar" %{
    set-option global tagbar_sort false
    set-option global tagbar_size 40
    set-option global tagbar_display_anon false
} config %{
    # if you have wrap highlighter enamled in you configuration
    # files it's better to turn it off for tagbar, using this hook:
    hook global WinSetOption filetype=tagbar %{
        remove-highlighter buffer/softwrap
        # you can also disable rendering whitespaces here, line numbers, and
        # matching characters
    }
}

# case subversion
# plug "your-tools/kak-subvert"

# spaces instead of tabs
plug "andreyorst/smarttab.kak" defer smarttab %{
    set-option global softtabstop 4
    set-option global indentwidth 4
} config %{
    hook global WinSetOption filetype=(python|ocaml|kak|v) expandtab
}

# preview kakoune palette
plug "Delapouite/kakoune-palette"

# phantom selection
plug "occivink/kakoune-phantom-selection" config %{
    declare-user-mode phantom
    map global normal <a-p> ':enter-user-mode phantom<ret>'
    map global normal <a-P> ':enter-user-mode -lock phantom<ret>'
    map global phantom a ':phantom-selection-add-selection<ret>' -docstring "add current selections into phantom selections"
    map global phantom <percent> ':phantom-selection-select-all<ret>' -docstring "select EVERY phantom selection"
    map global phantom d ':phantom-selection-clear<ret>' -docstring "remove current phantom selection"
    map global phantom , ':phantom-selection-select-all; phantom-selection-clear<ret>' -docstring "remove all phantom selections"
    map global phantom n ':phantom-selection-iterate-next<ret>' -docstring "jump to next phantom selection"
    map global phantom p ':phantom-selection-iterate-prev<ret>' -docstring "jump to previous phantom selection"
    set-face global PhantomSelection "%opt{c_black},%opt{c_comment}+F"
}

# vlang support
plug "antono2/vlang.kak"

# tabs for buffers
# plug "enricozb/tabs.kak" config %{
#     set-option global tabs_modelinefmt '{{mode_info}} | %val{cursor_line}:%val{cursor_char_column} '
#     map global normal <a-q> ':enter-user-mode tabs<ret>'
#     map global normal <a-s-q> ':enter-user-mode -lock tabs<ret>'
#     map global tabs D ':delete-buffer!<ret>' -docstring 'delete (focused) even in unsaved'
#     set-option global tabs_options --minified --separator '""' --focused-face StatusLineMode --inactive-face StatusLine --modified-face StatusLineValue
# }

# surround (almost like helix but worse) (for some reason works)
plug "h-youhei/kakoune-surround" config %{
    declare-user-mode surround
    map global surround s ':surround<ret>' -docstring 'surround'
    map global surround r ':change-surround<ret>' -docstring 'replace'
    map global surround d ':delete-surround<ret>' -docstring 'delete'
    map global surround t ':select-surrounding-tag<ret>' -docstring 'select tag'
    map global normal '<a-s>' ':enter-user-mode surround<ret>' -docstring 'surround'
    # putting this there so that <a-s> is not overrided (i'm sorry :c)
    map global normal '<c-v>' '<a-s>'
}

# focus on multi-cursor selections
# plug "caksoylar/kakoune-focus" config %{
#     map global space f ':focus-toggle<ret>' -docstring 'toggle focus'
# }

# select up and down
# plug "occivink/kakoune-vertical-selection" config %{
#     map global space <a-v> ':vertical-selection-up<ret>'      -docstring 'vertical selection up'
#     map global space v ':vertical-selection-down<ret>'        -docstring 'vertical selection down'
#     map global space V ':vertical-selection-up-and-down<ret>' -docstring 'vertical selection up and down'
# }

# select view (only visible text, not the entire buffer)
plug "Delapouite/kakoune-select-view" config %{
    map global normal <a-%> ':select-view<ret>'
}

# unified objects
plug "Delapouite/kakoune-text-objects"

# lsp
plug "kak-lsp/kak-lsp" do %{
    cargo install --locked --force --path .
    # mkdir -p ~/.config/kak-lsp
    # cp -n kak-lsp.toml ~/.config/kak-lsp/
} config %{
    set-face global DiagnosticError "default,default"
    set-face global DiagnosticWarning "default,default"
    # lsp-diagnostic-lines-enable global
    lsp-stop-on-exit-enable

    hook -group lsp-filetype-vlang global BufSetOption filetype=v %{
        set-option buffer lsp_servers %{
            [v-analyzer]
            root_globs = ["v.mod", "mod.v", "main.v"]
        }
    }

    hook -group lsp-filetype-vlang global BufSetOption filetype=odin %{
        set-option buffer lsp_servers %{
            [ols]
            command = "/home/hotsadboi/thirdparty/ols/ols"
            root_globs = ["main.odin", "src"]
            [ols.settings]
        	enable_semantic_tokens = false
        	enable_document_symbols = true
        	enable_hover = true
        	enable_snippets = true
        	profile = "default"
        }
    }
}
# hooks for kak-lsp
hook global WinSetOption filetype=(ocaml) %{
    source "%val{config}/ocaml.kak"
    set-option buffer formatcmd  'ocamlformat --enable-outside-detected-project --impl -'
    set-option window indentwidth 2
    set-option window softtabstop 2
}
hook global WinSetOption filetype=(c|go|rust|haskell|ocaml) %{
    # lsp-enable-window
    expandtab
}
hook global WinSetOption filetype=(v|odin) %{
    expandtab
}

# autopairs
plug 'alexherbo2/auto-pairs.kak' config %{
    enable-auto-pairs
}

plug 'ABuffSeagull/kakoune-vue' noload

# my utils
# plug "hotsadboi" load-path "%val{config}/plugins/hotsadboi" config %{
plug "hotsadboi" config %{
    # map global normal '<c-u>' "<c-u>gc"
    # map global normal '<c-d>' "<c-d>gc"
    map global normal '<c-u>' ":custom-third-a-page-up<ret>"
    map global normal '<c-d>' ":custom-third-a-page-down<ret>"

    # there is custom-page-up/down commands but <c-b> is occupied with multicursor selection backwards
    # map global normal '<c-b>' ":custom-page-up<ret>"
    # map global normal '<c-f>' ":custom-page-down<ret>"

    # easier way to move between brackets
    map global normal '<F1>' ':prev-matching-pair<ret>'
    map global normal '<F2>' ':next-matching-pair<ret>'
    map global normal '<s-F1>' ':extend-with-prev-matching-pair<ret>'
    map global normal '<s-F2>' ':extend-with-next-matching-pair<ret>'

    # select words with multiple cursors
    map global normal <c-e> ':add-next-word<ret>'
    map global normal <c-w> ':add-next-word<ret>'
    map global normal <c-b> ':add-prev-word<ret>'

    # drag selections up and down
    map global normal <c-k> ':drag-up<ret>'
    map global normal <c-j> ':drag-down<ret>' # <- works because <c-j> is <ret>
    map global normal <ret> ':drag-down<ret>' # <- works because <c-j> is <ret>
}

plug "ex.kak" config %{
    map global space e ':ls<ret>' -docstring 'open ex buffer'
}

plug "csharp.kak"
