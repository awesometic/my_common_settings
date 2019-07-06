#!/bin/bash

if [[ "$OSTYPE" != "linux-gnu" ]]; then
    echo 'You cannot install to non-Linux operating system.'
fi

TEXT_BOLD=`tput bold`
TEXT_RESET=`tput sgr0`

echo_msg() {
    echo -e "${TEXT_BOLD}"
    echo -e "/**"
    echo -e "/* $1"
    echo -e " */"
    echo -e "${TEXT_RESET}"
}

echo_msg "Install useful packages..."
sudo apt install neovim terminator tmux git htop iotop iftop gnome-tweaks shellcheck \
    curl wget zsh build-essential python3 python3-dev python3-pip python3-setuptools imwheel

echo_msg "Install shell preference using 'Oh My Zsh'..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
cp -f zsh/.zshrc ~/

echo_msg "Install neovim preference..."
if [ ! -d ~/.config/nvim ]; then
    mkdir ~/.config/nvim
fi
cp -rL --remove-destination nvim/* ~/.config/nvim/

echo_msg "Install vim-plug..."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo_msg "Execute PlugInstall command to install plugins..."
nvim +PlugInstall +qall

echo_msg "Install terminator preference..."
if [ ! -d ~/.config/terminator ]; then
    mkdir ~/.config/terminator
fi
cp terminator/* ~/.config/terminator/config
gsettings set org.gnome.desktop.default-applications.terminal exec '/usr/bin/terminator'

echo_msg "Install mouse sensitivity autostart entry..."
cp -f mouse/mouse.desktop ~/.config/autostart/

echo_msg "Install imwheel configuration to optimize scrolling speed and to enable side buttons..."
cp -f imwheel/.imwheelrc ~/
cp -f imwheel/imwheel.desktop ~/.config/autostart/
imwheel --kill

echo_msg "Optimize docker to enable minimize click action..."
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

echo_msg "Configure global git configuration..."
git config --global user.name "Yang Deokgyu"
git config --global user.email "secugyu@gmail.com"
git config --global user.username "awesometic"
git config --global core.editor "nvim"
git config --global color.ui "auto"

echo_msg "You should set your system up using gnome-tweaks to your liking."
echo_msg "Done! Reboot your system to apply changes."

