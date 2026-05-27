# plugin manager
source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload

plug "andreyorst/langmap.kak" config %{
    # add needed extra layout, for example Russian 'йцукен'
    set-option global langmap %opt{langmap_ru_jcuken}
} demand "langmap" %{
    # optional: mappings to toggle langmap
    map -docstring "toggle layout" global normal '<c-l>' ':      toggle-langmap<ret>'
    map -docstring "toggle layout" global insert '<c-l>' '<a-;>: toggle-langmap<ret>'
    map -docstring "toggle layout" global prompt '<c-l>' '<a-;>: toggle-langmap prompt<ret>'
}

plug "occivink/kakoune-buffer-switcher" config %{
    map global user a ':buffer-switcher<ret>' -docstring 'buffer switcher'
    # putting it here because of disabled tabs plugin
    # set-option global modelinefmt '{{context_info}} │ {StatusLineInfo}%val{bufname}{StatusLine} │ %val{cursor_line}:%val{cursor_char_column} │ %val{client}@[%val{session}] │ {{mode_info}}'
    # set-option global modelinefmt '{{context_info}} | {StatusLineInfo}%val{bufname}{StatusLine} | %val{cursor_line}:%val{cursor_char_column} [%sh{echo "$kak_cursor_line * 100 / $kak_buf_line_count" | bc}%%] | %val{client}@[%val{session}] | {{mode_info}} (%opt{langmap_current_lang}) '
    set-option global modelinefmt '{{context_info}} | {StatusLineInfo}%val{bufname}{StatusLine} | %val{cursor_line}:%val{cursor_char_column} | %val{client}@[%val{session}] | {{mode_info}} (%opt{langmap_current_lang}) '
    map global user q ':delete-buffer<ret>'
    map global user Q ':delete-buffer!<ret>'
    set-face global BufferSwitcherCurrent "%opt{yellow},default+b"
}

plug "https://github.com/Delapouite/kakoune-registers" config %{
    # map global insert <a-r> '<a-;>:info-registers<ret>i<c-r>'
    map global normal <a-r> ':info-registers<ret>'
}

# my utils
# plug "hotsadboi" load-path "%val{config}/plugins/hotsadboi" config %{
plug "hotsadboi" config %{
    map global normal '<c-u>' ":custom-half-a-page-up<ret>"
    map global normal '<c-d>' ":custom-half-a-page-down<ret>"
    # map global normal '<c-p>' '<a-[>p'
    # map global normal '<c-s-p>' '<a-{>p'
    # map global normal '<c-n>' ']p'
    # map global normal '<c-s-n>' '\}p'

    # easier way to move between brackets
    map global normal '<F1>' ':prev-matching-pair<ret>'
    map global normal '<F2>' ':next-matching-pair<ret>'
    map global normal '<s-F1>' ':extend-with-prev-matching-pair<ret>'
    map global normal '<s-F2>' ':extend-with-next-matching-pair<ret>'

    # drag selections up and down
    map global normal <c-k> ':drag-up<ret>'
    map global normal <c-j> ':drag-down<ret>' # <- works because <c-j> is <ret>
    map global normal <ret> ':drag-down<ret>' # <- works because <c-j> is <ret>
    map global normal <s-d> ':dup-line<ret>'

    map global user / ':switch-search-highlight<ret>'

    map global normal <s-a> ':indent-and-append<ret>'
    map global user s ':scratch-buffer<ret>'

    map global object h '<esc>:hump<ret>'
    map global normal <c-s-e> ":hump-extend-end<ret>"
    map global normal <c-s-w> ":hump-extend-word<ret>"
    map global normal <c-s-b> ":hump-extend-back<ret>"
    map global normal <c-e> ":hump-end<ret>"
    map global normal <c-w> ":hump-word<ret>"
    map global normal <c-b> ":hump-back-hsb<ret>"

    map global normal '=' ":autoindent<ret>"

    map global user l ":tmux-split-vertical<ret>"
    map global user j ":tmux-split-horizontal<ret>"
    map global user i ":selection-info<ret>"

    random-name
}

# highlight the line with the main selection
plug "insipx/kak-crosshairs" config %{
    set-face global crosshairs_line "default,%opt{gray_0}"
    # cursorline
}

plug "raiguard/kak-harpoon" config %{
    harpoon-add-bindings
}

# spaces instead of tabs
plug "andreyorst/smarttab.kak" defer smarttab %{
    set-option global softtabstop 4
    set-option global indentwidth 4
} config %{
    hook global WinSetOption filetype=(python|ocaml|kak|v) expandtab
}

