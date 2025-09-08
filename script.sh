#! /bin/bash

readfile() {
    clear
    if [ ! -f "$1" ]; then
        echo "ERROR: The archive '$1' is not in the principal paste "
        return 1 
    fi

    local LINE=0

    while IFS= read -r CURRENT_LINE || [[ -n "$CURRENT_LINE" ]]
    do
        ((LINE++))
        if [[ -n "$CURRENT_LINE" && $CURRENT_LINE != "#"* ]]; then

            if [[ $CURRENT_LINE == "!"* ]]; then
                package_name="${CURRENT_LINE:1}"
                echo "$LINE: Instalando AUR: $package_name (com yay)"
            else
                echo "$LINE: Instalando: $CURRENT_LINE (com pacman)"
            fi
            
        fi
    done < "$1" 
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

generatePermission
installAUR 

while true; do
    echo "Select your instalation File:"
    echo "1) Development Tools (dev-tools.txt)"
    echo "2) Essencial Tools (essencial-tools.txt)"
    echo "3) Install AUR (yay) "
    echo "4) Quit"
    
    read -p "Select one: " choice
    echo "" 

    case $choice in
        1)
            readfile "dev-tools.txt"
            ;;
        2)
            readfile "essencial-tools.txt"
            ;;
        3)
            installAUR
            ;;    
        4)
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
    
