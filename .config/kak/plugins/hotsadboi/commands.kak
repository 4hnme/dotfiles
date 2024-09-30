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

define-command custom-third-a-page-down -override %{
    execute-keys %sh{echo $(($kak_window_height/3))jvv}
}

define-command custom-third-a-page-up -override %{
    execute-keys %sh{echo $(($kak_window_height/3))kvv}
}

define-command custom-page-down -override %{
    execute-keys %sh{echo $(($kak_window_height))jvv}
}

define-command custom-page-up -override %{
    execute-keys %sh{echo $(($kak_window_height))kvv}
}
