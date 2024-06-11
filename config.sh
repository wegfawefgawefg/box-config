#!/bin/bash

: ' Title: Wegfawefgawefg PC Setup Script
Author: Wegfawefgawefg
Description:
    This script will configure your debian 12 pc wegfawefgawefg style.
Features:
    - [-] i3
    - [-] x11-xserver-utils, and multiple monitor setup
    - [ ] neovim
        - [ ] basic settings
            - [ ] line numbers
        - [ ] lazy pkg manager
            - [ ] ruff
    - [ ] install curl
    - [ ] install git
        - [ ] setup git
            - [ ] git config --global user.name "wegfawefgawefg"
            - [ ] git config --global user.email "668es218pur@gmail.com"
            - [ ] git config --global core.editor "nvim"
            - [ ] git config --global pull.rebase true
    - [ ] install nvm
        - [ ] install node 20
    - [ ] install python 3.11
    - [ ] install pip3.11
    - [ ] install gcc, and c build tools: binutils, make, build-essential, etc
    - [ ] install go
    - [ ] install rust
    - [ ] install tmux
    - [ ] install lf
    - [ ] install screenfetch
    - [ ] install wget
    - [ ] install vlc
    - [ ] install discord
    - [ ] install mpv

    - [ ] enable vim mode in terminal via: set -o vi
Aliases:
    - vi, vim, v, e => neovim
    - r, ranger => lf
    - l => la -lah
'

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

