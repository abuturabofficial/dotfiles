#   __        _ _     _                _                               _ 
#  / _\ __ _ (_|_) __| |   /\/\   __ _| |__  _ __ ___   ___   ___   __| |
#  \ \ / _` || | |/ _` |  /    \ / _` | '_ \| '_ ` _ \ / _ \ / _ \ / _` |
#  _\ \ (_| || | | (_| | / /\/\ \ (_| | | | | | | | | | (_) | (_) | (_| |
#  \__/\__,_|/ |_|\__,_| \/    \/\__,_|_| |_|_| |_| |_|\___/ \___/ \__,_|
#          |__/                                                          

# Setting Neovim as a Pager

export EDITOR='nvim'
export MANPAGER='nvim +Man!'
alias less=$PAGER
alias zless=$PAGER

# Setting aliases for Neovim

alias vim=nvim

## aliases for dotfiles git bare repo
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Setting aliases for config files quick access

alias init.vim='nvim ~/.config/nvim/init.vim'
alias i3conf='nvim ~/.config/i3/config'
alias i3blocks='nvim ~/.config/i3/i3blocks.conf'
# Setting aliases for 'exa' utility (a drop-in replacement for ls)

alias ls='exa --icons --git'
alias ll='exa -lh --icons --git'   # show long listing of all except ".."
alias lal='exa -lah --icons --git'
alias lah='exa --long --all --icons --git' # show long listing but no hidden dotfiles except "."

alias cat='bat'
alias sudo='sudo '
alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'
alias ..='cd ..'


# For when keys break
alias archlinx-fix-keys="sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys"

