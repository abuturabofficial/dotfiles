#   __        _ _     _                _                               _ 
#  / _\ __ _ (_|_) __| |   /\/\   __ _| |__  _ __ ___   ___   ___   __| |
#  \ \ / _` || | |/ _` |  /    \ / _` | '_ \| '_ ` _ \ / _ \ / _ \ / _` |
#  _\ \ (_| || | | (_| | / /\/\ \ (_| | | | | | | | | | (_) | (_) | (_| |
#  \__/\__,_|/ |_|\__,_| \/    \/\__,_|_| |_|_| |_| |_|\___/ \___/ \__,_|
#          |__/                                                          

pfetch
# The following lines were added by compinstall
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '' '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 1
zstyle :compinstall filename '/home/abuturab/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v
# End of lines configured by zsh-newuser-install
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
## Export Paths
export PATH=~/.emacs.d/bin/:$PATH
export PATH=~/.npm-global/bin/:$PATH
export PATH=~/.cargo/bin/:$PATH
# Aliases
source ~/.config/aliases.zshrc

# remembeing the recent directories
#autoload -Uz add-zsh-hook
#
#DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
#if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
#	dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
#	[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
#fi
#chpwd_dirstack() {
#	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
#}
#add-zsh-hook -Uz chpwd chpwd_dirstack
#
#DIRSTACKSIZE='20'
#
#setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
#

# pacman -F command not found hander
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=(
        ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
    )
    if (( ${#entries[@]} ))
    then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}"
        do
            # (repo package version file)
            local fields=(
                ${(0)entry}
            )
            if [[ "$pkg" != "${fields[2]}" ]]
            then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
}

## Fish like syntax highlighting and auto-suggestons
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS


## pkgfile command not found handler 
source /usr/share/doc/pkgfile/command-not-found.zsh

## Avoiding duplicates in the .histfile
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

## Speedy keys
xset r rate 300 50

## This reverts the +/- operators.
setopt PUSHD_MINUS
# starship prompt and smart cd completion
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
