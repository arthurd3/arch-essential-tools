#! /bin/bash

readfile() {
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
    ##Get Status Permission on Terminal -> 744 
    permissions=$(stat -c "%a" script.sh)
    
    if [[ "$permissions" == "744" ]]; then    
        return
    fi

    echo "Generating permission u+x to you run your Script"
    sudo chmod u+x script.sh
}

generatePermission

echo "Select 1 File"

PS3='Please enter your choice: '

options=("dev-tools.txt" "essencial-tools.txt" "quit")

selectedOption="";
select opt in "${options[@]}"
do
    case $opt in
        "dev-tools.txt")
            readfile "dev-tools.txt"
            ;;
        "essencial-tools.txt")
            readfile "essencial-tools.txt"
            ;;
        "quit")
            break
            ;;
        *) echo "invalid Option"
    esac
done
    
