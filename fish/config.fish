# PATH
fish_add_path $HOME/.pub-cache/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /home/mike/.dotnet/tools

# Environment variables
set -gx MANPAGER 'nvim +Man!'
set -gx EDITOR /bin/nvim
set -gx DOTNET_CLI_TELEMETRY_OPTOUT true
set -gx GH_TELEMETRY false
set -g fish_greeting

# History: commands starting with space won't be saved
set -g fish_history_ignore_space 1

# Aliases
alias c="clear"
alias s="source ~/.config/fish/config.fish"
alias y="yazi"
alias g="gitui"
alias v="nvim"
alias sudovim="sudo -Es nvim"
alias vim="nvim"
alias parus="paru -S"
alias parur="paru -R"
alias ld="sudo lazydocker"
alias esp="espanso edit"
alias disk_usage="du -h | sort -hr | head -n 30"
alias mountstorage="sudo mount -t ntfs3 /dev/sda2 /mnt/storage"
alias blb="bluetoothctl disconnect; bluetoothctl connect A0:D0:5B:A5:4E:74"
alias blh="bluetoothctl disconnect; bluetoothctl connect 58:18:62:1F:C7:E1"
alias bld="bluetoothctl connect C3:ED:90:B1:C5:61"
alias docker="sudo docker"
alias sit="bld && linak-controller --move-to sit"
alias stand="bld && linak-controller --move-to stand"
alias curltime="curl -Ls --output /dev/null -w '\n\nTotal: %{time_total}s Code: %{response_code}\n' "
alias cs="csharprepl"
alias nvminit="source /usr/share/nvm/init-nvm.sh"

# Functions
function cheat
    curl cheat.sh/$argv[1]
end

function mkcdir
    mkdir -p -- $argv[1]; and cd -P -- $argv[1]
end

function gitopen
    git remote -v | head -n 1 | awk -F " " '{print $2}' | sed 's/\.git//g' | sed 's/git\@github\.com:/https:\/\/github\.com\//g' | xargs firefox --new-tab &
end

function installed
    pacman -Qqett | sort
end

# Starship prompt
starship init fish | source
