#! /bin/bash

verifyPaste() {
    if [ ! -f "$1" ]; then
        echo "ERROR: The archive '$1' is not in the tools paste "
        sleep 0.7
        clear
        break;
    fi
}

generatePermission() {
    ##Get Status Permission (scirpt.sh) on Terminal -> 744 
    permissions=$(stat -c "%a" script.sh)
    
    if [[ "$permissions" == "744" ]]; then    
        return
    fi

    echo "Generating permission u+x to you run your Script"
    sudo chmod u+x script.sh
}

readfile() {
    clear

    verifyPaste $1

    local LINE=0

    while IFS= read -r CURRENT_LINE || [[ -n "$CURRENT_LINE" ]]
    do
        ((LINE++))
        if [[ -n "$CURRENT_LINE" && $CURRENT_LINE != "#"* ]]; then

            if [[ $CURRENT_LINE == "!"* ]]; then
                package_name="${CURRENT_LINE:1}"
                echo "$LINE: Intalling AUR: $package_name (with yay)"
            else
                echo "$LINE: Intalling: $CURRENT_LINE (with pacman)"
            fi
            
        fi
    done < "$1" 
}

installAUR() {
    if yay --version &> /dev/null; then
        return
    fi
    
    read -p "Install AUR (yay). Continue install [y/n]:" choice
    
    case "$choice" in
        y|Y)
            #Install AUR(yay) from github
            sudo pacman -S --needed --noconfirm git base-devel
            git clone https://aur.archlinux.org/yay.git
            cd yay
            makepkg -si --noconfirm
            cd ..
            rm -rf yay
            ;;
        *)
            echo "AUR (yay) installation is not confirmed..."
            sleep 0.8
            clear
            return
            ;;
    esac
    return
}

mountDisk() {

    if ! pacman -Qq ntfs-3g &> /dev/null; then
        echo "Intalling ntfs-3g..."
        sudo pacman -S --noconfirm ntfs-3g
    fi

    read -p "You want select default or select a directory? Enter(Default) / AnyKey(Select Dir) :" choice
    
    case "$choice" in
        "")
            defaultDirectoryDisk
            ;;
        *)
            selectDirectoryDisk
            ;;
    esac
    return
}

selectDirectoryDisk() {

    if ! command -v zenity &> /dev/null; then
        echo "Installing zenity..."
        sudo pacman -S --noconfirm zenity
    fi

    selected_dir=$(zenity --file-selection --directory --title="Select a dir to MOUNT")
    clear
    if [ -n "$selected_dir" ]; then
        selected_dir="${selected_dir%/}"
        echo "You select dir: '$selected_dir'"
    else
        echo "Nothing dir select quiting...."
        sleep 0.7
        clear
        break;
    fi

}

defaultDirectoryDisk() {

    verifyPaste "tools/mount-disc.txt"

    #Default installation is in /run/media/arthurd3/ThuzinMemoria , with ThuzinMemoria name
    local LINE=0

    while IFS= read -r CURRENT_LINE || [[ -n "$CURRENT_LINE" ]]
    do
        ((LINE++))
        if [[ -n "$CURRENT_LINE" && $CURRENT_LINE != "#"* ]]; then
            echo "$LINE: Default Installation: $package_name  $CURRENT_LINE"
        fi
    done < "tools/mount-disc.txt" 

    sleep 0.8
    clear

}

generatePermission
installAUR 

while true; do
    echo "Select your instalation File:"
    echo "1) Complet Stup instalation + configuration"
    echo "2) Development Tools (dev-tools.txt)"
    echo "3) Essencial Tools (essencial-tools.txt)"
    echo "4) Install AUR (yay) "
    echo "5) Generate MountDisk script."
    echo "6) Quit"
    
    read -p "Select one: " choice
    echo "" 

    case $choice in
        1)

            ;;

        2)
            readfile "tools/dev-tools.txt"
            ;;
        3)
            readfile "tools/essencial-tools.txt"
            ;;
        4)
            installAUR
            ;;   
        5)
            mountDisk
            ;;

        6)
            echo "Quiting...."
            sleep 0.8
            clear
            break 
            ;;
        *)
            echo "Invalid option: '$choice'."
            echo ""
            ;;
    esac
done
    
