# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
export PATH=$PATH:/usr/local/go/bin:$HOME/.dotnet/tools
export TRANSMISSION_WEB_HOME=$HOME/Documents/transmission/public_html

# . /usr/share/autojump/autojump.zsh
# [[ -s /home/hotsadboi/.autojump/etc/profile.d/autojump.sh ]] && source /home/hotsadboi/.autojump/etc/profile.d/autojump.sh

autoload -U compinit && compinit -u

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="simple"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"
export TERM=st-256color

case $TERM in xterm*)
    precmd () {print -Pn "\e]0;%~\a"}
    ;;
esac

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
# setopt inc_append_history
unsetopt share_history


function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}


# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode gh)
export VI_MODE_SET_CURSOR=true

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export EDITOR='kak'
export BROWSER='zen'
export TERMINAL='st'
export AI_PROVIDER='duckduckgo'
export PATH=$PATH:/home/hotsadboi/.cargo/bin
export PATH=$PATH:/home/hotsadboi/.local/bin
export PATH=$PATH:/home/hotsadboi/go/bin
export PATH=$PATH:/home/hotsadboi/thirdparty/odin

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias kak="pkill lsp || true && kak"
alias uwu="uwufetch"

# autojump but smarter
eval "$(zoxide init zsh)"
alias cd="z"

# custom nice-looking prompt (sucks sometimes)
eval "$(starship init zsh)"
eval "$(dircolors)"
eval "$(opam env)"

# delete with c-w without saving the deleted word into system clipboard
bindkey '^W' backward-delete-word
