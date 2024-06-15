#!/bin/bash

# Constants
FONT_DIR="/usr/share/fonts/nerdfonts"
I3_CONFIG="$HOME/.config/i3/config"
START_MARKER="# START_NERD_FONT"
END_MARKER="# END_NERD_FONT"
DOWNLOAD_PAGE="https://www.nerdfonts.com/font-downloads"
LOCAL_HTML="/tmp/nerdfonts.html"
LAST_FETCH_FILE="/tmp/nerdfonts_last_fetch"
FETCH_INTERVAL=$((7 * 24 * 60 * 60))  # One week in seconds

# Function to check internet connection
check_internet() {
  wget -q --spider http://google.com
  if [ $? -eq 0 ]; then
    echo "Internet is available."
  else
    echo "No internet connection. Showing local fonts only."
    return 1
  fi
}

# Function to fetch the latest HTML if needed
fetch_html() {
  if [ ! -f $LAST_FETCH_FILE ] || [ $(($(date +%s) - $(cat $LAST_FETCH_FILE))) -ge $FETCH_INTERVAL ]; then
    wget -q -O $LOCAL_HTML "$DOWNLOAD_PAGE"
    if [ $? -eq 0 ]; then
      date +%s > $LAST_FETCH_FILE
    else
      echo "Failed to fetch the latest fonts list. Showing local fonts only."
      return 1
    fi
  fi
}

# Function to list available fonts
list_fonts() {
  echo "Fetching available fonts from Nerd Fonts..."
  grep -oP '(?<=<a href="https://github.com/ryanoasis/nerd-fonts/releases/download/)[^"]+\.zip' $LOCAL_HTML | sed 's/.*\///' | sed 's/\.zip//' | sort | uniq > /tmp/nerd_fonts_list.txt

  local fonts=()
  while read font; do
    if [ -f "$FONT_DIR/$font.ttf" ] || [ -f "$FONT_DIR/$font.otf" ]; then
      fonts+=("$font (downloaded)")
    else
      fonts+=("$font")
    fi
  done < /tmp/nerd_fonts_list.txt

  echo "${fonts[@]}"
}

# Function to install a font from a URL
install_font() {
  local font_name=$1
  local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/${font_name}.zip"
  local zip_file="/tmp/${font_name}.zip"

  # Download the zip file
  wget -O $zip_file $font_url

  # Create nerdfonts directory if it doesn't exist
  sudo mkdir -p $FONT_DIR

  # Extract the zip file to a temporary directory
  local tmp_dir=$(mktemp -d)
  unzip $zip_file -d $tmp_dir

  # Move font files to the nerdfonts directory
  sudo find $tmp_dir -name "*.ttf" -exec mv {} $FONT_DIR \;
  sudo find $tmp_dir -name "*.otf" -exec mv {} $FONT_DIR \;

  # Clean up
  rm -rf $zip_file $tmp_dir

  # Update font cache
  sudo fc-cache -fv

  echo "Nerd Font installed successfully."
}

# Function to set xterm font
set_xterm_font() {
  local font_name=$1
  # Remove old font settings
  sed -i '/xterm\*faceName/d' ~/.Xresources
  sed -i '/xterm\*faceSize/d' ~/.Xresources
  # Add new font settings
  echo -e "xterm*faceName: $font_name\nxterm*faceSize: 12" >> ~/.Xresources
  xrdb -merge ~/.Xresources
  echo "Xterm font set to $font_name"
}

# Function to set a font in i3 config
set_font() {
  local font_name=$1

  # Create a backup of the i3 config
  cp $I3_CONFIG $I3_CONFIG.bak

  # Remove old font settings
  sed -i "/$START_MARKER/,/$END_MARKER/d" $I3_CONFIG

  # Add new font settings
  echo -e "$START_MARKER\nfont pango:$font_name 10\n$END_MARKER" >> $I3_CONFIG

  # Reload i3 config
  i3-msg reload

  echo "i3 config updated with font: $font_name"
  set_xterm_font "$font_name"
}

# Function to choose and set a font
choose_font() {
  check_internet && fetch_html
  fonts=$(list_fonts | tr ' ' '\n' | fzf --height=40% --border --ansi --prompt="Select a font to set: ")
  if [ -n "$fonts" ]; then
    set_font "${fonts%% *}"  # Remove the "(downloaded)" part if present
  fi
}

# Main logic
case $1 in
  list)
    check_internet && fetch_html
    list_fonts
    ;;
  install)
    if [ -z "$2" ]; then
      echo "Usage: $0 install <Font_Name>"
      exit 1
    fi
    install_font "$2"
    ;;
  set)
    if [ -z "$2" ]; then
      echo "Usage: $0 set <Font_Name>"
      exit 1
    fi
    set_font "$2"
    ;;
  choose)
    choose_font
    ;;
  *)
    echo "Usage: $0 {list|install <Font_Name>|set <Font_Name>|choose}"
    ;;
esac

