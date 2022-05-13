# .bashrc

# Add this lines at the top of .bashrc:
# [[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --noattach

# set vi mode
# if [[ $- == *i* ]]; then # in interactive session
#   set -o vi
# fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Path variables
export PATH="~/.local/bin/lvim:$PATH"
export PATH="~/.npm-global/bin:$PATH"
# export PATH="~/.local/bin/:$PATH"
export PATH="~/.cargo/bin:$PATH"
export PATH="~/.emacs.d/bin/:$PATH"
# export LIBVA_DRIVER_NAME=iHD
# export VDPAU_DRIVER=va_gl

# Aliases
alias "emacs-kill"="emacsclient -e '(kill-emacs)'"
alias "emc"="emacsclient"
alias "emt"="emacsclient -nw"
alias '..'='z ..'

## Speedy keys
xset r rate 400 50

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
# to stop the duplicate entries in the history
export HISTCONTROL=erasedups

# Bash powerline script
# source ~/.config/bash/bash-powerline.sh

# Add this line at the end of .bashrc:
# [[ ${BLE_VERSION-} ]] && ble-attach

function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# Zoxide
eval "$(zoxide init bash)"
