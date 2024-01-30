#!/bin/bash
i3-msg 'workspace 3; append_layout /home/mike/.config/i3/workspace-1.json'
exec_zsh="source ~/.zshrc; woops;"
pushd ~/git/rust-api-plus-htmx
i3-msg "exec \"alacritty -T win1 --working-directory $PWD -e zsh -c '$exec_zsh nvim .' \""
i3-msg "exec \"alacritty -T win2 --working-directory $PWD -e zsh -c '$exec_zsh cargo watch -x 'run -r' -i src/static'\""
pushd ~/git/rust-api-plus-htmx/static
i3-msg "exec \"alacritty -T win3 --working-directory $PWD -e zsh -c '$exec_zsh source /usr/share/nvm/init-nvm.sh && npm run tailwind' \""
popd
popd
