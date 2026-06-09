declare-option -hidden str-list hump_selections ""

define-command hump-select -hidden -override %{
    try %{
        select %opt{hump_selections}
    } catch %{
        fail 'no selections remaining'
    }
    execute-keys ":<esc>" # this is only here to get rid of an annoying message in the status line
}

# # TODO: sometimes crashes on %{ (see the inner catch branch)
# # ----- hump end --------------------------------------------------------------
# define-command hump-extend-end -override %{
#     try %{
#         evaluate-commands -draft %{
#             # execute-keys "?([-_\h\s\d]?)([A-Z]?[a-z]+)|([A-Z]+)(?=[-_\h\s\d])"
#             try %{
#                 execute-keys "?([-_\h\s\d]?)([A-Z]?[a-z]+)|([A-Z]+)(?=[-_\h\s\d])|[-_A-Z\h\s]"
#                 execute-keys "<ret>_"
#             } catch %{
#                 #             v this is such a hack. doesn't error out, also doesn't work that great
#                 execute-keys "e?([-_\h\s\d]?)([A-Z]?[a-z]+)|([A-Z]+)(?=[-_\h\s\d])|[-_A-Z\h\s]"
#                 execute-keys "<ret>_"
#             }
#             set-option global hump_selections %val{selection_desc}
#         }
#         hump-select
#     } catch %{
#         fail 'no selections remaining'
#     }
# }

# define-command hump-end -override %{
#     evaluate-commands -draft %{
#         try %{
#             execute-keys ';s[-_A-Z\h\s]<ret>'
#             execute-keys 'l:hump-extend-end<ret>'
#         } catch %{
#             try %{
#                 execute-keys ';s\b[a-zA-Z]<ret>'
#                 execute-keys ':hump-extend-end<ret>'
#             } catch %{
#                 execute-keys 'l:hump-extend-end<ret>'
#             }
#         }
#         set-option global hump_selections %val{selection_desc}
#     }
#     hump-select
# }

# # ----- hump word -------------------------------------------------------------
# define-command hump-extend-word -override %{
#     try %{
#         evaluate-commands -draft %{
#             execute-keys "?([A-Z]+[-_\h]?)|([a-z]+[-_\h]?)|.(?=[-_A-Z\h\s])<ret>"
#             set-option global hump_selections %val{selection_desc}
#         }
#         hump-select
#     } catch %{
#         fail 'no selections remaining'
#     }
# }

# define-command hump-word -override %{
#     evaluate-commands -draft %{
#         try %{
#             execute-keys ';s[-_A-Z\h\s]<ret>'
#             execute-keys 'l:hump-extend-word<ret>'
#         } catch %{
#             try %{
#                 execute-keys ';s\b[a-zA-Z]<ret>'
#                 execute-keys ':hump-extend-word<ret>'
#             } catch %{
#                 execute-keys "l:hump-extend-word<ret>"
#             }
#         }
#         set-option global hump_selections %val{selection_desc}
#     }
#     hump-select
# }

# # ----- hump back -------------------------------------------------------------
# define-command hump-extend-back -override %{
#     try %{
#         evaluate-commands -draft %{
#             execute-keys "<a-?>(?<=[-_\h\s])(([-_\h\s]?)([A-Z]?[a-z]+))|([A-Z]+)"
#             execute-keys '<ret>_' # if not in a separate command, it fucking dies lmao
#             set-option global hump_selections %val{selection_desc}
#         }
#         hump-select
#     } catch %{
#         fail 'no selections remaining'
#     }
# }

# # no extend ??
# define-command hump-back-hsb -override %{
#     evaluate-commands -draft %{
#         try %{
#             execute-keys ';s[-_A-Z\h\s]<ret>'
#             execute-keys 'h:hump-extend-back<ret>'
#         } catch %{
#             try %{
#                 execute-keys ';s\b[a-zA-Z]\b<ret>'
#                 execute-keys ':hump-extend-back<ret>'
#             } catch %{
#                 execute-keys "h:hump-extend-back<ret>"
#             }
#         }
#         set-option global hump_selections %val{selection_desc}
#     }
#     hump-select
# }

