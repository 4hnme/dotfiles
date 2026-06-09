define-command drag-up -override -docstring "drag current selection up one line" %{
    # evaluate-commands -save-regs \" %{
        try %{
            execute-keys -save-regs \"# %sh{
                if [ $kak_cursor_line = $kak_buf_line_count ]; then
                    echo "xdP,"
                else
                    echo "xdkP,"
                fi
            }
        } catch %{
            echo "couldn't drag up"
        }
    # }
}

define-command drag-down -override -docstring "drag current selection down one line" %{
    try %{
        execute-keys -save-regs \"# 'xdp'
    } catch %{
        echo "couldn't drag down"
    }
}

define-command next-matching-pair -override -docstring "go to the next sequence enclosed by matching characters, truly" %{
    evaluate-commands %{
        try %{
            execute-keys -draft '<a-:>lm'
            execute-keys '<a-:>lm<a-:>'
        } catch %{
            echo "no parenthesis ahead"
        }
    }
}


define-command prev-matching-pair -override -docstring "go to the previous sequence enclosed by matching characters, truly" %{
    evaluate-commands %{
        try %{
            execute-keys -draft '<a-:><a-;>h<a-m>'
            execute-keys '<a-:><a-;>h<a-m><a-:>'
        } catch %{
            echo "no parenthesis back"
        }
    }
}

define-command extend-with-next-matching-pair -override -docstring "add the next sequence enclosed by matching characters to your selections" %{
    evaluate-commands -save-regs ^ %{
        execute-keys %sh{
            char=$(printf "\x$(printf %x $kak_cursor_char_value)")
            pairs="$kak_opt_matching_pairs"
            if [[ "$pairs" == *"$char"* ]]; then
                printf "<Z>,:next-matching-pair<ret><a-Z>az<esc>"
            else
                printf ":next-matching-pair<ret>"
            fi
        }
    }
}

define-command extend-with-prev-matching-pair -override -docstring "add the previous sequence enclosed by matching characters to your selections" %{
    evaluate-commands -save-regs ^ %{
        execute-keys %sh{
            char=$(printf "\x$(printf %x $kak_cursor_char_value)")
            pairs="$kak_opt_matching_pairs"
            if [[ "$pairs" == *"$char"* ]]; then
                printf "<Z>,:prev-matching-pair<ret><a-Z>az<esc>"
            else
                printf ":prev-matching-pair<ret>"
            fi
        }
    }
}

define-command select-next-word -override -docstring "select next word" %{
    try %{
        execute-keys "e<a-i>w"
    } catch %{
        try %{
            execute-keys ":select-next-word<ret>"
        } catch %{
            echo "nothing left to select"
        }
    }
}

define-command select-prev-word -override -docstring "select previous word" %{
    try %{
        execute-keys "b<a-i>w<a-;>"
    } catch %{
        try %{
            execute-keys ":select-prev-word<ret>"
        } catch %{
            echo "nothing left to select"
        }
    }
}

define-command add-next-word -override -docstring "add next word in multicursor selection" %{
    evaluate-commands -save-regs ^ %{
        execute-keys %sh{
            if [ "$kak_selection_lengths" = "1" ]; then
                printf ":select-next-word<ret>"
            else
                printf "Z,:select-next-word<ret><a-Z>az<esc>"
            fi
        }
    }
}

define-command add-prev-word -override -docstring "add previous word in multicursor selection" %{
    evaluate-commands -save-regs ^ %{
        execute-keys %sh{
            if [[ "$kak_selection_lengths" = "1" ]]; then
                printf ":select-prev-word<ret>"
            else
                printf "Z,:select-prev-word<ret><a-Z>az<esc>"
            fi
        }
    }
}

define-command reverse-selections -override -docstring "reverse 'order' of multiple selections" %{
    evaluate-commands -save-regs ^\" %{
        set-register dquote %sh{
            printf " $kak_reg_dot" | sed 's/\"/\\"/g'
        }
        execute-keys <a-:>
        evaluate-commands %sh{
            reversed=$($kak_config/plugins/hotsadboi/reverse/reverse "$kak_reg_dquote" "$kak_selections_desc")
            if [ $? = 0 ]; then
                printf "set-register dquote $reversed\nexec R" > /tmp/hotsadboi-rev
            else
                printf "echo 'error handling command'" > /tmp/hotsadboi-rev
            fi
        }
        source /tmp/hotsadboi-rev
    }
}

define-command reverse-chars -override -docstring "reverse order of chars in selection" %{
    evaluate-commands -save-regs ^\" %{
        execute-keys %sh{
            printf "|tac --regex -s'.'<ret>"
        }
    }
}

define-command respect-scrolloff -override -hidden %{
    execute-keys vjvk # here to update the view ¯\_(ツ)_/¯
    execute-keys %sh{
        set -- $kak_window_range
        visible_top=$1
        visible_bottom=$(($1 + $3 - 1))
        scrolloff=$((${kak_opt_scrolloff%%,*}))
        if [ $scrolloff -gt $(($kak_window_height/2)) ]; then
            echo ":echo -markup {Error}scrolloff is greater than half of the window. please reconsider<ret>"
            exit
        fi
        dtop=$(($kak_cursor_line - $visible_top))
        if [ $scrolloff -gt $dtop ]; then
            step=$((scrolloff - $dtop))
            echo -n "$step"vk
            visible_bottom=$((visible_bottom - $step))
        fi
        dbot=$(($visible_bottom - $kak_cursor_line))
        if [ $scrolloff -gt $dbot ]; then
            step=$(($scrolloff - $dbot))
            echo -n "$step"vj
            visible_bottom=$((visible_bottom - $step))
        fi
        padding=$(($visible_bottom - $kak_buf_line_count))
        if [ $padding -gt $scrolloff ]; then
            echo -n "$(($padding - $scrolloff))vk"
        fi
    }
}

