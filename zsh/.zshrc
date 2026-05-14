export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/home/mike/.dotnet/tools"
export MANPAGER='nvim +Man!'
export EDITOR=/bin/nvim
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export GH_TELEMETRY=false


unsetopt HIST_VERIFY # Disable preview when typing !!, just execute the command
setopt histignorespace # Commands starting with space will not be saved to history
PROMPT_EOL_MARK='' # Remove percentage sign for partial lines (mainly happens with curl)

# Aliases
alias c="clear"
alias s="source ~/.zshrc"
alias r="ranger"
alias g="gitui"
alias v="nvim"
alias sudovim="sudo -Es  nvim"
alias vim="nvim"
cheat() { curl cheat.sh/$1; }
alias parus="paru -S"
alias parur="paru -R"
alias ld="sudo lazydocker"
alias esp="espanso edit"
alias disk_usage="du -h | sort -hr | head -n 30"
alias mountstorage="sudo mount -t ntfs3 /dev/sda2 /mnt/storage"
alias blb="bluetoothctl disconnect; bluetoothctl connect A0:D0:5B:A5:4E:74" # Soundbar
alias blh="bluetoothctl disconnect; bluetoothctl connect 58:18:62:1F:C7:E1" # Headphones
alias bld="bluetoothctl connect C3:ED:90:B1:C5:61" # Desk
alias docker="sudo docker"
alias sit="bld && linak-controller --move-to sit" # Requires "pipx install linak-controller"
alias stand="bld && linak-controller --move-to stand"
alias curltime="curl -Ls --output /dev/null -w '\n\nTotal: %{time_total}s Code: %{response_code}\n' "
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

# Do not source on init because its quite slow
alias nvminit="source /usr/share/nvm/init-nvm.sh"

eval "$(starship init zsh)"

