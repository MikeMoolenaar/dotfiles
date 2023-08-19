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

zstyle ":omz:plugins:ssh-agent" quiet yes
plugins=(
git
aliases
dotnet
zsh-autosuggestions
zsh-syntax-highlighting
docker
ssh-agent
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
PROMPT_EOL_MARK='' # Remove percentage sign for partial lines (mainly happens with curl)

alias c="clear"
#alias ip="ifconfig | grep broadcast | awk '{print \$2}'"
alias s="source ~/.zshrc"
alias python="python3"
#vman() { vim <(man $1); } # Doesn't work anymore lol, just empties screen after a few seconds
cheat() { curl cheat.sh/$1; }
#alias upd="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && flatpak update -y"
alias upd="paru"
alias yay="paru"
alias jpwine="LANG='ja_JP.UTF8' wine"
alias lzd="sudo lazydocker"
alias esp="EDITOR=/usr/bin/vim espanso edit"
alias mount_storage="sudo mount -t ntfs3 /dev/sda2 /mnt/storage"
alias blb="bluetoothctl connect A0:D0:5B:A5:4E:74" # Soundbar
alias blh="bluetoothctl connect 38:18:4C:AE:8D:E1" # Headphones
alias bld="bluetoothctl connect C3:ED:90:B1:C5:61" # Desk
alias docker="sudo docker"
alias sit="bld && idasen-controller --move-to sit"
alias stand="bld && idasen-controller --move-to stand"
alias curltime="curl -s -w '\n\nTotal: %{time_total}s Code: %{response_code}\n' "
alias windows="sudo grub-reboot 'Windows 10 (on /dev/sdb1)'i && systemctl reboot"

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
installed() {
  echo "<== Pacman ==>"
  pacman -Qqett | sort
}

tv1() {
  # Enable flipping to prevent tearing
  nvidia-settings -l -a "AllowFlipping=1"
  xrandr --output HDMI-1 --mode 3840x2160 --rate 60 --above DP-2
  echo "TV connected"
}

tv0() {
  nvidia-settings -l -a "AllowFlipping=0"
  xrandr --output HDMI-1 --off
  echo "TV disconnected"
}

# Github copilot CLI
# eval "$(github-copilot-cli alias -- "$0")"

# Do not source on init because of init slowdowns 
alias init-nvm="source /usr/share/nvm/init-nvm.sh"

# Pipx places binaries in this folder
export PATH="$PATH:/home/mike/.local/bin"
