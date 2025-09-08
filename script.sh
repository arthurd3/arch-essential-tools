#! /bin/bash

readfile() {
    clear
    if [ ! -f "$1" ]; then
        echo "ERROR: The archive '$1' is not in the principal paste "
        return 1 
    fi

    local LINE=1
    while read -r CURRENT_LINE
    do
        echo "$LINE: $CURRENT_LINE"
        ((LINE++))
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

generatePermission

while true; do
    echo "Select your instalation File:"
    echo "1) Development Tools (dev-tools.txt)"
    echo "2) Essencial Tools (essencial-tools.txt)"
    echo "3) Quit"
    
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
            echo "Quiting...."
            break 
            ;;
        *)
            echo "Invalid option: '$choice'."
            echo ""
            ;;
    esac
done
    