cool_intro_animation() {
    text="    Welcome To Wegfawefgawefg's PC Setup    "
    len=${#text}
    colors=(31 32 33 34 35 36)

    # Function to handle key press to stop the animation
    stop_animation() {
        tput cnorm
        stty echo
        exit
    }

    trap 'stop_animation' SIGINT

    tput civis
    stty -echo

    while :; do
        for (( i=0; i<$len; i++ )); do
            color=${colors[$((i % ${#colors[@]}))]}
            echo -ne "\033[${color}m${text:i:1}\033[0m"
        done
        echo -ne "\r"
        sleep 0.05
        text="${text:1}${text:0:1}"

        # Check if a key has been pressed
        if read -t 0.01 -n 1; then
            break
        fi
    done

    echo ""
    tput cnorm
    stty echo
}

is_installed() {
    dpkg -l | grep -q "$1"
}

setup_aliases() {
    read -p "Do you want to setup aliases? Y/n: " SETUP_ALIASES
    SETUP_ALIASES=${SETUP_ALIASES:-Y}
    if [[ "$SETUP_ALIASES" =~ ^[Nn]$ ]]; then
        echo "    skipping alias setup."
        return 0
    fi

    # Define the alias section without leading newline
    ALIAS_START="# WEG_START: Aliases"
    ALIAS_END="# WEG_END: Aliases"
    ALIASES="$ALIAS_START
alias vi='nvim'
alias vim='nvim'
alias v='nvim'
alias e='nvim'
alias r='lf'
alias ranger='lf'
alias l='ls -lah'
$ALIAS_END"

    # File to modify
    BASHRC="$HOME/.bashrc"

    # Check if the alias section exists
    if grep -q "$ALIAS_START" "$BASHRC"; then
        # Remove the existing alias section
        sed -i "/$ALIAS_START/,/$ALIAS_END/d" "$BASHRC"
    fi

    # Append the new alias section
    printf "%s\n" "$ALIASES" >> "$BASHRC"
}

setup_i3() {
    read -p "Do you want to setup i3? Y/n: " SETUP_I3
    SETUP_I3=${SETUP_I3:-Y}
    if [[ "$SETUP_I3" =~ ^[Nn]$ ]]; then
        echo "    skipping i3 setup."
        return 0
    fi

    # Install i3 if not installed
    echo -n "Checking if i3 is installed..."
    if is_installed i3; then
        echo -e "${GREEN}already installed.${NC}"
    else
        echo -e "${YELLOW}not installed.${NC}"
        echo "Installing i3..."
        sudo apt update
        sudo apt install -y i3
        echo -e "${GREEN}i3 installed.${NC}"
    fi

    if [ "$DESKTOP_SESSION" != "i3" ]; then
        echo -e "${RED}i3 is installed but you are not running i3. Please switch to i3 and run this script again.${NC}"
        exit 1
    fi

    # Install x11-xserver-utils if not installed
    echo -n "Checking if x11-xserver-utils is installed..."
    if is_installed x11-xserver-utils; then
        echo -e "${GREEN}already installed.${NC}"
    else
        echo -e "${YELLOW}not installed.${NC}"
        echo "Installing x11-xserver-utils..."
        sudo apt install -y x11-xserver-utils
        echo -e "${GREEN}x11-xserver-utils installed.${NC}"
    fi

    # Setup multiple monitors
    I3_CONFIG="$HOME/.config/i3/config" # Path to i3 config
    mkdir -p "$(dirname "$I3_CONFIG")" # Ensure i3 config directory exists

    XRANDR_CMD="xrandr --output DP-2 --mode 1920x1080 --rate 144 --output DP-4 --mode 1920x1080 --rate 144 --pos 1920x400 --rotate left"
    # if the command is already in there skip this section
    echo -n "Checking if multi monitor xrandr command is in i3 config..."
    if grep -q "$XRANDR_CMD" "$I3_CONFIG"; then
       echo -e "${GREEN}already in i3 config.${NC}"
    else 
        # Add xrandr command to i3 config
        read -p "Do you have multiple monitors? (Y/n): " MULTI_MON
        MULTI_MON=${MULTI_MON:-n}
        if [[ "$MULTI_MON" =~ ^[Yy]$ ]]; then
            echo "exec --no-startup-id $XRANDR_CMD" >> "$I3_CONFIG"
        fi
        echo -e "${GREEN}Multi monitor xrandr command added to i3 config.${NC}"
    fi

    echo "DE setup complete."
}

setup_neovim() {
    read -p "Do you want to setup Neovim? Y/n: " SETUP_NVIM
    SETUP_NVIM=${SETUP_NVIM:-Y}
    if [[ "$SETUP_NVIM" =~ ^[Nn]$ ]]; then
        echo "    skipping Neovim setup."
        return 0
    fi

    echo -n "Checking if Neovim is installed..."
    if is_installed neovim; then
        echo -e "${GREEN}already installed.${NC}"
    else
        echo -e "${YELLOW}not installed.${NC}"
        echo "Installing Neovim..."
        sudo apt update
        sudo apt install -y neovim
        echo -e "${GREEN}Neovim installed.${NC}"
    fi

    # Basic Neovim settings
    NVIM_CONFIG="$HOME/.config/nvim/init.vim"
    mkdir -p "$(dirname "$NVIM_CONFIG")"
    echo "set number" > "$NVIM_CONFIG"

    # Setup lazy plugin manager (e.g., lazy.nvim)
    echo "Installing lazy.nvim plugin manager..."
    # Add your lazy.nvim installation and configuration here

    echo "Neovim setup complete."
}

setup_git() {
    read -p "Do you want to setup Git? Y/n: " SETUP_GIT
    SETUP_GIT=${SETUP_GIT:-Y}
    if [[ "$SETUP_GIT" =~ ^[Nn]$ ]]; then
        echo "    skipping Git setup."
        return 0
    fi

    echo -n "Checking if Git is installed..."
    if is_installed git; then
        echo -e "${GREEN}already installed.${NC}"
    else
        echo -e "${YELLOW}not installed.${NC}"
        echo "Installing Git..."
        sudo apt update
        sudo apt install -y git
        echo -e "${GREEN}Git installed.${NC}"
    fi

    # Setup Git configuration
    git config --global user.name "wegfawefgawefg"
    git config --global user.email "668es218pur@gmail.com"
    git config --global core.editor "nvim"
    git config --global pull.rebase true

    echo "Git setup complete."
}

setup_nvm() {
    read -p "Do you want to setup NVM and Node.js? Y/n: " SETUP_NVM
    SETUP_NVM=${SETUP_NVM:-Y}
    if [[ "$SETUP_NVM" =~ ^[Nn]$ ]]; then
        echo "    skipping NVM and Node.js setup."
        return 0
    fi

    echo -n "Checking if NVM is installed..."
    if command -v nvm > /dev/null 2>&1; then
        echo -e "${GREEN}already installed.${NC}"
    else
        echo -e "${YELLOW}not installed.${NC}"
        echo "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
        echo -e "${GREEN}NVM installed.${NC}"
    fi

    echo "Installing Node.js 20..."
    nvm install 20
    nvm use 20

    echo "NVM and Node.js setup complete."
}

setup_python() {
    read -p "Do you want to setup Python 3.11 and pip? Y/n: " SETUP_PYTHON
    SETUP_PYTHON=${SETUP_PYTHON:-Y}
    if [[ "$SETUP_PYTHON" =~ ^[Nn]$ ]]; then
        echo "    skipping Python setup."
        return 0
    fi

    echo -n "Checking if Python 3.11 is installed..."
    if is_installed python3.11; then
        echo -e "${GREEN}already installed.${NC}"
    else
        echo -e "${YELLOW}not installed.${NC}"
        echo "Installing Python 3.11..."
        sudo apt update
        sudo apt install -y python3.11 python3.11-venv python3.11-dev
        echo -e "${GREEN}Python 3.11 installed.${NC}"
    fi

    echo -n "Checking if pip3.11 is installed..."
    if command -v pip3.11 > /dev/null 2>&1; then
        echo -e "${GREEN}already installed.${NC}"
    else
        echo -e "${YELLOW}not installed.${NC}"
        echo "Installing pip3.11..."
        sudo apt install -y python3-pip
        echo -e "${GREEN}pip3.11 installed.${NC}"
    fi

    echo "Python setup complete."
}

setup_c_build_tools() {
    read -p "Do you want to setup C build tools? Y/n: " SETUP_C_TOOLS
    SETUP_C_TOOLS=${SETUP_C_TOOLS:-Y}
    if [[ "$SETUP_C_TOOLS" =~ ^[Nn]$ ]]; then
        echo "    skipping C build tools setup."
        return 0
    fi

    echo "Installing C build tools..."
    sudo apt update
    sudo apt install -y gcc g++ make binutils build-essential
    echo -e "${GREEN}C build tools installed.${NC}"
}

setup_go() {
    read -p "Do you want to setup Go? Y/n: " SETUP_GO
    SETUP_GO=${SETUP_GO:-Y}
    if [[ "$SETUP_GO" =~ ^[Nn]$ ]]; then
        echo "    skipping Go setup."
        return 0
    fi

    echo "Setting up Go..."
    if is_installed golang-go; then
        echo -e "${GREEN}already installed.${NC}"
    else
        echo -e "${YELLOW}not installed.${NC}"
        wget https://go.dev/dl/go1.20.1.linux-amd64.tar.gz
        sudo tar -C /usr/local -xzf go1.20.1.linux-amd64.tar.gz
        export PATH=$PATH:/usr/local/go/bin
        echo "export PATH=\$PATH:/usr/local/go/bin" >> "$HOME/.profile"
        echo -e "${GREEN}Go installed.${NC}"
    fi

    echo "Go setup complete."
}

setup_rust() {
    read -p "Do you want to setup Rust? Y/n: " SETUP_RUST
    SETUP_RUST=${SETUP_RUST:-Y}
    if [[ "$SETUP_RUST" =~ ^[Nn]$ ]]; then
        echo "    skipping Rust setup."
        return 0
    fi

    echo "Setting up Rust..."
    if command -v rustc > /dev/null 2>&1; then
        echo -e "${GREEN}already installed.${NC}"
    else
        echo -e "${YELLOW}not installed.${NC}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        echo -e "${GREEN}Rust installed.${NC}"
    fi

    echo "Rust setup complete."
}

setup_tmux() {
    read -p "Do you want to setup tmux? Y/n: " SETUP_TMUX
    SETUP_TMUX=${SETUP_TMUX:-Y}
    if [[ "$SETUP_TMUX" =~ ^[Nn]$ ]]; then
        echo "    skipping tmux setup."
        return 0
    fi

    echo "Installing tmux..."
    sudo apt update
    sudo apt install -y tmux
    echo -e "${GREEN}tmux installed.${NC}"
}

setup_lf() {
    read -p "Do you want to setup lf? Y/n: " SETUP_LF
    SETUP_LF=${SETUP_LF:-Y}
    if [[ "$SETUP_LF" =~ ^[Nn]$ ]]; then
        echo "    skipping lf setup."
        return 0
    fi

    echo "Installing lf..."
    sudo apt update
    sudo apt install -y lf
    echo -e "${GREEN}lf installed.${NC}"
}

setup_screenfetch() {
    read -p "Do you want to setup screenfetch? Y/n: " SETUP_SCREENFETCH
    SETUP_SCREENFETCH=${SETUP_SCREENFETCH:-Y}
    if [[ "$SETUP_SCREENFETCH" =~ ^[Nn]$ ]]; then
        echo "    skipping screenfetch setup."
        return 0
    fi

    echo "Installing screenfetch..."
    sudo apt update
    sudo apt install -y screenfetch
    echo -e "${GREEN}screenfetch installed.${NC}"
}

setup_wget() {
    read -p "Do you want to setup wget? Y/n: " SETUP_WGET
    SETUP_WGET=${SETUP_WGET:-Y}
    if [[ "$SETUP_WGET" =~ ^[Nn]$ ]]; then
        echo "    skipping wget setup."
        return 0
    fi

    echo "Installing wget..."
    sudo apt update
    sudo apt install -y wget
    echo -e "${GREEN}wget installed.${NC}"
}

setup_vlc() {
    read -p "Do you want to setup VLC? Y/n: " SETUP_VLC
    SETUP_VLC=${SETUP_VLC:-Y}
    if [[ "$SETUP_VLC" =~ ^[Nn]$ ]]; then
        echo "    skipping VLC setup."
        return 0
    fi

    echo "Installing VLC..."
    sudo apt update
    sudo apt install -y vlc
    echo -e "${GREEN}VLC installed.${NC}"
}

setup_discord() {
    read -p "Do you want to setup Discord? Y/n: " SETUP_DISCORD
    SETUP_DISCORD=${SETUP_DISCORD:-Y}
    if [[ "$SETUP_DISCORD" =~ ^[Nn]$ ]]; then
        echo "    skipping Discord setup."
        return 0
    fi

    echo "Installing Discord..."
    wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo apt install -y ./discord.deb
    rm discord.deb
    echo -e "${GREEN}Discord installed.${NC}"
}

setup_mpv() {
    read -p "Do you want to setup MPV? Y/n: " SETUP_MPV
    SETUP_MPV=${SETUP_MPV:-Y}
    if [[ "$SETUP_MPV" =~ ^[Nn]$ ]]; then
        echo "    skipping MPV setup."
        return 0
    fi

    echo "Installing MPV..."
    sudo apt update
    sudo apt install -y mpv
    echo -e "${GREEN}MPV installed.${NC}"
}

setup_vim_mode() {
    read -p "Do you want to enable vim mode in terminal? Y/n: " SETUP_VIM_MODE
    SETUP_VIM_MODE=${SETUP_VIM_MODE:-Y}
    if [[ "$SETUP_VIM_MODE" =~ ^[Nn]$ ]]; then
        echo "    skipping vim mode setup."
        return 0
    fi

    echo "Enabling vim mode in terminal..."
    echo "set -o vi" >> "$HOME/.bashrc"
    echo -e "${GREEN}vim mode enabled.${NC}"
}

main() {
    cool_intro_animation
    
    setup_i3
    setup_aliases
    setup_neovim
    setup_git
    setup_nvm
    setup_python
    setup_c_build_tools
    setup_go
    setup_rust
    setup_tmux
    setup_lf
    setup_screenfetch
    setup_wget
    setup_vlc
    setup_discord
    setup_mpv
    setup_vim_mode
}

main
