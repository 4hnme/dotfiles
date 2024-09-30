# meliora theme for Kakoune

# Main colors
declare-option str c_white_sec 'rgb:c2b4a8' #secondary_white from helix
declare-option str c_black     'rgb:1c1917' #m_bg0
declare-option str c_dark      'rgb:24201e' #m_bg1
declare-option str c_gray_1    'rgb:2a2522' #m_bg2
declare-option str c_gray_2    'rgb:302a27' #m_bg4
declare-option str c_white_3   'rgb:685c55' #m_white3
declare-option str c_white_2   'rgb:9a8d84' #m_white2
declare-option str c_white_1   'rgb:b8aea8' #m_white1
declare-option str c_white_0   'rgb:d6d0cd' #m_white0
# declare-option str c_blue      'rgb:a09bac' #m_blue
declare-option str c_blue      'rgb:9e96b6' #m_blue
declare-option str c_aqua      'rgb:98acc8' #m_light_blue
declare-option str c_khaki     'rgb:bcaa9a' #m_khaki
declare-option str c_green     'rgb:b6b696' #m_green
declare-option str c_comment   'rgb:727246' #m_dark_green
declare-option str c_orange    'rgb:cdb899' #m_orange
declare-option str c_pink      'rgb:eabab5' #m_pink
declare-option str c_red       'rgb:d4a1a1' #m_red
declare-option str c_purple    'rgb:b098c8' #m_light_purple because c_purple is c_green for some reason
declare-option str c_yellow    'rgb:c4b392' #m_yellow
declare-option str c_test      'rgb:ff0000' #shit

# Special colors
declare-option str ssel        'rgb:493938'
declare-option str trailing_spaces "default,%opt{ssel}+F"

# Code faces
set-face global value      "%opt{c_white_0}"
set-face global type       "%opt{c_yellow}"
set-face global variable   "%opt{c_yellow}"
set-face global module     "%opt{c_blue}"
set-face global function   "%opt{c_blue}"
set-face global string     "%opt{c_green}"
set-face global keyword    "%opt{c_red}"
set-face global operator   "%opt{c_white_0}"
set-face global attribute  "%opt{c_white_2}"
set-face global bracket    "%opt{c_white_0}"
set-face global argument   "%opt{c_orange}"
set-face global comma      "%opt{c_white_0}"
set-face global constant   "%opt{c_test}"
set-face global comment    "%opt{c_comment}"
set-face global meta       "%opt{c_white_2}"
set-face global builtin    "%opt{c_orange}"
set-face global trailing   "%opt{trailing_spaces}"
set-face global warning    "%opt{c_pink}+b"

# Markup faces
set-face global title  "%opt{c_pink}"
set-face global header "%opt{c_orange}"
set-face global bold   "%opt{c_pink}"
set-face global italic "%opt{c_purple}"
set-face global mono   "%opt{c_green}"
set-face global block  "%opt{c_khaki}"
set-face global link   "%opt{c_purple}"
set-face global bullet "%opt{c_green}"
set-face global list   "%opt{c_white_0}"

# Different mode colors
declare-option str normal_cursor     "%opt{c_dark},%opt{c_white_1}+g"
declare-option str insert_cursor     "%opt{c_dark},%opt{c_blue}+g"
declare-option str normal_cursor_eol "%opt{c_dark},%opt{c_yellow}+g"
declare-option str insert_cursor_eol "%opt{c_dark},%opt{c_aqua}+g"
declare-option str normal_psel       "default,rgb:604945"
declare-option str insert_psel       "default,rgb:454960"
declare-option str normal_ssel       "default,rgb:483837"
declare-option str insert_ssel       "default,rgb:373848"

# Hightlight trailing spaces
add-highlighter -override global/trails regex \h+$ 0:trailing

# Display line numbers
add-highlighter -override global/numbers number-lines -relative -cursor-separator '└' -hlcursor

# Builtin faces                       FG              BG
set-face global BufferPadding      "%opt{c_gray_1},default"
set-face global Default            "%opt{c_white_0},default"
set-face global PrimarySelection   "%opt{normal_psel}+b"
set-face global SecondarySelection "%opt{normal_ssel}+b"
set-face global PrimaryCursor      "%opt{normal_cursor}"
set-face global SecondaryCursor    "%opt{c_dark},%opt{c_white_3}+g"
set-face global PrimaryCursorEol   "%opt{normal_cursor_eol}"
set-face global SecondaryCursorEol "%opt{c_dark},%opt{c_white_3}+g"
set-face global LineNumbers        "%opt{c_white_3},%opt{c_black}"
set-face global LineNumberCursor   "%opt{c_white_2},%opt{c_black}"
set-face global LineNumbersWrapped "%opt{c_black},%opt{c_black}"
set-face global MenuBackground     "%opt{c_white_2},%opt{c_gray_1}"   #unselected
set-face global MenuForeground     "%opt{c_dark},%opt{c_khaki}" #selected
set-face global MenuInfo           "%opt{c_white_1},%opt{c_gray_1}+b"
set-face global Information        "%opt{c_yellow},%opt{c_gray_1}" #that clippy thing
set-face global Error              "%opt{c_black},%opt{c_red}+b"
set-face global StatusLine         "%opt{c_white_2},%opt{c_gray_1}"
set-face global StatusLineMode     "%opt{c_gray_1},%opt{c_yellow}"
set-face global StatusLineInfo     "%opt{c_khaki},%opt{c_gray_1}"
set-face global StatusLineValue    "%opt{c_blue},%opt{c_gray_1}"
set-face global StatusCursor       "%opt{c_dark},%opt{c_white_1}"
set-face global Prompt             "%opt{c_orange},%opt{c_black}"
set-face global MatchingChar       "%opt{c_blue},%opt{c_black}"
set-face global Whitespace         "%opt{c_white_sec},%opt{c_black}"
set-face global WrapMarker Whitespace

# Different mode hooks
# when entering normal mode
hook -group meliora-theme global ModeChange pop:insert:normal %{
    add-highlighter -override global/trails regex \h+$ 0:trailing
    # set-face global SecondarySelection "%opt{normal_ssel}+b"
    # set-face global PrimarySelection "%opt{normal_psel}+b"
    set-face global PrimaryCursor "%opt{normal_cursor}"
    set-face global PrimaryCursorEol "%opt{normal_cursor_eol}"
}

# when entering insert mode
hook -group meliora-theme global ModeChange push:normal:insert %{
    try %{ remove-highlighter global/trails }
    # set-face global SecondarySelection "%opt{insert_ssel}+b"
    # set-face global PrimarySelection "%opt{insert_psel}+b"
    set-face global PrimaryCursor "%opt{insert_cursor}"
    set-face global PrimaryCursorEol "%opt{insert_cursor}"
}
