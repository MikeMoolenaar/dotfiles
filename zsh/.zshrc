# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export EDITOR=/bin/vim
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
git
aliases
dotnet
zsh-autosuggestions
zsh-syntax-highlighting
docker
)

source $ZSH/oh-my-zsh.sh

# Import zcalc 
# e = non interactive
# f = always use floating point numbers
autoload zcalc
calcc() { if [[ $# > 0 ]]; then zcalc -e -f "$@"; else zcalc; fi }
alias calc="noglob calcc"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


unsetopt HIST_VERIFY # Disable preview when typing !!, just execute the command
setopt histignorespace # Commands starting with space will not be saved to history


alias c="clear"
#alias ip="ifconfig | grep broadcast | awk '{print \$2}'"
alias s="source ~/.zshrc"
alias python="python3"
#vman() { vim <(man $1); } # Doesn't work anymore lol, just empties screen after a few seconds
cheat() { curl cheat.sh/$1; }
#alias upd="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && flatpak update -y"
alias upd="paru && flatpak update -y"
alias jpwine="LANG='ja_JP.UTF8' wine"
alias lzd="sudo $HOME/.local/bin/lazydocker"
alias esp="EDITOR=/usr/bin/vim espanso edit"
alias yay="paru"
alias mount_storage="sudo mount -t ntfs3 /dev/sda2 /mnt/storage"

mkcdir () {
    mkdir -p -- "$1" &&
       cd -P -- "$1"
}

bluetooth() {
#    sudo systemctl start bluetooth
    blueman-manager > /dev/null 2>&1 &
}

gitopen() {
  git remote -v | head -n 1 | awk -F " " '{print $2}' | sed 's/\.git//g' | sed 's/git\@github\.com:/https:\/\/github\.com\//g' | xargs firefox --new-tab
}

# Show installed packages excluding the default ones
# Source: https://unix.stackexchange.com/a/409903
installed() {
  comm -23 <(pacman -Qqett | sort) <(pacman -Qqg base-devel | sort | uniq)
}



# Load Angular CLI autocompletion.
# source <(ng completion script)

# Github copilot CLI
# eval "$(github-copilot-cli alias -- "$0")"
source /usr/share/nvm/init-nvm.sh