define-command custom-half-a-page-down -override %{
    execute-keys %sh{
        lines=$(($kak_window_height/2))
        if [ $kak_count -gt 0 ]; then
            lines=$(($lines * $kak_count))
        fi
        echo -n "$lines"j"$lines"vjgi
    }
    respect-scrolloff
}

define-command custom-half-a-page-up -override %{
    # execute-keys %sh{echo $(($kak_window_height/2))kgi}
    execute-keys %sh{
        lines=$(($kak_window_height/2))
        if [ $kak_count -gt 0 ]; then
            lines=$(($lines * $kak_count))
        fi
        echo "$lines"k"$lines"vkgi
    }
    respect-scrolloff
}

define-command custom-page-down -override %{
    execute-keys %sh{echo $(($kak_window_height))jvv}
}

define-command custom-page-up -override %{
    execute-keys %sh{echo $(($kak_window_height))kvv}
}

define-command open-config -override -docstring "Open current config file" %{
    evaluate-commands e "%val{config}/kakrc"
}

define-command cd-config-folder -override -docstring "Change PWD to kakoune config directory" %{
    evaluate-commands cd "%val{config}"
}

define-command dup-line -override -docstring "Duplicate current line" %{
    execute-keys -save-regs \"^ "ZxyPz"
}

define-command switch-search-highlight -override %{
    try %{
        remove-highlighter window/search
    } catch %{
        add-highlighter window/search dynregex '%reg{/}' 0:search
    }
}

define-command scratch-buffer -override %{
    try %{
        execute-keys ':buffer *scratch*<ret>'
    } catch %{
        execute-keys ':edit -scratch *scratch*<ret>'
    }
}

define-command selection-info -override %{
    echo %sh{
        echo -n "$kak_selections" | wc -l -w | awk '{printf "selected %d lines and %d words", $1, $2}'
    }
}

# TODO: comments completely and utterly break this
# define-command -override autoindent %{
#     evaluate-commands -save-regs '"^i' %{
#         try %{ disable-auto-pairs }

#         # save selection to register i
#         execute-keys 'x"iZ'

#         # unindent
#         try %{
#             execute-keys '"_s^[ \t]+<ret><a-d>'
#         }

#         # escape backslashes
#         execute-keys '"iz'
#         try %{
#             execute-keys 's\\<ret>i\<esc>'
#         }

#         # retype everything with indentation hooks enables
#         execute-keys '"iz'
#         execute-keys -with-hooks "<a-o><a-d>ko%sh{ echo ""$kak_selection"" | sed -e 's/</<lt>/g' }<del><del><esc>:select %val{selection_desc}<ret><a-x>"

#         try %{ enable-auto-pairs }
#     }
# }

define-command indent-and-append -override %{
    execute-keys -with-hooks %sh{
        if [ "$kak_cursor_char_value" = "10" ] && [ "$kak_cursor_column" = "1" ] && [ "$kak_cursor_line" != "1" ]; then
            if [ "$kak_cursor_line" = "$kak_buf_line_count" ]; then
                printf "<a-d>o"
            else
                printf "<a-d>ko"
            fi
        else
            printf "<s-a>"
        fi
    }
}

define-command -override autoindent %{
    evaluate-commands -save-regs '"^/wicp' %{
        set-register p '' # for safety
        # try %{ disable-auto-pairs }
        try %{ remove-hooks global 'twos.*' }

        set-register w %val{selections_desc} # and WHOLE selection to register w. otherwise removing comments will break the mark
        # save selection to register i
        execute-keys '<a-:>xH"iZ'

        # save and delete comments (c for contents, p for position)
        try %{
            # set-register slash "(^[ \t]*%opt{comment_line}[^\n]*\n)|((?<!\^)[ \t]*%opt{comment_line}[^\n]*)"
            set-register slash "(^[ \t]*%opt{comment_line}[^\n]*\n)"
            execute-keys "s<ret>"
            set-register c %val{selections}
            execute-keys "<a-d>"
            set-register p %val{selections_desc}
        }
        execute-keys '"iz'

        # unindent
        try %{
            execute-keys '"_s^[ \t]+<ret><a-d>'
        }
        execute-keys '"iz'

        # escape backslashes
        try %{
            execute-keys 's\\<ret>i\<esc>'
        }
        execute-keys '"iz'

        # retype everything with indentation hooks enables
        # execute-keys -with-hooks "<a-o><a-O><a-d>ko<backspace>%sh{ echo ""$kak_selection"" | sed -e 's/</<lt>/g' }<del><del><esc>:select %val{selection_desc}<ret><a-x>"
        # execute-keys -with-hooks "<a-d>:indent-and-append<ret>%sh{ echo ""$kak_selection"" | sed -e 's/</<lt>/g' }<esc>:select %val{selection_desc}<ret>"
        execute-keys -with-hooks "<a-d>:indent-and-append<ret>%sh{ echo ""$kak_selection"" | sed -e 's/</<lt>/g' }<esc>"

        # restore comments
        try %{
            select %reg{p}
            execute-keys '"cP'
        }
        select %reg{w}

        try %{ twos-register-defaults }
        # try %{ enable-auto-pairs }
    }
}

define-command -override foo %{
    execute-keys %sh{ printf '%s %s\n' "$kak_session" "$kak_client" > /tmp/kak_scroll.fifo }
}
