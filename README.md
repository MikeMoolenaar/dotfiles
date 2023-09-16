# dotfiles
Still in progress..


## Install
(optional) update pacman.conf:
- Uncomment `Color`
- Uncomment `ParallelDownloads = 5`
- Add `ILoveCandy`

Get and run the install script
```sh
wget https://raw.githubusercontent.com/MikeMoolenaar/dotfiles/main/install.sh
chmod +x install.sh
bash install.sh
```

## Post-install steps
- Install the user.js settings file for Firefox (Firefox has to be started at least once before this works):
```sh
ln -s ~/.config/firefox/user.js ~/.mozilla/firefox/*default-release
```
- [Setup Github authentication](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key), the connection can be tested using `ssh -T git@github.com
