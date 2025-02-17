# Package management on developer workstation
## Remove all installed packages
```
sudo pkg remove -a
```
## Install essential packages
As root:
```
pkg install tmux neovim git portlint portgrep zsh zsh-autosuggestions zsh-syntax-highlighting sudo doas poudriere-devel nginx cmake ninja mutt htop neofetch
```
## Install Desktop essentials
```
sudo pkg install nvidia-drm-kmod xorg xfce lightdm lightdm-gtk-greeter firefox kitty xfce4-cpugraph-plugin xfce4-wm-themes xfce4-genmon-plugin xfce4-docklike-plugin xfce4-clipman-plugin
```
## Install gnome desktop
```
sudo pkg install gnome gnome-menus
```
Prevent gnome going to sleep as it screws things up
```
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
```
