#!/bin/sh

cmd z %{{
	result="$(zoxide query --exclude $PWD $@ | sed 's/\\/\\\\/g;s/"/\\"/g')"
	lf -remote "send $id cd \"$result\""
}}

cmd zi ${{
	result="$(zoxide query -i | sed 's/\\/\\\\/g;s/"/\\"/g')"
	lf -remote "send $id cd \"$result\""
}}

cmd on-cd &{{
        zoxide add "$PWD"
}}
