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

# Call the function
setup_aliases


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
        # echo "i3 installed but ur not in i3. Please switch to i3 and run this script again."
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

setup_go(){
    echo "Setting up Go..."
    # Remove any previous Go installation by deleting the /usr/local/go folder (if it exists), 
    # then extract the archive you just downloaded into /usr/local, creating a fresh Go tree in /usr/local/go:
    #   $ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz

    # (You may need to run the command as root or through sudo).

    # Do not untar the archive into an existing /usr/local/go tree. This is known to produce broken Go installations.
    # Add /usr/local/go/bin to the PATH environment variable.
    # You can do this by adding the following line to your $HOME/.profile or /etc/profile (for a system-wide installation):
    #         export PATH=$PATH:/usr/local/go/bin

    # Note: Changes made to a profile file may not apply until the next time you log into your computer. To apply the changes immediately, just run the shell commands directly or execute them from the profile using a command such as source $HOME/.profile.
    # Verify that you've installed Go by opening a command prompt and typing the following command:
    #         $ go version
    # Confirm that the command prints the installed version of Go.
}

setup_rust(){
    echo "Setting up Rust..."
    # To download Rustup and install Rust, run the following in your terminal, then follow the on-screen instructions. 
    # curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

main() {
    cool_intro_animation
    
    setup_i3
    setup_aliases
    # ask to setup neovim, Y/n
    # ask to setup lf, Y/n
    # ask to setup vim mode in terminal, Y/n
    # ask to setup aliases, Y/n
}

main