plug "occivink/kakoune-expand" config %{
    declare-user-mode expand
    map global expand <c-[> '<esc>'
    map global expand <space> ':expand<ret>' -docstring 'expand more'
    map global user <space> ':expand; enter-user-mode -lock expand<ret>' -docstring 'enter expand mode'
}

# vlang support
plug "antono2/vlang.kak"

plug "gustavo-hms/luar"
plug "gustavo-hms/objetiva" config %{
    require-module objetiva
    # map global object h '<a-;>objetiva-case<ret>' -docstring case
    map global object m '<a-;>objetiva-matching<ret>' -docstring matching
    # map global normal <c-b> ':objetiva-case-move-previous<ret>'
    # map global normal <c-e> ':objetiva-case-move<ret>'
    # map global normal <c-w> ':objetiva-case-move<ret>'
    # map global normal <c-s-b> ':objetiva-case-expand-previous<ret>'
    # map global normal <c-s-e> ':objetiva-case-expand<ret>'
    # map global normal <c-s-w> ':objetiva-case-expand<ret>'
    declare-option -hidden str humps_saved_selection ""
    define-command -hidden -override hump-forward %{
        set local humps_saved_selection %val{selection_desc}
        objetiva-case-move
        try %{
            execute-keys 'Z<c-o><c-o>z<a-:><esc>'
        } catch %{
            select %opt{humps_saved_selection}
            echo -markup "{Error}no selections remaining"
        }
    }
    define-command -hidden -override hump-back %{
        set local humps_saved_selection %val{selection_desc}
        objetiva-case-move-previous
        try %{
            execute-keys 'Z<c-o><c-o>z<a-:><a-;><esc>'
        } catch %{
            select %opt{humps_saved_selection}
            echo -markup "{Error}no selections remaining"
        }
    }
    # map global normal <c-b> ':hump-back<ret>'
    # map global normal <c-e> ':hump-forward<ret>'
    # map global normal <c-w> ':hump-forward<ret>'
}

# surround (almost like helix but worse) (for some reason works)
plug "h-youhei/kakoune-surround" config %{
    declare-user-mode surround
    map global surround s ':surround<ret>' -docstring 'surround'
    map global surround r ':change-surround<ret>' -docstring 'replace'
    map global surround d ':delete-surround<ret>' -docstring 'delete'
    map global surround t ':select-surrounding-tag<ret>' -docstring 'select tag'
    map global normal \' ':enter-user-mode surround<ret>' -docstring 'surround'
    # putting this there so that <a-s> is not overrided (i'm sorry :c)
    # map global normal '<c-v>' '<a-s>'
    define-command -override -hidden -params 1 _select-surrounding-pair %{ execute-keys -with-maps "<a-a>%arg{1}<a-S>" }
    define-command -hidden -params 2 -override _change-surround %{ execute-keys "Z,r%arg{2}z),r%arg{1}" }
}

# select view (only visible text, not the entire buffer)
plug "Delapouite/kakoune-select-view" config %{
    map global normal <a-%> ':select-view<ret>'
}

# unified objects
plug "Delapouite/kakoune-text-objects" config %{
    map global normal q ':enter-user-mode selectors<ret>'
    map global normal <a-q> 'q'
}
plug "occivink/kakoune-vertical-selection"

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
            command = "/home/hotsadboi/thirdparty/v-analyzer/bin/v-analyzer"
            root_globs = ["v.mod", "mod.v", "main.v"]
        }
    }

    hook -group lsp-filetype-odin global BufSetOption filetype=odin %{
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
hook global BufSetOption filetype=(c|go|rust|haskell|ocaml|v|odin) %{
    # lsp-enable-window
    suplocon-enable-column
    expandtab
}

# autopairs
plug 'alexherbo2/auto-pairs.kak' config %{
    enable-auto-pairs
}

plug 'ABuffSeagull/kakoune-vue' noload

plug "ex.kak" config %{
    map global user e ':ls<ret>' -docstring 'open ex buffer'
}

plug "Yukaii/bookmarks.kak" config %{
    declare-user-mode mark

    map global user b ':enter-user-mode mark<ret>'
    map global mark l ':bookmarks-show-list<ret>'
    map global mark a ':bookmarks-add-prompt<ret>'
    map global mark 1 ':bookmarks-nav 1<ret>'
    map global mark 2 ':bookmarks-nav 2<ret>'
    map global mark 3 ':bookmarks-nav 3<ret>'
    map global mark 4 ':bookmarks-nav 4<ret>'
    map global mark 5 ':bookmarks-nav 5<ret>'
    map global mark 6 ':bookmarks-nav 6<ret>'
    map global mark 7 ':bookmarks-nav 7<ret>'
    map global mark 8 ':bookmarks-nav 8<ret>'
    map global mark 9 ':bookmarks-nav 9<ret>'
}

plug "csharp" noload