# # ----- hump object -----------------------------------------------------------
# define-command hump-inside -override %{
#     evaluate-commands -draft %{
#         try %{
#             try %{
#                 execute-keys ";s((?<=[-_A-Z\h\s])|\b)[a-z]<ret>"
#                 execute-keys "<ret>"
#                 execute-keys ":hump-extend-end<ret>;:hump-extend-back<ret><a-:>"
#             } catch %{
#                 execute-keys "l:hump-extend-back<ret>;:hump-extend-end<ret>"
#             }
#         } catch %{
#             fail 'no selections remaining'
#         }
#         set-option global hump_selections %val{selection_desc}
#     }
#     hump-select
# }

# define-command hump-around -override %{
#     evaluate-commands -draft %{
#         try %{
#             try %{
#                 execute-keys ";s((?<=[-_A-Z\h\s])|\b)[a-z]<ret>"
#                 execute-keys "<ret>"
#                 execute-keys ":hump-extend-word<ret>"
#             } catch %{
#                 execute-keys "l:hump-extend-back<ret>;:hump-extend-word<ret>"
#             }
#         } catch %{
#             fail 'no selections remaining'
#         }
#         set-option global hump_selections %val{selection_desc}
#     }
#     hump-select
# }
# camelCase

define-command hump-save -hidden -override %{
    set-option window hump_selections %val{selections_desc}
}

define-command hump-end -override %{
    evaluate-commands -draft %{
        execute-keys ';'
        try %{
            execute-keys -draft L <a-k> ([^A-Z][A-Z] | [^\W_][\W_] | [\W_][^\W_]) \z <ret>
            execute-keys l
        }
        eak-grow-chunk-right
        hump-save
    }
    hump-select
}

define-command hump-word -override %{
    evaluate-commands -draft %{
        execute-keys ';'
        try %{
            execute-keys -draft s [\W_] <ret>
            execute-keys l
        }
        eak-grow-chunk-right
        try %{
            execute-keys -draft l s [^\n] <ret>
            # execute-keys <?> [^\w\n]* <ret>
            execute-keys <?> [\h-_] * <ret>
        }
        hump-save
    }
    hump-select
}

define-command hump-back-hsb -override %{
    evaluate-commands -draft %{
        execute-keys ';'
        try %{
            execute-keys -draft H s ([^A-Z][A-Z] | [\W_][^\W_] | [A-Z][^A-Z]) <ret>
            execute-keys h
        }
        eak-grow-chunk-left
        hump-save
    }
    hump-select
}

define-command hump-extend-end -override %{
    evaluate-commands -draft %{
        execute-keys L
        eak-extend-chunk-fd
        hump-save
    }
    hump-select
}

define-command hump-extend-word -override %{
    evaluate-commands -draft %{
        eak-extend-chunk-fd
        try %{
            execute-keys -draft l s [^\n] <ret>
            execute-keys <?> [^\w\n]* <ret>
        }
        hump-save
    }
    hump-select
}

define-command hump-extend-back -override %{
    evaluate-commands -draft %{
        eak-extend-chunk-bd
        hump-save
    }
    hump-select
}

define-command hump-inside -override %{
    evaluate-commands -draft %{
        eak-grow-chunk-left
        eak-grow-chunk-right
        hump-save
    }
    hump-select
}

define-command hump-around -override %{
    evaluate-commands -draft %{
        eak-grow-chunk-left
        eak-grow-chunk-right
        try %{
            execute-keys -draft "s[\W_]"
            execute-keys L
        }
        hump-save
    }
    hump-select
}

define-command hump -override %{
    evaluate-commands %sh{
        case "$kak_opt_objects_last_mode" in
        # around
        '<a-a>') k=':hump-around<ret>' ;;
        # inside
        '<a-i>') k=':hump-inside<ret>' ;;
        esac
        [ -n $k ] && echo "execute-keys $k"
    }
    # hump-select
}
