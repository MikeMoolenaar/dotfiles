# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export FLYCTL_INSTALL="/home/mike/.fly"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH=$PATH:$(go env GOPATH)/bin
export PATH="$FLYCTL_INSTALL/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:/home/mike/.dotnet/tools"
export MANPAGER='nvim +Man!'
export EDITOR=/bin/nvim
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export UPDATE_ZSH_DAYS=45
export DISABLE_UPDATE_PROMPT=true # Always update oh-my-zsh

source .zshrc-personal 2> /dev/null

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
bindkey '^ ' autosuggest-accept # Ctrl + Space to accept suggestion

unsetopt HIST_VERIFY # Disable preview when typing !!, just execute the command
setopt histignorespace # Commands starting with space will not be saved to history
PROMPT_EOL_MARK='' # Remove percentage sign for partial lines (mainly happens with curl)

# Aliases
alias c="clear"
alias s="source ~/.zshrc"
alias r="ranger"
alias g="gitui"
alias v="nvim"
woops() { trap 'zsh -i' INT }
alias sudovim="sudo -Es  nvim"
alias vim="nvim"
alias python="python3"
cheat() { curl cheat.sh/$1; }
alias yay="paru"
alias parus="paru -S"
alias parur="paru -R"
alias jpwine="LANG='ja_JP.UTF8' wine"
alias lzd="sudo lazydocker"
alias esp="espanso edit"
alias disk_usage="du -h | sort -hr | head -n 30"
alias mountstorage="sudo mount -t ntfs3 /dev/sda2 /mnt/storage"
alias blb="bluetoothctl disconnect; bluetoothctl connect A0:D0:5B:A5:4E:74" # Soundbar
alias blh="bluetoothctl disconnect; bluetoothctl connect 38:18:4C:AE:8D:E1" # Headphones
alias bld="bluetoothctl connect C3:ED:90:B1:C5:61" # Desk
alias docker="sudo docker"
alias sit="bld && linak-controller --move-to sit" # Requires "pipx install linak-controller"
alias stand="bld && linak-controller --move-to stand"
alias curltime="curl -Ls --output /dev/null -w '\n\nTotal: %{time_total}s Code: %{response_code}\n' "
alias windows="sudo grub-reboot 'Windows 10 (on /dev/sdb1)' && systemctl reboot"
zv() { z $1 && nvim .; }
alias ziv="zi && nvim ."
alias cs=csharprepl


mkcdir() {
    mkdir -p -- "$1" &&
       cd -P -- "$1"
}

gitopen() {
  git remote -v | head -n 1 | awk -F " " '{print $2}' | sed 's/\.git//g' | sed 's/git\@github\.com:/https:\/\/github\.com\//g' | xargs firefox --new-tab &
}

# Show installed packages
installed() {
  pacman -Qqett | sort
}

tv1() {
  # Enable flipping to prevent tearing
  nvidia-settings -l -a "AllowFlipping=1"
  xrandr --output HDMI-1 --mode 1920x1080 --rate 60 --above DP-2

  s="$(nvidia-settings -q CurrentMetaMode -t)"

  if [[ "${s}" != "" ]]; then
    s="${s#*" :: "}"
    nvidia-settings -a CurrentMetaMode="${s//\}/, ForceCompositionPipeline=On\}}"
  fi

  echo "TV connected"
}

tv0() {
  nvidia-settings -l -a "AllowFlipping=0"
  xrandr --output HDMI-1 --off
  echo "TV disconnected"
}

# Github copilot CLI
# eval "$(github-copilot-cli alias -- "$0")"

# Do not source on init because its quite slow
alias nvminit="source /usr/share/nvm/init-nvm.sh"

# Pipx places binaries in this folder
export PATH="$PATH:/home/mike/.local/bin"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Turso
export PATH="/home/mike/.turso:$PATH"
