# Package management on developer workstation
## Remove all installed packages
```
sudo pkg remove -a
```
## Install essential packages
As root:
```
pkg install tmux neovim git portlint portgrep zsh zsh-autosuggestions zsh-syntax-highlighting sudo doas poudriere-devel nginx ninja mutt htop neofetch
```
## Install Desktop essentials
```
sudo pkg install xfce firefox kitty xfce4-cpugraph-plugin
```
