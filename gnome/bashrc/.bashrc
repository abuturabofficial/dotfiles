#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Ignore case completion
bind 'set completion-ignore-case on'

#alias open="xdg-open"
alias make="make -j$(nproc)"
alias ninja="ninja -j$(nproc)"
alias n="ninja"
alias c="clear"
alias rmpkg="sudo pacman -Rsn"
alias cleanch="sudo pacman -Scc"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias update="sudo pacman -Syu"

# Cleanup orphaned packages
alias cleanup="sudo pacman -Rsn $(pacman -Qtdq)"

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Environment Variables
export PATH=~/.cargo/bin/:$PATH
export PATH=~/.npm-global/bin:$PATH
export PATH=~/.local/bin:$PATH
export EDITOR="nvim"
export BUNDLE_PATH=~/.gems

# some more ls aliases
alias ll='exa --long --all --icons --group-directories-first'
alias la='exa -a --icons --group-directories-first'
alias l='exa -1 --icons --group-directories-first'
alias ls='exa --icons --group-directories-first'
alias tree='exa --tree --icons --group-directories-first'
alias vim="nvim "
alias cp='cp -v --reflink=auto'
alias cat='bat'
alias rcp='rsync -v --progress'
alias rmv='rsync -v --progress --remove-source-files'
alias mv='mv -v'
alias rm='trash -v'
alias rmdir='rmdir -v'
alias ln='ln -v'
alias chmod="chmod -c"
alias chown="chown -c"
alias mkdir="mkdir -v"
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias sudo='sudo '
# alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"
# alias stow="stow -t ~/"

# command-not-found handler for ArchLinux, Bash Shell only
source /usr/share/doc/pkgfile/command-not-found.bash

__fzf_history_search() {
  # Use fc to list history, remove numbers, feed into fzf
  local selected
  selected=$(fc -rl 1 | fzf +s --tac | sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//')
  if [[ -n $selected ]]; then
    READLINE_LINE="$selected"        # put the command into current buffer
    READLINE_POINT=${#READLINE_LINE} # move cursor to end
  fi
}

# Bind Ctrl+R to our custom function
bind -x '"\C-r": __fzf_history_search'

# Bitwarden SSH agent
export SSH_AUTH_SOCK=/home/abuturab/.bitwarden-ssh-agent.sock

# Yazi shell wrapper
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Startship
eval "$(starship init bash)"

# Zoxide
eval "$(zoxide init bash)"
