# Main colors
# declare-option str giga_balck 'rgb:080807'
# declare-option str black  'rgb:282726'
declare-option str black  'rgb:201f1e'
declare-option str gray_0  'rgb:333333'
declare-option str gray_1  'rgb:474747'
declare-option str gray_2  'rgb:4a4a4a'
declare-option str gray_3  'rgb:545454'
declare-option str gray_4  'rgb:5e5e5e'
declare-option str gray_5  'rgb:686868'
declare-option str gray_6  'rgb:727272'
declare-option str gray_7  'rgb:7c7c7c'
declare-option str gray_8  'rgb:868686'
declare-option str gray_9  'rgb:909090'
declare-option str gray_10 'rgb:9a9a9a'
declare-option str gray_11 'rgb:a4a4a4'
declare-option str gray_12 'rgb:aeaeae'
declare-option str gray_13 'rgb:b8b8b8'
declare-option str gray_14 'rgb:c2c2c2'
declare-option str gray_15 'rgb:cccccc'
declare-option str comment   'rgb:8f8b8c'
# declare-option str comment   'rgb:8a8886'
# declare-option str comment   'rgb:aeacaa'
declare-option str blue      'rgb:c0c2ca'
# declare-option str green     'rgb:a5aba3'
declare-option str green     'rgb:a5a7a3'
declare-option str yellow    'rgb:c4c2bb'
declare-option str red       'rgb:cbc3c0'
declare-option str test      'rgb:ff0000'
# declare-option str normal_cursor     ",+rgb"
declare-option str normal_cursor     "%opt{black},%opt{gray_15}+gb"
declare-option str insert_cursor     "%opt{black},%opt{blue}+gb"
declare-option str normal_psel       "%opt{black},%opt{gray_9}"
declare-option str normal_ssel       "%opt{black},%opt{gray_6}"
declare-option str unfocused_cursor  "%opt{black},%opt{gray_7}+gb"
declare-option str unfocused_psel    "%opt{black},%opt{gray_4}"
declare-option str unfocused_ssel    "%opt{black},%opt{gray_4}"


# Code faces
set-face global value      "%opt{gray_15}"
set-face global type       "%opt{yellow}"
set-face global variable   "%opt{gray_11}"
set-face global module     "%opt{blue}"
set-face global function   "%opt{blue}"
set-face global string     "%opt{green}"
set-face global keyword    "%opt{red}"
set-face global operator   "%opt{gray_10}"
set-face global attribute  "%opt{yellow}"
set-face global bracket    "%opt{gray_14}"
set-face global argument   "%opt{test}"
set-face global comma      "%opt{test}"
# set-face global search     ",+ud"
set-face global search     ",%opt{gray_1}"
set-face global constant   "%opt{test}"
set-face global comment    "%opt{comment}"
set-face global meta       "%opt{gray_10}"
set-face global builtin    "%opt{red}"
set-face global trailing   "default,%opt{gray_1}+g"
set-face global warning    "%opt{red}+b"

# Builtin faces                       FG              BG
set-face global Default            "%opt{gray_14},%opt{black}"
set-face global BufferPadding      "%opt{gray_2},%opt{black}"

set-face global PrimarySelection   "%opt{normal_psel}+bg"
set-face global PrimaryCursor      "%opt{normal_cursor}"
set-face global PrimaryCursorEol   "%opt{normal_cursor}"

set-face global SecondarySelection "%opt{normal_ssel}+bg"
set-face global SecondaryCursor    "%opt{black},%opt{gray_12}+g"
set-face global SecondaryCursorEol "%opt{black},%opt{gray_12}+g"

set-face global LineNumbers        "%opt{gray_4},%opt{black}"
set-face global LineNumberCursor   "%opt{gray_10},%opt{black}"
set-face global LineNumbersWrapped "%opt{black},%opt{black}"

set-face global MenuBackground     "%opt{gray_14},%opt{gray_1}"  # unselected
set-face global MenuForeground     "%opt{gray_1},%opt{gray_14}" # selected
set-face global MenuInfo           "%opt{gray_14},%opt{gray_0}+b" # autocomplete thingy

set-face global Information        "%opt{yellow},%opt{gray_2}" # that clippy box
set-face global Error              "%opt{black},%opt{red}+b"

set-face global StatusLine         "%opt{gray_13},%opt{gray_2}"
set-face global StatusLineMode     "%opt{gray_2},%opt{yellow}"
set-face global StatusLineInfo     "%opt{yellow},%opt{gray_2}"
set-face global StatusLineValue    "%opt{blue},%opt{gray_2}"
set-face global StatusCursor       "%opt{gray_1},%opt{gray_15}"
set-face global Prompt             "%opt{red},%opt{gray_2}"

set-face global MatchingChar       "%opt{gray_15},default+ib"
set-face global WrapMarker Whitespace

# Hightlight trailing spaces
add-highlighter -override global/trails regex \h+$ 0:trailing
add-highlighter -override global/matching show-matching

# Scrollbar (experimental)
set-option -add global ui_options terminal_scroll_bar=true
set-face global ScrollBarGutter    "%opt{gray_10},default"
set-face global ScrollBarHandle    "%opt{gray_14},%opt{gray_1}+b"

# Show indentation
set-face global Whitespace         "%opt{gray_1},default+bf"
set-face global WhitespaceIndent   Whitespace
add-highlighter -override global/indents show-whitespaces -lf ' ' -spc ' ' -nbsp ' ' -tab '⇒' -tabpad ' ' -indent '▏'
set-face global Column             ",%opt{gray_0}"
define-command -override suplocon-enable-column %{
    add-highlighter -override buffer/col column 81 Column
}

# Display line numbers
add-highlighter -override global/numbers number-lines -relative -cursor-separator '└' -hlcursor

# when entering normal mode
hook -group suplocon-colors global ModeChange pop:insert:normal %{
    add-highlighter -override global/trails regex \h+$ 0:trailing
    add-highlighter -override global/matching show-matching
    set-face window PrimaryCursor "%opt{normal_cursor}"
    set-face window PrimaryCursorEol "%opt{normal_cursor}"
}

# when entering insert mode
hook -group suplocon-colors global ModeChange push:normal:insert %{
    try %{ remove-highlighter global/trails }
    try %{ remove-highlighter global/matching }
    set-face window PrimaryCursor "%opt{insert_cursor}"
    set-face window PrimaryCursorEol "%opt{insert_cursor}"
}

hook -group suplocon-colors global FocusIn '.*' %{
    set-face window PrimaryCursor      "%opt{normal_cursor}"
    set-face window PrimaryCursorEol   "%opt{normal_cursor}"
    set-face window PrimarySelection   "%opt{normal_psel}+bg"
    set-face window SecondarySelection "%opt{normal_ssel}+bg"
    set-face window SecondaryCursor    "%opt{black},%opt{gray_12}+g"
}

hook -group suplocon-colors global FocusOut '.*' %{
    set-face window PrimaryCursor      "%opt{unfocused_cursor}"
    set-face window PrimaryCursorEol   "%opt{unfocused_cursor}"
    set-face window PrimarySelection   "%opt{unfocused_psel}+bg"
    set-face window SecondarySelection "%opt{unfocused_ssel}+bg"
    set-face window SecondaryCursor    "%opt{unfocused_ssel}+bg"
}
