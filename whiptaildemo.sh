#!/bin/bash

# Title and message for the info box
whiptail --title "Info Box" --msgbox "This is an info box. Press OK to continue." 8 78

# Title and message for the yes/no box
if whiptail --title "Yes/No Box" --yesno "Do you want to continue?" 8 78; then
    echo "You chose Yes. Continuing..."
else
    echo "You chose No. Exiting..."
    exit 1
fi

# Prompt for user input
NAME=$(whiptail --inputbox "Please enter your name:" 8 78 --title "Input Box" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Hello, $NAME!"
else
    echo "You chose Cancel."
fi

# Prompt for a password
PASSWORD=$(whiptail --passwordbox "Please enter your password:" 8 78 --title "Password Box" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your password is $PASSWORD"
else
    echo "You chose Cancel."
fi

# Selection menu
OPTION=$(whiptail --title "Menu Box" --menu "Choose an option" 15 60 4 \
"1" "Option 1" \
"2" "Option 2" \
"3" "Option 3" \
"4" "Option 4" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "You chose option $OPTION"
else
    echo "You chose Cancel."
fi

# Displaying a checklist
CHECKLIST=$(whiptail --title "Checklist Box" --checklist \
"Choose options" 15 60 4 \
"Option 1" "" OFF \
"Option 2" "" OFF \
"Option 3" "" OFF \
"Option 4" "" OFF 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "You selected: $CHECKLIST"
else
    echo "You chose Cancel."
fi

# Displaying a radiolist
RADIOLIST=$(whiptail --title "Radiolist Box" --radiolist \
"Choose one option" 15 60 4 \
"Option 1" "" OFF \
"Option 2" "" OFF \
"Option 3" "" ON \
"Option 4" "" OFF 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "You selected: $RADIOLIST"
else
    echo "You chose Cancel."
fi
